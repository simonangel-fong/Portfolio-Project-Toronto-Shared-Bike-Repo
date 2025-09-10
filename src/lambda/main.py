import boto3
import os
import json
import datetime
import logging
from boto3.dynamodb.conditions import Attr

# logging
logger = logging.getLogger()
log_level = os.environ.get('LOG_LEVEL', 'INFO').upper()
logger.setLevel(getattr(logging, log_level))

# get env var
PROJECT = os.environ.get('PROJECT', 'toronto-shared-bike')
APP = os.environ.get('APP', 'data-warehouse')
ENV = os.environ.get('ENV', 'dev')

dynamodb = boto3.resource('dynamodb')
MV_BIKE_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_bike_year"
MV_STATION_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_station_year"
MV_TRIP_USER_HOUR = f"{PROJECT}-{APP}-{ENV}-mv_trip_user_year_hour"
MV_TRIP_USER_MONTH = f"{PROJECT}-{APP}-{ENV}-mv_trip_user_year_month"
MV_TOPSTATION_USER_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_top_station_user_year"


def lambda_handler(event, context):
    logger.info("Lambda function invoked.")
    logger.debug(f"Event received: {event}")

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

    # GET request: path /bike
    if method == 'GET' and path == '/bike':
        year = params.get('year') if params else None
        return _bike_year(year)

    # GET request: path /station
    if method == 'GET' and path == '/station':
        year = params.get('year') if params else None
        return _station_year(year)

    # GET request: path /trip-hour
    if method == 'GET' and path == '/trip-hour':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _trip_hour(year, user)

    # GET request: path /trip-month
    if method == 'GET' and path == '/trip-month':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _trip_month(year, user)

    # GET request: path /top-station
    if method == 'GET' and path == '/top-station':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _top_station(year)

    # Default response: unsupported paths/methods
    return {
        "statusCode": 404,
        "body": "Not Found"
    }

# helper function


def _bike_year(year=None):
    table = dynamodb.Table(MV_BIKE_YEAR)
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

        # extract key attr
        filtered_items = [
            {
                "dim_year": int(item.get("dim_year")),
                "bike_count": int(item.get("bike_count"))
            }
            for item in items]

        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(filtered_items),
            "data": filtered_items
        }

        logger.info(f"Call _bike_year function success.")
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps(result)
        }
    except Exception as e:
        # Error handling: return 500 with error message
        logger.error(f"Error during execution: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _station_year(year=None):
    table = dynamodb.Table(MV_STATION_YEAR)
    try:
        # filter year
        if year:
            response = table.scan(
                FilterExpression=Attr('dim_year').eq(year)
            )
        else:
            # Get all items
            response = table.scan()

        filtered_items = []
        items = response.get('Items', [])

        # extract key attr
        filtered_items = [
            {
                "dim_year": int(item.get("dim_year")),
                "station_count": int(item.get("station_count"))
            }
            for item in items]

        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(filtered_items),
            "data": filtered_items
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
        logger.error(f"Error during execution: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _trip_hour(year=None, user=None):
    table = dynamodb.Table(MV_TRIP_USER_HOUR)
    try:
        # filter expression
        filter_expr = None
        if year and user:
            filter_expr = Attr('dim_year').eq(
                str(year)) & Attr('dim_user').eq(str(user))
        elif year:
            filter_expr = Attr('dim_year').eq(str(year))
        elif user:
            filter_expr = Attr('dim_user').eq(str(user))

        # Scan with filter
        if filter_expr:
            response = table.scan(FilterExpression=filter_expr)
        else:
            response = table.scan()

        items = response.get('Items', [])

        # extract key attr
        filtered_items = [
            {
                "dim_year": int(item.get("dim_year")),
                "dim_hour": int(item.get("dim_hour")),
                "dim_user": item.get("dim_user"),
                "trip_count": int(item.get("trip_count")),
                "duration_sum": int(item.get("duration_sum"))
            }
            for item in items
        ]

        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(filtered_items),
            "data": filtered_items
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
        logger.error(f"Error during execution: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _trip_month(year=None, user=None):
    table = dynamodb.Table(MV_TRIP_USER_MONTH)
    try:
        # filter expression
        filter_expr = None
        if year and user:
            filter_expr = Attr('dim_year').eq(
                str(year)) & Attr('dim_user').eq(str(user))
        elif year:
            filter_expr = Attr('dim_year').eq(str(year))
        elif user:
            filter_expr = Attr('dim_user').eq(str(user))

        # Scan with filter
        if filter_expr:
            response = table.scan(FilterExpression=filter_expr)
        else:
            response = table.scan()

        items = response.get('Items', [])

        # extract key attr
        filtered_items = [
            {
                "dim_year": int(item.get("dim_year")),
                "dim_month": int(item.get("dim_month")),
                "dim_user": item.get("dim_user"),
                "trip_count": int(item.get("trip_count")),
                "duration_sum": int(item.get("duration_sum"))
            }
            for item in items
        ]

        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(filtered_items),
            "data": filtered_items
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
        logger.error(f"Error during execution: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _top_station(year=None, user=None):
    table = dynamodb.Table(MV_TOPSTATION_USER_YEAR)
    try:
        # filter expression
        filter_expr = None
        if year and user:
            filter_expr = Attr('dim_year').eq(
                str(year)) & Attr('dim_user').eq(str(user))
        elif year:
            filter_expr = Attr('dim_year').eq(str(year))
        elif user:
            filter_expr = Attr('dim_user').eq(str(user))

        # Scan with filter
        if filter_expr:
            response = table.scan(FilterExpression=filter_expr)
        else:
            response = table.scan()

        items = response.get('Items', [])

        # extract key attr
        filtered_items = [
            {
                "dim_user": item.get("dim_user"),
                "dim_year": int(item.get("dim_year")),
                "dim_station": item.get("dim_station"),
                "trip_count": int(item.get("trip_count"))
            }
            for item in items
        ]

        result = {
            "datetime": datetime.datetime.utcnow().isoformat() + "Z",
            "count": len(filtered_items),
            "data": filtered_items
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
        logger.error(f"Error during execution: {e}", exc_info=True)
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
