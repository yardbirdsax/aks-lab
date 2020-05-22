resource kubernetes_namespace prometheus {
  metadata {
    name = "prometheus"
  }
}

resource helm_release prometheus {
  chart = "prometheus"
  name = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  namespace = kubernetes_namespace.prometheus.metadata[0].name
  version = "11.3.0"
}
