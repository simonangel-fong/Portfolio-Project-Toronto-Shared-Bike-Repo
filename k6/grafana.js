import http from "k6/http";
import { sleep } from "k6";

export const options = {
  vus: 10,
  duration: "30s",
  cloud: {
    // Project: Default project
    projectID: 4205576,
    // Test runs with the same name groups test runs together.
    name: "Demo K6 with Grafana",
  },
};

// export default function () {
//   // First API call
//   const res1 = http.get("https://trip.arguswatcher.net/prod/bike");
//   check(res1, {
//     "endpoint1 status is 200": (r) => r.status === 200,
//   });
//   sleep(1);
// }

export default function () {
  http.get("https://test.k6.io"); // Make an HTTP GET request to the specified URL
  sleep(1); // Pause for 1 second between iterations
}
