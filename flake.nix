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
          # Go 1.27 lets a hard macOS sandbox use a mounted PEM bundle instead
          # of Security.framework's unavailable trust service.
          ghSandbox = pkgs.gh.override {
            buildGoModule = pkgs.buildGo127Module;
          };

          # --- Package Groups ---
          minimal = with pkgs; [ zsh ghSandbox bat hyperfine jq ripgrep just ];

          buildTools = with pkgs; [
            pkg-config clang zig
            autoconf automake libtool
          ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.libiconv ];

          services = with pkgs; [ redis memcached postgresql ];

          runtimeTools = with pkgs; [
            docker-client docker-compose process-compose k3d
          ];

          # To bump: update `nebiusVersion`, then refresh each hash with
          # `nix store prefetch-file <url>`.
          nebiusVersion = "0.12.280";
          nebiusReleases = {
            "aarch64-darwin" = {
              os = "darwin";
              arch = "arm64";
              hash = "sha256-v10vrm2v/RYGyiIXZy4+UsAssNtVTIuYIoLWlyR1DiY=";
            };
            "aarch64-linux" = {
              os = "linux";
              arch = "arm64";
              hash = "sha256-RP3IbM/rPhJWjHclEGfCQzcH0jDjuZDtgUMoUtEEba0=";
            };
            "x86_64-linux" = {
              os = "linux";
              arch = "x86_64";
              hash = "sha256-LjAg2RtWgF4lagAief8iLZ+zvQ9VUIGMseNMEKmTO9Q=";
            };
          };
          nebiusRelease = nebiusReleases.${system}
            or (throw "nebius: unsupported system ${system}");
          nebiusCli = pkgs.stdenvNoCC.mkDerivation {
            pname = "nebius";
            version = nebiusVersion;
            src = pkgs.fetchurl {
              url = "https://storage.eu-north1.nebius.cloud/cli/release/${nebiusVersion}/${nebiusRelease.os}/${nebiusRelease.arch}/nebius";
              inherit (nebiusRelease) hash;
            };
            dontUnpack = true;
            installPhase = ''
              runHook preInstall
              install -Dm755 "$src" "$out/bin/nebius"
              runHook postInstall
            '';
            doInstallCheck = true;
            installCheckPhase = ''
              runHook preInstallCheck
              [ "$("$out/bin/nebius" version)" = "${nebiusVersion}" ]
              runHook postInstallCheck
            '';
            meta = {
              description = "Nebius AI Cloud command-line interface";
              homepage = "https://docs.nebius.com/cli";
              mainProgram = "nebius";
              platforms = builtins.attrNames nebiusReleases;
              sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
            };
          };

          cloudTools = with pkgs; [ google-cloud-sdk nebiusCli ];

          ciTools = with pkgs; [ actionlint shellcheck yamllint ];

          infraTools = with pkgs; [ opentofu ];

          baseTools = minimal ++ cloudTools ++ ciTools ++ infraTools
            ++ [ pkgs.pandoc ];

          media = with pkgs; [ ffmpeg whisper-cpp ];

          docsPkgs = with pkgs; [ mdbook mdbook-mermaid ];

          latexPkgs = with pkgs; [
            (texliveMedium.withPackages (ps: [ ps.latexmk ]))
            biber
          ];

          pythonPkgs = with pkgs; [ uv ruff black pyright ];

          # Pinned Rust toolchain — single source of truth for the version.
          # To bump: update `channel`, set `sha256` to `pkgs.lib.fakeHash`,
          # run `nix develop`, paste the real hash nix prints.
          rustManifest = {
            channel = "1.100.0";
            sha256 = "sha256-MFHoWVcPZKjFrLnQnodCXbUsfZcofGfo9tV9fTTvklg=";
          };
          crossTargets = [
            "aarch64-unknown-linux-gnu"
            "aarch64-unknown-linux-musl"
            "x86_64-unknown-linux-gnu"
            "x86_64-unknown-linux-musl"
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
            cargo-sweep asciinema-agg sccache
          ];

          rustPkgs = [ rustToolchain pkgs.fenix.rust-analyzer pkgs.lld ]
            ++ cargoTools;

          nodePkgs = with pkgs; [ nodejs_24 pnpm deno ];

          haskellPkgs = with pkgs; [
            ghc cabal-install haskell-language-server
            hlint fourmolu
          ];

          javaPkgs = with pkgs; [ jdk25_headless javacc ];

          # All packages combined
          allPkgs = baseTools ++ buildTools ++ services ++ media
            ++ runtimeTools ++ docsPkgs ++ latexPkgs ++ pythonPkgs
            ++ rustPkgs ++ nodePkgs ++ haskellPkgs ++ javaPkgs;

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
            packages = baseTools ++ runtimeTools ++ pythonPkgs;
            shellHook = uvZshHook;
          };

          python-rust = pkgs.mkShell {
            packages = baseTools ++ buildTools ++ pythonPkgs ++ rustPkgs;
            shellHook = uvZshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          rust = pkgs.mkShell {
            packages = baseTools ++ buildTools ++ docsPkgs ++ rustPkgs;
            shellHook = zshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          # Nightly — for unstable rustfmt options and features, not cross-compilation
          rust-nightly = pkgs.mkShell {
            packages = baseTools ++ buildTools
              ++ [ nightlyToolchain pkgs.fenix.rust-analyzer ]
              ++ cargoTools;
            shellHook = zshHook;
            RUST_SRC_PATH = nightlySrcPath;
          };

          java = pkgs.mkShell {
            packages = baseTools ++ javaPkgs;
            shellHook = zshHook;
          };

          node = pkgs.mkShell {
            packages = baseTools ++ nodePkgs;
            shellHook = zshHook;
          };

          latex = pkgs.mkShell {
            packages = baseTools ++ latexPkgs;
            shellHook = zshHook;
          };

          rust-typescript = pkgs.mkShell {
            packages = baseTools ++ buildTools ++ services ++ rustPkgs
              ++ nodePkgs ++ runtimeTools;
            shellHook = zshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          rust-typescript-python = pkgs.mkShell {
            packages = baseTools ++ buildTools ++ services ++ pythonPkgs
              ++ rustPkgs ++ nodePkgs ++ runtimeTools;
            shellHook = uvZshHook;
            RUST_SRC_PATH = rustSrcPath;
          };

          haskell = pkgs.mkShell {
            packages = baseTools ++ buildTools ++ haskellPkgs;
            shellHook = zshHook;
          };
        }
      );
    };
}
