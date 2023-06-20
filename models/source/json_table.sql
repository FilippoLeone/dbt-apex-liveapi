{{ config(materialized='table') }}
SELECT 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(data, '\"{', '{'), '}\"', '}'), '\\n', ''), '{\\n', '{'), '\\', '') AS `data`
FROM {{ source('pubsub', 'apex')}}
