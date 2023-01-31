target "build-reset-fs-metadata" {
  context="reset-fs-metadata"
}

target "build-isolate-cargo" {
  context="isolate-cargo"
}

target "build-docker-lib" {
    context = "docker-lib" 
    contexts = {
        isolate-cargo = "target:build-isolate-cargo"
        reset-fs-metadata = "target:build-reset-fs-metadata"
    }
}


group "default" {
    targets = ["build-docker-lib"]
}