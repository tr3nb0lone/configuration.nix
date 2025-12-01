{ pkgs, ... }:

{
  # All the Windows / AD hacking related tools.
  environment.systemPackages = with pkgs; [
    python312Packages.bloodhound-py
    openldap
    netexec
    powershell
    krb5
    samba4Full
    python312Packages.lsassy
    ldeep
    python312Packages.xlsxwriter
    python312Packages.pypykatz
    coercer
    adidnsdump
    adenum
    wimlib
    john
    netexec
    # inputs.redflake-packages.packages.x86_64-linux.bloodhound-ce-desktop

  ];
}
