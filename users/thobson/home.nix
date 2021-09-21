{ systemName, config, pkgs, ... }:
let
  useSecret = import ../../useSecret.nix;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thobson";
  home.homeDirectory = "/home/thobson";


  imports = [
    ./i3.nix
    ./alacritty.nix
    ./emacs.nix
    ./keepass.nix
    ./browser.nix
    ./display.nix
    ../../modules/discord.nix

    (./. + "/${systemName}.nix")
    ];

  home.packages = with pkgs; [
    spotify
    thunderbird
    master.neofetch
    texstudio
    pavucontrol
    nmap
    obs-studio
    obs-v4l2sink
    zoom-us
    xfce.thunar
    xdotool
  ];

  


  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
        WakaTime.vscode-wakatime
        #ms-vscode-remote.remote-ssh # won't work with vscodium
      ];
  };

  programs.git = {
    enable = true;
    userName = "Thomas Hobson";
    userEmail = "thomas@hexf.me";
    signing.key = "0x107DA02C7AE97B084746564B9F1FD9D87950DB6F";
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentryFlavor = "qt";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = (useSecret {
      callback = secrets: secrets.ssh_hosts;
      default = {};
    });
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      nrb = "sudo nixos-rebuild --flake ~/dotfiles# switch";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.discord = {
    enable = true;
    autostart = true;
  };

  

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
