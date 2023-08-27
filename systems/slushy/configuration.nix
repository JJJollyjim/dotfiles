{ config, pkgs, lib, ... }: 
let
  libfprint = pkgs.libfprint.overrideAttrs( old : {
      version = "1.94.4";
      src = pkgs.fetchFromGitHub {
        owner = "Infinytum";
        repo = "libfprint";
        rev = "5e14af7f136265383ca27756455f00954eef5db1";
        sha256 = "sha256-MFhPsTF0oLUMJ9BIRZnSHj9VRwtHJxvWv0WT5zz7vDY=";
      };

      buildInputs = old.buildInputs ++ [pkgs.openssl];

          
      installCheckPhase = ''
        runHook preInstallCheck

        # ninjaCheckPhase

        runHook postInstallCheck
      '';
      
    });
in {
  imports = [
    ../modules/base.nix
    ../modules/efi.nix
    ../modules/desktop.nix
    ../modules/wireless.nix
    ../modules/bluetooth.nix
    ../modules/dm-sway.nix
    

    ./hardware-configuration.nix
  ];

  networking.hostName = "slushy";
  networking.hostId = "FFFFABCD";

  services.xserver = {
        libinput = {
            enable = true;            
        };
  };

  # powerManagement.powertop.enable = true;
  services.fwupd.enable = true;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/persist/secureboot";
    };
    bootspec.enable = true;
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 30;    
        editor = false;
      };
      timeout = 0;
    };
  };

  programs.light.enable = true; # needed for udev rules
  users.users.thobson.extraGroups = [ "docker" "video" ]; 

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override {libfprint = libfprint; };
  };

  

  services.udev.packages = [ pkgs.stlink pkgs.openocd pkgs.pulseview ];

  environment.systemPackages = with pkgs; [
    pkgs.pulseview
  ];

  hardware.sensor.iio.enable = true;


  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "hourly";
    };
    enableOnBoot = false;
    extraOptions = "--insecure-registry 'nef.stingray-monitor.ts.net:5000' --insecure-registry 'slushy.stingray-monitor.ts.net:5000' --insecure-registry '100.111.28.25:5000' --insecure-registry '100.112.226.140:5000'";
  };
  
  virtualisation = {
    # waydroid.enable = true;
    # lxd.enable = true;
  };


  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    i3lock-color.u2fAuth = true;
    i3lock.u2fAuth = true;
    swaylock = {};
  };
  
}