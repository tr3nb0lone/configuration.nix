{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    go
    autoconf
    automake
    glfw
    cmake
    clang-tools
    cargo
    rustup
    dotnet-sdk_8
    dotnet-runtime_8
    dotnet-aspnetcore_8
    mono
    jdk
    maven
    python311
    python313
    python312
    uv
    python313Packages.pip
    python313Packages.pipx
    python27Full
    python313Packages.bpython
    # windows.mingw_w64
    # windows.mingw_w64_headers
    cygwin.w32api-headers
    windows.sdk
    pkgs.pkgsCross.mingwW64.buildPackages.gcc13
    pkgs.pkgsCross.mingwW64.buildPackages.gcc # x86_64-w64-mingw32-gcc & g++
    pkgs.pkgsCross.mingw32.buildPackages.gcc # i686-w64-mingw32-gcc & g++
    pkgs.pkgsCross.mingwW64.buildPackages.binutils # Binutils for 64-bit
    pkgs.pkgsCross.mingw32.buildPackages.binutils # Binutils for 32-bit
    pkgs.pkgsCross.mingw32.windows.mcfgthreads
    pkgs.pkgsCross.mingwW64.windows.mcfgthreads
    pkgs.pkgsCross.mingwW64.stdenv.cc
    pkgs.llvmPackages.libcxxClang
    pkgs.zig
    nasm
    ruby
 # Dev utils
  docker_28
  wezterm
  ghostty
  fzf
  zoxide
  neovide
  docker-compose
  podman-compose
  podman-desktop
  git
  gh
    # DB related:
    sqlitebrowser
    dbeaver-bin
    sqlmap
    mariadb
    sqlcmd
    sqsh
    mdbtools

  ];
}
