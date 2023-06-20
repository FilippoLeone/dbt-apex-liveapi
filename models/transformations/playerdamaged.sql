{{ config(materialized='table') }}

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
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.nucleusHash') AS attacker_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.hardwareName') AS attacker_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.attacker.character') AS attacker_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.name') AS victim_name,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.victim.teamId') AS INT64) AS victim_teamId,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.nucleusHash') AS victim_nucleusHash,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.hardwareName') AS victim_hardwareName,
    JSON_EXTRACT_SCALAR(jsondata, '$.victim.character') AS victim_character,
    JSON_EXTRACT_SCALAR(jsondata, '$.item') AS item,
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.damage') AS FLOAT64) AS damage
  FROM source_data
  WHERE JSON_EXTRACT_SCALAR(jsondata, '$.category') = 'playerDamaged'
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
