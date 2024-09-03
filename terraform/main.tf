

###############################################################################
## Get references to existing resources
###############################################################################

data "ibm_resource_group" "resource_group" {
  name = "andrea-rg"
}

## Get reference to existing Service ID to that will be used to push images
## this Service ID should be created prior with an API Key that is saved
data "ibm_iam_service_id" "icr_push_image_service_id" {
  name  = "icr-devel-image-push-service-id"
}

## Get reference to existing Service ID to that will be used to pull images
## this Service ID should be created prior with an API Key that is saved
data "ibm_iam_service_id" "icr_image_pull_service_id" {
  name  = "icr-devel-image-pull-service-id"
}

###############################################################################
## Create Code Engine resources
###############################################################################

#create a Code Engine project to store base image builders
resource "ibm_code_engine_project" "base_images_project_instance" {
  name              = "base-images"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

#create a build configuration for an image builder (in this case, nodejs+express on an alpine distro)
#this build config assumes a Dockerfile build with the source in a public github repo
#the build configuration requires the IBM Code Engine secret being created prior
resource "ibm_code_engine_build" "nodejs_express_build_configuration" {
  project_id = ibm_code_engine_project.base_images_project_instance.project_id
  name = "${var.build-image}-build"
  output_image = "${var.icr_server}/${var.icr_repo}/${var.build-image}"
  output_secret = ibm_code_engine_secret.ce_build_push_image_secret.name
  source_url = var.build_source_repo_url
  source_context_dir = var.source_context_dir
  source_revision = "main"
  strategy_type = "dockerfile"
  strategy_size = "small"

  depends_on = [ ibm_code_engine_secret.ce_build_push_image_secret ]
}

###############################################################################
# Create an Access Group and Policies to PUSH images to ICR
###############################################################################

#create an Access Group to allow image "push" to IBM Container Registry
resource "ibm_iam_access_group" "icr_ce_build_push_ag" {
  name = "icr-ce-build-push-ag"
  description = "Access Group with members that have privilege to use Code Engine to execute a build and push to ICR"
}

#add "pushers" to Access Group, members must have an API Key
resource "ibm_iam_access_group_members" "icr_ce_build_push_members" {
  access_group_id = ibm_iam_access_group.icr_ce_build_push_ag.id
  iam_service_ids = [data.ibm_iam_service_id.icr_push_image_service_id.service_ids[0].id]
}

## create the Access Policies to allow Access Group/Service ID to use ICR
# IAM Identity Service
resource "ibm_iam_access_group_policy" "iam_identity_ce_build_policy" {
    access_group_id = ibm_iam_access_group.icr_ce_build_push_ag.id
    roles   = ["Administrator"]

    resources {
        service = "iam-identity"
        resource_type = "serviceid"
        resource = data.ibm_iam_service_id.icr_push_image_service_id.service_ids[0].id
    }
}

# Container Registry
# https://cloud.ibm.com/docs/Registry?topic=Registry-user#create_region_policy_iam
resource "ibm_iam_access_group_policy" "icr_push_policy" {
  access_group_id = ibm_iam_access_group.icr_ce_build_push_ag.id
  roles = ["Reader", "Writer"]

  resources {
    service = "container-registry"
    resource_type = "namespace"
    resource = var.icr_repo
  }
}


###############################################################################
# Create an Access Group and Policies to PULL images from ICR
###############################################################################

#create an Access Group to allow image "pull" from IBM Container Registry
resource "ibm_iam_access_group" "icr_image_pull_ag" {
  name = "icr-image-pull-ag"
  description = "Access Group with members that have privilege to pull images from ICR"
}

#add "pullers" to Access Group, members must have an API Key
resource "ibm_iam_access_group_members" "icr_image_pull_members" {
  access_group_id = ibm_iam_access_group.icr_image_pull_ag.id
  iam_service_ids = [data.ibm_iam_service_id.icr_image_pull_service_id.service_ids[0].id]
}

# Container Registry
# https://cloud.ibm.com/docs/Registry?topic=Registry-user#create_region_policy_iam
resource "ibm_iam_access_group_policy" "icr_image_pull_policy" {
  access_group_id = ibm_iam_access_group.icr_image_pull_ag.id
  roles = ["Reader"]

  resources {
    service = "container-registry"
    resource_type = "namespace"
    resource = var.icr_repo
  }
}

###############################################################################
## Create an IBM Cloud Code Engine Registry Secret
###############################################################################

resource "ibm_code_engine_secret" "ce_build_push_image_secret" {
  project_id = ibm_code_engine_project.base_images_project_instance.project_id
  name = "build-push-image-secret"
  format = "registry"
  data = {
    password = var.icr_push_api_key
    server = var.icr_server
    username = "iamapikey"
  }
}
