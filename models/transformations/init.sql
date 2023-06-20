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
    JSON_EXTRACT_SCALAR(jsondata, '$.gameVersion') AS gameVersion,
    STRUCT(
      CAST(JSON_EXTRACT_SCALAR(jsondata, '$.apiVersion.majorNum') AS INT64) AS majorNum,
      CAST(JSON_EXTRACT_SCALAR(jsondata, '$.apiVersion.minorNum') AS INT64) AS minorNum,
      CAST(JSON_EXTRACT_SCALAR(jsondata, '$.apiVersion.buildStamp') AS INT64) AS buildStamp
    ) AS apiVersion
  FROM source_data
)

SELECT DISTINCT * FROM parsed_data
WHERE timestamp IS NOT NULL
