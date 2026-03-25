# Bollinger + IBOV Pivot Correlation Strategy (Vivi)

This MetaTrader 5 (MT5) indicator is designed for the Brazilian Mini-Index (**WINFUT**), filtering volatility signals through real-time correlation with the spot market (**IBOV**).

## 🚀 Key Features

*   **Dual Confirmation Strategy**: Signals Buy (Green) and Sell (Red) only when price closes outside Bollinger Bands (Futures) AND IBOV confirms with a 5-minute pivot breakout.
*   **Smart Coloring**: 
    *   **Green**: Validated Buy Signal.
    *   **Red**: Validated Sell Signal.
    *   **Black**: Negative candle (Close < Open) without validation.
    *   **Gray**: Positive candle (Close > Open) without validation.
*   **Time Filter**: Automatically begins analysis from 10:00 AM (MT5 Server Time), coinciding with the IBOV spot market opening.
*   **Multi-Asset Support**: Fetches real-time IBOV data regardless of the active chart.

## 🛠️ Recommended Setup

*   **Asset**: WINFUT (Mini Index Future)
*   **Timeframe**: 2 Minutes
*   **Correlation Reference**: IBOV (Bovespa Index) 5-minute chart.
*   **Required Configuration**: Make sure the symbol **IBOV** is added to your **Market Watch** (Observação do Mercado).

## 📥 Installation

1.  Download the `Vivi.mq5` (source) or `Vivi.ex5` (compiled) file.
2.  Open your MetaTrader 5 terminal.
3.  Go to `File` -> `Open Data Folder`.
4.  Navigate to `MQL5` -> `Indicators`.
5.  Paste the file(s) into this folder.
6.  Restart MetaTrader 5 or refresh the Navigator panel.
7.  Drag and drop the indicator onto your WINFUT 2min chart.

## 📌 Requirements

For the indicator to fetch data from the spot market:
1.  Your broker must provide the **IBOV** symbol.
2.  Ensure you have historical data for the IBOV on the 5-minute timeframe.

---

### Português

Este indicador MT5 sincroniza as Bandas de Bollinger do WINFUT (2min) com o rompimento de pivô no IBOV (5min), fornecendo sinais coloridos de alta confiança para traders do mercado brasileiro (B3).

*   **Sinal de Compra**: Fechamento acima da banda superior + IBOV rompendo máxima anterior de 5min.
*   **Sinal de Venda**: Fechamento abaixo da banda inferior + IBOV rompendo mínima anterior de 5min.

---
*Created with the assistance of Antigravity AI.*
