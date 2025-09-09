CONTAINER_IMAGE := "test"
CONTAINER_TAG := "rust-linux-v1"
CONTAINER_VOLUME := "/workspace"
PROFILE_CI := "ci"

# List all the available commands
_default:
    just --list

# Install prerequisities to useall just recipes on Arch
install-prerequisities:
    sudo pacman -S rustup lld taplo-cli
    @# This is to install the "rustfmt" nightly release
    rustup toolchain install nightly

# ######################################## Docker

# Build the Docker container locally
docker-build:
    docker build . --tag {{ CONTAINER_IMAGE }}:{{ CONTAINER_TAG }}

# Run the Docker container
docker-run EXEC: docker-build
    docker run -it --rm -v ./:{{ CONTAINER_VOLUME }} {{ CONTAINER_IMAGE }}:{{ CONTAINER_TAG }} {{ EXEC }}

# Publish the image to Docker Hub
_docker-push: docker-build
    docker push {{ CONTAINER_IMAGE }}:{{ CONTAINER_TAG }}

# ######################################## Rust

# Run the CI in this directory
ci:
    just _fmt-ci _lint-ci _doc-ci _build-ci _test-ci

# Clean all temporary files
clean:
    cargo clean

# Build the default binary of this crate
build:
    cargo build

# Build with warnings as errors in CI
_build-ci:
    RUSTFLAGS="-D warnings" cargo build --profile {{ PROFILE_CI }}

# Run the default binary of this crate
run:
    cargo run

# Format all files
fmt:
    cargo +nightly fmt --all  
    just --unstable --fmt
    @# Options: https://taplo.tamasfe.dev/configuration/formatter-options.html
    taplo format --option align_entries=true --option reorder_keys=true

# Check formatting of all files in CI
_fmt-ci:
    cargo +nightly fmt --all -- --check
    just --unstable --fmt --check
    @# Options: https://taplo.tamasfe.dev/configuration/formatter-options.html
    taplo format --check  --option align_entries=true --option reorder_keys=true

# Run the linter for all files
lint:
    cargo clippy -- --no-deps
    taplo check

# Run the linter for all files in CI
_lint-ci:
    RUSTFLAGS="-D warnings" cargo clippy --profile {{ PROFILE_CI }} -- --no-deps

# Run all tests
test:
    cargo test --all

# Run all tests in CI
_test-ci:
    RUSTFLAGS="-D warnings" cargo test --all --profile {{ PROFILE_CI }}

# Build this package's documentation
doc:
    cargo doc --all-features

# Build this package's documentation
_doc-ci:
    RUSTFLAGS="-D warnings" RUSTDOCFLAGS="-D warnings" cargo doc --profile {{ PROFILE_CI }} --all-features --no-deps --document-private-items
