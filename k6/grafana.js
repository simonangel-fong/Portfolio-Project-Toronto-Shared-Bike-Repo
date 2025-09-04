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

export default function () {
  http.get("https://quickpizza.grafana.com");
  sleep(1);
}
