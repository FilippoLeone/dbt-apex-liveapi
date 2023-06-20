{{ config(materialized='table', sort='timestamp') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    TIMESTAMP_SECONDS(CAST(JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS INT)) AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.name') AS attacker_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.attacker.teamId') AS INT64) AS attacker_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.pos.x') AS attacker_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.pos.y') AS attacker_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.pos.z') AS attacker_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.angles.y') AS attacker_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.nucleusHash') AS attacker_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.hardwareName') AS attacker_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.character') AS attacker_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.name') AS victim_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.victim.teamId') AS INT64) AS victim_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.x') AS victim_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.y') AS victim_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.pos.z') AS victim_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.angles.y') AS victim_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.nucleusHash') AS victim_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.hardwareName') AS victim_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.character') AS victim_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.name') AS awardedTo_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.teamId') AS INT64) AS awardedTo_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.pos.x') AS awardedTo_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.pos.y') AS awardedTo_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.pos.z') AS awardedTo_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.angles.y') AS awardedTo_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.nucleusHash') AS awardedTo_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.hardwareName') AS awardedTo_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.awardedTo.character') AS awardedTo_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.weapon') AS weapon
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'playerKilled'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
