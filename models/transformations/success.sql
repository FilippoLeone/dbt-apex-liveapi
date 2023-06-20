WITH source_data AS (
  SELECT
    `data`,
    CAST(`data` AS JSON) AS jsondata
  FROM {{ ref('json_table') }}
),

parsed_data AS (
  SELECT
    CAST(JSON_EXTRACT_SCALAR(jsondata, '$.success') AS BOOL) AS success
  FROM source_data
)

SELECT * FROM parsed_data
WHERE success IS NOT NULL
