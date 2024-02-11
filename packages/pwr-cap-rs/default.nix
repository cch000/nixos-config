{rustPlatform, ...}:
rustPlatform.buildRustPackage {
  name = "pwr-cap-rs";
  cargoLock.lockFile = ./Cargo.lock;
  src = ./.;
}
