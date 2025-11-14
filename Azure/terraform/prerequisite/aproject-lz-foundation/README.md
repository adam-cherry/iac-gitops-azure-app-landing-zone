# Overview
This module is used to implement the [Azure landing zone](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones) foundations using Microsoft's [CAF Enterprise scale](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/) module.

It configures
* foundation resources for the core landing zone,
  * basic Management resources,
  * basic Connectivity resources,
  * basic Identity resources.
* Azure Lighthouse
* Cost management budgets

# Pre-Requisites and dependencies
This module expects to find its Terraform remote state in an Azure storage container (see `backend` configuration [terraform.tf](./terraform.tf)) as well as correctly set up Azure subscriptions for the Landing zone deployment:
* Management subscription
* Identity subscription
* Connectivity subscription
* Subscriptions for the Application Landing zone