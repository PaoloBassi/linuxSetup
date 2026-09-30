local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

-- no front_app_switched on (re)load: ask AeroSpace for the initial label
sbar.exec("aerospace list-windows --focused --format '%{app-name}'", function(app)
  front_app:set({ label = { string = (tostring(app):gsub("%s+$", "")) } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
