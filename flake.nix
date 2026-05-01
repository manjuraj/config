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

          services = with pkgs; [ docker redis memcached ];

          media = with pkgs; [ ffmpeg whisper-cpp ];

          pythonPkgs = with pkgs; [ uv ruff black ];

          rustPkgs = with pkgs; [
            (pkgs.fenix.stable.withComponents [
              "cargo" "clippy" "rustc" "rustfmt" "rust-src"
            ])
            pkgs.fenix.rust-analyzer
            cargo-nextest cargo-watch cargo-expand
          ];

          nodePkgs = with pkgs; [ nodejs_20 pnpm deno ];

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

          rust = pkgs.mkShell {
            packages = minimal ++ buildTools ++ rustPkgs;
            shellHook = zshHook;
            RUST_SRC_PATH = "${pkgs.fenix.stable.rust-src}/lib/rustlib/src/rust/library";
          };

          node = pkgs.mkShell {
            packages = minimal ++ nodePkgs;
            shellHook = zshHook;
          };
        }
      );
    };
}
