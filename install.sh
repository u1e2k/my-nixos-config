#!/usr/bin/env bash
# NixOS Hyprland インストールスクリプト

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# アイコン
INFO="${BLUE}ℹ${NC}"
OK="${GREEN}✓${NC}"
WARN="${YELLOW}⚠${NC}"
ERROR="${RED}✗${NC}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  NixOS Hyprland Configuration Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 現在のディレクトリを確認
if [ ! -f "flake.nix" ]; then
    echo -e "${ERROR} flake.nix が見つかりません"
    echo -e "このスクリプトはリポジトリのルートディレクトリで実行してください"
    exit 1
fi

# ホスト名を取得
current_hostname=$(hostname)
echo -e "${INFO} 現在のホスト名: ${BLUE}$current_hostname${NC}"
read -p "使用するホスト名を入力 [デフォルト: $current_hostname]: " hostname
hostname=${hostname:-$current_hostname}

# ホスト設定ディレクトリが存在するか確認
if [ ! -d "hosts/$hostname" ]; then
    echo -e "${WARN} hosts/$hostname が存在しません"
    read -p "新しいホスト設定を作成しますか? (y/N): " create_host
    
    if [[ $create_host =~ ^[Yy]$ ]]; then
        echo -e "${INFO} laptop をテンプレートとして使用します..."
        cp -r hosts/laptop "hosts/$hostname"
        echo -e "${OK} hosts/$hostname を作成しました"
    else
        echo -e "${ERROR} ホスト設定が必要です"
        exit 1
    fi
fi

# ハードウェア設定を生成
echo ""
echo -e "${INFO} ハードウェア設定を生成しています..."
if sudo nixos-generate-config --show-hardware-config > "hosts/$hostname/hardware-configuration.nix"; then
    echo -e "${OK} hardware-configuration.nix を生成しました"
else
    echo -e "${ERROR} ハードウェア設定の生成に失敗しました"
    exit 1
fi

# ユーザー名を取得
current_user=$(whoami)
echo ""
echo -e "${INFO} 現在のユーザー名: ${BLUE}$current_user${NC}"
read -p "使用するユーザー名を入力 [デフォルト: $current_user]: " username
username=${username:-$current_user}

# Git設定を取得
echo ""
echo -e "${INFO} Git設定を入力してください"
read -p "Git ユーザー名: " git_username
read -p "Git メールアドレス: " git_email

# home/user/default.nix のGit設定を更新
if [ -n "$git_username" ] && [ -n "$git_email" ]; then
    sed -i "s/userName = \".*\"/userName = \"$git_username\"/" home/user/default.nix
    sed -i "s/userEmail = \".*\"/userEmail = \"$git_email\"/" home/user/default.nix
    echo -e "${OK} Git設定を更新しました"
fi

# flake.nix のホスト名を更新（必要に応じて）
if [ "$hostname" != "laptop" ]; then
    echo ""
    echo -e "${INFO} flake.nixを更新しています..."
    # laptop を新しいホスト名に置換（コメント行は除く）
    sed -i "/^[^#]*laptop/s/laptop/$hostname/g" flake.nix
    echo -e "${OK} flake.nixを更新しました"
fi

# Flakesを有効化（まだの場合）
echo ""
echo -e "${INFO} Nix Flakesを有効化しています..."
if ! grep -q "experimental-features.*flakes" /etc/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    echo -e "${OK} Flakesを有効化しました"
else
    echo -e "${OK} Flakesは既に有効です"
fi

# Git設定（flakeのために必要）
git config --global user.name "${git_username:-installer}"
git config --global user.email "${git_email:-installer@localhost}"

# 変更をgitに追加
echo ""
echo -e "${INFO} 変更をステージングしています..."
git add .

# 確認
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}以下の設定でインストールを開始します:${NC}"
echo -e "  ホスト名: ${GREEN}$hostname${NC}"
echo -e "  ユーザー名: ${GREEN}$username${NC}"
echo -e "  Git: ${GREEN}$git_username <$git_email>${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -p "続行しますか? (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${WARN} インストールをキャンセルしました"
    exit 0
fi

# ビルド開始
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}NixOSをビルドしています...${NC}"
echo -e "${YELLOW}これには時間がかかる場合があります。コーヒーでも飲んでお待ちください ☕${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if sudo nixos-rebuild switch --flake ".#$hostname"; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✨ インストールが完了しました！ ✨${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${INFO} 次のステップ:"
    echo -e "  1. ${YELLOW}sudo reboot${NC} で再起動"
    echo -e "  2. ログイン後 ${YELLOW}Hyprland${NC} を起動"
    echo -e "  3. ${YELLOW}just rebuild${NC} で設定を再適用"
    echo ""
    echo -e "${INFO} 便利なコマンド:"
    echo -e "  ${GREEN}just rebuild${NC}  - 設定を再ビルド"
    echo -e "  ${GREEN}just update${NC}   - パッケージを更新"
    echo -e "  ${GREEN}just clean${NC}    - 古い世代を削除"
    echo ""
else
    echo ""
    echo -e "${ERROR} ビルドに失敗しました"
    echo -e "エラーログを確認してください"
    exit 1
fi
