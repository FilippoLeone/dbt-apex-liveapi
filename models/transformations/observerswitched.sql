{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    JSON_EXTRACT_SCALAR(jsondata, '$.timestamp') AS timestamp,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.name') AS observer_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.observer.teamId') AS INT64) AS observer_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.pos.x') AS observer_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.pos.y') AS observer_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.pos.z') AS observer_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.angles.x') AS observer_angles_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.angles.y') AS observer_angles_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.angles.z') AS observer_angles_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.nucleusHash') AS observer_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.hardwareName') AS observer_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.teamName') AS observer_teamName,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.character') AS observer_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.observer.skin') AS observer_skin,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.name') AS target_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.teamId') AS INT64) AS target_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.pos.x') AS target_pos_x,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.pos.y') AS target_pos_y,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.pos.z') AS target_pos_z,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.angles.y') AS target_angles_y,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.currentHealth') AS INT64) AS target_currentHealth,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.maxHealth') AS INT64) AS target_maxHealth,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.shieldHealth') AS INT64) AS target_shieldHealth,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.shieldMaxHealth') AS INT64) AS target_shieldMaxHealth,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.nucleusHash') AS target_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.hardwareName') AS target_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.teamName') AS target_teamName,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.target.squadIndex') AS INT64) AS target_squadIndex,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.character') AS target_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.target.skin') AS target_skin,
    JSON_EXTRACT(jsondata, '$.targetTeam') AS targetTeam
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'observerSwitched'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
