-- FelixKratz's spaces.lua ported from yabai to AeroSpace:
-- only occupied + focused workspaces are drawn, names come from rename-workspace (alt-,)
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local state = require("helpers.state")

local NAMES_DIR = os.getenv("HOME") .. "/.local/state/sketchybar/workspace_names"
local WORKSPACES = 10

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_windows_change")

local spaces = {}
local brackets = {}
local paddings = {}

for i = 1, WORKSPACES, 1 do
  local space = sbar.add("item", "space." .. i, {
    drawing = false,
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
    click_script = "aerospace workspace " .. i,
  })

  -- Single item bracket for space items to achieve double border on highlight
  brackets[i] = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    }
  })

  paddings[i] = sbar.add("item", "space.padding." .. i, {
    drawing = false,
    width = settings.group_paddings,
  })

  spaces[i] = space
end

local function read_name(sid)
  local file = io.open(NAMES_DIR .. "/" .. sid, "r")
  if not file then return tostring(sid) end
  local name = file:read("*a")
  file:close()
  return (name ~= "") and name or tostring(sid)
end

local function update_spaces(focused)
  sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(windows)
    windows = tostring(windows)
    local apps = {}
    for ws, app in string.gmatch(windows, "(%d+)|([^\r\n]+)") do
      local sid = tonumber(ws)  -- loop variables are const in lua 5.5
      apps[sid] = apps[sid] or {}
      table.insert(apps[sid], app)
    end

    for i = 1, WORKSPACES, 1 do
      local selected = (tostring(i) == focused)
      local occupied = apps[i] ~= nil
      local drawing = (selected or occupied) and not state.menus_shown

      local icon_line = " —"
      if occupied then
        icon_line = ""
        for _, app in ipairs(apps[i]) do
          icon_line = icon_line .. " " .. (app_icons[app] or app_icons["Default"])
        end
      end

      spaces[i]:set({
        drawing = drawing,
        icon = { string = read_name(i), highlight = selected },
        label = { string = icon_line, highlight = selected },
        background = { border_color = selected and colors.black or colors.bg2 },
      })
      brackets[i]:set({
        background = { border_color = selected and colors.grey or colors.bg2 },
      })
      paddings[i]:set({ drawing = drawing })
    end
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe({ "forced", "aerospace_workspace_change", "aerospace_windows_change" },
  function(env)
    if env.FOCUSED_WORKSPACE and env.FOCUSED_WORKSPACE ~= "" then
      update_spaces(tostring(env.FOCUSED_WORKSPACE))
    else
      sbar.exec("aerospace list-workspaces --focused", function(focused)
        update_spaces((tostring(focused):gsub("%s+", "")))
      end)
    end
  end)

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
