import http from "k6/http";
import { check, sleep } from "k6";

const DNS_URL = __ENV.DNS_URL;
const API_STAGE = __ENV.API_STAGE;

const HOME_URL = `https://${DNS_URL}`;
const BIKE_URL = `https://${DNS_URL}/${API_STAGE}/bike`;
const STATION_URL = `https://${DNS_URL}/${API_STAGE}/station`;
const TRIP_HOUR_URL = `https://${DNS_URL}/${API_STAGE}/trip-hour`;
const TRIP_MONTH_URL = `https://${DNS_URL}/${API_STAGE}/trip-month`;
const TOP_STATION_URL = `https://${DNS_URL}/${API_STAGE}/top-station`;

export const options = {
  thresholds: {
    http_req_failed: ["rate<0.01"], // SLA: http errors < 1%
  },
  vus: 2,
  duration: "10s",
  cloud: {
    name: "Smoke Testing",
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
