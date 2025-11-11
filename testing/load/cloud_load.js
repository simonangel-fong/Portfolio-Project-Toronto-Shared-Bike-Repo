import http from "k6/http";
import { check, sleep } from "k6";

const TEST = __ENV.TEST || "Load test";
const ENV = __ENV.ENV || "dev";

const DOMAIN = __ENV.DOMAIN || "localhost";
const HOME_URL = `https://${DOMAIN}`;
const BIKE_URL = `https://${DOMAIN}/${ENV}/bike`;
const STATION_URL = `https://${DOMAIN}/${ENV}/station`;
const TRIP_HOUR_URL = `https://${DOMAIN}/${ENV}/trip-hour`;
const TRIP_MONTH_URL = `https://${DOMAIN}/${ENV}/trip-month`;
const TOP_STATION_URL = `https://${DOMAIN}/${ENV}/top-station`;

const VU = __ENV.VU || 5;
const SCALE = __ENV.SCALE || 1;
const DURATION = __ENV.DURATION || "30s";

const SLA_FAIL = __ENV.SLA_FAIL || "0.01";
const SLA_DUR_99 = __ENV.SLA_DUR_99 || "1000";

const TARGET = 30;

export const options = {
  thresholds: {
    http_req_failed: [`rate<${SLA_FAIL}`], // SLA: http errors < 1%
    // http_req_duration: [`p(99)<${SLA_DUR_99}`], // SLA: http 99% of requests < 1s
  },
  scenarios: {
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: DURATION, target: VU },
        { duration: DURATION, target: VU },
        { duration: DURATION, target: 0 },
      ],
    },
  },
  cloud: {
    name: TEST,
  },
};

// Smoke testing
export default () => {
  for (let i = 0; i < SCALE; i++) {
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
  }
  sleep(1);
};
