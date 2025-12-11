# 秘密情報ディレクトリ（sops-nix）

このディレクトリには、sops-nixで暗号化された秘密情報を配置します。

## ⚠️ 重要な注意事項

- **秘密鍵（keys.txt、.key ファイル）は絶対にGitにコミットしないでください！**
- `.gitignore` で既に除外設定されています

## セットアップ手順

### 1. Age キーペアを生成

```bash
# キーを保存するディレクトリを作成
mkdir -p ~/.config/sops/age

# キーペアを生成
age-keygen -o ~/.config/sops/age/keys.txt

# 公開鍵を表示（次のステップで使用）
age-keygen -y ~/.config/sops/age/keys.txt
```

### 2. .sops.yaml を作成

プロジェクトルートに `.sops.yaml` を作成（**このファイルもGitignore対象**）：

```yaml
keys:
  - &admin age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *admin
```

`age1xxx...` の部分は、ステップ1で表示された公開鍵に置き換えてください。

### 3. 秘密情報ファイルを作成・編集

```bash
# sopsで暗号化されたファイルを編集（初回は自動作成される）
sops secrets/secrets.yaml
```

エディタが開くので、秘密情報を記述：

```yaml
# secrets/secrets.yaml
wifi-password: "your-secure-password"
api-key: "your-api-key"
github-token: "ghp_xxxxxxxxxxxx"
```

保存すると自動的に暗号化されます。

### 4. NixOS設定で使用

`hosts/thinkpad/default.nix` に追加：

```nix
{
  # sops-nixの設定
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/user/.config/sops/age/keys.txt";
    
    secrets = {
      wifi-password = {
        # 復号後のファイルは /run/secrets/wifi-password に配置される
      };
      api-key = {};
    };
  };

  # 秘密情報を使う例
  # networking.wireless.networks."MyWiFi".psk = config.sops.secrets.wifi-password.path;
}
```

## GitHub / GitLab での共有方法

複数マシンやチームで秘密情報を共有する場合：

1. 各メンバーの公開鍵を `.sops.yaml` に追加
2. `sops updatekeys secrets/secrets.yaml` で再暗号化
3. 暗号化されたファイルはGitにコミット可能（平文は含まれない）

## 参考

- [sops-nix GitHub](https://github.com/Mic92/sops-nix)
- [Age GitHub](https://github.com/FiloSottile/age)
