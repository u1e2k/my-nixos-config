# 🚀 My NixOS Configuration

**2025年最新のベストプラクティス構成** - Flakes + Home Manager + sops-nix 完全対応

## 📂 ディレクトリ構造

```text
my-nixos-config/
├── flake.nix                     # 📌 エントリーポイント（最重要）
├── flake.lock                    # 🔒 依存関係のロックファイル
├── hosts/                        # 💻 ホスト固有の設定
│   └── thinkpad/                 # メインマシン
│       ├── default.nix           # システム設定
│       └── hardware-configuration.nix  # ハードウェア設定（自動生成）
├── home/                         # 🏠 Home Manager設定
│   └── user/
│       └── default.nix           # ユーザー環境設定
├── modules/                      # 🧩 カスタムモジュール
├── secrets/                      # 🔐 暗号化された秘密情報（sops-nix）
├── pkgs/                         # 📦 カスタムパッケージ
└── README.md                     # このファイル
```

## 🎯 クイックスタート

### 1️⃣ 初回セットアップ（新しいNixOSマシンで）

#### 🚀 簡単インストール（推奨）

```bash
# このリポジトリをクローン
git clone git@github.com:YOUR_USERNAME/nixos-config.git ~/nixos-config
cd ~/nixos-config

# インタラクティブインストールスクリプトを実行
./install.sh
```

スクリプトが自動的に：
- ホスト名・ユーザー名を設定
- ハードウェア設定を生成
- システムをビルド

#### 📋 手動セットアップ

```bash
# このリポジトリをクローン
git clone git@github.com:YOUR_USERNAME/nixos-config.git ~/nixos-config
cd ~/nixos-config

# ハードウェア設定を生成（既存のものを置き換え）
sudo nixos-generate-config --show-hardware-config > hosts/thinkpad/hardware-configuration.nix

# Flakesを有効化（まだの場合）
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# システムを再構築して適用
sudo nixos-rebuild switch --flake .#thinkpad
```

### 2️⃣ 日常的な使い方

#### Just コマンド（推奨）

```bash
# システムを再構築
just rebuild

# パッケージ更新 + 再構築
just update

# 古い世代を削除
just clean

# システム情報表示
just info

# 全コマンド表示
just --list
```

#### または便利なエイリアスで
```bash
rebuild    # システム再構築
update     # パッケージ更新
clean      # クリーンアップ
```

> 💡 **詳細は [EASY_SETUP.md](EASY_SETUP.md) をご覧ください**

### 3️⃣ アップデート

## ⚙️ カスタマイズガイド

### ホスト名を変更する

[hosts/thinkpad/default.nix](hosts/thinkpad/default.nix) を編集：

```nix
networking.hostName = "your-hostname";  # ← ここを変更
```

### ユーザー名を変更する

1. [hosts/thinkpad/default.nix](hosts/thinkpad/default.nix)：

```nix
users.users.your-username = {  # ← userから変更
  isNormalUser = true;
  # ...
};
```

2. [home/user/default.nix](home/user/default.nix)：

```nix
home.username = "your-username";  # ← ここを変更
home.homeDirectory = "/home/your-username";
```

3. [flake.nix](flake.nix)：

```nix
home-manager.users.your-username = import ./home/user;  # ← ここも変更
```

### パッケージを追加する

#### システム全体で使うパッケージ

[hosts/thinkpad/default.nix](hosts/thinkpad/default.nix) の `environment.systemPackages` に追加：

```nix
environment.systemPackages = with pkgs; [
  firefox
  vlc
  your-package  # ← 追加
];
```

#### ユーザー個人のパッケージ

[home/user/default.nix](home/user/default.nix) の `home.packages` に追加：

```nix
home.packages = with pkgs; [
  discord
  your-package  # ← 追加
];
```

### unstable版のパッケージを使う

```nix
environment.systemPackages = with pkgs; [
  pkgs.unstable.neovim  # ← unstable版を使う
];
```

### デスクトップ環境を変更する

[hosts/thinkpad/default.nix](hosts/thinkpad/default.nix) を編集：

```nix
# GNOME（デフォルト）
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;

# KDE Plasmaに変更する場合
# services.xserver.displayManager.sddm.enable = true;
# services.xserver.desktopManager.plasma6.enable = true;

# Hyprlandに変更する場合
# programs.hyprland.enable = true;
```

## 🔐 秘密情報の管理（sops-nix）

### セットアップ

```bash
# 1. Ageキーを生成
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# 2. 公開鍵を確認（.sops.yamlに記載する）
age-keygen -y ~/.config/sops/age/keys.txt

# 3. .sops.yamlを作成
cat > .sops.yaml <<EOF
keys:
  - &admin YOUR_PUBLIC_KEY_HERE
creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *admin
EOF

# 4. 秘密情報ファイルを作成・編集
sops secrets/secrets.yaml
```

### 使用例

[hosts/thinkpad/default.nix](hosts/thinkpad/default.nix) に追加：

```nix
sops = {
  defaultSopsFile = ../../secrets/secrets.yaml;
  age.keyFile = "/home/user/.config/sops/age/keys.txt";
  secrets = {
    wifi-password = {};
    api-key = {};
  };
};

# 秘密情報を参照
networking.wireless.networks."MyWiFi".psk = config.sops.secrets.wifi-password.path;
```

## 🌟 便利なコマンド（エイリアス）

Home Managerで設定済み：

```bash
rebuild    # システム再構築
update     # flake.lock更新 → 再構築
clean      # ガベージコレクション（古い世代を削除）
search     # パッケージ検索

# Git
g          # git
gs         # git status
ga         # git add
gc         # git commit
gp         # git push
```

## 🖥️ 複数マシンの管理

新しいマシンを追加する場合：

```bash
# 1. ホスト用ディレクトリを作成
mkdir -p hosts/framework

# 2. 設定ファイルをコピー
cp hosts/thinkpad/default.nix hosts/framework/
sudo nixos-generate-config --show-hardware-config > hosts/framework/hardware-configuration.nix

# 3. flake.nixに追加
# nixosConfigurations.framework = ... を追記

# 4. 新しいマシンで適用
sudo nixos-rebuild switch --flake .#framework
```

## 🔧 トラブルシューティング

### ビルドが失敗する

```bash
# キャッシュをクリア
nix-collect-garbage -d
sudo nix-collect-garbage -d

# 再試行
sudo nixos-rebuild switch --flake .#thinkpad --show-trace
```

### ロールバック（前の世代に戻す）

```bash
# 世代一覧を表示
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 特定の世代に戻す
sudo nix-env --switch-generation 42 --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

# または起動時にGRUBメニューから選択
```

## 📚 参考リンク

- [NixOS公式マニュアル](https://nixos.org/manual/nixos/stable/)
- [Home Manager公式ドキュメント](https://nix-community.github.io/home-manager/)
- [sops-nix](https://github.com/Mic92/sops-nix)
- [nixos-hardware](https://github.com/NixOS/nixos-hardware)
- [NixOS Search（パッケージ検索）](https://search.nixos.org/)

## 🎨 おすすめ参考リポジトリ

- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [NotAShelf/nix-config](https://github.com/NotAShelf/nix-config)
- **[JaKooLit/NixOS-Hyprland](https://github.com/JaKooLit/NixOS-Hyprland)** - ✨ このリポジトリで統合済み！

## 🚀 追加機能

### JaKooLit/NixOS-Hyprland統合

このリポジトリには[JaKooLit/NixOS-Hyprland](https://github.com/JaKooLit/NixOS-Hyprland)の機能が統合されています。

詳細は [JAKOOLIT_INTEGRATION.md](JAKOOLIT_INTEGRATION.md) をご覧ください。

主な追加機能：
- 🎨 高度なHyprlandツール（hypridle, pyprland, waypaper等）
- ⚡ システム最適化（zramスワップ、パワーマネジメント）
- 📦 Flatpakサポート
- 🎯 Hyprland Cachix（高速ビルド）

---

**🐧 Enjoy NixOS Life! 🚀**