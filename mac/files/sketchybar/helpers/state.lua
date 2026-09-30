-- State shared between item modules (require() caches it, so it's a single table)
return {
  -- true while the app menus are shown in place of the workspaces
  menus_shown = false,
}
