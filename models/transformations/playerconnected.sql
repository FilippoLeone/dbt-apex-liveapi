{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    TIMESTAMP_SECONDS(CAST(JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS INT)) AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.name') AS player_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.player.teamId') AS INT64) AS player_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.pos.x') AS player_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.pos.y') AS player_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.pos.z') AS player_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.nucleusHash') AS player_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.hardwareName') AS player_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.teamName') AS player_teamName,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.player.squadIndex') AS INT64) AS player_squadIndex,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.character') AS player_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.player.skin') AS player_skin
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'playerConnected'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
