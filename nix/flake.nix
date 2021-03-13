{
  description = "HexF's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations.snowflake = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      hostname = "snowflake";

      modules = [ 
        (_: {
          supportedFilesystems = [ "zfs" ];
        })
       ];
    };

  };
}
