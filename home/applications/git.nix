{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      core.editor = "hx";

      alias = {
        st = "status";
        co = "checkout";      
      };
    };
  };
}
