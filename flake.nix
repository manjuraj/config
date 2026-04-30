{
  description = "Dev shells";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, fenix }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ fenix.overlays.default ];
      };
      zshBin = pkgs.lib.getExe pkgs.zsh;

      # --- Package Groups ---
      core = with pkgs; [
        zsh gh bat jq
        pkg-config clang libiconv
        autoconf automake libtool
        docker redis memcached
        ffmpeg-full 
        whisper-cpp
      ];

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

      # --- Hooks ---
      zshHook = ''
        export SHELL=${zshBin}
        if [ -z "$ZSH_VERSION" ] && [ -z "$DIRENV_IN_ENVRC" ]; then 
          exec ${zshBin} -l                                               
        fi                                                  
      '';

        uvZshHook = ''
        # Only run in Python projects
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
      '' + zshHook;
      
    in {
      devShells.${system} = {
        # Full (default)
        default = pkgs.mkShell {
          packages = core ++ pythonPkgs ++ rustPkgs ++ nodePkgs ++ javaPkgs;
          shellHook = uvZshHook;
        };

        # Language-specific (lean)
        python = pkgs.mkShellNoCC {
          packages = core ++ pythonPkgs;
          shellHook = uvZshHook;
        };

        rust = pkgs.mkShellNoCC {
          packages = core ++ rustPkgs;
          shellHook = zshHook;
        };

        node = pkgs.mkShellNoCC {
          packages = core ++ nodePkgs;
          shellHook = zshHook;
        };
      };
    };
}
