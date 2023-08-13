# Nixos configuration files

This is my personal nixos configuration.

## Installation instructions

Once you've booted the installation media:

1. `sudo su` so that we can actually do things.
2. `loadkeys es` set the keyboard layout to Spanish.
3. `nix-env -i git` temporally install git. 
4. `git clone https://gitlab.com/cch000/nixinstall` small script to set up partitions and stuff.
5. `cd nixinstall`
6. `chmod +x install`
7. `./install`
8. `nix-env -e git` remove git. 
8. Reboot into the basic installation.
9. If using impermanence set up passwords like this:

   `mkpasswd -m sha-512 > /persist/passwords/<user&&root>` after you confirm `/persist/passwords` exists

10. `git clone https://gitlab.com/cch000/nixos-config` My personal configuration.
11. `nix --extra-experimental-features nix-command --extra-experimental-features flakes nixos-rebuild boot --flake ~/nixos-config`
12. profit???
