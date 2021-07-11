{config, lib, pkgs, ...}:
let
  useSecret = import ../../useSecret.nix;

in
{

  home.packages = with pkgs; [
    multimc
    dotnet-sdk
    insomnia
    (useSecret {
      callback = secrets: pkgs.factorio.override {
        username = secrets.factorio.username;
        token = secrets.factorio.token;
      };
    })
    jetbrains.datagrip
    jetbrains.idea-ultimate
    (callPackage ../../packages/audio-reactive-led-strip {})
    (callPackage ../../packages/digital {})

  ];

}
