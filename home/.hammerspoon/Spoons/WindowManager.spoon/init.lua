local obj = {}
obj.__index = obj

obj.name = "WindowManager"
obj.version = "1.0"

local tileSizes = { 1 / 2, 2 / 3, 1 / 3 }
local threshold = 10

local function focusedWindow()
  local win = hs.window.focusedWindow()
  if not win or not win:isStandard() then return nil end
  return win
end

local function nearEqual(a, b)
  return math.abs(a - b) < threshold
end

local function currentTileIndex(wf, sf, side)
  if not nearEqual(wf.y, sf.y) or not nearEqual(wf.h, sf.h) then return nil end
  for i, ratio in ipairs(tileSizes) do
    local w = sf.w * ratio
    if side == "left" then
      if nearEqual(wf.x, sf.x) and nearEqual(wf.w, w) then return i end
    else
      if nearEqual(wf.x, sf.x + sf.w - w) and nearEqual(wf.w, w) then return i end
    end
  end
  return nil
end

local function tile(side)
  local win = focusedWindow()
  if not win then return end
  local sf = win:screen():frame()
  local wf = win:frame()
  local idx = currentTileIndex(wf, sf, side)
  local nextIdx = idx and (idx % #tileSizes) + 1 or 1
  local w = sf.w * tileSizes[nextIdx]
  local x = side == "left" and sf.x or sf.x + sf.w - w
  win:setFrame({ x = x, y = sf.y, w = w, h = sf.h })
end

local function maximize()
  local win = focusedWindow()
  if not win then return end
  win:setFrame(win:screen():frame())
end

local function center()
  local win = focusedWindow()
  if not win then return end
  local sf = win:screen():frame()
  local w = sf.w * 0.65
  local h = sf.h * 0.80
  local x = sf.x + (sf.w - w) / 2
  local y = sf.y + (sf.h - h) / 2
  win:setFrame({ x = x, y = y, w = w, h = h })
end

local resizeStep = 0.05

local function resize(larger)
  local win = focusedWindow()
  if not win then return end
  local sf = win:screen():frame()
  local wf = win:frame()
  local dw = sf.w * resizeStep * (larger and 1 or -1)
  local dh = sf.h * resizeStep * (larger and 1 or -1)
  local newW = math.max(200, math.min(sf.w, wf.w + dw))
  local newH = math.max(200, math.min(sf.h, wf.h + dh))
  local newX = wf.x - (newW - wf.w) / 2
  local newY = wf.y - (newH - wf.h) / 2
  newX = math.max(sf.x, math.min(sf.x + sf.w - newW, newX))
  newY = math.max(sf.y, math.min(sf.y + sf.h - newH, newY))
  win:setFrame({ x = newX, y = newY, w = newW, h = newH })
end

local function moveToScreen(direction)
  local win = focusedWindow()
  if not win then return end
  local target
  if direction == "left" then
    target = win:screen():toWest()
  else
    target = win:screen():toEast()
  end
  if not target then return end
  win:moveToScreen(target, true, true)
end

function obj:bindHotkeys()
  hs.hotkey.bind({ "cmd", "shift" }, "h", function() tile("left") end)
  hs.hotkey.bind({ "cmd", "shift" }, "l", function() tile("right") end)
  hs.hotkey.bind({ "cmd", "shift" }, "j", center)
  hs.hotkey.bind({ "cmd", "shift" }, "-", function() resize(false) end)
  hs.hotkey.bind({ "cmd", "shift" }, "=", function() resize(true) end)
  hs.hotkey.bind({ "cmd", "shift" }, "return", maximize)
  hs.hotkey.bind({ "cmd", "shift", "ctrl" }, "h", function() moveToScreen("left") end)
  hs.hotkey.bind({ "cmd", "shift", "ctrl" }, "l", function() moveToScreen("right") end)
  return self
end

function obj:init()
  return self
end

return obj
