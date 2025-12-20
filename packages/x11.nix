{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # get all X11 libraries FFS

xorg.libAppleWM       xorg.libX11           xorg.libXcomposite    xorg.libXfixes        xorg.libXinerama      xorg.libXrandr        xorg.libXv            xorg.libdmx           xorg.libxcvt
xorg.libFS            xorg.libXScrnSaver    xorg.libXcursor       xorg.libXfont         xorg.libXmu           xorg.libXrender       xorg.libXvMC          xorg.libfontenc       xorg.libxkbfile
xorg.libICE           xorg.libXTrap         xorg.libXdamage       xorg.libXfont2        xorg.libXp            xorg.libXres          xorg.libXxf86dga      xorg.libpciaccess     xorg.libxshmfence
xorg.libSM            xorg.libXau           xorg.libXdmcp         xorg.libXft           xorg.libXpm           xorg.libXt            xorg.libXxf86misc     xorg.libpthreadstubs
xorg.libWindowsWM     xorg.libXaw           xorg.libXext          xorg.libXi            xorg.libXpresent      xorg.libXtst          xorg.libXxf86vm       xorg.libxcb


  ];
}
