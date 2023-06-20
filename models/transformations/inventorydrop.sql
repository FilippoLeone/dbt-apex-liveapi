{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.name') AS name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.player.teamId') AS INT64) AS teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.nucleusHash') AS nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.hardwareName') AS hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.character') AS character,
    JSON_EXTRACT_SCALAR(jsondata, '$.item') AS item,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.quantity') AS INT64) AS quantity
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'inventoryDrop'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
