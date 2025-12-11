# hardware-configuration.nix は通常、nixos-generate-config で自動生成されます
# このファイルは実際のマシンで以下のコマンドで生成してください:
# sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# 以下はテンプレート例です。実際のハードウェアに合わせて生成し直してください。

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ============================================================================
  # ブート設定（要カスタマイズ）
  # ============================================================================

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # AMDの場合は "kvm-amd"
  boot.extraModulePackages = [ ];

  # ============================================================================
  # ファイルシステム（要カスタマイズ）
  # ============================================================================

  # 実際のUUIDは `blkid` コマンドで確認してください
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/xxxx-xxxx";
    fsType = "vfat";
  };

  # スワップパーティション（必要な場合）
  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; }
  # ];

  # ============================================================================
  # CPU / GPU設定
  # ============================================================================

  # Intel CPUの場合
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # AMD CPUの場合は以下を使用
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Intel GPUの場合
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver  # VAAPI
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # NVIDIA GPUの場合は以下を参考に
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   open = false;  # オープンソースドライバーを使う場合はtrue
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # ============================================================================
  # その他のハードウェア設定
  # ============================================================================

  # Bluetooth
  hardware.bluetooth.enable = true;

  # プリンター
  # services.printing.enable = true;

  # スキャナー
  # hardware.sane.enable = true;

  # ラップトップのバッテリー最適化
  services.power-profiles-daemon.enable = false;  # TLP使用時はfalse
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      START_CHARGE_THRESH_BAT0 = 40;  # バッテリー寿命を延ばす設定
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # タッチパッド
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      middleEmulation = true;
    };
  };

  # ============================================================================
  # 注意事項
  # ============================================================================
  # このファイルは実際のマシンで以下のコマンドを実行して生成してください:
  # sudo nixos-generate-config --show-hardware-config > hosts/thinkpad/hardware-configuration.nix
}
