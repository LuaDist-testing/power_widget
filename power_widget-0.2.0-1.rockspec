-- This file was automatically generated for the LuaDist project.

package = "power_widget"
version = "0.2.0-1"
-- LuaDist source
source = {
  tag = "0.2.0-1",
  url = "git://github.com/LuaDist-testing/power_widget.git"
}
-- Original source
-- source = {
--    url = "git://github.com/stefano-m/awesome-power_widget",
--    tag = "v0.2.0"
-- }
description = {
   summary = "A Power widget for the Awesome Window Manager",
   detailed = [[
    Monitor your power devices in Awesome with UPower and DBus.
    ]],
   homepage = "https://github.com/stefano-m/awesome-power_widget",
   license = "GPL v3"
}
supported_platforms = {
   "linux"
}
dependencies = {
   "lua >= 5.1",
   "upower_dbus >= 0.2.0, < 0.3"
}
build = {
   type = "builtin",
   modules = {
      power_widget = "power_widget.lua"
   }
}