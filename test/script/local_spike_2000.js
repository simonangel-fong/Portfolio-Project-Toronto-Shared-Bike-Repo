import http from "k6/http";
import { check, sleep } from "k6";

const HOME_URL = "https://trip.arguswatcher.net";
const BIKE_URL = "https://trip.arguswatcher.net/prod/bike";
const STATION_URL = "https://trip.arguswatcher.net/prod/station";
const TRIP_HOUR_URL = "https://trip.arguswatcher.net/prod/trip-hour";
const TRIP_MONTH_URL = "https://trip.arguswatcher.net/prod/trip-month";
const TOP_STATION_URL = "https://trip.arguswatcher.net/prod/top-station";

export const options = {
  stages: [
    { duration: "2m", target: 2000 }, // fast ramp-up
    { duration: "1m", target: 0 }, // quick ramp-down
  ],
};

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
