{ pkgs, ... }: {
  home.packages = [
    pkgs.nushellPlugins.polars
  ];
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./../dotfiles/nushell/config.nu;
      extraConfig = ''
       let carapace_completer = {|spans|
       carapace $spans.0 nushell ...$spans | from json
       }
       $env.config = {
        show_banner: false,
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
       } 
       $env.PATH = ($env.PATH | 
       split row (char esep) |
       prepend /home/myuser/.apps |
       append /usr/bin/env
       )

       
      def --env y [...args] {
          let tmp = (mktemp -t "yazi-cwd.XXXXXX")
          yazi ...$args --cwd-file $tmp
          let cwd = (open $tmp | str trim)
          rm -f $tmp

          if ($cwd != "" and $cwd != $env.PWD and ($cwd | path exists)) {
              cd $cwd
          }
      }

      plugin add ${pkgs.nushellPlugins.polars}/bin/nu_plugin_polars
      '';
       shellAliases = {
         ll = "ls -l";
         i = "isolate";
         fg = "job unfreeze";
         zf = "tv zoxide";
         s = "cd (tv dirs)";
         wallpaper = "awww img --transition-type center";

         tvgb = "tv git-branch";
         tvgl = "tv git-log";
         tvf = "tv files";
         tvd = "tv dirs";
         tvz = "tv zoxide";
       };
     };  
     carapace.enable = true;
     carapace.enableNushellIntegration = true;

     starship = {
       enable = true;
       settings = {
         format = "$directory\${custom.isolate}$all$character";
         custom = {
          isolate = {
            command = "sh -c 'echo $ISOLATION'";
            when = "sh -c '[ -v ISOLATION ]'";
            format = "[$symbol](red) [$output](bold) ";
            symbol = "⎇";
          };
          bash = {
            command = "echo $STARSHIP_SHELL";
            when = "sh -c '[ $STARSHIP_SHELL != \"nu\" ]'";
            format = "$symbol [$output]($style) ";
            style = "bold";
            symbol = "🐚";
          };
         };

         add_newline = true;
         character = { 
         success_symbol = "[➜](bold green)";
         error_symbol = "[➜](bold red)";
       };
      };
    };
  };
}
