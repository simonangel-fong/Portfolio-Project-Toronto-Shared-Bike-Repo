import boto3
import os
import json

dynamodb = boto3.resource('dynamodb')
MV_BIKE_COUNT_TABLE = os.environ.get('MV_BIKE_COUNT_TABLE', 'mv_bike_count')


def lambda_handler(event, context):
    method = event.get('httpMethod', '')
    path = event.get('path', '')
    params = event.get('queryStringParameters', {})

    # OPTIONS request
    if method == 'OPTIONS':
        return {
            "statusCode": 204,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "GET,OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type"
            },
            "body": ""
        }

    # GET request: path /mv_bike_count
    if method == 'GET' and path == '/mv_bike_count':
        # get year parameter
        year = params.get('year') if params else None
        return _mv_bike_count(year)

    # Default response: unsupported paths/methods
    return {
        "statusCode": 404,
        "body": "Not Found"
    }

# helper function


def _mv_bike_count(year=None):
    ''' Query dynamodb table '''
    table = dynamodb.Table(MV_BIKE_COUNT_TABLE)

    if year:
        # if filterd by year
        from boto3.dynamodb.conditions import Attr
        response = table.scan(
            FilterExpression=Attr('dim_year').eq(int(year))
        )
    else:
        # Get all items
        response = table.scan()

    # get items
    items = response.get('Items', [])

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(items)
    }
