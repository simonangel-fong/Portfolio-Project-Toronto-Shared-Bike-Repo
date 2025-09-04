import http from "k6/http";
import { sleep } from "k6";

// option with stage
export const options = {
  stages: [
    // ramp up to 50
    { duration: "1m", target: 50 },
    // ramp up to 100
    { duration: "5m", target: 100 },
    // ramp down back to 50
    { duration: "1m", target: 50 },
  ],
};

export default function () {
  http.get("https://trip.arguswatcher.net/prod/bike");
  sleep(1);
}
