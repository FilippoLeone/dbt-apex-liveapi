{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.playerToken') AS playerToken,
    JSON_EXTRACT_SCALAR(jsondata, '$.players[0].name') AS name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.players[0].teamId') AS INT64) AS teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.players[0].nucleusHash') AS nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.players[0].hardwareName') AS hardwareName
  FROM source_data
)

SELECT * FROM parsed_data
WHERE playerToken IS NOT NULL
