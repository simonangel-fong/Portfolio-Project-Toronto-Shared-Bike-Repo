import boto3
import os
import json
import datetime
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')
MV_BIKE_COUNT_TABLE = os.environ.get(
    'MV_BIKE_COUNT_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_bike_count')


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
    if method == 'GET' and path == '/mv-bike-count':
        # get year parameter
        year = params.get('year') if params else None
        print(year)
        return _mv_bike_count(year)

    # Default response: unsupported paths/methods
    return {
        "statusCode": 404,
        "body": "Not Found"
    }

# helper function


def _mv_bike_count(year=None):
    """
    Query DynamoDB table for all items or filter by year.
    Returns HTTP response dict.
    """
    table = dynamodb.Table(MV_BIKE_COUNT_TABLE)
    try:
        # filter year
        if year:
            response = table.scan(
                FilterExpression=Attr('dim_year').eq(year)
            )
        else:
            # Get all items
            response = table.scan()
        items = response.get('Items', [])
        
        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(items),
            "data": items
        }

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(result)
        }
    except Exception as e:
        # Error handling: return 500 with error message
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


if __name__ == "__main__":
    # event = {
    #     "httpMethod": "GET",
    #     "path": "/mv_bike_count"
    # }
    # print(lambda_handler(event=event, context={}))

    event = {
        "httpMethod": "GET",
        "path": "/mv_bike_count",
        "queryStringParameters": {
            "year": "2009"
        }
    }
    print(lambda_handler(event=event, context={}))
