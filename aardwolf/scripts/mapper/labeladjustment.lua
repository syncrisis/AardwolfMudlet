-- AardwolfMudlet: labelAdjustment
-- Group: aard > aardMap

GUIlabel = GUIlabel or {}
local adjustInfo

GUIlabel.adjustLabel = function(name, x, y, w, h, c)
    local info, lbl
    if type(name) == "table" then
        if name.type == "label" then
            lbl = name
        else
            info = name
        end
    else
        info = {name = name, x = x, y = y, width = w, height = h, color = c}
    end
    if not lbl then
        lbl = Geyser.Label:new(info)
    end
    lbl:setClickCallback("GUIlabel.onClick",lbl)
    lbl:setReleaseCallback("GUIlabel.onRelease",lbl)
    lbl:setMoveCallback("GUIlabel.onMove",lbl)
    if info then
        return lbl
    end
end

local function make_percent(num)
    num = math.floor(10000*num)/100
    num = tostring(num).."%"
    return num
end

GUIlabel.finishLabel = function(lbl, size_as_percent, position_as_percent)
    lbl:setClickCallback("fakeFunction")
    lbl:setReleaseCallback("fakeFunction")
    lbl:setMoveCallback("fakeFunction")
    local x, y, w, h = lbl:get_x(), lbl:get_y(), lbl:get_width(), lbl:get_height()
    local winw, winh = getMainWindowSize()
    x, y, w, h = make_percent(x/winw), make_percent(y/winh), make_percent(w/winw), make_percent(h/winh)
    if size_as_percent then lbl:resize(w,h) end
    if position_as_percent then lbl:move(x,y) end
end

GUIlabel.onClick = function(lbl, event)
    if event.button == "LeftButton" then
        local x, y = getMousePosition()
        local w, h = lbl:get_width(), lbl:get_height()
        local x1, y1 = x - event.x, y - event.y
        local x2, y2 = x1 + w, y1 + h
        local left, right, top, bottom = event.x <= 10, x >= x2 - 10, event.y <= 10, y >= y2 - 10
        if right and left then left = false end
        if top and bottom then top = false end
        local move = not (right or left or top or bottom)
        adjustInfo = {name = lbl.name, top = top, bottom = bottom, left = left, right = right, move = move, x = x, y = y}
    end
end

GUIlabel.onRelease = function(lbl, event)
    if event.button == "LeftButton"  and adjustInfo and adjustInfo.name == lbl.name then
        adjustInfo = nil
    end
end

GUIlabel.onMove = function(lbl, event)
    if adjustInfo and adjustInfo.name == lbl.name then
        local x, y = getMousePosition()
        local winw, winh = getMainWindowSize()
        local x1, y1, w, h = lbl.get_x(), lbl.get_y(), lbl:get_width(), lbl:get_height()
        local dx, dy = adjustInfo.x - x, adjustInfo.y - y
        local max, min = math.max, math.min
        if adjustInfo.move then
            local tx, ty = max(0,x1-dx), max(0,y1-dy)
            tx, ty = min(tx, winw - w), min(ty, winh - h)
            lbl:move(tx, ty)
        else
            local w2, h2, x2, y2 = w - dx, h - dy, x1 - dx, y1 - dy
            local tx, ty, tw, th = x1, y1, w, h
            if adjustInfo.top then
                ty, th = y2, h + dy
            elseif adjustInfo.bottom then
                th = h2
            end
            if adjustInfo.left then
                tx, tw = x2, w + dx
            elseif adjustInfo.right then
                tw = w2
            end
            tx, ty, tw, th = max(0,tx), max(0,ty), max(10,tw), max(10,th)
            tw, th = min(tw, winw), min(th, winh)
            tx, ty = min(tx, winw-tw), min(ty, winh-th)
            lbl:move(tx, ty)
            lbl:resize(tw, th)
        end
        adjustInfo.x, adjustInfo.y = x, y
    end
end
