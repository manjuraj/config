{
  description = "Dev shells";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, fenix }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ];
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ fenix.overlays.default ];
          };
          zshBin = pkgs.lib.getExe pkgs.zsh;

          # --- Package Groups ---
          minimal = with pkgs; [ zsh gh bat jq ];

          buildTools = with pkgs; [
            pkg-config clang
            autoconf automake libtool
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];

          services = with pkgs; [ redis memcached postgresql ];

          media = with pkgs; [ ffmpeg whisper-cpp ];

          pythonPkgs = with pkgs; [ uv ruff black ];

          # Pinned Rust toolchain — single source of truth for the version.
          # `toolchainOf` pins an exact release; `fenix.stable` would instead
          # float with the fenix input (the cause of the 1.95/1.96 drift).
          # To change versions: bump `channel`, set `sha256` back to
          # `pkgs.lib.fakeHash`, run `nix develop`, and paste the real hash
          # nix prints into `sha256`.
          rustChannel = "1.96.0";
          rustSha256 = "sha256-mvUGEOHYJpn3ikC5hckneuGixaC+yGrkMM/liDIDgoU=";
          rustHostToolchain = pkgs.fenix.toolchainOf {
            channel = rustChannel;
            sha256 = rustSha256;
          };
          rustTargetToolchain = pkgs.fenix.targets.aarch64-unknown-linux-gnu.toolchainOf {
            channel = rustChannel;
            sha256 = rustSha256;
          };
          rustToolchain = pkgs.fenix.combine [
            (rustHostToolchain.withComponents [
              "cargo" "clippy" "rustc" "rustfmt" "rust-src"
            ])
            rustTargetToolchain.rust-std
          ];

          cargoTools = with pkgs; [
            cargo-nextest cargo-watch cargo-expand cargo-audit cargo-zigbuild
          ];

          rustPkgs = [ rustToolchain pkgs.fenix.rust-analyzer ]
            ++ cargoTools;

          nodePkgs = with pkgs; [ nodejs_22 pnpm deno ];

          javaPkgs = with pkgs; [ jdk17_headless javacc ];

          # All packages combined
          allPkgs = minimal ++ buildTools ++ services ++ media
            ++ pythonPkgs ++ rustPkgs ++ nodePkgs ++ javaPkgs;

          # --- Hooks ---
          zshHook = ''
            export SHELL=${zshBin}
            if [ -z "$ZSH_VERSION" ] && [ -z "$DIRENV_IN_ENVRC" ]; then
              exec ${zshBin} -l
            fi
          '';

          uvHook = ''
            if [ -f "pyproject.toml" ] || [ -f ".python-version" ]; then
              UV_PY_VER="$(cat .python-version 2>/dev/null || echo 3.13)"
              if ! uv python find "$UV_PY_VER" >/dev/null 2>&1; then
                uv python install "$UV_PY_VER" >/dev/null || true
              fi
              if [ ! -d ".venv" ]; then
                uv venv --python "$UV_PY_VER" --seed .venv >/dev/null || true
              fi
              export VIRTUAL_ENV="$(pwd)/.venv"
              export PATH="$VIRTUAL_ENV/bin:$PATH"
              export PIP_DISABLE_PIP_VERSION_CHECK=1
              export PYTHONNOUSERSITE=1
              hash -r
            fi
          '';

          uvZshHook = uvHook + zshHook;

        in {
          # Full (default)
          default = pkgs.mkShell {
            packages = allPkgs;
            shellHook = uvZshHook;
          };

          # Language-specific (lean)
          python = pkgs.mkShell {
            packages = minimal ++ pythonPkgs;
            shellHook = uvZshHook;
          };

          python-rust = pkgs.mkShell {
            packages = minimal ++ buildTools ++ pythonPkgs ++ rustPkgs;
            shellHook = uvZshHook;
            RUST_SRC_PATH = "${rustHostToolchain.rust-src}/lib/rustlib/src/rust/library";
          };

          rust = pkgs.mkShell {
            packages = minimal ++ buildTools ++ rustPkgs;
            shellHook = zshHook;
            RUST_SRC_PATH = "${rustHostToolchain.rust-src}/lib/rustlib/src/rust/library";
          };

          rust-nightly = pkgs.mkShell {
            packages = minimal ++ buildTools ++ [
              (pkgs.fenix.complete.withComponents [
                "cargo" "clippy" "rustc" "rustfmt" "rust-src"
              ])
              pkgs.fenix.rust-analyzer
            ] ++ cargoTools;
            shellHook = zshHook;
            RUST_SRC_PATH = "${pkgs.fenix.complete.rust-src}/lib/rustlib/src/rust/library";
          };

          node = pkgs.mkShell {
            packages = minimal ++ nodePkgs;
            shellHook = zshHook;
          };
        }
      );
    };
}
