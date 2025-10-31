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
   # Should be installed in a more better way!
    # ntlm_theft
    # wmiexec-Pro
    # pyGPOAbuse
    # autobloody
    # python313Packages.bloodyad
    # ldapdomaindump-patched
    # bloodhound-quickwin
    # python312Packages.impacket-patched
    # python312Packages.certipy-ad
    # powerview-py
    # pkinittools
    # inputs.redflake-packages.packages.x86_64-linux.bloodhound-ce-desktop
    # shortscan
    # certipy
    # petitpotam
    


  ];
}
