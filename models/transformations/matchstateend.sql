{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.state') AS state,
    JSON_EXTRACT_ARRAY(jsondata, '$.winners') AS winners_json
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'matchStateEnd'
),

winners_data AS (
  SELECT
    timestamp,
    state,
    winner_json
  FROM
    parsed_data,
    UNNEST(winners_json) AS winner_json
),

parsed_winners_data AS (
  SELECT
    timestamp,
    state,
    JSON_EXTRACT_SCALAR(winner_json, '$.name') AS winner_name,
    CAST(JSON_EXTRACT_SCALAR(winner_json, '$.teamId') AS INT64) AS winner_teamId,
    JSON_EXTRACT_SCALAR(winner_json, '$.pos.x') AS winner_pos_x,
    JSON_EXTRACT_SCALAR(winner_json, '$.pos.y') AS winner_pos_y,
    JSON_EXTRACT_SCALAR(winner_json, '$.pos.z') AS winner_pos_z,
    JSON_EXTRACT_SCALAR(winner_json, '$.angles.y') AS winner_angles_y,
    JSON_EXTRACT_SCALAR(winner_json, '$.nucleusHash') AS winner_nucleusHash,
    JSON_EXTRACT_SCALAR(winner_json, '$.hardwareName') AS winner_hardwareName,
    JSON_EXTRACT_SCALAR(winner_json, '$.character') AS winner_character
  FROM winners_data
)

SELECT * FROM parsed_winners_data
WHERE timestamp IS NOT NULL
