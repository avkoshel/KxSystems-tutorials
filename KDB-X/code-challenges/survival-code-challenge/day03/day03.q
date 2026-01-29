/
Challenge:
1. Into a q instance load:
 - weather data from day 1
 - vitals.csv into a table called vitals with data types: time as timestamp, heartRate as integer and hydration as real.
2. For each vitals reading, find the closest previous weather observation.
3. Connecting to your q instance using Python, or using another KDB-X integration, plot a scatter plot of heart rate vs temperature.
4. Using your visualization or otherwise, identify periods where heart rate exceeds 100 bpm and temperature is above 77°F.
\
.pq:use`kx.pq

logger:(use`kx.log)[`createLog;()];

\d .day03
loadData:{
    // Load data from day 1 and make sure it's sorted by time (for aj performance later on):
    .day03.weather:`time xasc select from (.pq.pq`:../day01/weather.parquet);
    
    // Load vitals data:
    .day03.vitals:("PIE";enlist csv)0:`:vitals.csv;

    // As-of join vitals with weather on time:
    t:`time xasc aj[`time;vitals;weather];

    // Add a flag for high-stress points (HR > 100 and Temp > 77°F):
    update stressfull:(heartRate>100)&(temperatureF>77) from t
    };

solve:{[data]
    q1:"Which sensor's data was matched most often during the asof join?";
    a1:first key desc d:exec count i by sensorId from data;

    q2:"How many high-stress points (HR > 100 and Temp > 77F) are visible on the chart?";
    a2:exec sum stressfull from data; 

    q3:"During which hour of the day do the high-stress points most frequently occur?";
    a3:d?max d:exec sum stressfull by time.hh from data;

    ([question:(q1;q2;q3)] answer:(a1;a2;a3)) 
    };
\d .

show .day03.solve .day03.loadData[];
exit 0;