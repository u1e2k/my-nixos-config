{ config, pkgs, ... }:

{
  # Hyprland基本設定
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # ============================================================================
      # モニター設定
      # ============================================================================
      monitor = [
        ",preferred,auto,1"  # 自動検出
        # 複数モニターの場合は以下のように設定
        # "eDP-1,1920x1080@60,0x0,1"
        # "HDMI-A-1,1920x1080@60,1920x0,1"
      ];

      # ============================================================================
      # 起動時に実行するプログラム
      # ============================================================================
      exec-once = [
        "waybar"                    # ステータスバー
        "dunst"                     # 通知デーモン
        "fcitx5 -d"                 # 日本語入力
        "swww init"                 # 壁紙デーモン
        "wl-paste --watch cliphist store"  # クリップボード履歴
      ];

      # ============================================================================
      # 環境変数
      # ============================================================================
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "GTK_IM_MODULE,fcitx"
        "QT_IM_MODULE,fcitx"
        "XMODIFIERS,@im=fcitx"
        "SDL_IM_MODULE,fcitx"
        "GLFW_IM_MODULE,ibus"       # fcitx5用
      ];

      # ============================================================================
      # 入力デバイス設定
      # ============================================================================
      input = {
        kb_layout = "jp";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
        };
      };

      # ============================================================================
      # 一般設定
      # ============================================================================
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # ============================================================================
      # 装飾設定
      # ============================================================================
      decoration = {
        rounding = 10;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # ============================================================================
      # アニメーション設定
      # ============================================================================
      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # ============================================================================
      # レイアウト設定
      # ============================================================================
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      # ============================================================================
      # その他設定
      # ============================================================================
      gestures = {
        workspace_swipe = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # ============================================================================
      # キーバインド（Mod = SUPER/Windowsキー）
      # ============================================================================
      "$mod" = "SUPER";

      bind = [
        # アプリケーション起動
        "$mod, Return, exec, kitty"              # ターミナル
        "$mod, E, exec, nautilus"                # ファイルマネージャー
        "$mod, B, exec, firefox"                 # ブラウザ
        "$mod, D, exec, rofi -show drun"         # アプリランチャー
        
        # ウィンドウ操作
        "$mod, Q, killactive"                    # ウィンドウを閉じる
        "$mod, M, exit"                          # Hyprland終了
        "$mod, V, togglefloating"                # フローティング切り替え
        "$mod, F, fullscreen"                    # フルスクリーン
        "$mod, P, pseudo"                        # 疑似タイル
        "$mod, J, togglesplit"                   # スプリット方向切り替え

        # フォーカス移動
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # ワークスペース切り替え
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # ウィンドウをワークスペースに移動
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # スクロールでワークスペース切り替え
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # スクリーンショット
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"  # 範囲選択
        "SHIFT, Print, exec, grim - | wl-copy"             # 全画面

        # 音量調整（音量キーがある場合）
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # 画面の明るさ調整
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # マウスでウィンドウを移動/リサイズ
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
