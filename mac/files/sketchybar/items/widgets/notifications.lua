-- Notifications widget (not in FelixKratz's config, written in the same style): bell with the
-- number of notifications still in Notification Center. Click: open Notification Center.
-- Reads the usernoted db: needs Full Disk Access for sketchybar; clicking the hidden menu bar
-- clock needs Accessibility (already granted for the app menus).
local colors = require("colors")
local settings = require("settings")

local BELL_FONT = "IosevkaTerm Nerd Font:Regular:16.0"
local BELL_EMPTY = "󰂜"
local BELL = "󰂚"

local DB = '"$HOME/Library/Group Containers/group.com.apple.usernoted/db2/db"'
-- style 0 records (no alert style, e.g. Wallet) are never shown in Notification Center
local COUNT = "sqlite3 -readonly " .. DB .. " 'select count(*) from record where style != 0;'"

-- the clock menu extra opens Notification Center; matched by id, its name is localized
local OPEN_NC = [[osascript -e '
tell application "System Events" to tell process "ControlCenter"
  repeat with extra in menu bar items of menu bar 1
    try
      if value of attribute "AXIdentifier" of extra is "com.apple.menuextra.clock" then
        click extra
        exit repeat
      end if
    end try
  end repeat
end tell']]

local notifications = sbar.add("item", "widgets.notifications", {
  position = "right",
  icon = {
    font = BELL_FONT,
    string = BELL_EMPTY,
    color = colors.grey,
    padding_left = 8,
    padding_right = 8,
  },
  label = {
    font = { family = settings.font.numbers },
    padding_right = 8,
    drawing = false,
  },
  update_freq = 10,
  click_script = OPEN_NC,
})

sbar.add("bracket", "widgets.notifications.bracket", { notifications.name }, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.notifications.padding", {
  position = "right",
  width = settings.group_paddings
})

notifications:subscribe({ "routine", "forced", "system_woke" }, function()
  sbar.exec(COUNT, function(result)
    -- no Full Disk Access: sqlite fails and the bell stays empty
    local count = tonumber(tostring(result):match("%d+")) or 0
    notifications:set({
      icon = {
        string = count > 0 and BELL or BELL_EMPTY,
        color = count > 0 and colors.white or colors.grey,
        padding_right = count > 0 and 4 or 8,
      },
      label = { string = tostring(count), drawing = count > 0 },
    })
  end)
end)
