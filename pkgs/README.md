# カスタムパッケージディレクトリ

このディレクトリには、nixpkgsに存在しないカスタムパッケージを配置します。

## 使い方

例: `pkgs/my-app/default.nix` を作成した場合

```nix
# pkgs/my-app/default.nix
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "my-app";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "username";
    repo = "my-app";
    rev = "v${version}";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp my-app $out/bin/
  '';

  meta = with lib; {
    description = "My custom application";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
```

`flake.nix` でオーバーレイとして登録：

```nix
overlays = [
  (final: prev: {
    my-app = final.callPackage ./pkgs/my-app {};
  })
];
```

これでシステム全体で `pkgs.my-app` として使えます。
