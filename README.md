# Nixos configuration files

This is my personal nixos configuration.

## Installation instructions

Once you've booted the installation media:

1. `sudo su` so that we can actually do things.
2. `loadkeys es` set the keyboard layout to Spanish.
3. `nix-shell -p git nixUnstable` get a shell with git. 
4. `git clone https://gitlab.com/cch000/nixinstall` small script to set up partitions and stuff.
5. `cd nixinstall`
6. `chmod +x install`
7. `./install`
8. Add `neededForBoot = true` to `/persist` and `/var/log` in `hardware-configuration.nix`
9. Set up passwords:

     `mkpasswd -m sha-512 > /mnt/persist/passwords/<user&&root>`
    
10. `nixos-install --flake /mnt/etc/nixos/nixos-config#somehost`
11. profit???

## Credits

I have taken "inspiration" from these amazing configs:
 
- [Nýx by NotAShelf](https://github.com/NotAShelf/nyx#--n%C3%BDx)
- [Sioodmy's dotfiles](https://github.com/sioodmy/dotfiles)
- [viperML's dotfiles](https://github.com/viperML/dotfiles)
- [fufexan's dotfiles](https://github.com/fufexan/dotfiles)
