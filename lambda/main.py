import os
import json
import boto3
from decimal import Decimal
from boto3.dynamodb.conditions import Key

# ---- Static config for your REST API ----
ROUTE_TO_TABLE = {
    "bike-count": "bike-count",  # path segment -> DynamoDB table name
}
YEAR_ATTR = "dim_year"          # partition key name (Number)
CORS_ORIGIN = os.getenv("CORS_ORIGIN", "*")
# ----------------------------------------


dynamodb = boto3.resource("dynamodb")


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            # integers as int, others as float
            return int(obj) if obj % 1 == 0 else float(obj)
        return super().default(obj)


def _response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": CORS_ORIGIN,
            "Access-Control-Allow-Methods": "GET,OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        },
        "body": json.dumps(body, cls=DecimalEncoder),
    }


def _extract_path_and_query_v1(event):
    """
    API Gateway REST (v1):
      - path: "/bike-count"
      - queryStringParameters: {"year":"2019"} or None
    Returns ("bike-count", {"year":"2019"})
    """
    raw_path = (event.get("path") or "/").lstrip("/")
    qs = event.get("queryStringParameters") or {}
    return raw_path, qs


def _table_for_path(path_segment):
    """
    Map first path segment to a DynamoDB table.
    """
    first = path_segment.split("/", 1)[0] if path_segment else ""
    return ROUTE_TO_TABLE.get(first), first


def _scan_all(table):
    """Paginate Scan to return all items."""
    items = []
    kwargs = {}
    while True:
        resp = table.scan(**kwargs)
        items.extend(resp.get("Items", []))
        last = resp.get("LastEvaluatedKey")
        if not last:
            break
        kwargs["ExclusiveStartKey"] = last
    return items


def lambda_handler(event, context):
    try:
        method = event.get("httpMethod", "GET")

        # CORS preflight (REST v1)
        if method == "OPTIONS":
            return _response(200, {"ok": True})

        path, qs = _extract_path_and_query_v1(event)

        # Health checks
        if path in ("", "health"):
            return _response(200, {"status": "ok"})

        # Route to table
        table_name, route = _table_for_path(path)
        if not table_name:
            return _response(404, {"error": f"Unknow path: '{route}'"})

        table = dynamodb.Table(table_name)

        # /bike-count?year=2019  -> Query by PK (fast)
        year_param = qs.get("year")
        if year_param:
            try:
                year_value = int(year_param)
            except ValueError:
                return _response(400, {"error": "Invalid 'year' parameter. Use a number like 2019."})

            resp = table.query(
                KeyConditionExpression=Key(YEAR_ATTR).eq(year_value)
            )
            items = resp.get("Items", [])
            # Optional: stable sort (not strictly needed since all same year)
            items.sort(key=lambda x: x.get(YEAR_ATTR, 0))
            return _response(200, {"count": len(items), "items": items})

        # /bike-count  -> all rows (Scan)
        items = _scan_all(table)
        # Nice ordering for charts/UX
        items.sort(key=lambda x: x.get(YEAR_ATTR, 0))
        return _response(200, {"count": len(items), "items": items})

    except Exception as e:
        return _response(500, {"error": "Internal server error", "detail": str(e)})
