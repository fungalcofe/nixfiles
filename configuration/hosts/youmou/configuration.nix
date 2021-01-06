{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../../common/servers
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Set networking
  networking = {
    firewall.allowedTCPPorts = [ 22 80 443 ];
    hostName = "youmou";
    useDHCP = false;
    interfaces.ens18 = {
      ipv4 = {
        addresses = [{
          address = "10.0.20.10";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "10.0.20.1";
        }];
      };
    };
    nameservers = [ "185.233.100.100" "185.233.100.101" "1.1.1.1" ];
  };

  services = {
    openssh.enable = true;
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      # other Nginx options
      virtualHosts."graphs.dupon.in" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://10.0.20.20:3000";
          extraConfig =
            # required when the target is also TLS server with multiple hosts
            "proxy_ssl_server_name on;" +
            # required when the server wants to use HTTP Authentication
            "proxy_pass_header Authorization;";
        };
      };
      virtualHosts."kanboard.zefirchik.xyz" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://10.0.50.20:80"; };
      };
      # Matrix test
      virtualHosts."matrix-test.melisse.org" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "matrix-test.melisse.org:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" = { "base_url" = "https://matrix-test.melisse.org"; };
              # "m.identity_server" = { "base_url" = "https://vector.im"; };
            };
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
          locations."/".extraConfig = ''
            return 404;
          '';
          locations."/_matrix" = {
            proxyPass = "http://10.0.50.10:8448";
          };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "graphs.dupon.in".email = "pwet+admin@dupon.in";
      "kanboard.zefirchik.xyz".email = "pwet+admin@dupon.in";
      "matrix-test.melisse.org".email = "pwet+admin@dupon.in";
    };
  };

  system.stateVersion = "20.09";
}
