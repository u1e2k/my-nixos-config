{
  description = "NixOS configuration with flakes";

  inputs = {
    # 安定版のNixpkgs（2025年現在の推奨）
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    
    # unstable版も使えるようにしておく（最新パッケージが必要な時用）
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager - ユーザー環境を宣言的に管理
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # sops-nix - 秘密情報を安全に管理
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # nixos-hardware - よくあるハードウェアの最適化設定
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # JaKooLit/NixOS-Hyprland - 完全なHyprland設定パッケージ
    jakoolit-hyprland.url = "github:JaKooLit/NixOS-Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, nixos-hardware, jakoolit-hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # unstable版のパッケージをオーバーレイとして使えるようにする
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    in
    {
      # 各ホストの設定
      nixosConfigurations = {
        # メインのラップトップ設定
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          
          specialArgs = { inherit inputs; };
          
          modules = [
            # システム全体にオーバーレイを適用
            { nixpkgs.overlays = overlays; }
            
            # ホスト固有の設定
            ./hosts/laptop
            
            # Home Manager統合
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.user = import ./home/user;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            
            # sops-nix（秘密情報管理）
            sops-nix.nixosModules.sops
            
            # ThinkPad向けハードウェア最適化（必要に応じてコメントアウト）
            # nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          ];
        };
        
        # 別のマシン用の設定例（コメントアウト）
        # framework = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     { nixpkgs.overlays = overlays; }
        #     ./hosts/framework
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.useGlobalPkgs = true;
        #       home-manager.useUserPackages = true;
        #       home-manager.users.user = import ./home/user;
        #     }
        #     sops-nix.nixosModules.sops
        #   ];
        # };
      };
    };
}
