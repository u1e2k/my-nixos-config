{ config, pkgs, inputs, ... }:

{
  imports = [
    # ハードウェア設定（nixos-generate-configで生成される）
    ./hardware-configuration.nix
    
    # JaKooLitの追加機能
    ../../modules/jakoolit-extras.nix
  ];

  # ============================================================================
  # 基本システム設定
  # ============================================================================

  # ホスト名（お好みで変更してください）
  networking.hostName = "thinkpad";

  # タイムゾーン
  time.timeZone = "Asia/Tokyo";

  # ロケール設定
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # コンソールの日本語対応
  console = {
    font = "Lat2-Terminus16";
    keyMap = "jp106";
  };

  # ============================================================================
  # 指紋認証（fprintd）
  # ============================================================================
  # dynabook V72/B (2016年冬モデル) は Synaptics VFS495/VFS491 等の
  # 古いセンサーを使用しており、標準libfprintでサポートされています

  services.fprintd = {
    enable = true;
    # 2016年モデルでは標準libfprintを使用（TODドライバー不要）
    # tod.enable = true;
    # tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  # PAMで指紋認証を有効化
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    # Hyprlandロック画面用
    swaylock.fprintAuth = true;
  };

  # ============================================================================
  # 1Password
  # ============================================================================

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Polkit統合
    polkitPolicyOwners = [ "user" ];
  };

  # 日本語入力環境（fcitx5 + Mozc）
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # 日本語フォント
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      ipafont
      ipaexfont
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" "IPAMincho" ];
        sansSerif = [ "Noto Sans CJK JP" "IPAGothic" ];
        monospace = [ "Noto Sans Mono CJK JP" "IPAGothic" ];
      };
    };
  };

  # ============================================================================
  # Nix設定
  # ============================================================================

  nix = {
    # Flakesとnew CLIを有効化
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # 信頼されたユーザー（sudo不要でnixを使える）
      trusted-users = [ "root" "@wheel" ];
      # 自動最適化（ストレージ節約）
      auto-optimise-store = true;
    };

    # ガベージコレクション（古い世代を自動削除）
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # 不自由なパッケージを許可（VSCode, Chromeなど）
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # ブートローダー
  # ============================================================================

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ============================================================================
  # ネットワーク
  # ============================================================================

  networking = {
    networkmanager.enable = true;
    # ファイアウォール設定
    firewall = {
      enable = true;
      # 必要なポートを開ける場合はここに追加
      # allowedTCPPorts = [ 22 80 443 ];
    };
  };

  # ============================================================================
  # ユーザー設定
  # ============================================================================

  users.users.user = {
    isNormalUser = true;
    description = "Main User";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    # パスワードは初回セットアップ後に `passwd` で設定推奨
    # initialPassword = "changeme";
    shell = pkgs.zsh;
  };

  # ============================================================================
  # デスクトップ環境 / ウィンドウマネージャー
  # ============================================================================

  # Hyprland（Waylandコンポジター）
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # X11サーバー（XWayland用に必要）
  services.xserver = {
    enable = true;
    
    # キーボードレイアウト
    xkb = {
      layout = "jp";
      variant = "";
    };
  };

  # GNOMEを使う場合（コメントアウトを外す）
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  
  # KDE Plasmaを使う場合
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma6.enable = true;

  # ============================================================================
  # サウンド
  # ============================================================================

  # PipeWire（モダンなサウンドサーバー）
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ============================================================================
  # システムパッケージ
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # 基本ツール
    vim
    neovim
    git
    wget
    curl
    htop
    btop
    tree
    unzip
    ripgrep
    fd
    fzf
    
    # ネットワーク
    networkmanager
    networkmanagerapplet
    
    # ファイルシステム
    ntfs3g
    exfat
    
    # Wayland / Hyprland関連
    waybar              # ステータスバー
    dunst               # 通知デーモン
    rofi-wayland        # アプリケーションランチャー
    swww                # 壁紙マネージャー
    grim                # スクリーンショット
    slurp               # 範囲選択
    wl-clipboard        # クリップボード
    cliphist            # クリップボード履歴
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    polkit-kde-agent    # 権限管理
    
    # ターミナルエミュレータ
    kitty               # GPU加速ターミナル
    alacritty           # 軽量ターミナル
    
    # ファイルマネージャー
    nautilus            # GUIファイルマネージャー
    
    # 画像ビューア
    imv                 # Wayland対応画像ビューア
    
    # unstable版のパッケージを使う例
    # pkgs.unstable.neovim
  ];

  # ============================================================================
  # プログラム設定
  # ============================================================================

  programs = {
    # Zsh
    zsh.enable = true;
    
    # Git
    git.enable = true;
    
    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # XDG Portal（ファイルピッカー、スクリーンシェアなど）
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # セキュリティ / Polkit
  security.polkit.enable = true;
  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # ============================================================================
  # サービス
  # ============================================================================

  services = {
    # SSH（リモートアクセスが必要な場合）
    openssh = {
      enable = false;  # 必要な場合はtrueに
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    
    # 自動アップデート（本番環境では慎重に）
    # automatic-updates = {
    #   enable = true;
    #   allowReboot = false;
    # };
  };

  # ============================================================================
  # Docker（必要な場合）
  # ============================================================================

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # ============================================================================
  # セキュリティ / sops-nix
  # ============================================================================

  # sops-nixで秘密情報を管理する場合
  # sops = {
  #   defaultSopsFile = ../../secrets/secrets.yaml;
  #   age.keyFile = "/home/user/.config/sops/age/keys.txt";
  #   secrets = {
  #     wifi-password = {};
  #   };
  # };

  # ============================================================================
  # システムバージョン（変更しないこと）
  # ============================================================================

  system.stateVersion = "24.11";
}
