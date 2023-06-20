{{ config(materialized='table', sort='timestamp') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    TIMESTAMP_SECONDS(CAST(JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS INT64)) AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.category') AS category,
    JSON_EXTRACT_SCALAR(jsondata, '$.map') AS map,
    JSON_EXTRACT_SCALAR(jsondata, '$.playlistName') AS playlistName,
    JSON_EXTRACT_SCALAR(jsondata, '$.playlistDesc') AS playlistDesc,
    JSON_EXTRACT_SCALAR(jsondata, '$.datacenter.name') AS datacenter,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.aimAssistOn') AS BOOL) AS aimAssistOn,
    JSON_EXTRACT_SCALAR(jsondata, '$.serverId') AS serverId
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'matchSetup'
)

SELECT DISTINCT * FROM parsed_data
WHERE timestamp IS NOT NULL
