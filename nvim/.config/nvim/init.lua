local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Local marks per project
local function set_project_shada()
	local project_root = vim.fn.getcwd()
	local shada_path = project_root .. "/.nvim/shada"
	if vim.fn.filereadable(shada_path) == 1 then
		vim.opt.shadafile = shada_path
		vim.cmd("rshada!")
	else
		vim.opt.shadafile = ""
	end
end

set_project_shada()

vim.api.nvim_create_user_command("LocalShada", function()
	local project_root = vim.fn.getcwd()
	local shada_path = project_root .. "/.nvim/shada"
	vim.fn.mkdir(vim.fn.fnamemodify(shada_path, ":h"), "p")
	vim.opt.shadafile = shada_path
	vim.cmd("wshada!")
	print("Data is now local to this session")
end, {})

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

require("plugins")
require("remap")
require("set")

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
