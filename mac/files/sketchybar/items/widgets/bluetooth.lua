-- Bluetooth widget (not in FelixKratz's config, written in the same style), via blueutil.
-- Left click: popup with power switch and paired devices (click = connect/disconnect).
-- Right click: Bluetooth settings.
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

-- SF Symbols has no Bluetooth logo: Nerd Font glyphs
local BT_FONT = "IosevkaTerm Nerd Font:Regular:16.0"
local BT_OFF = "󰂲"
local BT_ON = "󰂯"
local BT_CONNECTED = "󰂱"

local bluetooth = sbar.add("item", "widgets.bluetooth", {
  position = "right",
  icon = {
    font = BT_FONT,
    string = BT_ON,
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
  update_freq = 10,
  popup = { align = "center" },
})

local bracket = sbar.add("bracket", "widgets.bluetooth.bracket", { bluetooth.name }, {
  background = { color = colors.bg1 },
  popup = { align = "center" },
})

sbar.add("item", "widgets.bluetooth.padding", {
  position = "right",
  width = settings.group_paddings
})

local power = sbar.add("item", "bluetooth.power", {
  position = "popup." .. bracket.name,
  width = popup_width,
  align = "center",
  icon = { string = icons.switch.on },
  label = { string = "Bluetooth", font = { style = settings.font.style_map["Bold"] } },
  background = { height = 2, color = colors.grey, y_offset = -15 },
})

local function update()
  sbar.exec("blueutil --power", function(power_state)
    local on = tostring(power_state):match("1") ~= nil
    power:set({
      icon = { string = on and icons.switch.on or icons.switch.off,
               color = on and colors.blue or colors.grey },
    })
    if not on then
      bluetooth:set({ icon = { string = BT_OFF, color = colors.grey } })
      return
    end
    sbar.exec("blueutil --connected --format json | jq length", function(count)
      local connected = (tonumber(count) or 0) > 0
      bluetooth:set({
        icon = {
          string = connected and BT_CONNECTED or BT_ON,
          color = connected and colors.blue or colors.white,
        },
      })
    end)
  end)
end

local function hide_details()
  bracket:set({ popup = { drawing = false } })
  sbar.remove('/bluetooth.device\\..*/')
end

local function show_details()
  sbar.remove('/bluetooth.device\\..*/')
  bracket:set({ popup = { drawing = true } })
  local cmd = "blueutil --paired --format json | jq -r '.[] | \"\\(.address)|\\(.connected)|\\(.name)\"'"
  sbar.exec(cmd, function(devices)
    local counter = 0
    for address, connected, name in string.gmatch(tostring(devices), "([^|\r\n]+)|([^|\r\n]+)|([^\r\n]+)") do
      local is_connected = connected == "true"
      local action = is_connected and "--disconnect" or "--connect"
      sbar.add("item", "bluetooth.device." .. counter, {
        position = "popup." .. bracket.name,
        width = popup_width,
        align = "center",
        label = { string = name, color = is_connected and colors.white or colors.grey },
        click_script = "blueutil " .. action .. " " .. address
          .. "; sketchybar --trigger bluetooth_update --set " .. bracket.name .. " popup.drawing=off",
      })
      counter = counter + 1
    end
  end)
end

sbar.add("event", "bluetooth_update")

bluetooth:subscribe({ "routine", "forced", "system_woke", "bluetooth_update" }, update)

bluetooth:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec("open 'x-apple.systempreferences:com.apple.BluetoothSettings'")
    return
  end
  if bracket:query().popup.drawing == "off" then show_details() else hide_details() end
end)

bluetooth:subscribe("mouse.exited.global", hide_details)

power:subscribe("mouse.clicked", function(env)
  sbar.exec("blueutil --power toggle", function()
    update()
    hide_details()
  end)
end)
