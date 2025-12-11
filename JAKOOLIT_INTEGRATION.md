# 🎨 JaKooLit/NixOS-Hyprland 統合完了！

## ✨ 追加された機能

### 📦 JaKooLitから追加されたパッケージ

#### Hyprland関連ツール
- **hypridle** - アイドル時の動作管理
- **hyprshot** - スクリーンショットツール
- **pyprland** - Hyprland用Pythonプラグインシステム
- **nwg-displays** - ディスプレイ設定GUI
- **nwg-look** - GTKテーマ設定ツール
- **waypaper** - 壁紙管理ツール

#### システムツール
- **loupe** - GNOMEの画像ビューア
- **baobab** - ディスク使用量分析（GUI）
- **distrobox** - コンテナ環境
- **duf** - モダンなディスク使用量表示
- **gdu** - 高速ディスク使用量分析
- **glances** - 包括的システムモニター
- **gping** - グラフィカルping
- **hyfetch** - カスタマイズ可能なシステム情報表示

### ⚙️ システム最適化

#### zramスワップ
```nix
zramSwap = {
  enable = true;
  priority = 100;
  memoryPercent = 30;  # RAM の30%をzramに
  swapDevices = 1;
  algorithm = "zstd";  # 高速圧縮
};
```

#### パワーマネジメント
```nix
powerManagement = {
  enable = true;
  cpuFreqGovernor = "schedutil";  # 動的周波数調整
};
```

#### Hyprland Cachix
- ビルド済みバイナリを使用してビルド時間を短縮
- `https://hyprland.cachix.org` から自動ダウンロード

### 🔧 追加サービス

- **Flatpak** - 追加アプリケーションのインストール用
- **GNOME Keyring** - パスワード・認証情報の安全な保管

## 🚀 使い方

### 1. システムを再構築
```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#thinkpad
```

### 2. JaKooLit推奨ツールの使用

#### GTKテーマの設定
```bash
nwg-look
```

#### ディスプレイ設定
```bash
nwg-displays
```

#### 壁紙の設定
```bash
waypaper
```

#### スクリーンショット（JaKooLit版）
```bash
hyprshot -m region  # 範囲選択
hyprshot -m window  # ウィンドウ
hyprshot -m output  # 全画面
```

### 3. Flatpakでアプリをインストール
```bash
# Flathubが自動で追加されています
flatpak install spotify
flatpak install discord
flatpak install obs-studio
```

## 🎨 JaKooLitのdotfilesを使いたい場合

JaKooLitの完全なHyprland設定（dotfiles）も使用可能です：

```bash
# 1. JaKooLitのHyprland-Dotsをクローン
git clone https://github.com/JaKooLit/Hyprland-Dots ~/Hyprland-Dots

# 2. インストールスクリプトを実行
cd ~/Hyprland-Dots
./install.sh

# 3. 再ログインしてHyprlandを起動
```

### JaKooLit dotfilesの特徴
- **AGS（Aylur's GTK Shell）** - カスタマイズ可能なウィジェット
- **完全なWaybarテーマ** - 美しいステータスバー
- **Rofi / Wofi設定** - 統一されたランチャー
- **カスタムスクリプト** - 便利な自動化ツール多数
- **複数のカラースキーム** - Catppuccin等

## 📝 カスタマイズ

### JaKooLit機能を無効化したい場合

[hosts/thinkpad/default.nix](hosts/thinkpad/default.nix) から以下の行を削除：

```nix
imports = [
  ./hardware-configuration.nix
  # ../../modules/jakoolit-extras.nix  # ← コメントアウト
];
```

### 特定のパッケージだけ使いたい場合

[modules/jakoolit-extras.nix](modules/jakoolit-extras.nix) を編集して不要なパッケージを削除

## 🔗 関連リンク

- [JaKooLit/NixOS-Hyprland](https://github.com/JaKooLit/NixOS-Hyprland) - 本体リポジトリ
- [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) - Hyprland設定ファイル
- [JaKooLit/GTK-themes-icons](https://github.com/JaKooLit/GTK-themes-icons) - GTKテーマ

## 💡 ヒント

### pyprlandの使い方
```bash
# pyprlandを起動（Hyprland起動時に自動起動推奨）
pypr

# プラグイン機能を使う（例：スクラッチパッド）
pypr toggle term  # ドロップダウンターミナル
```

### システムモニタリング
```bash
glances  # 包括的な情報
btop     # 美しいUI
gdu      # ディスク使用量分析
duf      # ディスク使用量一覧
```

### Flatpak管理
```bash
flatpak list              # インストール済みアプリ
flatpak search <name>     # アプリ検索
flatpak update            # 全アプリ更新
flatpak uninstall <app>   # アプリ削除
```

---

**🎉 JaKooLitの強力なツール群をお楽しみください！**
