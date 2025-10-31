{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nmap
    rustscan
    wafw00f
    nikto
    davtest
    joomscan
    whatweb
    onesixtyone
    whois
    eyewitness
    rpcbind
    samba
    smbmap
    enum4linux-ng
    # wireshark 
    smbclient-ng

  ];
}
