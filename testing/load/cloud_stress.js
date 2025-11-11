import http from "k6/http";
import { check, sleep } from "k6";

const TEST = __ENV.TEST || "Default test";
const DOMAIN = __ENV.DOMAIN || "http://127.0.0.1:8080";
const VU = __ENV.VU || 100;
const SCALE = __ENV.SCALE || 1;
const DURATION = __ENV.DURATION || 30;

const SLA_FAIL = __ENV.SLA_FAIL || "0.01";
const SLA_DUR_99 = __ENV.SLA_DUR_99 || "1000";

export const options = {
  thresholds: {
    http_req_failed: [{ threshold: `rate<${SLA_FAIL}`, abortOnFail: true }], // SLA: http errors < 1%; otherwise abort the test
    http_req_duration: [`p(99)<${SLA_DUR_99}`], // SLA: http 99% of requests < 1s
  },
  // scenarios
  scenarios: {
    // name of scenario
    average_load: {
      executor: "ramping-vus",
      stages: [
        { duration: `${DURATION}s`, target: VU * 0.2 },
        { duration: `${DURATION}s`, target: VU * 0.2 },
        { duration: `${DURATION}s`, target: VU * 0.4 },
        { duration: `${DURATION}s`, target: VU * 0.4 },
        { duration: `${DURATION}s`, target: VU * 0.6 },
        { duration: `${DURATION}s`, target: VU * 0.6 },
        { duration: `${DURATION}s`, target: VU * 0.8 },
        { duration: `${DURATION}s`, target: VU * 0.8 },
        { duration: `${DURATION * 2}s`, target: VU * 1 },
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
