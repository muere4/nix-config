{ pkgs
, utils
, extraPackages ? []
}:
utils.env.importOnlyEnvironment ({
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Core functionality
      NrrwRgn
      popup-nvim
      plenary-nvim

      # Themes
      aurora
      dracula-nvim
      rose-pine
      kanagawa-nvim
      nightfox-nvim

      # File management and navigation
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-live-grep-args-nvim
      telescope-project-nvim
      telescope-symbols-nvim
      telescope-vim-bookmarks-nvim
      fzf-lua
      fzf-vim
      fzfWrapper
      dirbuf-nvim
      file-line

      # Git integration
      diffview-nvim
      git-blame-nvim
      gitlinker-nvim
      fzf-checkout-vim

      # Language support and LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip

      # Language-specific plugins
      haskell-vim
      hoogle
      fzf-hoogle-vim
      telescope_hoogle
      ghcid
      nvim-hs-vim
      rust-vim
      python-mode
      vim-nix
      dhall-vim
      html5-vim
      pgsql-vim

      # .NET/C# specific plugins - using only available plugins
      # Most C# support will come through LSP configuration

      # Debugging (verify availability)
      # nvim-dap                     # Debug Adapter Protocol
      # nvim-dap-ui                  # UI for DAP
      # nvim-dap-virtual-text        # Virtual text during debugging

      # Testing (verify availability)
      # neotest                      # Testing framework

      # Treesitter
      nvim-treesitter
      nvim-treesitter-context
      nvim-treesitter-pyfold
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-ts-autotag
      nvim-ts-context-commentstring
      rainbow-delimiters-nvim

      # Editing enhancements
      nvim-surround
      easy-align
      nvim-autopairs
      comment-nvim

      # UI enhancements
      nvim-web-devicons
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      which-key-nvim
      nvim-notify

      # Utilities
      nvim-lint
      nvim-highlight-colors
      editorconfig-nvim
      direnv-vim
      b64-nvim
      csv
      unicode-vim
      markdown-preview-nvim
      orgmode

      # Development tools
      nvim-gdb
      codi-vim
      prettyprint
      ultisnips

      # Additional telescope extensions
      telescope-asynctasks-nvim

      # Other useful plugins
      hydra-nvim
      prev_indent
      readline-vim
      bat-vim
      graphviz-vim
    ];

    extraConfig = builtins.readFile ./nvim-init.vim;
    extraLuaConfig = builtins.readFile ./nvim-init.lua + ''
      -- Configuración LSP para C#
      require('lspconfig').omnisharp.setup({
        cmd = { "${pkgs.omnisharp-roslyn}/bin/omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = false,
        enable_roslyn_analyzers = false,
        organize_imports_on_format = false,
        enable_import_completion = false,
        sdk_include_prereleases = true,
        analyze_open_documents_only = false,
      })

      -- Configuración de autocompletado
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Configuración de treesitter para C#
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c_sharp", "lua", "vim", "vimdoc", "query" },
        highlight = {
          enable = true,
        },
      })
    '';

    extraPackages = with pkgs; [
      # LSP servers
      haskell-language-server
      rust-analyzer
      clang-tools  # clangd
      nixd         # Nix LSP
      pyright      # Python LSP
      omnisharp-roslyn  # C# LSP server

      # Formatters
      stylua       # Lua formatter
      nixpkgs-fmt  # Nix formatter
      rustfmt      # Rust formatter

      # Additional tools
      ripgrep      # Required by telescope
      fd           # File finder
      tree-sitter  # For treesitter
    ] ++ extraPackages;
  };
})
