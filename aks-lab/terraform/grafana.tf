resource kubernetes_namespace grafana {
  metadata {
    name = "grafana"
  }
}

resource helm_release grafana {
  chart = "grafana"
  name = "grafana"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  namespace = kubernetes_namespace.grafana.metadata[0].name
  version = "5.0.26"
  values = [
    file("${path.module}/grafana.yml")
  ]
}
