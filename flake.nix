{
  description = "Lean shells with optional heavy combos";

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

      # --- Packages ---
      common = with pkgs; [
        # shell
        zsh 

        # utilities
        git bat cloc jq gh

        mitmproxy
      
        # typescript - node, deno
        nodejs_20 pnpm deno

        # python
        uv

        # java
        jdk17_headless javacc

        # rust
        (pkgs.fenix.stable.withComponents [
          "cargo" "clippy" "rustc" "rustfmt" "rust-src"
        ])
        pkgs.fenix.rust-analyzer
        pkgs.cargo-nextest
        pkgs.cargo-watch
        pkgs.pkg-config

        claude-code

        pkgs.clang
      ];

      buildPkgs = with pkgs; [
        autoconf automake libtool clang pkg-config
        python313
      ];

      svcPkgs = with pkgs; [
        docker redis memcached
      ];

      zshBin = pkgs.lib.getExe pkgs.zsh;

      # --- Hooks ---
      uvZshHook = ''
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
        export SHELL=${zshBin}; if [ -z "$ZSH_VERSION" ]; then exec ${zshBin} -l; fi
      '';
    in {
      devShells.${system} = {
        # Everyday shell (now includes Rust)
        default = pkgs.mkShellNoCC {
          packages = common;
          shellHook = uvZshHook;
        };

        # When compiling/building
        build = pkgs.mkShell {
          packages = common ++ buildPkgs;
          shellHook = uvZshHook;
        };

        # When running services locally
        services = pkgs.mkShellNoCC {
          packages = common ++ svcPkgs;
          shellHook = uvZshHook;
        };

        # Heavy combo (build + services)
        heavy = pkgs.mkShell {
          packages = common ++ buildPkgs ++ svcPkgs;
          shellHook = uvZshHook;
        };
      };
    };
}
