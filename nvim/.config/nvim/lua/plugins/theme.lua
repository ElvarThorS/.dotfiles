local uv = vim.uv or vim.loop
local theme_path = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

if uv and uv.fs_stat(theme_path) then
  return dofile(theme_path)
end
return {}
