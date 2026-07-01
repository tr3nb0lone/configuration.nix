
rebuild:
	sudo nixos-rebuild switch --flake .#thinkpad
warn:
	sudo NIX_ABORT_ON_WARN=1 nixos-rebuild switch --flake .#thinkpad --show-trace --impure
purge:
	sudo nix-collect-garbage -d
