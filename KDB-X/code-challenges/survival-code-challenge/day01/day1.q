.pq:use`kx.pq

dt:2026.01.25;

// Load data and convert temperature from Fahrenheit to Celsius, extract date and hour:
t:select date:`date$time,hour:60 xbar `minute$time,sensorId,temperatureC:(5%9)*temperatureF-32,humidity from select from (.pq.pq`:weather.parquet);

// Calculate average and weighted average temperature by hour and sensorId for the specified date:
t1:select avgTemp:avg temperatureC,wavgTemp:humidity wavg temperatureC by hour,sensorId from t where date=dt;

// 1. Which sensor recorded the highest hourly average temperature on 2026.01.25?
A1:exec first sensorId from t1 where avgTemp=max avgTemp;

// 2. What was the highest hourly average temperature (°C) on 2026.01.25?
A2:exec first avgTemp from t1 where avgTemp=max avgTemp;

// 3. Which sensor had the lowest weighted hourly average temperature (°C) on 2026.01.25?
A3:exec first sensorId from t1 where wavgTemp=max wavgTemp;                                                                                                                                                                                                      

// 4. What was the lowest weighted hourly average temperature (°C) on 2026.01.25?
A4:exec first wavgTemp from t1 where wavgTemp=max wavgTemp;

// Display answers:
show `A1`A2`A3`A4!(A1;A2;A3;A4)
