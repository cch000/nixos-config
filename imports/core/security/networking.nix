{lib, ...}: {
  users = {
    groups.tcpcryptd = {};
    users.tcpcryptd = {
      group = "tcpcryptd";
      isSystemUser = true;
    };
  };

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = ["mullvad-doh"];
      };
    };
    # systemd DNS resolver daemon
    resolved.enable = false; #So we can use dnscrypt-proxy2
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  networking = {
    #useDHCP = lib.mkForce false;
    #useNetworkd = lib.mkForce true;

    # dns
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    networkmanager = {
      enable = true;
      plugins = lib.mkForce []; # disable all plugins
      dns = "none"; # use dnscrypt-proxy2 as dns backend

      wifi = {
        macAddress = "random";
        scanRandMacAddress = true; #random MAC when scanning for wifi networks
      };

      #equivalent to "macchanger --ending"
      extraConfig = ''
        [connection]
        wifi.generate-mac-address-mask=FE:FF:FF:00:00:00
      '';
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
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

  boot.kernelModules = ["tcp_bbr"];
}
