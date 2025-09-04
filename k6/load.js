// import necessary modules
import { check } from "k6";
import http from "k6/http";

// define configuration
export const options = {
  // define thresholds
  thresholds: {
    http_req_failed: [{ threshold: "rate<10", abortOnFail: true }], // availability threshold for error rate
    http_req_duration: ["p(99)<1000"], // Latency threshold for percentile
  },
  // define scenarios
  scenarios: {
    breaking: {
      executor: "ramping-vus",
      stages: [
        { duration: "10s", target: 20 },
        { duration: "50s", target: 20 },
        { duration: "50s", target: 40 },
        { duration: "50s", target: 60 },
        { duration: "50s", target: 80 },
        { duration: "50s", target: 100 },
        { duration: "50s", target: 100 },
        { duration: "50s", target: 100 },
      ],
    },
  },
  cloud: {
    // Project: Default project
    projectID: 4205576,
    // Test runs with the same name groups test runs together.
    name: "Load Testing",
  },
};

export default function () {
  // define URL and request body
  const url = "https://trip.arguswatcher.net/prod/bike";
  const params = {
    headers: {
      "Content-Type": "application/json",
    },
  };

  const res = http.get(url);

  // check that response is 200
  check(res, {
    "response code was 200": (res) => res.status == 200,
  });
}
