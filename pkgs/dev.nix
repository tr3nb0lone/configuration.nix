{ pkgs, ... }:

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

    wezterm
    ghostty
    fzf
    zoxide
    sesh
    docker-compose
    podman-compose
    podman-desktop
    git
    gh

    # DB related:
    sqlitebrowser
    dbeaver-bin
    mariadb
    sqlcmd

  ];
}
