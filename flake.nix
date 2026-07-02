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
          minimal = with pkgs; [ zsh gh bat jq ripgrep ];

          buildTools = with pkgs; [
            pkg-config clang
            autoconf automake libtool
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];

          services = with pkgs; [ redis memcached postgresql vector ];

          media = with pkgs; [ ffmpeg whisper-cpp ];

          docsPkgs = with pkgs; [ mdbook ];

          pythonPkgs = with pkgs; [ uv ruff black pyright ];

          # Pinned Rust toolchain — single source of truth for the version.
          # To bump: update `channel`, set `sha256` to `pkgs.lib.fakeHash`,
          # run `nix develop`, paste the real hash nix prints.
          rustManifest = {
            channel = "1.96.0";
            sha256 = "sha256-mvUGEOHYJpn3ikC5hckneuGixaC+yGrkMM/liDIDgoU=";
          };
          crossTargets = [
            "aarch64-unknown-linux-gnu"
            "x86_64-unknown-linux-gnu"
          ];
          rustHostToolchain = pkgs.fenix.toolchainOf rustManifest;
          rustToolchain = pkgs.fenix.combine ([
            (rustHostToolchain.withComponents [
              "cargo" "clippy" "rustc" "rustfmt" "rust-src"
            ])
          ] ++ map (t:
            (pkgs.fenix.targets.${t}.toolchainOf rustManifest).rust-std
          ) crossTargets);
          rustSrcPath = "${rustHostToolchain.rust-src}/lib/rustlib/src/rust/library";

          nightlyToolchain = pkgs.fenix.complete.withComponents [
            "cargo" "clippy" "rustc" "rustfmt" "rust-src"
          ];
          nightlySrcPath = "${pkgs.fenix.complete.rust-src}/lib/rustlib/src/rust/library";

          cargoTools = with pkgs; [
            cargo-nextest cargo-watch cargo-expand cargo-audit cargo-zigbuild
            asciinema-agg
          ];

          rustPkgs = [ rustToolchain pkgs.fenix.rust-analyzer ]
            ++ cargoTools;

          nodePkgs = with pkgs; [ nodejs_24 pnpm deno ];

          haskellPkgs = with pkgs; [
            ghc cabal-install haskell-language-server
            hlint fourmolu
          ];

          javaPkgs = with pkgs; [ jdk25_headless javacc ];

          # All packages combined
          allPkgs = minimal ++ buildTools ++ services ++ media
            ++ docsPkgs ++ pythonPkgs ++ rustPkgs ++ nodePkgs
            ++ haskellPkgs ++ javaPkgs;

          # --- Hooks ---
          zshHook = ''
            export SHELL=${zshBin}
            if [ -z "$ZSH_VERSION" ] && [ -z "$DIRENV_IN_ENVRC" ]; then
              case "$-" in
                *i*) exec ${zshBin} -l ;;
              esac
            fi
          '';

          uvHook = ''
            if [ -f "pyproject.toml" ] || [ -f ".python-version" ]; then
              UV_PY_VER="$(cat .python-version 2>/dev/null || echo 3.14)"
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

          # Language-specific
          python = pkgs.mkShell {
            packages = minimal ++ pythonPkgs;
            shellHook = uvZshHook;
          };

          python-rust = pkgs.mkShell {
            packages = minimal ++ buildTools ++ pythonPkgs ++ rustPkgs;
            shellHook = uvZshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          rust = pkgs.mkShell {
            packages = minimal ++ buildTools ++ docsPkgs ++ rustPkgs;
            shellHook = zshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          # Nightly — for unstable rustfmt options and features, not cross-compilation
          rust-nightly = pkgs.mkShell {
            packages = minimal ++ buildTools
              ++ [ nightlyToolchain pkgs.fenix.rust-analyzer ]
              ++ cargoTools;
            shellHook = zshHook;
            RUST_SRC_PATH = nightlySrcPath;
          };

          java = pkgs.mkShell {
            packages = minimal ++ javaPkgs;
            shellHook = zshHook;
          };

          node = pkgs.mkShell {
            packages = minimal ++ nodePkgs;
            shellHook = zshHook;
          };

          haskell = pkgs.mkShell {
            packages = minimal ++ buildTools ++ haskellPkgs;
            shellHook = zshHook;
          };
        }
      );
    };
}
