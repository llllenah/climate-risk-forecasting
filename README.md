# Climate Risk Forecasting

LSTM-based temperature forecasting and K-Means climate scenario analysis using historical Open-Meteo weather data.

## Overview

This project combines time-series forecasting and unsupervised learning for climate risk assessment. It includes:

- Daily maximum temperature forecasting with an LSTM model.
- Yearly climate-profile clustering with K-Means.
- Climate indicators for heat, precipitation, drought risk, soil moisture, and wind.
- Notebook-based analysis with reproducible data preparation and visual reporting.

## Results

### Temperature Forecasting

| Metric | Value |
|--------|-------|
| MAE | < 2.0 °C |
| RMSE | < 2.8 °C |
| R² | > 0.93 |

### Climate Scenario Clustering

| Cluster | Interpretation | Relative Risk |
|---------|----------------|---------------|
| Stable-Cool | Lower-temperature years with moderate moisture | Low |
| Transitional | Mixed conditions with moderate variability | Moderate |
| Warm-Dry | Higher temperatures and more dry days | High |
| Extreme | Stronger heat and drought-risk signals | Very High |

## Methodology

- Feature engineering from daily weather observations into yearly climate profiles.
- Thermal, hydrological, extreme-event, and wind indicators.
- K-Means clustering for climate scenario grouping.
- LSTM model with chronological train/test split for temperature forecasting.
- Visual analysis with Plotly, Matplotlib, and Seaborn.

## Repository Structure

```text
climate-risk-forecasting/
├── README.md
├── requirements.txt
├── notebooks/
│   ├── 01_scenario_analysis.ipynb
│   └── 02_lstm_forecasting.ipynb
└── data/
    ├── raw_open_meteo/
    └── sql_queries_open_meteo/
```

## Quick Start

```bash
git clone https://github.com/llllenah/climate-risk-forecasting.git
cd climate-risk-forecasting
pip install -r requirements.txt
jupyter notebook notebooks/
```

## Tech Stack

Python, TensorFlow/Keras, scikit-learn, Pandas, NumPy, Plotly, Seaborn, Open-Meteo data, SQL.
