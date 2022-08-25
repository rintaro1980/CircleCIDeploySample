import json

def lambda_handler(event, context):
    request_id = event['pathParameters']['id']
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': request_id
        }),
    }
