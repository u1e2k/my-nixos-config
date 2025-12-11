# JaKooLit Hyprland設定統合モジュール

{ pkgs, inputs, ... }:

{
  # JaKooLitのパッケージを利用可能にする
  environment.systemPackages = with pkgs; [
    # JaKooLitで推奨されているツール
    hypridle
    hyprshot
    pyprland
    nwg-displays
    nwg-look
    waypaper
    
    # 追加の便利ツール
    loupe            # 画像ビューア
    baobab           # ディスク使用量
    cmatrix          # マトリックス風スクリーンセーバー
    distrobox        # コンテナツール
    duf              # ディスク使用量表示
    gdu              # ディスク使用量分析
    glances          # システムモニター
    gping            # グラフィカルping
    hyfetch          # neofetchの後継
    
    # ファイルマネージャー拡張
    # (yaziは既にHome Managerで設定済み)
  ];

  # Hyprland最適化設定
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 追加サービス
  services = {
    # GNOMEキーリング（パスワード管理）
    gnome.gnome-keyring.enable = true;
  };

  # zramスワップ（JaKooLit推奨設定）
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  # パワーマネジメント最適化
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # Flatpakサポート（オプション）
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Cachix for Hyprland（ビルド済みバイナリ）
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
