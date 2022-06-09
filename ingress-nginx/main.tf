terraform {
  required_version = ">= 1.2.0"
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.8.2"
    }
  }
}

variable "manifests_dir" {
  type        = list(string)
  description = "path to manifests_dir"
  default     = []
}

provider "kustomization" {
  #   # optional path to kubeconfig file
  #   # falls back to KUBECONFIG or KUBE_CONFIG env var
  #   # or finally '~/.kube/config'

  kubeconfig_path = "~/.kube/config"

  #   # optional raw kubeconfig string
  #   # overwrites kubeconfig_path
  #   # kubeconfig_raw = data.template_file.kubeconfig.rendered

  #   # optional context to use in kubeconfig with multiple contexts
  #   # if unspecified, the default (current) context is used
  #   # context = "my-context"
}

data "kustomization_overlay" "kube_overlay" {
  resources = var.manifests_dir
}

resource "kustomization_resource" "kube_resources" {
  for_each = data.kustomization_overlay.kube_overlay.ids
  manifest = data.kustomization_overlay.kube_overlay.manifests[each.value]
}