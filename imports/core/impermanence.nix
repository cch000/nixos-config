#inspired by https://github.com/NotAShelf/nyx/blob/5af8cfdd561cf5d9df3516c0f284ab4073c27235/modules/core/common/system/impermanence/default.nix
{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [inputs.impermanence.nixosModule];
  users = {
    # this option makes it that users are not mutable outside our configurations
    # if you are on nixos, you are probably smart enough to not try and edit users
    # manually outside your configuration.nix or whatever
    mutableUsers = false; # TODO: maybe check the existence of /persist/passwords with an assertion

    # P.S: This option requires you to define a password file for your users
    # inside your configuration.nix - you can generate this password with
    # mkpasswd -m sha-512 > /persist/passwords/notashelf after you confirm /persist/passwords exists

    users = {
      root = {
        # hashedPasswordFile needs to be in a volume marked with `neededForBoot = true`
        hashedPasswordFile = "/persist/passwords/root";
      };
      ${username} = {
        hashedPasswordFile = "/persist/passwords/${username}";
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager"
      "/etc/asusd"

      "/var/lib/libirt"
      "/var/lib/btrfs/"
    ];

    files = [
      # important state
      "/etc/machine-id"
    ];
  };

  # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/mapper/enc /mnt

    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  '';
}
