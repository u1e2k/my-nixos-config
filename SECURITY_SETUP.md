# 🔐 1Password & 指紋認証セットアップガイド

## 🔑 1Password

### 初回セットアップ

1. **システムを再ビルド**
   ```bash
   just rebuild
   ```

2. **1Passwordを起動**
   ```bash
   1password
   # または SUPER+D → "1password" と入力
   ```

3. **アカウントにサインイン**
   - 既存アカウント: サインイン情報を入力
   - 新規: アカウントを作成

4. **ブラウザ拡張機能**
   - Brave: [Chrome Web Store](https://chrome.google.com/webstore) から「1Password」をインストール
   - デスクトップアプリと自動連携

### SSH キー管理

1Password で SSH キーを管理する場合：

```bash
# ~/.ssh/config に追加
Host *
    IdentityAgent ~/.1password/agent.sock
```

## 👆 指紋認証

### 対応ハードウェア

以下のような指紋センサーに対応：
- **Synaptics** (多くのDell, HP製品)
- **Goodix** (多くのLenovo製品)
- **ELAN** (一部のASUS製品)
- **VFS0090** (一部のDell製品) ← デフォルト設定

### 指紋を登録

```bash
# 指紋を登録（右手人差し指の例）
fprintd-enroll

# または特定の指を指定
fprintd-enroll -f right-index-finger
fprintd-enroll -f right-thumb
```

登録プロセス：
1. コマンドを実行
2. プロンプトに従って指を複数回スキャン
3. 「Enroll result: enroll-completed」と表示されたら完了

### 登録した指紋を確認

```bash
# 登録済みの指紋をリスト表示
fprintd-list $USER
```

### 登録した指紋を削除

```bash
# 特定の指を削除
fprintd-delete $USER

# 全て削除
fprintd-delete $USER --finger all
```

### 使用できる場所

- ✅ **ログイン画面** - パスワード代わりに指紋でログイン
- ✅ **sudo コマンド** - 管理者権限が必要な時
- ✅ **画面ロック解除** - swaylock使用時

### トラブルシューティング

#### 指紋センサーが認識されない

```bash
# デバイスを確認
lsusb | grep -i finger

# fprintdサービスの状態を確認
systemctl status fprintd
```

#### ドライバーが合わない場合

`hosts/laptop/default.nix` のドライバー設定を変更：

```nix
services.fprintd = {
  enable = true;
  tod.enable = true;
  # 機種に応じて変更
  tod.driver = pkgs.libfprint-2-tod1-vfs0090;  # Dell
  # tod.driver = pkgs.libfprint-2-tod1-goodix;  # Lenovo (Goodix)
  # tod.driver = pkgs.libfprint-2-tod1-elan;    # ASUS (ELAN)
};
```

または、TODドライバーを使わない場合：

```nix
services.fprintd = {
  enable = true;
  # tod.enable = false;  # 標準ドライバーを使用
};
```

#### 指紋認証が機能しない

```bash
# PAM設定を確認
cat /etc/pam.d/sudo | grep pam_fprintd

# テスト
fprintd-verify
```

## 🔒 セキュリティのヒント

### 1Password

- **マスターパスワード**は強固なものを設定
- **2要素認証**を有効化
- **緊急キット**を安全な場所に保管

### 指紋認証

- **複数の指**を登録（1本がうまくいかない時のバックアップ）
- **パスワードも覚えておく**（指紋センサー故障時のため）
- 指紋は**バイオメトリクスの補助**として使用し、重要な操作はパスワードも併用

## 💡 便利な使い方

### 1Password CLI

```bash
# CLIツールをインストール（オプション）
nix-shell -p _1password

# CLIでパスワード取得
op item get "GitHub Token" --fields password
```

### 指紋認証 + Hyprland

画面ロック時に指紋で解除：

```bash
# swaylockを指紋対応で起動（SUPER+L に設定推奨）
swaylock
```

## 🛠️ カスタマイズ

### 1Passwordのデータディレクトリ

デフォルト: `~/.config/1Password`

### fprintdの設定

`/etc/fprintd.conf` で詳細設定が可能（通常は不要）

---

**🎉 これで安全で便利な認証環境が整いました！**
