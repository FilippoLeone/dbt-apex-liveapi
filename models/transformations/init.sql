WITH source_data AS (
  SELECT
    *,
    CAST(json_string AS JSON) AS json
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    json_extract_scalar(json, '$.timestamp') AS timestamp,
    json_extract_scalar(json, '$.category') AS category,
    json_extract_scalar(json, '$.gameVersion') AS gameVersion,
    STRUCT(
      CAST(json_extract_scalar(json, '$.apiVersion.majorNum') AS INT64) AS majorNum,
      CAST(json_extract_scalar(json, '$.apiVersion.minorNum') AS INT64) AS minorNum,
      CAST(json_extract_scalar(json, '$.apiVersion.buildStamp') AS INT64) AS buildStamp
    ) AS apiVersion
  FROM source_data
)

SELECT * FROM parsed_data
WHERE timestamp IS NOT NULL
