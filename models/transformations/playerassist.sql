{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.name') AS assistant_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.assistant.teamId') AS INT64) AS assistant_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.pos.x') AS assistant_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.pos.y') AS assistant_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.pos.z') AS assistant_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.angles.y') AS assistant_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.nucleusHash') AS assistant_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.hardwareName') AS assistant_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.assistant.character') AS assistant_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.name') AS victim_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.victim.teamId') AS INT64) AS victim_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.x') AS victim_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.y') AS victim_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.z') AS victim_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.angles.y') AS victim_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.nucleusHash') AS victim_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.hardwareName') AS victim_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.character') AS victim_character
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'playerAssist'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
