import http from "k6/http";
import { check, sleep } from "k6";

const API_STAGE = __ENV.API_STAGE;
const HOME_URL = __ENV.HOME_URL;

const BIKE_URL = `${HOME_URL}/${API_STAGE}/bike`;
const STATION_URL = `${HOME_URL}/${API_STAGE}/bike/station`;
const TRIP_HOUR_URL = `${HOME_URL}/${API_STAGE}/bike/trip-hour`;
const TRIP_MONTH_URL = `${HOME_URL}/${API_STAGE}/bike/trip-month`;
const TOP_STATION_URL = `${HOME_URL}/${API_STAGE}/bike/top-station`;

export const options = {
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
