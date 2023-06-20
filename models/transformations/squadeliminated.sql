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
    JSON_EXTRACT_ARRAY(jsondata, '$.players') AS players
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'squadEliminated'
),

players_unnested AS (
  SELECT 
    timestamp,
    category,
    player
  FROM parsed_data,
  UNNEST(JSON_EXTRACT_ARRAY(players)) as player
)

SELECT
  timestamp,
  category,
  JSON_EXTRACT_SCALAR(player, '$.name') AS player_name,
  CAST(JSON_EXTRACT_SCALAR(player, '$.teamId') AS INT64) AS player_teamId,
  JSON_EXTRACT_SCALAR(player, '$.pos.x') AS player_pos_x,
  JSON_EXTRACT_SCALAR(player, '$.pos.y') AS player_pos_y,
  JSON_EXTRACT_SCALAR(player, '$.pos.z') AS player_pos_z,
  JSON_EXTRACT_SCALAR(player, '$.angles.y') AS player_angles_y,
  CAST(JSON_EXTRACT_SCALAR(player, '$.currentHealth') AS INT64) AS player_currentHealth,
  CAST(JSON_EXTRACT_SCALAR(player, '$.maxHealth') AS INT64) AS player_maxHealth,
  CAST(JSON_EXTRACT_SCALAR(player, '$.shieldMaxHealth') AS INT64) AS player_shieldMaxHealth,
  JSON_EXTRACT_SCALAR(player, '$.nucleusHash') AS player_nucleusHash,
  JSON_EXTRACT_SCALAR(player, '$.hardwareName') AS player_hardwareName,
  JSON_EXTRACT_SCALAR(player, '$.teamName') AS player_teamName,
  JSON_EXTRACT_SCALAR(player, '$.character') AS player_character,
  JSON_EXTRACT_SCALAR(player, '$.skin') AS player_skin
FROM players_unnested
