provider helm {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aksCluster.kube_config.0.host
    username               = azurerm_kubernetes_cluster.aksCluster.kube_config.0.username
    password               = azurerm_kubernetes_cluster.aksCluster.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.cluster_ca_certificate)
  }
}

provider kubernetes {
  host                   = azurerm_kubernetes_cluster.aksCluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aksCluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aksCluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aksCluster.kube_config.0.cluster_ca_certificate)
}

data helm_repository stable {
  name = "stable"
  url = "https://kubernetes-charts.storage.googleapis.com/"
}

resource kubernetes_namespace traefik {
  metadata {
    name = "traefik"
  }
}

resource helm_release traefik {
  chart = "traefik"
  name = "traefik"
  repository = data.helm_repository.stable.metadata[0].name
  namespace = kubernetes_namespace.traefik.metadata[0].name
  set {
    name = "kubernetes.ingressClass"
    value = "traefik"
  }
  set {
    name = "kubernetes.ingressEndpoint.useDefaultPublishedService"
    value = "true"
  }
  set {
    name = "service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal\""
    value = "false"
  }
  version = "1.85.0"
}
