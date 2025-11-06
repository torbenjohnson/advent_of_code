PROFILE_CI := "ci"

# List all the available commands
_default:
    just --list

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
    cargo fmt --all  
    just --unstable --fmt

# Check formatting of all files in CI
_fmt-ci:
    cargo fmt --all -- --check
    just --unstable --fmt --check

# Run the linter for all files
lint:
    cargo clippy -- --no-deps

# Run the linter for all files in CI
_lint-ci:
    RUSTFLAGS="-D warnings" cargo clippy --profile {{ PROFILE_CI }} -- --no-deps

# Run all tests
test:
    cargo nextest run

# Run all tests in CI
_test-ci:
    RUSTFLAGS="-D warnings" cargo nextest run --cargo-profile {{ PROFILE_CI }}

# Build this package's documentation
doc:
    cargo doc --all-features

# Build this package's documentation
_doc-ci:
    RUSTFLAGS="-D warnings" RUSTDOCFLAGS="-D warnings" cargo doc --profile {{ PROFILE_CI }} --all-features --no-deps --document-private-items
