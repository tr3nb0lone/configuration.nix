{ inputs, pkgs, lib, config, ... }:

{
  # All the Windows / AD hacking related tools.
  environment.systemPackages = with pkgs; [
    python312Packages.bloodhound-py
    # bloodhound-quickwin
    # python312Packages.impacket-patched
    openldap
    # ldapdomaindump-patched
    python312Packages.certipy-ad
    netexec
    powershell
    python313Packages.bloodyad
    krb5Full
    krb5Full.dev
    samba4Full
    autobloody
    python312Packages.lsassy
    ldeep
    python312Packages.xlsxwriter
    # pyGPOAbuse
    python312Packages.pypykatz
    # wmiexec-Pro
    coercer
    # ntlm_theft
    # powerview-py
    # pkinittools
    # petitpotam
    adidnsdump
    adenum
    wimlib
    inputs.redflake-packages.packages.x86_64-linux.bloodhound-ce-desktop
    # shortscan
    certipy
    john
    netexec
    


  ];
}
