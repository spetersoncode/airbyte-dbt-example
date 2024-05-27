# Airbyte-DBT Synthea ELT Pipeline

This project contains everything needed to set up a ELT pipeline for Synthea using public synthetic data.

## Requirements

- **Airbyte** must be installed and running on a server. The server must be accessible from the machine running the terraform template. The server must have a workspace created and the workspace ID must be known.
- **Postgres** must be installed and running on a server. The server must be accessible from the machine running the terraform template.
- **Terraform** must be installed to create the airbyte resources.
- **DBT** must be installed to run the dbt project.

## Airbyte Terraform Template

This terraform template will connect to a self-hosted airbyte URL and build out the necessary resources to load the patient data into the database.

To work with terraform, use `cd airbyte-tf` from an open terminal to go into the terraform directory.

### Variables

You must create a variables file `vars.tfvars` in the `airbyte-tf` folder and populate it with the following, filling out all fields with values from your environment.

```bash
airbyte_username="airbyte"
airbyte_password=""
airbyte_server_url=""
cron_expression="0 0 * * * ?"
postgres_host=""
postgres_port=5432
postgres_username="postgres"
postgres_password=""
workspace_id=""
```

### Execution

Check the functionality of the template and review the execution plan with the following command

```bash
terraform plan -var-file="vars.tfvars"
```

Apply the template with the following ocmmand

```bash
terraform apply -var-file="vars.tfvars"
```

### Result

All resources will be created and the data will be loaded into the database at the specified time. For now I am browsing manually to the GUI and running the sync jobs manually. I would like to find a way to "run on launch."

## DBT

The dbt project is available in the `dbt/synthea` folder. 

### Profile

Your `~/.dbt/profiles.yml` file should look like this:

```yaml
synthea:
  outputs:
    dev:
      dbname: synthea
      host: [fill in]
      pass: [fill in]
      port: [fill in]
      schema: public
      threads: 10
      type: postgres
      user: [fill in]
  target: dev
```

### Execution

To test the dbt project, run the following command.

```bash
dbt test
```

To run the transformations, run the following command.

```bash
dbt run
```
