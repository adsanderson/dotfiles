local groups = {
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle", "Pmenu",
  "Terminal", "EndOfBuffer", "FoldColumn", "Folded", "SignColumn", "LineNr",
  "CursorLineNr", "WhichKeyFloat", "TelescopeBorder", "TelescopeNormal",
  "TelescopePromptBorder", "TelescopePromptTitle", "NeoTreeNormal",
  "NeoTreeNormalNC", "NeoTreeVertSplit", "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer", "NvimTreeNormal", "NvimTreeVertSplit",
  "NvimTreeEndOfBuffer", "MiniPickNormal", "MiniPickBorder",
  "MiniPickPrompt", "SnacksNormal", "SnacksNormalNC",
}

local function apply()
  for _, name in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok then
      hl.bg = nil
      hl.ctermbg = nil
      if name == "Normal" then
        hl.fg = nil
        hl.ctermfg = nil
      end
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(apply)
  end,
})

vim.schedule(apply)

