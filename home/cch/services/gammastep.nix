_: {
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 57.7;
    longitude = 11.9;
    settings = {
      general.adjustment-method = "wayland";
    };
  };
}
