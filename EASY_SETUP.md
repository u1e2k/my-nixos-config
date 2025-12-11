# 🚀 簡単インストール・管理ガイド

## 🆕 新しいマシンでのインストール

### 方法1: インタラクティブインストール（推奨）

```bash
# 1. このリポジトリをクローン
git clone https://github.com/YOUR_USERNAME/nixos-config.git ~/nixos-config
cd ~/nixos-config

# 2. インストールスクリプトを実行
./install.sh
```

スクリプトが自動的に以下を行います：
- ✅ ホスト名の設定
- ✅ ハードウェア設定の生成
- ✅ ユーザー名・Git設定の入力
- ✅ システムのビルドと適用

### 方法2: Just コマンドを使用

```bash
# justがインストールされていない場合
nix-shell -p just

# 一発でインストール
just rebuild
```

## 🔧 日常的な管理

### Just コマンド（おすすめ）

```bash
# システムを再構築
just rebuild

# パッケージ更新 + 再構築
just update

# 古い世代を削除（ストレージ節約）
just clean

# システム情報表示
just info

# 全コマンド表示
just --list
```

### NH (NixOS Helper) コマンド

```bash
# システム再構築
nh os switch

# アップデート
nh os switch -u

# クリーンアップ
nh clean all
```

### 従来のコマンド

```bash
# システム再構築
sudo nixos-rebuild switch --flake .#thinkpad

# アップデート
nix flake update
sudo nixos-rebuild switch --flake .#thinkpad

# クリーンアップ
sudo nix-collect-garbage -d
```

## 📋 便利なJustコマンド一覧

| コマンド | 説明 |
|---------|------|
| `just rebuild` | システムを再構築 |
| `just update` | パッケージ更新＋再構築 |
| `just clean` | 古い世代を削除 |
| `just boot` | 次回起動時に適用 |
| `just test` | テストモード（再起動で戻る） |
| `just rollback-previous` | 前の世代に戻す |
| `just generations` | 世代一覧を表示 |
| `just search <query>` | パッケージ検索 |
| `just info` | システム情報表示 |
| `just optimize` | ストレージ最適化 |
| `just deep-clean` | 徹底クリーンアップ |
| `just push "message"` | Git コミット＋プッシュ |

## 🆕 新しいホストを追加

```bash
# 1. 新しいホスト設定を作成
just new-host framework

# 2. ハードウェア設定を生成
sudo nixos-generate-config --show-hardware-config > hosts/framework/hardware-configuration.nix

# 3. flake.nix に追加
# nixosConfigurations.framework = ... を追記

# 4. ビルド
NIXOS_HOSTNAME=framework just rebuild
```

## 🔄 ロールバック

### 前の世代に戻す
```bash
just rollback-previous
```

### 特定の世代に戻す
```bash
# 世代一覧を表示
just generations

# 世代42に戻す
just rollback 42
```

## 🎯 エイリアス

シェルのエイリアスも使えます：

```bash
rebuild    # just rebuild と同じ
update     # just update と同じ
clean      # just clean と同じ
```

## 📦 パッケージ管理

### パッケージを検索
```bash
just search firefox
# または
nix search nixpkgs firefox
```

### パッケージを追加
1. `home/user/default.nix` または `hosts/thinkpad/default.nix` を編集
2. `just rebuild` で適用

## 🧹 メンテナンス

### 定期的なクリーンアップ
```bash
# 週1回推奨
just clean

# 月1回推奨（より徹底的）
just deep-clean
```

### ストレージ使用量確認
```bash
just info
# または
du -sh /nix/store
```

## 🔍 トラブルシューティング

### ビルドエラーの詳細を表示
```bash
just rebuild-debug
```

### 設定をチェック
```bash
just check
```

### ハードウェア設定を再生成
```bash
just regen-hardware
```

## 💡 ヒント

1. **エディタから直接ビルド**
   - VSCode: ターミナルで `just rebuild`
   - Vim/Neovim: `:!just rebuild`

2. **リモートマシンで適用**
   ```bash
   # SSH経由でビルド
   nixos-rebuild switch --flake .#thinkpad --target-host user@remote-host
   ```

3. **CI/CDで自動テスト**
   ```yaml
   # GitHub Actions例
   - name: Check Flake
     run: nix flake check
   ```

## 🎓 学習リソース

- [Just Manual](https://just.systems/man/en/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

---

**💡 Tip**: `just` コマンドを覚えるだけで、ほぼ全ての操作が簡単になります！
