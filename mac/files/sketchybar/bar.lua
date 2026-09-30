local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  -- above the auto-hidden macOS menu bar too, so its hover reveal stays covered
  topmost = "on",
  height = 40,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
})
