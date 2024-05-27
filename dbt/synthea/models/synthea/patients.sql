{{ config(schema="staging")}}

-- Inputs
with patients as (
    select * from {{ source('synthea', 'patients') }}
),

staged_patients as (
    select
        "Id" as id,
        "LAT" as lat,
        "LON" as lon,
        "SSN" as ssn,
        "ZIP" as zip,
        "CITY" as city,
        "FIPS" as fips,
        "LAST" as last_name,
        "FIRST" as first_name,
        "RACE" as race,
        "STATE" as state,
        "COUNTY" as county,
        "GENDER" as gender,
        "INCOME" as income,
        "MAIDEN" as maiden_name,
        "PREFIX" as prefix,
        "SUFFIX" as suffix,
        "ADDRESS" as address,
        "DRIVERS" as drivers,
        "MARITAL" as marital,
        "PASSPORT" as passport,
        "BIRTHDATE" as birthdate,
        "DEATHDATE" as deathdate,
        "ETHNICITY" as ethnicity,
        "BIRTHPLACE" as birthplace,
        "HEALTHCARE_COVERAGE" as healthcare_coverage,
        "HEALTHCARE_EXPENSES" as healthcare_expenses
    from
        patients
),
-- Final
final as (
    select * from staged_patients
)
select * from final