{ config, pkgs, ... }:

{
  # Rofi設定（Wayland版）
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "Arc-Dark";
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "アプリケーション";
      display-run = "実行";
      display-window = "ウィンドウ";
      drun-display-format = "{name}";
      font = "Noto Sans CJK JP 12";
    };
  };

  # Kitty（ターミナルエミュレータ）設定
  programs.kitty = {
    enable = true;
    
    settings = {
      # フォント設定
      font_family = "JetBrains Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "11.0";

      # カラースキーム
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      
      # カーソル
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";

      # 透明度
      background_opacity = "0.9";

      # ウィンドウ設定
      window_padding_width = 10;
      
      # タブバー
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # その他
      scrollback_lines = 10000;
      enable_audio_bell = false;
      
      # 日本語対応
      allow_remote_control = true;
      clipboard_control = "write-clipboard write-primary";
    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };

  # Dunst（通知デーモン）設定
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 0;
        
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        indicate_hidden = true;
        transparency = 10;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#89B4FA";
        separator_color = "frame";
        
        sort = true;
        idle_threshold = 120;
        
        font = "Noto Sans CJK JP 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        
        sticky_history = true;
        history_length = 20;
        
        browser = "firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };

      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#FAB387";
        timeout = 0;
      };
    };
  };
}
