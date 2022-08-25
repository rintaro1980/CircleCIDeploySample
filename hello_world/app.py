import json

def lambda_handler(event, context):
    request_id = event['pathParameters']['id']
    return {
        'statusCode': 200,
        'body': json.dumps({
            'env': 'prod',
            'message': request_id
        }),
    }
