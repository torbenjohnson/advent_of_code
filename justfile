PROFILE_CI := "ci"

# List all the available commands
_default:
    just --list

# Run the CI in this directory
ci:
    just _fmt-ci _lint-ci _doc-ci _test-ci

# Clean all temporary files
clean:
    cargo clean

# Build the default binary of this crate
build:
    cargo build

# Run the default binary of this crate
run:
    cargo run

# Format all files
fmt:
    cargo fmt --all
    tombi fmt
    just --unstable --fmt

# Check formatting of all files in CI
_fmt-ci:
    cargo fmt --all -- --check
    tombi fmt --check
    just --unstable --fmt --check

# Run the linter for all files
lint:
    cargo clippy -- --no-deps
    tombi lint

# Run the linter for all files in CI
_lint-ci:
    RUSTFLAGS="-D warnings" cargo clippy --all-targets --all-features --profile {{ PROFILE_CI }} -- --no-deps
    tombi lint --error-on-warnings

# Run all tests
test:
    cargo nextest run

# Run all tests in CI
_test-ci:
    RUSTFLAGS="-D warnings" cargo nextest run --all-targets --all-features --cargo-profile {{ PROFILE_CI }}

# Build this package's documentation
doc:
    cargo doc --all-features

# Build this package's documentation
_doc-ci:
    RUSTFLAGS="-D warnings" RUSTDOCFLAGS="-D warnings" cargo doc --profile {{ PROFILE_CI }} --all-features --no-deps --document-private-items
