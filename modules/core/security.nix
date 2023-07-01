{
  config,
  pkgs,
  lib,
  ...
}: {
  security = {
    protectKernelImage = true;
    lockKernelModules = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };
  };

  #Make /tmp volatile by mounting it in ram
  boot = {
    tmp.useTmpfs = lib.mkDefault true;
    # See description in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
    kernelParams = [
      "lsm=landlock,lockdown,yama,apparmor,bpf"
      "iommu=force"
      "lockdown=confidentiality"
      "pti=on"
      "init_on_free=1"
      "slub_debug=FZ"
      "vsyscall=none"
      "randomize_kstack_offset=on"
    ];
  };

  nix.settings.allowed-users = ["@wheel"];

  networking = {
    networkmanager.wifi.macAddress = "random";
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowPing = false;
    };
  };

  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

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

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";

    "kernel.exec-shield" = 1;

    # No core dump of executable setuid
    "fs.suid_dumpable" = 0;
    # Activation of the ASLR
    "kernel.randomize_va_space" = 2;
    # Prohibit mapping of memory in low addresses (0)
    "vm.mmap_min_addr" = 65536;
    # Larger choice space for PID values
    "kernel.pid_max" = 65536;
    # Obfuscation of addresses memory kernel
    "kernel.kptr_restrict" = 2;
    # Access restriction to the dmesg buffer
    "kernel.dmesg_restrict" = 1;
    # Restricts the use of the perf system
    "kernel.perf_event_paranoid" = 3;
    "kernel.perf_event_max_sample_rate" = 1;
    "kernel.perf_cpu_time_max_percent" = 1;
    # Control access rights to ptrace
    "kernel.yama.ptrace_scope" = 1;
    #Prevents a lot of possible attacks against the JIT compiler such as heap spraying
    "kernel.unprivileged_bpf_disabled" = 1;
    # Disable User Namespaces, as it opens up a large attack surface to unprivileged users.
    #"user.max_user_namespaces" = 0;
    # Disable tty line discipline autoloading
    "dev.tty.ldisc_autoload" = 0;
  };

  boot.kernelModules = ["tcp_bbr"];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];
}
