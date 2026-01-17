-- Theme
vim.cmd("colorscheme monokai-pro")
vim.o.background = "dark"
vim.o.termguicolors = true

vim.o.clipboard = "unnamedplus"

vim.o.swapfile = false

vim.o.nu = true
vim.o.relativenumber = true

vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.scrolloff = 8

vim.o.updatetime = 50

vim.o.wrap = true
vim.o.breakindent = true

-- vim.o.signcolumn = 'no'
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>")
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>")
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>")

vim.keymap.set("n", "$", "g_")
vim.keymap.set("n", "0", "g^")

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.keymap.set("n", "<C-CR>", ":IPythonCellExecuteCellVerbose<cr>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.keymap.set("n", "<leader>r", ":IPythonCellExecuteCellVerbose<cr>")
