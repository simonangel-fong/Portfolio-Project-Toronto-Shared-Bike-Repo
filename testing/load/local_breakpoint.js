import http from "k6/http";
import { check, sleep } from "k6";

const DNS_DOMAIN = __ENV.DNS_DOMAIN || "trip-dev.arguswatcher.net";
const API_ENV = __ENV.API_ENV || "dev";

const HOME_URL = `https://${DNS_DOMAIN}`;
const BIKE_URL = `https://${DNS_DOMAIN}/${API_ENV}/bike`;
const STATION_URL = `https://${DNS_DOMAIN}/${API_ENV}/station`;
const TRIP_HOUR_URL = `https://${DNS_DOMAIN}/${API_ENV}/trip-hour`;
const TRIP_MONTH_URL = `https://${DNS_DOMAIN}/${API_ENV}/trip-month`;
const TOP_STATION_URL = `https://${DNS_DOMAIN}/${API_ENV}/top-station`;

const TARGET = 100;

export const options = {
  executor: "ramping-arrival-rate", //Assure load increase if the system slows
  stages: [
    { duration: "1h", target: TARGET }, // slowly ramp-up to a HUGE load
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
