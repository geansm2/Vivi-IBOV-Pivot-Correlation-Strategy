//+------------------------------------------------------------------+
//|                                     VIVI_WINFUT_IBOV.mq5|
//+------------------------------------------------------------------+
#property copyright "Gean Machado"
#property version   "1.60"
#property description "This indicator was specifically designed for the Brazilian Mini-Index (WINFUT), aimed at filtering volatility signals through correlation with the spot market (IBOV)."
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1

#property indicator_label1  "BollingerCorr"
#property indicator_type1   DRAW_COLOR_CANDLES
// Definimos 4 cores iniciais (as cores reais virão dos inputs no OnInit)
#property indicator_color1  clrGray, clrLimeGreen, clrRed, clrBlack

// --- Inputs de Configuração ---
input int      InpBBPeriod      = 20;          
input double   InpBBMultiplier  = 2.0;         
input string   InpCorrellSymbol = "IBOV";      
input ENUM_TIMEFRAMES InpCorrTF = PERIOD_M5;   

// --- Customização de Cores ---
input color    ColorPosNeutral  = clrGray;      // Cor de Alta (Neutro)
input color    ColorBuySignal   = clrLimeGreen; // Cor de Sinal COMPRA
input color    ColorSellSignal  = clrRed;       // Cor de Sinal VENDA
input color    ColorNegNeutral  = clrBlack;     // Cor de Baixa (Neutro)

// --- Filtros ---
input bool     InpUseTimeFilter = true;        // Ativar filtro das 10h em diante?
input int      InpStartHour     = 10;          // Hora de início (Servidor)

// --- Buffers ---
double BufferOpen[], BufferHigh[], BufferLow[], BufferClose[], BufferColors[];
int hBB;

int OnInit()
{
   SetIndexBuffer(0, BufferOpen,  INDICATOR_DATA);
   SetIndexBuffer(1, BufferHigh,  INDICATOR_DATA);
   SetIndexBuffer(2, BufferLow,   INDICATOR_DATA);
   SetIndexBuffer(3, BufferClose, INDICATOR_DATA);
   SetIndexBuffer(4, BufferColors, INDICATOR_COLOR_INDEX);
   
   // Vincula as cores dos inputs aos índices do Plot
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, 0, ColorPosNeutral);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, 1, ColorBuySignal);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, 2, ColorSellSignal);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, 3, ColorNegNeutral);

   hBB = iBands(_Symbol, _Period, InpBBPeriod, 0, InpBBMultiplier, PRICE_CLOSE);
   SymbolSelect(InpCorrellSymbol, true);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if(rates_total < InpBBPeriod) return(0);

   int limit = prev_calculated;
   if(limit > 0) limit--;

   double upper[], lower[];
   // Copia exatamente como na sua versão funcional 1.20
   if(CopyBuffer(hBB, 1, 0, rates_total, upper) <= 0) return(0);
   if(CopyBuffer(hBB, 2, 0, rates_total, lower) <= 0) return(0);

   for(int i = limit; i < rates_total; i++)
   {
      BufferOpen[i]  = open[i];
      BufferHigh[i]  = high[i];
      BufferLow[i]   = low[i];
      BufferClose[i] = close[i];
      
      // 1. Define a cor padrão conforme se o candle é positivo ou negativo
      if(close[i] < open[i])
         BufferColors[i] = 3; // CorNegNeutral (Preto)
      else
         BufferColors[i] = 0; // ColorPosNeutral (Cinza)

      // 2. Verifica se o horário é válido (>= 10:00)
      MqlDateTime dt;
      TimeToStruct(time[i], dt);
      
      if(!InpUseTimeFilter || dt.hour >= InpStartHour)
      {
         // 3. Verifica a correlação IBOV (Lógica do v1.20)
         int ibovIdx = iBarShift(InpCorrellSymbol, InpCorrTF, time[i]);
         
         if(ibovIdx != -1)
         {
            double ibovClose  = iClose(InpCorrellSymbol, InpCorrTF, ibovIdx);
            double ibovHigh1  = iHigh(InpCorrellSymbol, InpCorrTF, ibovIdx + 1);
            double ibovLow1   = iLow(InpCorrellSymbol, InpCorrTF, ibovIdx + 1);

            if(ibovClose > 0 && ibovHigh1 > 0)
            {
               // Lógica de COMPRA
               if(close[i] > upper[i] && close[i] > open[i] && ibovClose > ibovHigh1)
                  BufferColors[i] = 1; // ColorBuySignal
               
               // Lógica de VENDA
               else if(close[i] < lower[i] && close[i] < open[i] && ibovClose < ibovLow1)
                  BufferColors[i] = 2; // ColorSellSignal
            }
         }
      }
   }

   return(rates_total);
}
