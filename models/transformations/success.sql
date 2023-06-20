WITH source_data AS (
  SELECT
    *,
    CAST(json_string AS JSON) AS json
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    CAST(json_extract_scalar(json, '$.success') AS BOOL) AS success
  FROM source_data
)

SELECT * FROM parsed_data
WHERE success IS NOT NULL
