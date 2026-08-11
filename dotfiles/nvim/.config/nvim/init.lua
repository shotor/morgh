-- options
vim.opt.number = true
vim.opt.clipboard = "unnamedplus" 

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

