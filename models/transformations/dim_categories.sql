{{ config(materialized='table') }}

WITH source_data AS (
  SELECT
    `data` AS jsondata
  FROM {{ ref('json_table') }}
),

category_types AS (
  SELECT
    ROW_NUMBER() OVER() as category_id,
    category_type
  FROM (
    SELECT DISTINCT
      JSON_EXTRACT_SCALAR(jsondata, '$.category') AS category_type
    FROM source_data
  )
)

SELECT * FROM category_types
