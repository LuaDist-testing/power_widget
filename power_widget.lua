--[[
  Copyright 2017 Stefano Mazzucco <stefano AT curso DOT re>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local beautiful = require("beautiful")

local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local power = require("upower_dbus")
local WarningLevel = power.enums.BatteryWarningLevel

local spawn_with_shell = awful.spawn.with_shell or awful.util.spawn_with_shell
local icon_theme_dirs = { -- The trailing slash is mandatory!
  "/usr/share/icons/Adwaita/scalable/status/",
  "/usr/share/icons/Adwaita/scalable/devices/"}
local icon_theme_extensions = {"svg"}
icon_theme_dirs = beautiful.upower_icon_theme_dirs or icon_theme_dirs
icon_theme_extensions = beautiful.upower_icon_theme_extension or icon_theme_extensions

local widget = wibox.widget.imagebox()

local function build_icon_path(device)
  if device.IconName then
    return awful.util.geticonpath(device.IconName, icon_theme_extensions, icon_theme_dirs)
  end
  return ""
end

function widget:update()
  self.device:update_mappings()

  self:set_image(build_icon_path(self.device))

  if self.device.IsPresent then

    local percentage = math.floor(self.device.Percentage)
    local warning_level = self.device.warninglevel

    self.tooltip:set_text(
      percentage .. "%" .. " - " .. self.device.state.name)

    if warning_level == WarningLevel.Low or warning_level == WarningLevel.Critical then
      naughty.notify({
          preset = naughty.config.presets.critical,
          title = warning_level.name .. "  battery!",
          text = percentage .. "% remaining"})
    end
  else
    -- We don't know how we're powered, but we must be somehow!
    self.tooltip:set_text("Plugged In")
  end
end

function widget:init()
  local manager = power.Manager
  self.manager = manager

  -- https://upower.freedesktop.org/docs/UPower.html#UPower.GetDisplayDevice
  self.device = power.create_device("/org/freedesktop/UPower/devices/DisplayDevice")

  self.device:on_properties_changed(
    function ()
      self:update()
    end
  )

  self.tooltip = awful.tooltip({ objects = { widget },})
  self.gui_client = ""

  self:update()

  self:buttons(awful.util.table.join(
                 awful.button({ }, 3,
                   function ()
                     spawn_with_shell(self.gui_client)
                   end
  )))
end

return widget
