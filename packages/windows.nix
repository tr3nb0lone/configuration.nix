{ pkgs, ... }:

{
  # All the Windows / AD hacking related tools.
  environment.systemPackages = with pkgs; [
    openldap
    netexec
    powershell
    krb5
    samba4Full
    ldeep
    wimlib
    john
    netexec
    # inputs.redflake-packages.packages.x86_64-linux.bloodhound-ce-desktop

  ];
}
