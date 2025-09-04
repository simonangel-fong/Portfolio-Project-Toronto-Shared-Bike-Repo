import http from "k6/http";
import { sleep } from "k6";

// option object
export const options = {
  vus: 10,
  duration: "30s",
  iterations: 10,
};

export default function () {
  http.get("https://trip.arguswatcher.net/prod/bike");
  sleep(1);
}
