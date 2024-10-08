# my_base_images
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

## Run
0. Ensure pre-requisites are in place
1. [Run Terraform](terraform/README.md)
2. Execute Code Engine build-run by [Running a build configuration](https://cloud.ibm.com/docs/codeengine?topic=codeengine-build-run)

The outcome should be an image pushed to your IBM Container Registry namespace.
