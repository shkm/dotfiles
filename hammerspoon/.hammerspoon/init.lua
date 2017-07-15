local hotkey = require "hs.hotkey"
local grid = require "hs.grid"
local eventtap = require "hs.eventtap"
local window = require "hs.window"
local notify = require "hs.notify"

window.animationDuration = 0

grid.GRIDWIDTH = 2
grid.GRIDHEIGHT = 1
grid.MARGINX = 0
grid.MARGINY = 0

-- reload config with ctrl+cmd+f12
hotkey.bind({"ctrl", "cmd"}, "F12", function()
  notify.show("Hammerspoon", "Reloading config…", "")
  hs.reload()
end)

-- Window movement

local function pushWindowLeft()
  grid.set(window.focusedWindow(), '0,0 1x1')
end

local function pushWindowRight()
  grid.set(window.focusedWindow(), '1,0 1x1')
end

hotkey.bind({"ctrl", "shift"}, "H", pushWindowLeft)
hotkey.bind({"ctrl", "shift"}, "L", pushWindowRight)
hotkey.bind({"ctrl", "shift"}, "K", grid.maximizeWindow)
hotkey.bind({"ctrl", "shift", "alt"}, "H", grid.pushWindowNextScreen)
hotkey.bind({"ctrl", "shift", "alt"}, "L", grid.pushWindowPrevScreen)

-- Weather
local weather = require "hs-weather"
weather.start()
