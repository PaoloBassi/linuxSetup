-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Build the menus helper (the only C helper left: no cpu/network widgets)
os.execute("(cd helpers/menus && make) >/dev/null")
