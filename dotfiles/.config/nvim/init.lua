-- Ember for Neovim: no plugins, just the palette and a few sane options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.scrolloff = 6
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.fillchars = { eob = " " }

local c = {
    bg = "#191715", bg2 = "#23201d", bg3 = "#2e2a26", sel = "#3a3530",
    fg = "#ece5da", sub = "#a89f93", dim = "#5a524b",
    clay = "#d97757", sage = "#8fae8b", sand = "#e0b872",
    red = "#d0675f", blue = "#7f9cb8", rose = "#c48aa8", teal = "#7fb0a8",
}

vim.cmd("highlight clear")
vim.g.colors_name = "ember"
local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.bg2 })
hl("FloatBorder", { fg = c.clay, bg = c.bg2 })
hl("CursorLine", { bg = c.bg2 })
hl("CursorLineNr", { fg = c.clay, bold = true })
hl("LineNr", { fg = c.dim })
hl("SignColumn", { bg = c.bg })
hl("Visual", { bg = c.sel })
hl("Search", { fg = c.bg, bg = c.sand })
hl("IncSearch", { fg = c.bg, bg = c.clay })
hl("CurSearch", { fg = c.bg, bg = c.clay })
hl("MatchParen", { fg = c.clay, bold = true })
hl("StatusLine", { fg = c.fg, bg = c.bg3 })
hl("StatusLineNC", { fg = c.sub, bg = c.bg2 })
hl("WinSeparator", { fg = c.bg3 })
hl("Pmenu", { fg = c.fg, bg = c.bg2 })
hl("PmenuSel", { fg = c.bg, bg = c.clay })
hl("Title", { fg = c.clay, bold = true })
hl("Directory", { fg = c.blue })

hl("Comment", { fg = c.dim, italic = true })
hl("Constant", { fg = c.sand })
hl("String", { fg = c.sage })
hl("Character", { fg = c.sage })
hl("Number", { fg = c.sand })
hl("Boolean", { fg = c.clay })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.blue })
hl("Statement", { fg = c.clay })
hl("Keyword", { fg = c.clay })
hl("Operator", { fg = c.sub })
hl("PreProc", { fg = c.rose })
hl("Type", { fg = c.teal })
hl("Special", { fg = c.rose })
hl("Delimiter", { fg = c.sub })
hl("Todo", { fg = c.bg, bg = c.sand, bold = true })
hl("Error", { fg = c.red })
hl("WarningMsg", { fg = c.sand })
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.sand })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.teal })

-- a small statusline: mode, file, position
local modes = { n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", c = "COMMAND", R = "REPLACE" }
hl("StMode", { fg = c.bg, bg = c.clay, bold = true })
function _G.ember_status()
    local m = modes[vim.fn.mode()] or vim.fn.mode()
    return "%#StMode# " .. m .. " %#StatusLine# %f %m%=%l:%c  %p%% "
end
vim.opt.statusline = "%!v:lua.ember_status()"
