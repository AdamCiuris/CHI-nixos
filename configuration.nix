#Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ plasma-manager, config, nixpkgs, pkgs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		# ./home-manager/home-manager-module.nix
		# ./system/nixos-generators.nix
		./hardware-configuration.nix
		];
	# Bootloader.
	# boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/vda";
	boot.loader.grub.useOSProber = true;
	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.
	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Chicago";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	
	services.spice-vdagentd.enable = true; # enables clipboard sharing
	# Enable cinnamon desktop environment.
	services.xserver.displayManager.sddm ={
		enable = true; # lightweight display manager
		autoLogin = {
			enable=true;
			user="chi";
			relogin = true;
			};
	}; # lightweight display manager, "greeters" for 
	services.xserver.desktopManager.plasma5.enable = true;
	programs.dconf.enable = true;

	# Configure keymap in X11
	services.xserver = {
		layout = "us";
		xkbVariant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;
	# MORE PRINTER STUFF
	services.avahi = {
		enable = true;
		# Whether to run the Avahi daemon, which allows Avahi clients to use Avahi’s service discovery facilities and also allows the local machine to advertise its presence and services (through the mDNS responder implemented by avahi-daemon).
		nssmdns = true;
		openFirewall = true;
	};
	# hardware.printers = {
		# ensurePrinters = [
		# 	{
		# 		name = "Dell_1250c";
		# 		location = "Home";
		# 		deviceUri = "http://192.168.178.2:631/printers/Dell_1250c";
		# 		model = "drv:///sample.drv/generic.ppd";
		# 		ppdOptions = {
		# 			PageSize = "A4";
		# 		};
		# 	}
		# ];
		# # ensureDefaultPrinter = "Dell_1250c";
	# };




	
	# Enable sound with pipewire.
	sound.enable = true;
  # hardware.pulseaudio = {
  #   enable = true; #Enabling extra codecs, see https://nixos.wiki/wiki/Bluetooth
  #   package = pkgs.pulseaudioFull;
  # };
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};
	# https://nixos.wiki/wiki/Bluetooth
	# START BLUETOOTH
	hardware.bluetooth= {
		enable = true; # enables support for Bluetooth
		settings = {
			General = {
				Enable = "Source,Sink,Media,Socket"; # Enabling A2DP Sink
			};
		};
	};
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
	services.blueman.enable = true;
	# END BLUETOOTH

	users ={
		mutableUsers = true;
		users= {
			root = {
				initialHashedPassword="$y$j9T$qhPMNns01CkMEoPsVUSsv/$xmo.lUiUrxdp1eOyrTBonhgGFWhGyNPDr8my3LCz.E0";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				isSystemUser = true;
			}; 
			chi = {
				isNormalUser = true;
				description = "chi";
				initialHashedPassword = "$y$j9T$Fj7uE/Bbwy/Zk18712MCw1$UjvkW7f2p709pqW8.B.Hor7A4HezmEHAHQ.8.LDTkSD";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				# extraGroups = [ "networkmanager" "wheel" ];
				packages = with pkgs; [
					zsh
			
				];
			};
		};
	};
	programs.zsh.enable = true;
	# needed for vscode in pkgs
	# nixpkgs.config.allowUnfree = true;
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim
		nano # available by default but declare anyways
	];
	system.stateVersion = "23.11"; # Did you read the comment?

}
