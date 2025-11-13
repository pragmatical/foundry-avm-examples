terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id     = var.subscription_id
  storage_use_azuread = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

locals {
  base_name = var.base_name
  
  # Extract unique resource IDs for each BYOR type from all projects
  # Creates map keyed by resource ID for passing to the module
  
  ai_search_definitions = {
    for project_key, project in var.ai_projects :
    project.ai_search_connection.existing_resource_id => {
      existing_resource_id       = project.ai_search_connection.existing_resource_id
      enable_diagnostic_settings = var.enable_diagnostic_settings
    }
    if project.create_project_connections && try(project.ai_search_connection.existing_resource_id, null) != null
  }
  
  cosmosdb_definitions = {
    for project_key, project in var.ai_projects :
    project.cosmos_db_connection.existing_resource_id => {
      existing_resource_id       = project.cosmos_db_connection.existing_resource_id
      enable_diagnostic_settings = var.enable_diagnostic_settings
    }
    if project.create_project_connections && try(project.cosmos_db_connection.existing_resource_id, null) != null
  }
  
  storage_account_definitions = {
    for project_key, project in var.ai_projects :
    project.storage_account_connection.existing_resource_id => {
      existing_resource_id       = project.storage_account_connection.existing_resource_id
      enable_diagnostic_settings = var.enable_diagnostic_settings
    }
    if project.create_project_connections && try(project.storage_account_connection.existing_resource_id, null) != null
  }
  
  key_vault_definitions = {
    for project_key, project in var.ai_projects :
    project.key_vault_connection.existing_resource_id => {
      existing_resource_id       = project.key_vault_connection.existing_resource_id
      enable_diagnostic_settings = var.enable_diagnostic_settings
    }
    if project.create_project_connections && try(project.key_vault_connection.existing_resource_id, null) != null
  }
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"

  suffix        = [local.base_name]
  unique-length = 5
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_log_analytics_workspace" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
  retention_in_days   = var.log_analytics_retention_days
  sku                 = "PerGB2018"
}

module "avm-ptn-aiml-ai-foundry" {
  source  = "Azure/avm-ptn-aiml-ai-foundry/azurerm"
  version = "0.7.0"

  base_name                  = local.base_name
  location                   = azurerm_resource_group.this.location
  resource_group_resource_id = azurerm_resource_group.this.id
  ai_foundry = {
    create_ai_agent_service = true
    name                    = module.naming.cognitive_account.name_unique
  }
  ai_model_deployments       = var.ai_model_deployments
  ai_projects                = var.ai_projects
  ai_search_definition       = local.ai_search_definitions
  cosmosdb_definition        = local.cosmosdb_definitions
  create_byor                = false
  create_private_endpoints   = false
  key_vault_definition       = local.key_vault_definitions
  storage_account_definition = local.storage_account_definitions

  depends_on = [azapi_resource_action.purge_ai_foundry]
}

resource "azapi_resource_action" "purge_ai_foundry" {
  method      = "DELETE"
  resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.CognitiveServices/locations/${azurerm_resource_group.this.location}/resourceGroups/${azurerm_resource_group.this.name}/deletedAccounts/${module.naming.cognitive_account.name_unique}"
  type        = "Microsoft.Resources/resourceGroups/deletedAccounts@2021-04-30"
  when        = "destroy"
}
