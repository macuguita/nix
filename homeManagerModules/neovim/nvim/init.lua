vim.cmd[[
    source ~/.vimrc
]]

local functions = require("functions")

-- Options
vim.opt.winborder   = "rounded"
vim.opt.tabstop     = 4
vim.opt.expandtab   = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4
vim.opt.signcolumn  = "yes"
vim.opt.wrap        = true
vim.opt.swapfile    = false
vim.opt.guicursor   = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250"

vim.g.mapleader = " "

-- Neovide
vim.o.guifont = "Maple Mono NL NF:h14"
vim.g.neovide_cursor_animation_length = 0

-- Keybinds
local map = vim.keymap.set
map("x", "<leader>a", functions.align_to_char, { desc = "Align to chosen char" })
map("n", "<leader>X", functions.pack_clean, { desc = "Clean unused plugins" })
map("", "<leader>d", ":Fex<CR>")
map("", "<leader>c", ":Compile<CR>")
map('n', '<leader>v', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if string.match(name, 'compilation') then
      vim.api.nvim_win_close(win, false)
      break
    end
  end
end, { desc = "Close compilation window" })
map("n", "<leader>f", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format file with LSP" })

vim.pack.add({
    { src = "https://github.com/editorconfig/editorconfig-vim" },
    { src = "https://github.com/blazkowolf/gruber-darker.nvim" },
    { src = "https://github.com/macuguita/fex.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/m00qek/baleia.nvim" },
    { src = "https://github.com/ej-shafran/compile-mode.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/airblade/vim-rooter" },
})

vim.cmd("colorscheme gruber-darker")
require("fex").setup({
    ls = "-lah --group-directories-first"
})
vim.g.compile_mode = {
    baleia_setup = true,
    default_command = "",
}

vim.g.rooter_change_directory_for_non_project_files = 'current'

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*compilation*",
  callback = function()
    if vim.fn.winnr('$') > 1 then
      vim.cmd('botright wincmd J | resize 10')
    end
  end,
})

local servers = {
    "lua_ls",
    "clangd",
    "nixd",
}
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})
vim.lsp.config("nixd", {
    cmd = { "nixd" },
    settings = {
        nixd = {
            formatting = {
                command = { "nixpkgs-fmt" }
            }
        }
    },
})

-- Show trailing whitespace
vim.opt.list = true

vim.opt.listchars = {
    tab      = '→ ',
    trail    = '▪',
    nbsp     = '␣',
    extends  = '⟩',
    precedes = '⟨'
}
