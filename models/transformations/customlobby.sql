{{ config(materialized='table', sort='timestamp') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

players AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.playerToken') AS playerToken,
    JSON_EXTRACT_ARRAY(jsondata, '$.players') AS players_array
  FROM source_data
),

players_unnested AS (
  SELECT
    playerToken,
    JSON_EXTRACT_SCALAR(player, '$.name') AS name,
    CAST(JSON_EXTRACT_SCALAR(player, '$.teamId') AS INT64) AS teamId,
    JSON_EXTRACT_SCALAR(player, '$.nucleusHash') AS nucleusHash,
    JSON_EXTRACT_SCALAR(player, '$.hardwareName') AS hardwareName
  FROM players, UNNEST(players_array) AS player
)

SELECT * FROM players_unnested
WHERE playerToken IS NOT NULL
