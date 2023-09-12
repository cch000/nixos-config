_: {
  networking = {
    networkmanager.wifi.macAddress = "random";
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

  networking = {};

  boot.kernel.sysctl = {
    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Ingnore broadcasts requests
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv6.icmp.echo_ignore_all" = 1;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Make sure spoofed packets get logged
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;
    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = false;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };

  boot.kernelModules = ["tcp_bbr"];
}
