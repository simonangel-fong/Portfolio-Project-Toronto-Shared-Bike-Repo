from locust import HttpUser, task, between
import os

API_URLS = {
    "home": "https://trip.arguswatcher.net/",
    "bike": "https://trip.arguswatcher.net/prod/bike",
    "station": "https://trip.arguswatcher.net/prod/station",
    "top_station": "https://trip.arguswatcher.net/prod/top-station",
    "trip_month": "https://trip.arguswatcher.net/prod/trip-month",
    "trip_hour": "https://trip.arguswatcher.net/prod/trip-hour",
}


class APIUser(HttpUser):
    host = os.getenv("TARGET_HOST", "https://trip.arguswatcher.net")
    wait_time = between(0.5, 1.5)

    @task
    def home(self):
        self.client.get(API_URLS["home"])

    @task
    def bike(self):
        self.client.get(API_URLS["bike"])

    @task
    def station(self):
        self.client.get(API_URLS["station"])

    @task
    def top_station(self):
        self.client.get(API_URLS["top_station"])

    @task
    def trip_month(self):
        self.client.get(API_URLS["trip_month"])

    @task
    def trip_hour(self):
        self.client.get(API_URLS["trip_hour"])
