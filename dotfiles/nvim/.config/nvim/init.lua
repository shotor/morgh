-- options
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"
vim.opt.showtabline = 2
vim.opt.clipboard = "unnamedplus" 

vim.opt.termguicolors = true
local theme = 'shotormorgh-purple-dark'
if vim.fn.executable('morgh-theme') == 1 then
  vim.opt.runtimepath:append('/usr/share/morgh/themes/editor/vim')
  local selected = vim.fn.trim(vim.fn.system({ 'morgh-theme', 'name' }))
  if vim.v.shell_error == 0 and selected:match('^shotormorgh%-[a-z%-]+$') then
    theme = selected
  end
end
vim.cmd.colorscheme(theme)

-- transparent when opened in kitty-dropdown-wl
if vim.env.NVIM_MODE == "dropdown" then
  vim.cmd [[
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
    hi SignColumn guibg=NONE ctermbg=NONE
    hi EndOfBuffer guibg=NONE ctermbg=NONE
  ]]
end

-- Bootstrap the plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to install lazy.nvim:\n" .. output, vim.log.levels.ERROR)
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        offsets = {
          { filetype = "neo-tree", text = "Files", text_align = "left" },
        },
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
      left = { { ft = "neo-tree", title = "Files" } },
      bottom = {
        {
          ft = "",
          title = "Terminal",
          size = { height = 0.3 },
          filter = function(buf, win)
            return vim.bo[buf].buftype == "terminal"
              and vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "auto", globalstatus = true },
      extensions = { "neo-tree" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    init = function()
      -- Let Neo-tree handle directory arguments instead of netrw.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local directory
          if vim.fn.argc() == 0 then
            if vim.bo.buftype ~= "" or vim.bo.modified then
              return
            end
            directory = vim.fn.getcwd()
          elseif vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            directory = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
            vim.cmd.enew()
          else
            return
          end
          require("neo-tree.command").execute({
            action = "show",
            source = "filesystem",
            position = "left",
            dir = directory,
          })
        end,
      })
    end,
    keys = {
      { "<C-n>", "<Cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
    },
    opts = {
      window = { position = "left", width = 30 },
      filesystem = { follow_current_file = { enabled = true } },
    },
  },
})

