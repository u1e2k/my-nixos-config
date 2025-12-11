{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./wayland-tools.nix
  ];

  # ============================================================================
  # Home Manager基本設定
  # ============================================================================

  # Home Managerのバージョン（変更しないこと）
  home.stateVersion = "24.11";

  # ユーザー情報
  home = {
    username = "user";
    homeDirectory = "/home/user";
  };

  # Home Managerにプログラムインストールを許可
  programs.home-manager.enable = true;

  # ============================================================================
  # シェル設定（Zsh）
  # ============================================================================

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -alh";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # NixOS便利エイリアス
      rebuild = "sudo nixos-rebuild switch --flake /workspaces/my-nixos-config#thinkpad";
      update = "cd /workspaces/my-nixos-config && nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      search = "nix search nixpkgs";
      
      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
    };
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";  # お好みのテーマに変更可能: "agnoster", "powerlevel10k/powerlevel10k" など
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "copypath"
        "copyfile"
        "history"
      ];
    };
    
    initExtra = ''
      # カスタム設定
      export EDITOR=nvim
      export VISUAL=nvim
      
      # 履歴設定
      HISTSIZE=10000
      SAVEHIST=10000
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
    '';
  };

  # ============================================================================
  # Git設定
  # ============================================================================

  programs.git = {
    enable = true;
    userName = "Your Name";  # ←ここを変更
    userEmail = "your.email@example.com";  # ←ここを変更
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      
      # 差分表示の改善
      diff.algorithm = "histogram";
      merge.conflictstyle = "zdiff3";
    };
    
    # Git alias
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    
    # Delta（高機能なdiffツール）
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = false;
      };
    };
  };

  # ============================================================================
  # エディタ（Neovim）
  # ============================================================================

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      " 基本設定
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set clipboard=unnamedplus
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      
      " カラースキーム
      colorscheme default
    '';
  };

  # ============================================================================
  # ターミナルマルチプレクサ（tmux）
  # ============================================================================

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    
    extraConfig = ''
      # マウスサポート
      set -g mouse on
      
      # ウィンドウ番号を1から開始
      set -g base-index 1
      setw -g pane-base-index 1
      
      # ステータスバー
      set -g status-style bg=black,fg=white
      set -g status-left-length 40
    '';
  };

  # ============================================================================
  # ファイルマネージャー（CLI）
  # ============================================================================

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================================
  # ファジーファインダー（fzf）
  # ============================================================================

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
  };

  # ============================================================================
  # ディレクトリジャンプ（zoxide）
  # ============================================================================

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================================
  # 開発ツール
  # ============================================================================

  # Direnv（プロジェクトごとの環境変数管理）
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # ============================================================================
  # ユーザーパッケージ
  # ============================================================================

  home.packages = with pkgs; [
    # CLIツール
    bat           # catの代替（シンタックスハイライト）
    eza           # lsの代替（モダンなls）
    fd            # findの代替
    ripgrep       # grepの代替
    jq            # JSONプロセッサ
    yq            # YAMLプロセッサ
    tldr          # manの簡易版
    tree
    
    # システムモニタリング
    htop
    btop
    fastfetch     # neofetchの代替
    
    # ネットワーク
    wget
    curl
    httpie
    
    # 圧縮・解凍
    zip
    unzip
    p7zip
    
    # バージョン管理
    gh            # GitHub CLI
    
    # エディタ・IDE
    vscodium      # VSCodeのオープンソース版
    # unstable版を使う場合
    # pkgs.unstable.vscodium
    
    # ブラウザ
    firefox
    # chromium
    
    # Hyprland / Wayland関連
    brightnessctl    # 画面の明るさ調整
    pavucontrol      # 音量コントロール
    playerctl        # メディアプレイヤー制御
    networkmanagerapplet  # Wi-Fi設定
    
    # コミュニケーション
    # discord
    # slack
    
    # マルチメディア
    # vlc
    # mpv
    
    # オフィス
    # libreoffice-fresh
    
    # 開発言語（プロジェクトごとにflake.nixで管理するのが推奨）
    # python3
    # nodejs
    # go
    # rustc
    # cargo
  ];

  # ============================================================================
  # XDGディレクトリ設定
  # ============================================================================

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # ============================================================================
  # GTK / Qt テーマ設定（デスクトップ環境用）
  # ============================================================================

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Adwaita-dark";
  #     package = pkgs.gnome.gnome-themes-extra;
  #   };
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  # };

  # ============================================================================
  # サービス
  # ============================================================================

  # SSH agent
  services.ssh-agent.enable = true;

  # GPG agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
