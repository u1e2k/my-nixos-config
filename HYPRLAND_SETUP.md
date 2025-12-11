# 🚀 Hyprland + 日本語入力環境 セットアップ完了！

## ✨ 追加された機能

### 🎨 Hyprland（Waylandコンポジター）
- **モダンなウィンドウマネージャー** - GPU加速、美しいアニメーション
- **完全なキーバインド設定** - SUPER（Windowsキー）ベース
- **日本語フォント** - Noto Fonts CJK、Source Han、IPAフォント完備

### ⌨️ 日本語入力環境
- **fcitx5 + Mozc** - Googleの日本語IME
- **環境変数設定済み** - GTK、Qt、SDL対応
- **自動起動設定** - Hyprland起動時に自動で有効化

### 🛠️ ツール類
- **Waybar** - カスタマイズ可能なステータスバー（日本語表示対応）
- **Rofi** - アプリケーションランチャー（Wayland版）
- **Kitty** - GPU加速ターミナルエミュレータ
- **Dunst** - 通知デーモン
- **その他** - スクリーンショット、クリップボード、壁紙ツール完備

## 🎮 Hyprland キーバインド一覧

### 基本操作
| キー | 動作 |
|------|------|
| `SUPER + Return` | ターミナル起動（Kitty） |
| `SUPER + D` | アプリランチャー（Rofi） |
| `SUPER + E` | ファイルマネージャー（Nautilus） |
| `SUPER + B` | ブラウザ（Firefox） |
| `SUPER + Q` | ウィンドウを閉じる |
| `SUPER + M` | Hyprland終了 |

### ウィンドウ操作
| キー | 動作 |
|------|------|
| `SUPER + V` | フローティング切り替え |
| `SUPER + F` | フルスクリーン |
| `SUPER + 矢印キー` | フォーカス移動 |
| `SUPER + マウスドラッグ` | ウィンドウ移動 |
| `SUPER + 右クリック` | ウィンドウリサイズ |

### ワークスペース
| キー | 動作 |
|------|------|
| `SUPER + 1〜0` | ワークスペース切り替え |
| `SUPER + SHIFT + 1〜0` | ウィンドウを移動 |
| `SUPER + マウスホイール` | ワークスペース切り替え |

### システム
| キー | 動作 |
|------|------|
| `Print` | 範囲選択スクリーンショット |
| `SHIFT + Print` | 全画面スクリーンショット |
| `音量キー` | 音量調整 |
| `明るさキー` | 画面の明るさ調整 |

## 📝 日本語入力の使い方

### 切り替え方法
1. **Ctrl + Space** で日本語入力ON/OFF（fcitx5のデフォルト）
2. または **半角/全角キー**（日本語キーボードの場合）

### fcitx5設定変更
```bash
# 設定ツールを起動
fcitx5-configtool
```

## 🚀 初回起動手順

### 1. システムを再構築
```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#thinkpad
```

### 2. 再起動
```bash
sudo reboot
```

### 3. ログイン画面で選択
- TTYでログイン後、`Hyprland` と入力して起動
- または GDM/SDDM を設定している場合はセッション選択で「Hyprland」を選択

### 4. 初回起動時の確認項目
```bash
# Waybarが表示されているか確認
pidof waybar

# 日本語入力が動作しているか確認
fcitx5 -r  # 再起動

# 壁紙を設定（任意）
swww img /path/to/wallpaper.jpg
```

## 🎨 カスタマイズ

### Waybarの見た目を変更
[home/user/waybar.nix](home/user/waybar.nix) を編集

### Hyprlandの設定を変更
[home/user/hyprland.nix](home/user/hyprland.nix) を編集

### キーバインドを変更
```nix
# home/user/hyprland.nix
bind = [
  "$mod, T, exec, alacritty"  # ターミナルをAlacrittyに変更
  # ...
];
```

## 🔧 トラブルシューティング

### 日本語入力ができない場合
```bash
# fcitx5が起動しているか確認
ps aux | grep fcitx5

# 環境変数を確認
echo $GTK_IM_MODULE
echo $QT_IM_MODULE

# fcitx5を手動起動
fcitx5 -d --replace
```

### Waybarが表示されない場合
```bash
# Waybarを手動起動
waybar

# エラーログを確認
journalctl --user -u waybar
```

### キーボードレイアウトがおかしい場合
```bash
# Hyprlandのキーボード設定を確認
hyprctl devices

# 再設定
hyprctl keyword input:kb_layout jp
```

## 📦 追加パッケージ

システムに追加されたパッケージ：
- waybar, dunst, rofi-wayland
- kitty, alacritty
- grim, slurp, wl-clipboard, cliphist
- swww, imv
- brightnessctl, pavucontrol, playerctl
- nautilus, polkit-kde-agent
- xdg-desktop-portal-hyprland
- fcitx5, fcitx5-mozc, fcitx5-gtk, fcitx5-configtool
- 日本語フォント各種（Noto、Source Han、IPA）

## 🌟 おすすめの次のステップ

1. **壁紙を設定**
   ```bash
   swww img ~/Pictures/wallpaper.jpg
   ```

2. **テーマをカスタマイズ**
   - GTKテーマ: home/user/default.nixで設定
   - アイコンテーマ: Papirus-Darkなど

3. **追加ツールのインストール**
   - スクリーンロック: swaylock
   - セッションマネージャー: wlogout
   - アプリケーションメニュー: wofi

4. **dotfilesとして公開**
   - GitHubにpushして他のマシンでも即座に同じ環境を再現！

---

**🎉 快適なHyprland生活をお楽しみください！**
