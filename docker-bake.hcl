target "build-reset-fs-metadata" {
    context="reset-fs-metadata"
}

target "build-bake-targets" {
    context = "bake-targets"
}
target "test-bake-targets" {
    inherits = ["build-bake-targets"]
    target = "test"
}

target "build-common" {
    context = "common"
}

target "build-docker-lib" {
    context = "docker-lib" 
    contexts = {
        common = "target:build-common"
        reset-fs-metadata = "target:build-reset-fs-metadata"
        bake-targets = "target:build-bake-targets"
    }
    tags = [
        "ghcr.io/pawelchcki/docker-lib:latest"
    ]
}

target "test-basic-operation" {
    context = "tests"
    dockerfile = "basic.Dockerfile"
    contexts = {
        docker-lib = "target:build-docker-lib"
    }
}

target "test-cargo-isolation" {
    inherits = ["test-basic-operation"]
    dockerfile = "cargo.Dockerfile"
}

group "test" {
    targets = ["test-basic-operation", "test-cargo-isolation", "test-bake-targets"]
}

group "default" {
    targets = ["build-docker-lib"]
}

target "extract-test-targets" {
    target = "extract-test-targets"
    output = ["type=local,dest=./"]
}