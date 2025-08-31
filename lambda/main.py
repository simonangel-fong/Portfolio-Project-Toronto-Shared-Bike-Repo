import boto3
import os
import json
import datetime
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')
MV_BIKE_COUNT_TABLE = os.environ.get(
    'MV_BIKE_COUNT_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_bike_count')
MV_STATION_COUNT_TABLE = os.environ.get(
    'MV_STATION_COUNT_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_station_count')
MV_USER_HOUR_TRIP_TABLE = os.environ.get(
    'MV_USER_HOUR_TRIP_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_user_year_hour_trip')
MV_USER_MONTH_TRIP_TABLE = os.environ.get(
    'MV_USER_MONTH_TRIP_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_user_year_month_trip')
MV_TOPSTATION_USER_YEAR_TABLE = os.environ.get(
    'MV_TOPSTATION_USER_YEAR_TABLE', 'Toronto-shared-bike-data-warehouse-dev-mv_user_year_station')


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

    # GET request: path /mv-bike-count
    if method == 'GET' and path == '/mv-bike-count':
        year = params.get('year') if params else None
        return _mv_bike_count(year)

    # GET request: path /mv-station-count
    if method == 'GET' and path == '/mv-station-count':
        year = params.get('year') if params else None
        return _mv_station_count(year)

    # GET request: path /mv-user-year-hour-trip
    if method == 'GET' and path == '/mv-user-year-hour-trip':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _mv_trip_user_hour(year, user)

    # GET request: path /mv-user-year-hour-trip
    if method == 'GET' and path == '/mv-user-year-month-trip':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _mv_trip_user_month(year, user)

    # GET request: path /mv-user-year-station
    if method == 'GET' and path == '/mv-user-year-station':
        year = params.get('year') if params else None
        user = params.get('user') if params else None
        return _mv_topstation_user_year(year)

    # Default response: unsupported paths/methods
    return {
        "statusCode": 404,
        "body": "Not Found"
    }

# helper function


def _mv_bike_count(year=None):
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


def _mv_station_count(year=None):
    table = dynamodb.Table(MV_STATION_COUNT_TABLE)
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
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _mv_trip_user_hour(year=None, user=None):
    table = dynamodb.Table(MV_USER_HOUR_TRIP_TABLE)
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
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _mv_trip_user_month(year=None, user=None):
    table = dynamodb.Table(MV_USER_MONTH_TRIP_TABLE)
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
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }


def _mv_topstation_user_year(year=None, user="all"):
    table = dynamodb.Table(MV_TOPSTATION_USER_YEAR_TABLE)
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
