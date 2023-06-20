{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.category') AS category,
    JSON_EXTRACT_SCALAR(jsondata, '$.state') AS state,
    JSON_EXTRACT_ARRAY(jsondata, '$.winners') AS winners
  FROM source_data
)

SELECT * FROM parsed_data
WHERE winners IS NOT NULL



