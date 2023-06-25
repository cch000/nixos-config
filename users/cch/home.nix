{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cch";
  home.homeDirectory = "/home/cch";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    neofetch
    git
    powerline-fonts
    terminator
    neovim
    yarn
    nodejs
    rnix-lsp
    evince
    wl-clipboard
    tree
    vscodium.fhs
    gnome.eog
    gnome3.gnome-tweaks
    gnome.nautilus
  ];

  gtk = with pkgs; {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = papirus-icon-theme;
    };
    theme = {
      name = "adw-gtk3";
      package = adw-gtk3;
    };
  };

  programs.git = {
    enable = true;
    userName = "Carlos";
    userEmail = "carloscamposherrera446@gmail.com";
    extraConfig = {
      core.editor = "nvim";
    };
  };
}
