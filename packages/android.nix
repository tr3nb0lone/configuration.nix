{ pkgs, ... }:

{
  # putting all the stuff I want here when there's direnv. pathetic!
  environment.systemPackages = with pkgs; [

    jdk11
    android-tools
    android-studio

    frida-tools
    apktool
    jadx
  ];
}
