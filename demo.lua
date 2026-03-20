-- 使用 http 和 python 模块通信
local HttpClient = {}
HttpClient.__index = HttpClient

function HttpClient:new(host)
    self = setmetatable({}, HttpClient)
    self.host = host
    return self
end

function HttpClient:charImage(char, width, height, fg, bg)
    local param = textutils.urlEncode(
        string.format("%s,%d,%d,%s,%s", char, width, height, colors.toBlit(fg), colors.toBlit(bg))
    )
    local url = string.format("http://%s/convert?data=%s", self.host, param)

    local response, err = http.get(url)
    if not response then
        -- 通信失败
        print("HTTP error: " .. err)
        return nil
    end

    local data = response.readAll()
    response.close()

    -- -- 保存所有
    -- local f = io.open("x", "w")
    -- if f then
    --     f:write(data)
    --     f:close()
    -- end

    return paintutils.parseImage(data)
end

local monitor = peripheral.find("monitor")


local meBridge = peripheral.find("me_bridge")

local cells = meBridge.getCells()
for i, cell in ipairs(cells) do
    print("Cell: " .. i)
    for k, v in pairs(cell) do
        print(k, v) 
end
end

-- 16种基本颜色
-- 0  1  2   3   4  5 6  7  8   9  a b  c  d  e  f
-- 白 橙 品红 浅蓝 黄 绿 粉 灰 浅灰 青 紫 蓝 棕 绿 红 黑
local text = "物品磁盘占用"
local client = HttpClient:new("10.2.203.225:8080")

local toolbarHeight = 12

while true do 
    -- 切换 term 到显示器
    local oldTerm = term.redirect(monitor)

    monitor.clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextScale(0.5)
    monitor.clear()

    local image = client:charImage(text, 100, 14, colors.black, colors.pink)
    if image then
        paintutils.drawImage(image, 2, 10)
    end

    paintutils.drawFilledBox(0, 0, 16, toolbarHeight, image and colors.green or colors.red)
    

    -- debug 信息显示
    local w, h = monitor.getSize()
    monitor.setCursorPos(1, h)
    monitor.setTextColor(colors.green)
    -- 
    monitor.write("size: " .. w .. "x" .. h .. " scale:" .. monitor.getTextScale())
    term.redirect(oldTerm)

    ::continue::
    sleep(1)
end