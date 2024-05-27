{{ config(schema="staging")}}

-- Import
with observations as (
    select * from {{ source('synthea', 'observations') }}
),

-- Logic
staged_observations as (
    select
        "CODE" as code,
        "DATE" as date,
        "TYPE" as type,
        "UNITS" as units,
        "VALUE" as value,
        "PATIENT" as patient,
        "CATEGORY" as category,
        "ENCOUNTER" as encounter,
        "DESCRIPTION" as description
    from
        observations
),

-- Final
final as (
    select * from staged_observations
)
select * from final