resource kubernetes_namespace elasticsearch {
  metadata {
    name = "elasticsearch"
  }
}

resource helm_release elasticsearch {
  chart = "elasticsearch"
  name = "elasticsearch"
  repository = "https://helm.elastic.co/"
  namespace = kubernetes_namespace.elasticsearch.metadata[0].name
  version = "7.7.0"
  set {
    name = "replicas"
    value = 1
  }
  set {
    name = "resources.requests.cpu"
    value = "500m"
  }
}

resource helm_release kibana {
  chart = "kibana"
  name = "kibana"
  repository = "https://helm.elastic.co/"
  namespace = kubernetes_namespace.elasticsearch.metadata[0].name
  version = "7.7.0"
  set {
    name = "replicas"
    value = 1
  }
  set {
    name = "resources.requests.cpu"
    value = "500m"
  }
}