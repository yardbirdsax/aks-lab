resource kubernetes_namespace traefik {
  metadata {
    name = "traefik"
  }
}

resource helm_release traefik {
  chart = "traefik"
  name = "traefik"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
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
