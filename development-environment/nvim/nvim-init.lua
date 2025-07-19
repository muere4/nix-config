-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

-- Set colorscheme
vim.cmd("colorscheme kanagawa")

-- Leader key
vim.g.mapleader = " "

-- LSP Configuration
local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Haskell LSP
lsp.hls.setup({
    capabilities = capabilities,
    settings = {
        haskell = {
            formattingProvider = "fourmolu"
        }
    }
})

-- Rust LSP
lsp.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- C/C++ LSP
lsp.clangd.setup({
    capabilities = capabilities,
})

-- Nix LSP
lsp.nixd.setup({
    capabilities = capabilities,
})

-- Python LSP
lsp.pyright.setup({
    capabilities = capabilities,
})

-- Completion setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                                        ['<C-Space>'] = cmp.mapping.complete(),
                                        ['<C-e>'] = cmp.mapping.abort(),
                                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                                        ['<Tab>'] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                            cmp.select_next_item()
                                            elseif luasnip.expand_or_jumpable() then
                                                luasnip.expand_or_jump()
                                                else
                                                    fallback()
                                                    end
                                                    end, { 'i', 's' }),
                                                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                                                    if cmp.visible() then
                                                        cmp.select_prev_item()
                                                        elseif luasnip.jumpable(-1) then
                                                            luasnip.jump(-1)
                                                            else
                                                                fallback()
                                                                end
                                                                end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Telescope setup
local telescope = require('telescope')
telescope.setup({
    defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
})

telescope.load_extension('fzf')

-- Treesitter setup con configuración para Nix
local treesitter_install_dir = vim.fn.stdpath("data") .. "/treesitter"
vim.fn.mkdir(treesitter_install_dir, "p")

require('nvim-treesitter.configs').setup({
    -- NO usar ensure_installed con Nix - los parsers vienen preinstalados
    -- ensure_installed = { "haskell", "rust", "c", "cpp", "python", "nix", "lua" },

    -- Configurar directorio de parsers para evitar problemas con Nix
    parser_install_dir = treesitter_install_dir,

    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
})

-- Agregar el directorio de parsers al runtimepath
vim.opt.runtimepath:append(treesitter_install_dir)

-- Key mappings
local keymap = vim.keymap.set

-- Telescope mappings
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })

-- LSP mappings
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Go to definition' })
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = 'Go to references' })
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = 'Hover' })
keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code action' })
keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename' })
keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<cr>', { desc = 'Format' })

-- Git blame toggle
keymap('n', '<leader>gb', '<cmd>GitBlameToggle<cr>', { desc = 'Toggle git blame' })

-- Language-specific configurations
-- Haskell
vim.api.nvim_create_autocmd("FileType", {
    pattern = "haskell",
    callback = function()
    keymap('n', '<leader>ht', '<cmd>Telescope hoogle<cr>', { desc = 'Hoogle search', buffer = true })
    end,
})

-- Auto format on save for certain filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.hs", "*.rs", "*.nix", "*.lua" },
    callback = function()
    vim.lsp.buf.format()
    end,
})
