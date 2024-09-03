# IBM Cloud Code Engine - Base Images
This repo contains the most basic provisioning of IBM Cloud resources to standup a Code Engine service instance (called a "project") and build a custom image from a Code Engine (ce) Build Configuration. This can absolutely be done using DevOps pipelines, but for showcasing basic ce functionality, the image build pipeline has been omitted. Pipelines should absolutely be used for enterprise-grade image builds.

## Pre-requisites
There are a few IBM Cloud resources that have to exist prior to running this Terraform. Issuing a terraform destroy will NOT tear down the resources listed below.

### Resource Group
Example: name-rg
An existing [Resource Group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_group) where all provisioned resources will belong.

### IBM Container Registry "namespace"
Example: "devel"
You can substitute or name an existing [Namespace](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cr_namespace), but one has to exist prior to running this Terraform. This is where your build-image (output) will be pushed.

### Service ID & Service ID API Key
Example: "icr-devel-image-push-service-id"
An IAM [Service ID](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_id) should be created with an [API Key](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_api_key) (be sure to save the API Key password in a secret/password manager). The Terraform will place this Service ID (and it's associated API Key) in an IAM Access Group with the proper policies.

## Inputs
Custom variable values should be specified in a ```terraform.tfvars``` file

| Name          | Description                   |
| --------------| ------------------------------|
| ```ibmcloud_api_key```   | API key value to run this Terraform. API Key must have permission to create Code Engine projects and create IAM Access Groups with Access Policies |
| ```icr_push_api_key``` | API key value used by Code Engine to execute builds and push images to IBM Container Registry|
| ```icr_repo```| IBM Container Registry (ICR) namespace |
| ```build-image```| name of the image to be saved in ICR |
| ```build_source_repo_url```| URL of the GitHub repo where your build source lives (i.e. DockerFile) |
| ```source_context_dir```| directory in ```build_source_repo_url``` where build source is located |

## Run
```
terraform init
```

```
terraform plan
```

```
terraform apply
```

## Teardown
```
terraform destroy
```
