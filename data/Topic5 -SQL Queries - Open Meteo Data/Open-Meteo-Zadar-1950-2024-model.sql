WITH yearly_temps AS (
  SELECT
    EXTRACT(YEAR FROM measurement_date) AS year,

    -- Air temperature statistics
    ROUND(AVG(temperature_2m_mean), 1) AS avg_year_temp,
    ROUND(
      PERCENTILE_CONT(0.5)
      WITHIN GROUP (ORDER BY temperature_2m_mean),
      1
    ) AS median_year_temp,
    MIN(temperature_2m_mean) AS min_year_temp,
    MAX(temperature_2m_max) AS max_year_temp,

    -- Apparent temperature (thermal stress)
    ROUND(AVG(apparent_temperature_mean), 1) AS avg_apparent_temp,
    ROUND(
      PERCENTILE_CONT(0.5)
      WITHIN GROUP (ORDER BY apparent_temperature_mean),
      1
    ) AS median_apparent_temp,
    MIN(apparent_temperature_mean) AS min_apparent_temp,
    MAX(apparent_temperature_mean) AS max_apparent_temp,

    -- Relative humidity
    ROUND(AVG(relative_humidity_2m_mean), 1) AS avg_relative_humidity

  FROM open_meteo_zadar_daily_1940_2025
  WHERE measurement_date BETWEEN
        DATE '1950-01-01' AND DATE '2024-12-31'
  GROUP BY EXTRACT(YEAR FROM measurement_date)
),
yearly_hydrology AS (
  SELECT
    EXTRACT(YEAR FROM measurement_date) AS year,

    -- Hydrological indicators
    COUNT(CASE WHEN precipitation_sum_mm < 1 THEN 1 END) AS dry_days,
    COUNT(CASE WHEN precipitation_sum_mm >= 1 THEN 1 END) AS rainy_days,
    MAX(precipitation_sum_mm) AS max_daily_precipitation_mm

  FROM open_meteo_zadar_daily_1940_2025
  WHERE measurement_date BETWEEN
        DATE '1950-01-01' AND DATE '2024-12-31'
  GROUP BY EXTRACT(YEAR FROM measurement_date)
),
heatwaves AS (
  SELECT
    grp,
    MIN(measurement_date) AS start_date,
    COUNT(*) AS duration_days
  FROM (
    SELECT
      measurement_date,
      measurement_date
        - ROW_NUMBER() OVER (ORDER BY measurement_date) AS grp
    FROM open_meteo_zadar_daily_1940_2025
    WHERE measurement_date BETWEEN
          DATE '1950-01-01' AND DATE '2024-12-31'
      AND temperature_2m_max > 30
  )
  GROUP BY grp
  HAVING COUNT(*) >= 5
),
heatwave_stats AS (
  SELECT
    EXTRACT(YEAR FROM start_date) AS year,

    -- Heatwave indicators
    COUNT(*) AS heatwave_count,
    ROUND(AVG(duration_days), 1) AS heatwave_avg_duration_days,
    MIN(duration_days) AS heatwave_min_duration_days,
    MAX(duration_days) AS heatwave_max_duration_days

  FROM heatwaves
  GROUP BY EXTRACT(YEAR FROM start_date)
),
yearly_drought AS (
  SELECT
    EXTRACT(YEAR FROM measurement_date) AS year,

    -- Combined drought risk (all conditions met)
    COUNT(
      CASE
        WHEN precipitation_sum_mm < 1
         AND et0_fao_evapotranspiration__mm > 4
         AND soil_moisture_0_to_100cm_mean < 0.20
        THEN 1
      END
    ) AS drought_risk_days,

    -- Individual drought-related conditions
    COUNT(
      CASE
        WHEN et0_fao_evapotranspiration__mm > 4
        THEN 1
      END
    ) AS high_et0_days,

    COUNT(
      CASE
        WHEN soil_moisture_0_to_100cm_mean < 0.20
        THEN 1
      END
    ) AS low_soil_moisture_days

  FROM open_meteo_zadar_daily_1940_2025
  WHERE measurement_date BETWEEN
        DATE '1950-01-01' AND DATE '2024-12-31'
  GROUP BY EXTRACT(YEAR FROM measurement_date)
),
yearly_wind AS (
  SELECT
    EXTRACT(YEAR FROM measurement_date) AS year,

    -- Wind extremes
    MAX(wind_speed_10m_max_km_h) AS max_wind_speed_km_h,
    COUNT(
      CASE
        WHEN wind_speed_10m_max_km_h > 50
        THEN 1
      END
    ) AS strong_wind_days_50kmh

  FROM open_meteo_zadar_daily_1940_2025
  WHERE measurement_date BETWEEN
        DATE '1950-01-01' AND DATE '2024-12-31'
  GROUP BY EXTRACT(YEAR FROM measurement_date)
)
SELECT
  t.year,

  -- Heatwave indicators
  COALESCE(h.heatwave_count, 0) AS heatwave_count,
  COALESCE(h.heatwave_avg_duration_days, 0) AS heatwave_avg_duration_days,
  COALESCE(h.heatwave_min_duration_days, 0) AS heatwave_min_duration_days,
  COALESCE(h.heatwave_max_duration_days, 0) AS heatwave_max_duration_days,

  -- Air temperature
  t.avg_year_temp,
  t.median_year_temp,
  t.min_year_temp,
  t.max_year_temp,

  -- Apparent temperature
  t.avg_apparent_temp,
  t.median_apparent_temp,
  t.min_apparent_temp,
  t.max_apparent_temp,

  -- Relative humidity
  t.avg_relative_humidity,

  -- Hydrology
  y.dry_days,
  y.rainy_days,
  y.max_daily_precipitation_mm,

  -- Drought stress
  COALESCE(d.drought_risk_days, 0) AS drought_risk_days,
  COALESCE(d.high_et0_days, 0) AS high_et0_days,
  COALESCE(d.low_soil_moisture_days, 0) AS low_soil_moisture_days,

  -- Wind
  w.max_wind_speed_km_h,
  w.strong_wind_days_50kmh

FROM yearly_temps t
LEFT JOIN heatwave_stats h ON t.year = h.year
JOIN yearly_hydrology y ON t.year = y.year
LEFT JOIN yearly_drought d ON t.year = d.year
LEFT JOIN yearly_wind w ON t.year = w.year
ORDER BY t.year;
