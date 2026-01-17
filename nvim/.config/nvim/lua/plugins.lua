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
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
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

	"tpope/vim-surround",
	"AndrewRadev/tagalong.vim",

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

	-- Vim fugitive
	{
		"tpope/vim-fugitive",
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

			-- LSP hotkeys
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
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
			require("lspconfig").hls.setup({})
		end,
	},

	-- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
				}),
			})
		end,
	},
	"hrsh7th/cmp-nvim-lsp",

	-- Autoformatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "black" },
					cpp = { "clang_format" },
					c = { "clang_format" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					lua = { "stylua" },
					json = { "fixjson" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			-- Custom formatter settings
			require("conform").formatters.black = {
				prepend_args = { "--line-length", "79" },
			}
			require("conform").formatters.clang_format = {
				prepend_args = { "-style={IndentWidth: 4}" },
			}
			require("conform").formatters.prettier = {
				prepend_args = { "--tab-width", "2" },
			}

			-- Keymap for manual formatting
			vim.keymap.set("n", "<leader>af", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format file" })
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
			vim.keymap.set("n", "<C-CR>", ":IPythonCellExecuteCell<cr>")
		end,
	},
})
