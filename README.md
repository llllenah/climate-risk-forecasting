<h1 align="center">🌡 Climate Risk Forecasting with Deep Learning</h1>

<p align="center">
  <img src="https://img.shields.io/badge/python-3.10+-blue.svg" alt="Python"/>
  <img src="https://img.shields.io/badge/TensorFlow-LSTM-FF6F00.svg" alt="TensorFlow"/>
  <img src="https://img.shields.io/badge/scikit--learn-clustering-F7931E.svg" alt="sklearn"/>
  <img src="https://img.shields.io/badge/data-Open_Meteo-2CA02C.svg" alt="OpenMeteo"/>
</p>

<p align="center">
  <b>LSTM-based temperature forecasting and K-Means climate scenario analysis using 75 years of Kyiv meteorological data.</b>
</p>

---

## 🎯 Overview

This project combines **deep learning** and **unsupervised ML** for climate risk assessment:

1. **LSTM Neural Network** — Forecasts daily maximum temperature using a 14-day lookback window over 15 years of data
2. **K-Means Scenario Clustering** — Groups 75 yearly climate profiles into stable, transitional, and unfavorable scenarios
3. **Environmental Risk Indicators** — Heatwave detection, drought risk index, soil moisture anomalies

## 📊 Key Results

### Temperature Forecasting (LSTM)
| Metric | Value |
|--------|-------|
| MAE | < 2.0 °C |
| RMSE | < 2.8 °C |
| R² | > 0.93 |

### Climate Scenarios (K-Means, k=4)
| Cluster | Label | Years | Avg Temp | Drought Risk |
|---------|-------|-------|----------|-------------|
| 0 | Stable-Cool | 25 | 7.8°C | Low |
| 1 | Transitional | 22 | 8.5°C | Moderate |
| 2 | Warm-Dry | 18 | 9.2°C | High |
| 3 | Extreme | 10 | 10.1°C | Very High |

## 🏗 Project Structure

```
climate-risk-forecasting/
├── README.md
├── requirements.txt
├── notebooks/
│   ├── 01_scenario_analysis.ipynb    # K-Means clustering & scenario identification
│   └── 02_lstm_forecasting.ipynb     # LSTM temperature prediction
├── data/
│   └── kyiv_weather_1950_2024.xlsx   # Open-Meteo historical data
└── figures/
    └── *.png                         # Generated visualizations
```

## 🔬 Methodology

### Feature Engineering (20+ climate indicators)
- **Thermal:** avg/median/min/max temperature, apparent temperature, humidity
- **Hydrological:** dry days, rainy days, max precipitation, soil moisture
- **Extreme events:** heatwave count/duration, drought risk days, high ET₀ days
- **Wind:** max wind speed, storm days

### LSTM Architecture
- Input: 14-day sliding windows × 2 features (MaxTemp, SolarRad)
- Network: LSTM(64) → Dropout(0.2) → Dense(1)
- Optimizer: Adam, MSE loss, EarlyStopping (patience=5)
- Train/Test: 80/20 chronological split

## 🚀 Quick Start

```bash
git clone https://github.com/llllenah/climate-risk-forecasting.git
cd climate-risk-forecasting
pip install -r requirements.txt
jupyter notebook notebooks/
```

## 🛠 Tech Stack

`Python` · `TensorFlow/Keras` · `scikit-learn` · `Pandas` · `NumPy` · `Plotly` · `Seaborn` · `Open-Meteo API` · `SQL`

## 👤 Author

**Olena Serhiienko** — [@llllenah](https://github.com/llllenah)
