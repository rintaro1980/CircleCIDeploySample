BUCKET_NAME := cm-yamamoto-circleci-deploy-sample-bucket-${SYSTEM_ENV}
STACK_NAME := CircleCIDeploySample-${SYSTEM_ENV}

create-bucket:
	aws s3 mb s3://$(BUCKET_NAME)

copy-swagger:
	aws s3 cp swagger.yaml s3://$(BUCKET_NAME)/swagger.yaml

build:
	sam build

deploy:
	sam package \
	    --output-template-file packaged.yaml \
		--s3-bucket $(BUCKET_NAME)

	sam deploy \
		--template-file packaged.yaml \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset \
		--parameter-overrides SystemEnv=${SYSTEM_ENV}

get-apigateway-endpoint:
	aws cloudformation describe-stacks \
		--stack-name $(STACK_NAME) \
		--query 'Stacks[].Outputs'

create-iam-user-for-circleci:
	aws cloudformation deploy \
		--template-file circleci-iam-user.yaml \
		--stack-name ${STACK_NAME}-for-CircleCI-User \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameter-overrides SystemEnv=${SYSTEM_ENV}

create-iam-user-access-key:
	aws iam create-access-key \
		--user-name CircleCIDeploySample-${SYSTEM_ENV}-for-CircleCI-User

delete-app:
	aws cloudformation delete-stack \
		--stack-name $(STACK_NAME)

delete-iam-user-for-ciecleci:
	aws cloudformation delete-stack \
		--stack-name ${STACK_NAME}-for-CircleCI-User
