SELECT * 
FROM {{ source('pubsub', 'apex')}}