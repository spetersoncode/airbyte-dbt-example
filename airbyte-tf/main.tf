### AIRBYTE TERRAFORM CONFIGURATION ###
terraform {
  required_providers {
    airbyte = {
      source = "airbytehq/airbyte"
      version = "0.5.0"
    }
  }
}

provider "airbyte" {
  password = var.airbyte_password
  username = var.airbyte_username
  server_url = var.airbyte_server_url
}

# Create sources
resource "airbyte_source_file" "patients_csv" {
  configuration = {
    dataset_name = "patients"
    format = "csv"
    provider = {
      https_public_web = {}
    }
    url = "https://slpaws-synthea.s3.us-west-2.amazonaws.com/patients.csv"
  }
  workspace_id = var.workspace_id
  name = "csv::patients"
}

resource "airbyte_source_file" "encounters_csv" {
  configuration = {
    dataset_name = "encounters"
    format = "csv"
    provider = {
      https_public_web = {}
    }
    url = "https://slpaws-synthea.s3.us-west-2.amazonaws.com/encounters.csv"
  }
  workspace_id = var.workspace_id
  name = "csv::encounters" 
}

resource "airbyte_source_file" "conditions_csv" {
  configuration = {
    dataset_name = "conditions"
    format = "csv"
    provider = {
      https_public_web = {}
    }
    url = "https://slpaws-synthea.s3.us-west-2.amazonaws.com/conditions.csv"
  }
  workspace_id = var.workspace_id
  name = "csv::conditions"
}


resource "airbyte_source_file" "observations_csv" {
  configuration = {
    dataset_name = "observations"
    format = "csv"
    provider = {
      https_public_web = {}
    }
    url = "https://slpaws-synthea.s3.us-west-2.amazonaws.com/observations.csv"
  }
  workspace_id = var.workspace_id
  name = "csv::observations"
}

resource "airbyte_source_file" "procedures_csv" {
  configuration = {
    dataset_name = "procedures"
    format = "csv"
    provider = {
      https_public_web = {}
    }
    url = "https://slpaws-synthea.s3.us-west-2.amazonaws.com/procedures.csv"
  }
  workspace_id = var.workspace_id
  name = "csv::procedures"
}

# Create the destination
resource "airbyte_destination_postgres" "postgres_synthea" {
  configuration = {
    host                = var.postgres_host
    password            = var.postgres_password
    port                = var.postgres_port
    database            = "synthea"
    schema              = "load"
    ssl_mode = {
      allow = {}
    }
    tunnel_method = {
      no_tunnel = {}
    }
    username = var.postgres_username
  }
  name = "postgres::synthea"
  workspace_id  = var.workspace_id
}

# Create the connections
resource "airbyte_connection" "patients_to_postgres" {
  name = "patients -> synthea"
  source_id = airbyte_source_file.patients_csv.source_id
  destination_id = airbyte_destination_postgres.postgres_synthea.destination_id
  schedule = {
    schedule_type = "cron"
    cron_expression = var.cron_expression
  }
}

resource "airbyte_connection" "encounters_to_postgres" {
  name = "encounters -> synthea"
  source_id = airbyte_source_file.encounters_csv.source_id
  destination_id = airbyte_destination_postgres.postgres_synthea.destination_id
  schedule = {
    schedule_type = "cron"
    cron_expression = var.cron_expression
  }
}

resource "airbyte_connection" "conditions_to_postgres" {
  name = "conditions -> synthea"
  source_id = airbyte_source_file.conditions_csv.source_id
  destination_id = airbyte_destination_postgres.postgres_synthea.destination_id
  schedule = {
    schedule_type = "cron"
    cron_expression = var.cron_expression
  }
}

resource "airbyte_connection" "observations_to_postgres" {
  name = "observations -> synthea"
  source_id = airbyte_source_file.observations_csv.source_id
  destination_id = airbyte_destination_postgres.postgres_synthea.destination_id
  schedule = {
    schedule_type = "cron"
    cron_expression = var.cron_expression
  }
}

resource "airbyte_connection" "procedures_to_postgres" {
  name = "procedures -> synthea"
  source_id = airbyte_source_file.procedures_csv.source_id
  destination_id = airbyte_destination_postgres.postgres_synthea.destination_id
  schedule = {
    schedule_type = "cron"
    cron_expression = var.cron_expression
  }
}

