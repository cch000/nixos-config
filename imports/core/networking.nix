{
  lib,
  config,
  ...
}: let
  dnscrypt = config.services.dnscrypt-proxy2.enable;
  inherit (lib) mkIf;
in {
  services = {
    dnscrypt-proxy2 = {
      enable = true;
      upstreamDefaults = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = ["mullvad-doh"];
      };
    };
    # systemd DNS resolver daemon
    resolved.enable = !dnscrypt; #So we can use dnscrypt-proxy2
  };

  systemd.services = {
    dnscrypt-proxy2 = {
      partOf = ["network.target"];
    };
  };

  networking = {
    # dns
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    # explicity disable dhcpcd
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager = {
      enable = true;
      plugins = lib.mkForce []; # disable all plugins
      dns = mkIf dnscrypt "none"; # use dnscrypt-proxy2 as dns backend

      wifi = {
        powersave = true;
        macAddress = "random";
        scanRandMacAddress = true; #random MAC when scanning for wifi networks
      };

      #equivalent to "macchanger --ending"
      settings = {
        connection = {
          "wifi.generate-mac-address-mask" = "FE:FF:FF:00:00:00";
        };
      };
    };

    firewall = {
      enable = true;
      allowPing = false;
    };

    #Should block "most" junk sites
    stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
        "porn"
        #"social" # blocks stuff like reddit
      ];
    };
  };
}
