# カスタムモジュールディレクトリ

このディレクトリには、再利用可能なNixOSモジュールを配置します。

## 使い方

例: `modules/docker.nix` を作成した場合

```nix
# modules/docker.nix
{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.groups.docker.members = [ "user" ];
}
```

これを `hosts/thinkpad/default.nix` でインポート：

```nix
imports = [
  ./hardware-configuration.nix
  ../../modules/docker.nix
];
```

## モジュール例

- `development.nix` - 開発環境用の設定
- `gaming.nix` - ゲーム用の設定
- `server.nix` - サーバー用の設定
- `bluetooth.nix` - Bluetooth設定
