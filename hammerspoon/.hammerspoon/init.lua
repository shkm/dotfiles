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

-- ctrl+n / ctrl+p to arrow key equivalents (more compatible in some apps)
hotkey.bind({"ctrl"}, "N", function()
  eventtap.event.newKeyEvent({}, "down", true):post()
  eventtap.event.newKeyEvent({}, "down", false):post()
end)

hotkey.bind({"ctrl"}, "P", function()
  eventtap.event.newKeyEvent({}, "up", true):post()
  eventtap.event.newKeyEvent({}, "up", false):post()
end)

-- Window movement

local function pushWindowLeft()
  grid.set(window.focusedWindow(), '0,0 1x1')
end

local function pushWindowRight()
  grid.set(window.focusedWindow(), '1,0 1x1')
end

local function pushWindowScreenLeft()
  grid.pushWindowPrevScreen()
  pushWindowLeft()
end

local function pushWindowScreenRight()
  grid.pushWindowNextScreen()
  pushWindowRight()
end

hotkey.bind({"ctrl", "shift"}, "H", pushWindowLeft)
hotkey.bind({"ctrl", "shift"}, "L", pushWindowRight)
hotkey.bind({"ctrl", "shift"}, "K", grid.maximizeWindow)
hotkey.bind({"ctrl", "shift", "cmd"}, "H", pushWindowScreenLeft)
hotkey.bind({"ctrl", "shift", "cmd"}, "H", pushWindowScreenRight)

-- Weather
local weather = require "hs-weather"
weather.start()

-- Remapping
local remap = require 'foundation_remapping'
local remapper = remap.new()

remapper
  :remap('§', '`') -- Stupid int'l grave sign
  :register()
