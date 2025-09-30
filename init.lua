require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- make my migration smoother
-- guidance: https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
vim.keymap.set('n', ',z', ':bp<CR>')
vim.keymap.set('n', ',x', ':bn<CR>')
vim.keymap.set('n', ',h', ':<C-u>split<CR>')
vim.keymap.set('n', ',v', ':<C-u>vsplit<CR>')
vim.keymap.set('n', ',c', ':bd<CR>')

vim.keymap.set('n', ',ga', ':Gwrite<CR>')
vim.keymap.set('n', ',gb', ':Git blame<CR>')
vim.keymap.set('n', ',gd', ':Gvdiffsplit<CR>')

vim.keymap.set('n', ']q', ':cnext<CR>')
vim.keymap.set('n', '[q', ':cprev<CR>')
vim.keymap.set('n', ']l', ':lnext<CR>')
vim.keymap.set('n', '[l', ':lprev<CR>')

vim.opt.relativenumber = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 20
vim.opt.clipboard = ""

vim.cmd('cnoreabbrev W! w!')
vim.cmd('cnoreabbrev Q! q!')
vim.cmd('cnoreabbrev Qall! qall!')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev Wa wa')
vim.cmd('cnoreabbrev wQ wq')
vim.cmd('cnoreabbrev WQ wq')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qall qall')

vim.keymap.set('n', '<leader>tsa', ':TSToolsAddMissingImports<CR>', { desc = 'Add all missing TS imports' })
vim.keymap.set('n', '<leader>tso', ':TSToolsOrganizeImports<CR>', { desc = 'Sort and remove unused TS imports' })
vim.keymap.set('n', '<leader>tsf', ':TSToolsFixAll<CR>', { desc = 'Fix all TS related issues possible'})
vim.keymap.set('n', '<leader>tsr', ':TSToolsRemoveUnusedImports<CR>', { desc = 'Remove unused TS imports'})
vim.keymap.set('n', '<leader>tss', ':TSToolsSortImports<CR>', { desc = 'Sort TS imports'})
vim.keymap.set('n', '<leader>tsu', ':TSToolsRemoveUnused<CR>', { desc = 'Remove unused TS code'})

local function hide_diagnostics()
    vim.diagnostic.config({  -- https://neovim.io/doc/user/diagnostic.html
        virtual_text = false,
        signs = false,
        underline = false,
    })
end

local function show_diagnostics()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
    })
end

-- Configure diagnostic signs properly to avoid deprecation warnings
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    }
  }
})

vim.keymap.set("n", ",dh", hide_diagnostics, { desc = 'Hide diagnostics' })
vim.keymap.set("n", ",ds", show_diagnostics, { desc = 'Show diagnostics' })

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = 'Go to context' })
