{ pkgs, inputs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    glfw
    cargo
    rustup
    uv
    nasm
    python3

    # go
    gofumpt
    inputs.go-overlay.packages.${stdenv.hostPlatform.system}.default
    gopls

    wezterm
    ghostty
    fzf
    zoxide
    sesh
    docker-compose
    git
    gh
    jdk

    # DB related:
    sqlitebrowser
    mariadb
    sqlcmd

  ];
}
