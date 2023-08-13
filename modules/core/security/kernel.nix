_: {

  security = {
    protectKernelImage = true;
    #can break some stuff
    #lockKernelModules = true;
  };

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
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;

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
      # Disable ftrace debugging
      "kernel.ftrace_enabled" = false;
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
