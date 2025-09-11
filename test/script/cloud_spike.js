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
  // thresholds: {
  //   http_req_failed: ["rate<0.01"], // SLA: http errors < 1%
  //   http_req_duration: ["p(99)<1000"], // SLA: http 99% of requests < 1s
  // },
  scenarios: {
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: "30s", target: TARGET },
        { duration: "30s", target: 0 },
      ],
    },
  },
  cloud: {
    name: "API Spike Testing",
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
