{
  config,
  pkgs,
  ...
}: {
  security = {
    protectKernelImage = true;
    #can break some stuff
    #lockKernelModules = true;
    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    # Disable unprivileged user namespaces, unless containers are enabled
    unprivilegedUsernsClone = config.virtualisation.containers.enable;

    apparmor = {
      enable = true;
      enableCache = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };
  };

  services.dbus.apparmor = "enabled";

  boot = {
    kernelParams = [
      "lsm=landlock,lockdown,yama,apparmor,bpf"
      "iommu=force"
      "lockdown=confidentiality"
      "pti=on"
      "init_on_free=1"
      # WARNING: this will leak unhashed memory addresses to dmesg
      #"slub_debug=FZ"
      "page_alloc.shuffle=1"
      "vsyscall=none"
      "slab_nomerge"
      "randomize_kstack_offset=on"
    ];

    # Only necessary when lockKernelModules = true;
    #kernelModules = [
    #  "sd_mod"
    #  "usb_storage"
    #]; #Otherwise usb hardrives won't work

    kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      "kernel.sysrq" = 1;

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
      # Disable User Namespaces, as it opens up a large attack surface to unprivileged users.
      #"user.max_user_namespaces" = 0;
      # Disable tty line discipline autoloading
      "dev.tty.ldisc_autoload" = 0;
      # Disable ftrace debugging
      "kernel.ftrace_enabled" = false;

      ##Kernel hardening checker
      "dev.tty.legacy_tiocsti" = 0;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;

      ##Nix-mineral

      # Disable io_uring. May be desired for Proxmox, but is responsible
      # for many vulnerabilities and is disabled on Android + ChromeOS.
      "kernel.io_uring_disabled" = "2";

      ###Networking###

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
    };

    blacklistedKernelModules = [
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
  };
}
