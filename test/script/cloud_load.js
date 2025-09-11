import http from "k6/http";
import { check, sleep } from "k6";

const DNS_DOMAIN = __ENV.DNS_DOMAIN;
const API_ENV = __ENV.API_ENV;

const HOME_URL = `https://${DNS_DOMAIN}`;
const BIKE_URL = `https://${DNS_DOMAIN}/${API_ENV}/bike`;
const STATION_URL = `https://${DNS_DOMAIN}/${API_ENV}/station`;
const TRIP_HOUR_URL = `https://${DNS_DOMAIN}/${API_ENV}/trip-hour`;
const TRIP_MONTH_URL = `https://${DNS_DOMAIN}/${API_ENV}/trip-month`;
const TOP_STATION_URL = `https://${DNS_DOMAIN}/${API_ENV}/top-station`;

const SLA_FAIL = __ENV.SLA_FAIL || "0.01";
const SLA_DUR_99 = __ENV.SLA_DUR_99 || "1000";

const TARGET = 30;

export const options = {
  thresholds: {
    http_req_failed: [`rate<${SLA_FAIL}`], // SLA: http errors < 1%
    http_req_duration: [`p(99)<${SLA_DUR_99}`], // SLA: http 99% of requests < 1s
  },
  scenarios: {
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: "1m", target: TARGET },
        { duration: "1m", target: TARGET },
        { duration: "1m", target: 0 },
      ],
    },
  },
  cloud: {
    name: "API Load Testing",
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
