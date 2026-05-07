{ pkgs, ... }:

{
  # All the Windows / AD hacking related tools.
  environment.systemPackages = with pkgs; [
    openldap
    netexec
    powershell

  ];
}
