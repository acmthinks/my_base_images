variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key"
}

variable "prefix" {
  type        = string
  default = "demo"
  description = "The string that needs to be attached to every resource created"
}

variable "resource_group" {
  type        = string
  default     = "demo-rg"
  description = "Name of the resource group"
}

variable "region" {
  type        = string
  description = "IBM Cloud region to provision the resources."
  default     = "us-south"
}

variable "zone" {
  type        = string
  description = "IBM Cloud availability zone within a region to provision the resources."
  default     = "us-south-1"
}

variable "icr_server" {
  type = string
  description = "IBM Container Registry server endpoint to store build-image output. All possible endpoints are listed here: https://cloud.ibm.com/docs/Registry?topic=Registry-registry_overview#registry_regions, but the default is the Global registry."
  default = "private.icr.io"
}

variable "icr_repo" {
  type = string
  description = "Name of the ICR repo that the Code Engine Build Configuration will push to"
}

variable "build-image" {
  type = string
  description = "Name of the build output image"
}

variable "build_source_repo_url" {
  type = string
  description = "Name of the GitHub repo where the Code Engine Build Configuration will pull it's source code from during a build"
}

variable "source_context_dir" {
  type = string
  description = "From the build_source_repo_url, the directory where your build source (aka Dockerfile) resides."
}

variable "icr_push_api_key" {
  type        = string
  description = "API Key used to PUSH images to ICR repo"
}

variable "icr_pull_api_key" {
  type        = string
  description = "API Key used to PULL images from ICR repo"
}
