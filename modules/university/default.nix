{ pkgs
, ...
}: {

  environment.systemPackages = with pkgs; [
    pandoc
    postman
    chromium
  ];

  #virtualisation.oci-containers.backend = "podman";
  #virtualisation.oci-containers.containers = {
  #  mongo = {
  #    image = "docker.io/library/mongo:latest";
  #    autoStart = true;
  #    ports = [ "27017:27017" ];
  #    volumes = [ "/home/cch/uniProjects/mongoData" ];
  #  };
  #};
}
