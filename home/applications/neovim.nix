{ pkgs, ... }: {
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      initLua = ''
        ${builtins.readFile ../dotfiles/neovim/options.lua}
      '';

      plugins = with pkgs.vimPlugins; [
        {
          type = "viml";
          plugin = gruvbox-material;
          config = "colorscheme gruvbox-material";
        }

        {
          type = "viml";
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }

        {
          type = "viml";
          plugin = nvim-lspconfig;
          config = toLuaFile ../dotfiles/neovim/plugin/lsp.lua;
        }

        {
          type = "viml";
          plugin = nvim-cmp;
          config = toLuaFile ../dotfiles/neovim/plugin/cmp.lua;
        }

        {
          type = "viml";
          plugin = telescope-nvim;
          config = toLuaFile ../dotfiles/neovim/plugin/telescope.lua;
        }

        telescope-fzf-native-nvim
        cmp_luasnip
        luasnip
        friendly-snippets
        lualine-nvim
        cmp-nvim-lsp
        neodev-nvim

        (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
          p.tree-sitter-rust
        ]))
      ];
    };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
