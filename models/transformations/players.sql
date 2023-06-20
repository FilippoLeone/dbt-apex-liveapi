WITH source_data AS (
  SELECT
    *,
    CAST(json_string AS JSON) AS json
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    json_extract_scalar(json, '$.playerToken') AS playerToken,
    json_extract_scalar(json, '$.players[0].name') AS name,
    CAST(json_extract_scalar(json, '$.players[0].teamId') AS INT64) AS teamId,
    json_extract_scalar(json, '$.players[0].nucleusHash') AS nucleusHash,
    json_extract_scalar(json, '$.players[0].hardwareName') AS hardwareName
  FROM source_data
)

SELECT * FROM parsed_data
WHERE playerToken IS NOT NULL
