function getSelectedChart() {
  const sel = document.getElementById("year-selector");
  if (!(sel instanceof HTMLSelectElement)) {
    console.warn("Select element #year-selector not found");
    return null;
  }
  const value = sel.value;
  console.log("Selected chart:", value);
  return value;
}

function genTripHourChart() {
  console.log("trip hour chart");
}

function genTripMonthChart() {
  console.log("trip month chart");
}

function genTopAnnualChart() {
  console.log("top annual chart");
}

function genTopCasualChart() {
  console.log("top casual chart");
}

// ===============================

async function genBikeChart({
  url,
  containerId = "chart-container",
  title = "Bike Count Over Years",
}) {
  const dom = document.getElementById(containerId);
  if (!dom) {
    console.warn(`Container #${containerId} not found`);
    return null;
  }

  // Dispose existing chart
  const existing = echarts.getInstanceByDom(dom);
  if (existing) existing.dispose();

  // initialize
  const chart = echarts.init(dom, null, {
    renderer: "canvas",
    useDirtyRect: false,
  });
  chart.showLoading("default", { text: "Loading…" });

  try {
    // get data
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();

    // process data
    const raw = Array.isArray(json?.data) ? json.data : [];
    const sorted = raw.slice().sort((a, b) => a.dim_year - b.dim_year);
    const years = sorted.map((d) => d.dim_year);
    const counts = sorted.map((d) => Number(d.bike_count));

    // gen option
    const option = {
      title: { text: title },
      tooltip: { trigger: "axis" },
      xAxis: {
        type: "category",
        name: "Year",
        data: years,
        axisLabel: { interval: 0 },
        boundaryGap: false,
      },
      yAxis: {
        type: "value",
        name: "Bike Count",
        max: 7500,
        min: 4500,
      },
      series: [
        {
          name: "Bike Count",
          type: "line",
          data: counts,
          label: { show: true, position: "top" },
        },
      ],
    };

    chart.setOption(option);
  } catch (err) {
    console.error("Failed to render chart:", err);
    chart.setOption({
      title: { text: title, subtext: "Failed to load data", left: "center" },
      xAxis: { type: "category", data: [] },
      yAxis: { type: "value" },
      series: [{ type: "line", data: [] }],
    });
  } finally {
    chart.hideLoading();
  }

  // Manage a single resize listener per container
  if (dom.__resizeHandler) {
    window.removeEventListener("resize", dom.__resizeHandler);
  }
  dom.__resizeHandler = () => chart.resize();
  window.addEventListener("resize", dom.__resizeHandler);

  return chart;
}

async function genStationChart({
  url,
  containerId = "chart-container",
  title = "Station Count Over Years",
}) {
  const dom = document.getElementById(containerId);
  if (!dom) {
    console.warn(`Container #${containerId} not found`);
    return null;
  }

  // Dispose existing chart
  const existing = echarts.getInstanceByDom(dom);
  if (existing) existing.dispose();

  // initialize
  const chart = echarts.init(dom, null, {
    renderer: "canvas",
    useDirtyRect: false,
  });
  chart.showLoading("default", { text: "Loading…" });

  try {
    // get data
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();

    // process data
    const raw = Array.isArray(json?.data) ? json.data : [];
    const sorted = raw.slice().sort((a, b) => a.dim_year - b.dim_year);
    const years = sorted.map((d) => d.dim_year);
    const counts = sorted.map((d) => Number(d.station_count));

    // gen option
    const option = {
      title: { text: title },
      tooltip: { trigger: "axis" },
      xAxis: {
        type: "category",
        name: "Year",
        data: years,
        axisLabel: { interval: 0 },
        boundaryGap: false,
      },
      yAxis: {
        type: "value",
        name: "Station Count",
        max: 750,
        min: 450,
      },
      series: [
        {
          name: "Station Count",
          type: "line",
          data: counts,
          label: { show: true, position: "top" },
        },
      ],
    };

    chart.setOption(option);
    window.addEventListener("resize", chart.resize);
  } catch (err) {
    console.error("Failed to render chart:", err);
    chart.setOption({
      title: { text: title, subtext: "Failed to load data", left: "center" },
      xAxis: { type: "category", data: [] },
      yAxis: { type: "value" },
      series: [{ type: "line", data: [] }],
    });
  } finally {
    chart.hideLoading();
  }
}

async function genTripMonthChart({
  url,
  containerId = "chart-container",
  title = "Monthly Pattern - Annual Member",
}) {
  const dom = document.getElementById(containerId);
  if (!dom) {
    console.warn(`Container #${containerId} not found`);
    return null;
  }

  // Dispose existing chart
  const existing = echarts.getInstanceByDom(dom);
  if (existing) existing.dispose();

  // initialize
  const chart = echarts.init(dom, null, {
    renderer: "canvas",
    useDirtyRect: false,
  });
  chart.showLoading("default", { text: "Loading…" });

  try {
    // get data
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    const raw = Array.isArray(json?.data) ? json.data : [];
    const months = Array.from({ length: 12 }, (_, i) => i + 1);

    // Collect years present
    const years = Array.from(new Set(raw.map((d) => d.dim_year))).sort(
      (a, b) => a - b
    );

    const byYearMonth = new Map();
    for (const y of years) byYearMonth.set(y, new Map());
    for (const r of raw) {
      const y = r.dim_year,
        m = r.dim_month;
      if (byYearMonth.has(y))
        byYearMonth.get(y).set(m, Number(r["trip_count"]) || 0);
    }

    // Series per year, ordered by year
    const series = years.map((y) => ({
      name: String(y),
      type: "line",
      smooth: true,
      symbol: "circle",
      symbolSize: 6,
      data: months.map((m) => {
        const v = byYearMonth.get(y).get(m);
        return Number.isFinite(v) ? v : fill;
      }),
    }));

    const option = {
      title: { text: title },
      tooltip: { trigger: "axis" },
      legend: { right: 24, data: years.map((y) => String(y)) },
      xAxis: {
        type: "category",
        name: "Month",
        data: months,
        // boundaryGap: false,
        // axisLabel: { interval: 0, showMaxLabel: true, showMinLabel: true },
      },
      yAxis: { type: "value", name: "Trips" },
      series,
    };
    console.log(option);

    chart.setOption(option);
    window.addEventListener("resize", chart.resize);
  } catch (err) {
    console.error("Failed to render chart:", err);
    chart.setOption({
      title: { text: title, subtext: "Failed to load data", left: "center" },
      xAxis: { type: "category", data: [] },
      yAxis: { type: "value" },
      series: [{ type: "line", data: [] }],
    });
  } finally {
    chart.hideLoading();
  }
}

async function genTripHourChart({
  url,
  containerId = "chart-container",
  title = "Hourly Pattern - Annual Member",
}) {
  const dom = document.getElementById(containerId);
  if (!dom) {
    console.warn(`Container #${containerId} not found`);
    return null;
  }

  // Dispose existing chart
  const existing = echarts.getInstanceByDom(dom);
  if (existing) existing.dispose();

  // initialize
  const chart = echarts.init(dom, null, {
    renderer: "canvas",
    useDirtyRect: false,
  });
  chart.showLoading("default", { text: "Loading…" });

  try {
    // get data
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    const raw = Array.isArray(json?.data) ? json.data : [];
    const months = Array.from({ length: 12 }, (_, i) => i + 1);

    // Collect years present
    const years = Array.from(new Set(raw.map((d) => d.dim_year))).sort(
      (a, b) => a - b
    );

    const byYearMonth = new Map();
    for (const y of years) byYearMonth.set(y, new Map());
    for (const r of raw) {
      const y = r.dim_year,
        m = r.dim_month;
      if (byYearMonth.has(y))
        byYearMonth.get(y).set(m, Number(r["trip_count"]) || 0);
    }

    // Series per year, ordered by year
    const series = years.map((y) => ({
      name: String(y),
      type: "line",
      smooth: true,
      symbol: "circle",
      symbolSize: 6,
      data: months.map((m) => {
        const v = byYearMonth.get(y).get(m);
        return Number.isFinite(v) ? v : fill;
      }),
    }));

    const option = {
      title: { text: title },
      tooltip: { trigger: "axis" },
      legend: { right: 24, data: years.map((y) => String(y)) },
      xAxis: {
        type: "category",
        name: "Month",
        data: months,
        // boundaryGap: false,
        // axisLabel: { interval: 0, showMaxLabel: true, showMinLabel: true },
      },
      yAxis: { type: "value", name: "Trips" },
      series,
    };
    console.log(option);

    chart.setOption(option);
    window.addEventListener("resize", chart.resize);
  } catch (err) {
    console.error("Failed to render chart:", err);
    chart.setOption({
      title: { text: title, subtext: "Failed to load data", left: "center" },
      xAxis: { type: "category", data: [] },
      yAxis: { type: "value" },
      series: [{ type: "line", data: [] }],
    });
  } finally {
    chart.hideLoading();
  }
}
