{  config, pkgs,... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";

in
{
	imports =  [
		(import "${home-manager}/nixos")
	];
	users.defaultUserShell = pkgs.zsh;
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.chi = {
		isNormalUser = true;
		useDefaultShell = true; # should be zsh
		description = "Catholic Charities computer club member";
		# extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			zsh
		];
	};
}
