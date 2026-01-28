/
Challenge:
Load the inventory.txt into a kdb+ table.
Classify each food item by adding a new column with a flag (1b,0b) indicating whether the food is perishable or not
Clean the inventory by:
Removing any expired items (items with quantity of zero or less)
Grouping any duplicated items (e.g., if milk appears twice, the resulting table should have only one row with the quantities summed)
Update and replenish the inventory:
After a recount, you need to update your inventory. Items to update: banana +5, rice +10, chocolate +3
Some foods are already in your list, others may be new.
Overwrite quantities where the food exists, otherwise append new rows where they don’t.
\
use`kx.log;

logger:(use`kx.log)[`createLog;()];

\d .day02

PERISHABLE_FOODS: `apples`bread`milk`carrots`eggs`yogurt`cheese`lettuce`tomatoes`grapes`banana;

init:{
    // Load inventory:
    t:("SI";enlist csv)0:`:inventory.txt;

    // Clean up:
    t:select sum quantity by name from delete from t where quantity<=0;

    // Update and replenish:
    t+([name:`banana`rice`chocolate]quantity:5 10 3i)
    };

solve:{[t]
    q1:`$"How many unique food types remain in your inventory?";
    a1:exec count distinct name from t;
    
    q2:`$"What is the total quantity of perishable food items in your final inventory?";
    a2:exec sum quantity from t where name in .day02.PERISHABLE_FOODS;

    ([question:(q1;q2)] answer:(a1;a2))
    };
\d .

show .day02.solve .day02.init[]

exit 0 
