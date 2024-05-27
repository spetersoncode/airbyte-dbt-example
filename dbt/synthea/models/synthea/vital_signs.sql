-- Import
with observations as (
    select *
    from 
        {{ ref('observations') }}
    where 
       category = 'vital-signs'
),
-- Logic
flattened as (
    select
        encounter,
        max(case when description = 'Body Height' then value end) as body_height,
        max(case when description = 'Body mass index (BMI) [Percentile] Per age and sex' then value end) as bmi_percentile,
        max(case when description = 'Body mass index (BMI) [Ratio]' then value end) as bmi_ratio,
        max(case when description = 'Body temperature' then value end) as body_temperature,
        max(case when description = 'Body Weight' then value end) as body_weight,
        max(case when description = 'Diastolic Blood Pressure' then cast(cast(value as float) as int) end) as diastolic_blood_pressure,
        max(case when description = 'Head Occipital-frontal circumference' then value end) as head_circumference,
        max(case when description = 'Head Occipital-frontal circumference Percentile' then value end) as head_circumference_percentile,
        max(case when description = 'Heart rate' then value end) as heart_rate,
        max(case when description = 'Mean blood pressure' then value end) as mean_blood_pressure,
        max(case when description = 'Medication management note' then value end) as medication_management_note,
        max(case when description = 'Natriuretic peptide.B prohormone N-Terminal [Mass/volume] in Blood by Immunoassay' then value end) as natriuretic_peptide,
        max(case when description = 'Oxygen saturation Calculated from oxygen partial pressure in Blood' then value end) as oxygen_saturation_calculated,
        max(case when description = 'Oxygen saturation in Arterial blood' then value end) as oxygen_saturation_arterial,
        max(case when description = 'Pain severity - 0-10 verbal numeric rating [Score] - Reported' then value end) as pain_severity,
        max(case when description = 'Respiratory rate' then value end) as respiratory_rate,
        max(case when description = 'Systolic Blood Pressure' then cast(cast(value as float) as int) end) as systolic_blood_pressure,
        max(case when description = 'Weight difference [Mass difference] --pre dialysis - post dialysis' then value end) as weight_difference,
        max(case when description = 'Weight-for-length Per age and sex' then value end) as weight_for_length
    from 
        observations
    group by
        encounter
),
derived as (
    select *,
        systolic_blood_pressure || '/' || diastolic_blood_pressure as display_blood_pressure
    from flattened
),

-- Final
final as (
    select *
    from derived
)
select * from final
