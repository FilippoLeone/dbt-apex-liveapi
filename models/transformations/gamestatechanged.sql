{{ config(materialized='table', sort='timestamp') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    TIMESTAMP_SECONDS(CAST(JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS INT)) AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.category') AS category,
    JSON_EXTRACT_SCALAR(jsondata, '$.state')  AS state
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'gameStateChanged'
)

SELECT DISTINCT * FROM parsed_data
WHERE timestamp IS NOT NULL
