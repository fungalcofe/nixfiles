{ config, lib, pkgs, ... }:

{
  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
        grpc_listen_port = 9096;
      };
      common = {
        path_prefix = "/tmp/loki";
        storage = {
          filesystem = {
            chunks_directory = "/tmp/loki/chunks";
            rules_directory = "/tmp/loki/rules";
          };
        };
        replication_factor = 1;
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
      };
      schema_config = {
        configs = [{
          from = "2020-10-24T00:00:00.000Z";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "h11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };
      # ruler.alertmanager_url = "http://localhost:9093";
      analytics.reporting_enabled = false;
    };
  };
}
