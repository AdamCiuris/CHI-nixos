{ plasma-manager, home-manager, config, pkgs,inputs, outputs,... }:
{
	users.defaultUserShell = pkgs.zsh;
	# BEGIN USER NYX
	users.users.chi.isNormalUser = true; # I'm a normal guy
	users.users.chi.useDefaultShell = true; # should be zsh
	home-manager.users.chi = {

		imports = [./home.nix ];
	}; # END USER NYX 
}
