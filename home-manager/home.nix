{ inputs, outputs, lib, config, pkgs, ... }:
let
	shellExtra = ''
		# BEGIN XDG_DATA_DIRS CHECK
		# used to add .desktop files to xdg-mime from nix profile if dne
		# TODO figure out why this gets entered every home-manager switch
		local xdgCheck="$HOME/.nix_profile/share/applications"
		if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
			export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
		fi	
		# END XDG_DATA_DIRS CHECK
		# BEGIN FUNCTIONS
		desktopFiles() {
			local firstArg="$1"
			echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
			ls ~/.nix-profile/share/applications | grep "$firstArg"
			echo "searching for $firstArg in /usr/share/applications/..."
			ls /usr/share/applications | grep "$firstArg"
		}	# END FUNCTIONS


		# BEGIN ALIASES
		alias src="source"; 
		alias resrc="source ~/.zshrc";
		alias ...="../../"; 
		alias nrs="sudo nixos-rebuild switch"; 
		alias "g*"="git add *"; 
		alias gcm="git commit -m";
		alias gp="git push"; # conflicts with global-platform-pro, pari
		alias hms="home-manager switch";
		# END ALIASES
		'';
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};

in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
	home ={
		username = "chi";
		homeDirectory = "/home/chi";
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "23.11";
		
	};

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
	};

	home.sessionVariables = {
		EDITOR = "nano";
	};

	# if not nixOS chsh to /usr/bin/zsh else change users.defaultShell
		nixpkgs.config.allowUnfree=true;
		fonts.fontconfig.enable = true;
		# BEGIN SHELL CONFIGS
		# BEGIN BASH
		programs.bash ={
			enable=true;
			historyControl = ["ignoredups"];
			initExtra = shellExtra;
		}; # END BASH
		# BEGIN ZSH
		programs.zsh = {
			enable = true;
			enableAutosuggestions = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh={
				enable = true;
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
				plugins = [ "git" "sudo" "systemd" "python"];  # a bunch of aliases and a few functions
				theme = "agnoster";  # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
				};
			initExtra = shellExtra;
			}; # END ZSH
		home.packages = with pkgs; [
			google-chrome
			libreoffice
			htop
			git
			# does bootloader.grub.enable = true always have to be commented out for iso gen
			gimp
			vlc
			zsh
			xdg-utils
			x2g0
			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];
		# BEGIN USER CONFIGS	
		programs.git = {
			enable = true;
			userName = "throw away";
			userEmail = "pleaseletmemakeanaccount123@proton.me";
		};
		# START VSCODE
		programs.vscode = {
			enable=true;
			userSettings  = {
				"files.autoSave" = "afterDelay";
				"files.autoSaveDelay" = 0;
				"window.zoomLevel"= -1;
				"workbench.colorTheme"= "Tomorrow Night Blue";
				"terminal.integrated.fontFamily" = "DroidSansM Nerd Font"; # fc-list to see all fonts
			};
			keybindings =  [
				{
					key="ctrl+shift+[";
					command= "workbench.debug.action.focusRepl";
				}
				{
					key="ctrl+shift+]";
					command= "workbench.action.terminal.focus";
				}
				{
					key = "alt+d";
					command = "editor.action.deleteLines";
				}
				{
					key = "shift+alt+2";
					command = "workbench.action.terminal.resizePaneUp";
					when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
				}
				{
					key = "shift+alt+1";
					command = "workbench.action.terminal.resizePaneDown";
					when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
				}
			];
			mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install
			# installing malware

			extensions = (with pkgs.vscode-extensions; [
				ms-vscode-remote.remote-containers # for when flakes are too annoying
				ms-azuretools.vscode-docker
				batisteo.vscode-django
				ms-python.vscode-pylance
				ms-python.python
				shd101wyy.markdown-preview-enhanced
				ms-toolsai.jupyter
			]) ++ [
				(ext "Nix" "bbenoist" "1.0.1" "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=") # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
				(ext "copilot" "GitHub"  "1.168.0" "sha256-KoN3elEi8DnF1uIXPi6UbLh+8MCSovXmBFlvJuwAOQg=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
				(ext "nix-ide" "jnoortheen" "0.2.2" "sha256-jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=" ) # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
			];
		}; # END VSCODE
		# xdg-open is what gets called from open "file" in terminal


  imports = [
		./configs/xdg.nix
		./configs/plasma.nix
  ];


}
