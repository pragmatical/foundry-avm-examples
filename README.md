# Azure AI Foundry - AVM Examples

This repository provides example implementations for deploying **Azure AI Foundry** infrastructure using **Azure Verified Modules (AVM)**.

## Overview

Azure AI Foundry is Microsoft's comprehensive platform for building and deploying AI applications. This repository demonstrates how to use Terraform and AVM patterns to automate the deployment of AI Foundry infrastructure at scale.

### What's Included

- **Production-ready examples** showing different deployment patterns
- **Best practices** for multi-project AI Foundry deployments
- **Reusable configurations** leveraging Azure Verified Modules
- **Dynamic resource generation** for scalable architectures

## Examples

### [`standard-public`](./standard-public/)

Demonstrates a multi-project AI Foundry deployment with:
- Multiple AI projects with dedicated Bring-Your-Own-Resource (BYOR) resources
- Shared Azure Key Vault for secure credential management
- Dynamic resource generation based on project definitions
- Azure OpenAI model deployments (GPT-4o, text-embedding-3-large)

This example shows how to scale from a single project to multiple projects while maintaining resource isolation where needed and sharing resources where appropriate.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.9
- Azure subscription with appropriate permissions
- Azure CLI configured with valid credentials

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/pragmatical/foundry-avm-examples.git
   cd foundry-avm-examples
   ```

2. Navigate to an example directory (e.g., `standard-public/`)

3. Review the example's README for specific configuration instructions

4. Initialize Terraform and deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## About Azure Verified Modules (AVM)

[Azure Verified Modules](https://aka.ms/avm) are Microsoft-endorsed Terraform modules that follow best practices for:
- Security and compliance
- Scalability and reliability
- Maintainability and consistency
- Azure Well-Architected Framework alignment

This repository uses the [AI Foundry Pattern Module](https://registry.terraform.io/modules/Azure/avm-ptn-aiml-ai-foundry/azurerm) to simplify complex deployments.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests with additional examples or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
