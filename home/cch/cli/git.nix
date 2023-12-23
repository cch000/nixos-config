_: {
  programs.git = {
    enable = true;
    userName = "Carlos";
    userEmail = "carloscamposherrera446@gmail.com";
    signing = {
      key = "E56E50F86E9F5DC9";
      signByDefault = true;
    };

    extraConfig = {
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
        editor = "nvim";
      };
      push.autoSetupRemote = true;
    };

    includes = [
      {
        contents = {
          user = {
            email = "carlosca@student.chalmers.se";
          };

          core = {
            sshCommand = "ssh -i ~/.ssh/id_ed25519_uni";
          };
        };

        condition = "gitdir:~/uniProjects/";
      }
    ];
  };
}
