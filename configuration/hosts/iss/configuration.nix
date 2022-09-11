{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nginx.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "iss";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "185.233.100.100" "2a0c:e300::100" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    mtu = 1500;
    ipv4 = {
      addresses = [{
        address = "185.233.103.71";
        prefixLength = 24;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a0c:e300::3:71";
        prefixLength = 64;
      }];
    };
  };
  networking.defaultGateway = {
    address = "185.233.103.254";
    interface = "ens18";
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300::3:126";
    interface = "ens18";
  };
  networking.interfaces.ens19.useDHCP = true;

  services.qemuGuest.enable = true;

  system.stateVersion = "22.05";
}