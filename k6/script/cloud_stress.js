import http from "k6/http";
import { check, sleep } from "k6";

const HOME_URL = "https://trip.arguswatcher.net";
const BIKE_URL = "https://trip.arguswatcher.net/prod/bike";
const STATION_URL = "https://trip.arguswatcher.net/prod/station";
const TRIP_HOUR_URL = "https://trip.arguswatcher.net/prod/trip-hour";
const TRIP_MONTH_URL = "https://trip.arguswatcher.net/prod/trip-month";
const TOP_STATION_URL = "https://trip.arguswatcher.net/prod/top-station";

export const options = {
  thresholds: {
    http_req_failed: [{ threshold: "rate<0.01", abortOnFail: true }], // SLA: http errors < 1%; otherwise abort the test
    http_req_duration: ["p(99)<1000"], // SLA: http 99% of requests < 1s
  },
  // scenarios
  scenarios: {
    // name of scenario
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: "30s", target: 20 },
        { duration: "30s", target: 20 },
        { duration: "30s", target: 50 },
        { duration: "30s", target: 50 },
        { duration: "30s", target: 80 },
        { duration: "30s", target: 80 },
        { duration: "30s", target: 100 },
        { duration: "30s", target: 100 },
        { duration: "30s", target: 80 },
        { duration: "30s", target: 80 },
        { duration: "30s", target: 50 },
        { duration: "30s", target: 50 },
        { duration: "30s", target: 20 },
        { duration: "30s", target: 20 },
        { duration: "30s", target: 0 },
      ],
    },
  },
  cloud: {
    name: "Stress Testing",
  },
};

// Smoke testing
export default () => {
  // home
  const homeRes = http.get(HOME_URL);
  check(homeRes, { "status returned 200": (r) => r.status == 200 });

  // bike
  const bikeRes = http.get(BIKE_URL);
  check(bikeRes, { "status returned 200": (r) => r.status == 200 });

  // station
  const stationRes = http.get(STATION_URL);
  check(stationRes, { "status returned 200": (r) => r.status == 200 });

  // trip hour
  const tripHourRes = http.get(TRIP_HOUR_URL);
  check(tripHourRes, { "status returned 200": (r) => r.status == 200 });

  // trip month
  const tripMonthRes = http.get(TRIP_MONTH_URL);
  check(tripMonthRes, { "status returned 200": (r) => r.status == 200 });

  // top station
  const topStationRes = http.get(TOP_STATION_URL);
  check(topStationRes, { "status returned 200": (r) => r.status == 200 });

  sleep(1);
};
