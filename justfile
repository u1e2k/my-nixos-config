# NixOS Configuration Management
# https://github.com/casey/just

# デフォルトホスト名（環境変数で上書き可能）
hostname := env_var_or_default('NIXOS_HOSTNAME', 'laptop')

# デフォルトのレシピを表示
default:
    @just --list

# システムを再構築（flake.lock更新なし）
rebuild:
    @echo "🔨 システムを再構築しています..."
    sudo nixos-rebuild switch --flake .#{{hostname}}
    @echo "✅ 完了！"

# システムを再構築（デバッグモード）
rebuild-debug:
    @echo "🔍 デバッグモードでシステムを再構築しています..."
    sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace
    @echo "✅ 完了！"

# flake.lockを更新してシステムを再構築
update:
    @echo "📦 flake.lockを更新しています..."
    nix flake update
    @echo "🔨 システムを再構築しています..."
    sudo nixos-rebuild switch --flake .#{{hostname}}
    @echo "✅ 完了！"

# 特定のinputだけ更新
update-input input:
    @echo "📦 {{input}} を更新しています..."
    nix flake lock --update-input {{input}}
    @echo "🔨 システムを再構築しています..."
    sudo nixos-rebuild switch --flake .#{{hostname}}
    @echo "✅ 完了！"

# 世代をリスト表示
generations:
    @echo "📋 システム世代一覧:"
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 古い世代を削除（ガベージコレクション）
clean:
    @echo "🗑️  古い世代を削除しています..."
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    @echo "✅ 完了！"

# 特定の世代に戻す
rollback generation:
    @echo "⏪ 世代 {{generation}} にロールバックしています..."
    sudo nix-env --switch-generation {{generation}} --profile /nix/var/nix/profiles/system
    sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    @echo "✅ 完了！"

# 1つ前の世代に戻す
rollback-previous:
    @echo "⏪ 前の世代に戻しています..."
    sudo nixos-rebuild switch --rollback
    @echo "✅ 完了！"

# ビルドのみ（適用しない）
build:
    @echo "🔨 ビルドのみ実行しています..."
    sudo nixos-rebuild build --flake .#{{hostname}}
    @echo "✅ 完了！"

# ブート時に適用（今すぐ反映しない）
boot:
    @echo "🔨 次回起動時に適用します..."
    sudo nixos-rebuild boot --flake .#{{hostname}}
    @echo "✅ 完了！次回起動時に反映されます"

# テスト（再起動まで適用、再起動でロールバック）
test:
    @echo "🧪 テストモードで適用しています..."
    sudo nixos-rebuild test --flake .#{{hostname}}
    @echo "✅ 完了！再起動すると元に戻ります"

# flakeをチェック
check:
    @echo "🔍 Flakeをチェックしています..."
    nix flake check
    @echo "✅ 完了！"

# flakeのメタデータを表示
show:
    @echo "📋 Flakeメタデータ:"
    nix flake show

# flakeのinputsを表示
inputs:
    @echo "📦 Flake inputs:"
    nix flake metadata | grep -A 100 "Inputs:"

# 設定ファイルをフォーマット
format:
    @echo "✨ Nixファイルをフォーマットしています..."
    find . -name '*.nix' -type f -exec alejandra {} \;
    @echo "✅ 完了！"

# 新しいホスト設定を作成
new-host name:
    @echo "📁 新しいホスト {{name}} を作成しています..."
    cp -r hosts/laptop hosts/{{name}}
    @echo "✅ hosts/{{name}} を作成しました"
    @echo "次のステップ:"
    @echo "  1. hosts/{{name}}/default.nix を編集"
    @echo "  2. sudo nixos-generate-config --show-hardware-config > hosts/{{name}}/hardware-configuration.nix"
    @echo "  3. flake.nix に新しいホストを追加"

# ハードウェア設定を再生成
regen-hardware:
    @echo "🔧 ハードウェア設定を再生成しています..."
    sudo nixos-generate-config --show-hardware-config > hosts/{{hostname}}/hardware-configuration.nix
    @echo "✅ 完了！"

# パッケージを検索
search query:
    @echo "🔍 '{{query}}' を検索しています..."
    nix search nixpkgs {{query}}

# システム情報を表示
info:
    @echo "💻 システム情報:"
    @echo ""
    @echo "ホスト名: {{hostname}}"
    @echo "NixOS バージョン:"
    @nixos-version
    @echo ""
    @echo "現在の世代:"
    @sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1
    @echo ""
    @echo "ディスク使用量 (/nix/store):"
    @du -sh /nix/store 2>/dev/null || echo "計測できませんでした"

# GitHub にプッシュ
push message:
    @echo "📤 変更をコミット＆プッシュしています..."
    git add .
    git commit -m "{{message}}"
    git push
    @echo "✅ 完了！"

# 変更を確認
diff:
    @echo "📝 変更されたファイル:"
    git status --short

# Home Manager のみ再構築
home:
    @echo "🏠 Home Managerを再構築しています..."
    home-manager switch --flake .#user
    @echo "✅ 完了！"

# 最適化（ストレージ節約）
optimize:
    @echo "🗜️  Nixストアを最適化しています..."
    nix-store --optimise
    @echo "✅ 完了！"

# 全てのクリーンアップと最適化
deep-clean:
    @echo "🧹 徹底的にクリーンアップしています..."
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    nix-store --gc
    nix-store --optimise
    @echo "✅ 完了！"

# ヘルプ
help:
    @echo "NixOS Configuration Management"
    @echo ""
    @echo "よく使うコマンド:"
    @echo "  just rebuild       - システムを再構築"
    @echo "  just update        - パッケージ更新＆再構築"
    @echo "  just clean         - 古い世代を削除"
    @echo "  just info          - システム情報を表示"
    @echo ""
    @echo "その他のコマンド:"
    @echo "  just --list        - 全コマンド一覧"
