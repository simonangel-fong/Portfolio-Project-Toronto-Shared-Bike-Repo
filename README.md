# Portfolio-Project-Toronto-Shared-Bike

| Path                     | Dynamodb Tb              |
| ------------------------ | ------------------------ |
| `/bike-year`             | mv_bike_year             |
| `/station-year`          | mv_station_year          |
| `/trip-user-year-hour`   | mv_trip_user_year_hour   |
| `/trip-user-year-month`  | mv_trip_user_year_month  |
| `/top-station-user-year` | mv_top_station_user_year |

path: `/mv_bike_count`
dynamodb: mv_bike_count

| Path                       | Data          |
| -------------------------- | ------------- |
| `/mv_bike_count`           | Get all data  |
| `/mv_bike_count?year=2019` | Get 2019 data |

data of mv_bike_count

pk bike_count dim_year
17d9b0f6-933c-4a01-bcec-7a3030974967 4901 2019
8bec5fd0-cf37-4615-b398-7fb9968fd0b9 6759 2020
43efcbf6-1d92-4642-ab62-8bd39bd2b647 6499 2021
2ce56322-44e1-4741-b02e-3e2a609ea13a 6829 2022

help me with a lambda function
lambda function is triggered by a REST API Gateway
create a subfunction `_mv_bike_count` for this path

function process:
check the path

- if it is option, return following the best practices
- if it is get method, then check the path
  - if the path is `/mv_bike_count` without parameter, then call the `_mv_bike_count` function, to get the data from dynamodb table `mv_bike_count`
