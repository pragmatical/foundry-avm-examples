variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID to deploy resources to"
}

variable "base_name" {
  type        = string
  description = "The base name prefix for resources"
  default     = "pubbyor"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources to"
  default     = "australiaeast"
}

variable "log_analytics_retention_days" {
  type        = number
  description = "The retention period in days for Log Analytics workspace"
  default     = 30
}

variable "enable_diagnostic_settings" {
  type        = bool
  description = "Whether to enable diagnostic settings for BYOR resources"
  default     = false
}

variable "ai_model_deployments" {
  type = map(object({
    name = string
    model = object({
      format  = string
      name    = string
      version = string
    })
    scale = object({
      type     = string
      capacity = optional(number, 1)
    })
  }))
  description = "Map of AI model deployments to create"
  default = {
    "gpt-4o" = {
      name = "gpt-4o"
      model = {
        format  = "OpenAI"
        name    = "gpt-4o"
        version = "2024-08-06"
      }
      scale = {
        type     = "Standard"
        capacity = 10
      }
    }
  }
}

variable "ai_projects" {
  type = map(object({
    name                       = string
    description                = string
    display_name               = string
    create_project_connections = optional(bool, true)
    cosmos_db_connection = optional(object({
      existing_resource_id = string
    }))
    ai_search_connection = optional(object({
      existing_resource_id = string
    }))
    storage_account_connection = optional(object({
      existing_resource_id = string
    }))
    key_vault_connection = optional(object({
      existing_resource_id = string
    }))
  }))
  description = "Map of AI projects to create with existing BYOR resource IDs"
  default = {
    project_1 = {
      name                       = "project-1"
      description                = "Default AI project"
      display_name               = "Project 1"
      create_project_connections = true
      cosmos_db_connection = {
        existing_resource_id = "/subscriptions/YOUR_SUB_ID/resourceGroups/YOUR_RG/providers/Microsoft.DocumentDB/databaseAccounts/YOUR_COSMOS"
      }
      ai_search_connection = {
        existing_resource_id = "/subscriptions/YOUR_SUB_ID/resourceGroups/YOUR_RG/providers/Microsoft.Search/searchServices/YOUR_SEARCH"
      }
      storage_account_connection = {
        existing_resource_id = "/subscriptions/YOUR_SUB_ID/resourceGroups/YOUR_RG/providers/Microsoft.Storage/storageAccounts/YOUR_STORAGE"
      }
      key_vault_connection = {
        existing_resource_id = "/subscriptions/YOUR_SUB_ID/resourceGroups/YOUR_RG/providers/Microsoft.KeyVault/vaults/YOUR_KV"
      }
    }
  }
}
