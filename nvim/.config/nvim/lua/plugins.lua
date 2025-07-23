require("lazy").setup({
	-- Core dependencies
	"nvim-lua/plenary.nvim",

	-- Navigation and file management
	{
		"ThePrimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)

			vim.keymap.set("n", "<leader>1", function()
				ui.nav_file(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				ui.nav_file(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				ui.nav_file(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				ui.nav_file(4)
			end)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				keymaps = {
					["<C-p>"] = function()
						require("telescope.builtin").find_files()
					end,
				},
			})
			vim.api.nvim_set_hl(0, "OilDir", { fg = "#A6CC70", bg = "NONE" })
			vim.api.nvim_set_hl(0, "OilDirIcon", { fg = "#A6CC70", bg = "NONE" })
			vim.keymap.set("n", "-", ":Oil<CR>")
		end,
	},

	-- Theming
	{
		"loctvl842/monokai-pro.nvim",
		config = function()
			require("monokai-pro").setup({})
		end,
	},

	{
		"tribela/transparent.nvim",
		config = function()
			require("transparent").setup({})
		end,
	},

	-- Syntax and treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"javascript",
					"typescript",
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	-- Mason for installing LSPs and Autoformatters
	{
		"williamboman/mason.nvim",
		version = "1.11.0",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "1.32.0",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({})
		end,
	},

	-- LSP config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-lspconfig.nvim",
			"cmp-nvim-lsp",
		},
		config = function()
			vim.opt.signcolumn = "yes"

			-- Diagnostic configuration
			vim.diagnostic.config({
				float = {
					border = "rounded",
					wrap = true,
				},
			})

			vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")

			-- Extend cmp with lsp
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			-- LSP hotkeys
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
					vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				end,
			})

			-- LSP setup
			require("lspconfig").lua_ls.setup({})
			require("lspconfig").pyright.setup({})
			require("lspconfig").clangd.setup({})
			require("lspconfig").marksman.setup({})
			require("lspconfig").asm_lsp.setup({})
			require("lspconfig").ts_ls.setup({})
		end,
	},

	-- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "cmp-nvim-lsp" },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
			})
		end,
	},
	"hrsh7th/cmp-nvim-lsp",

	-- Autoformatting
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.black.with({
						extra_args = { "--line-length", "79" },
					}),
					null_ls.builtins.formatting.clang_format.with({
						extra_args = { "-style={IndentWidth: 4}" },
					}),
					null_ls.builtins.formatting.prettier.with({
						extra_args = { "--tab-width-2" },
					}),
					null_ls.builtins.formatting.stylua,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format()
							end,
						})
					end
				end,
			})

			vim.keymap.set("n", "<leader>af", ":lua vim.lsp.buf.format()<cr>")
		end,
	},

	-- Copilot
	"github/copilot.vim",

	-- UI and icons
	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup()
		end,
	},
	"mg979/vim-visual-multi",

	-- TMUX integration
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup()
		end,
	},

	"christoomey/vim-tmux-navigator",

	-- Slime
	{
		"jpalardy/vim-slime",
		config = function()
			vim.g.slime_target = "tmux"
		end,
	},

	-- IPython
	{
		"hanschen/vim-ipython-cell",
		config = function()
			vim.g.slime_python_ipython = 1
			vim.keymap.set("n", "<C-CR>", ":IPythonCellExecuteCellVerbose<cr>")
		end,
	},
})
