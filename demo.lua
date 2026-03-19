for _, name in ipairs(peripheral.getNames()) do
    print(name, peripheral.getType(name))
end



local feDector = peripheral.wrap("left")

local methods = peripheral.getMethods("left")


print(feDector.getEnergy())
print(feDector.getEnergyCapacity())

local mon = peripheral.wrap("top")

while true do
    local energy = feDector.getEnergy()
    local maxEnergy = feDector.getEnergyCapacity()
    local percent = energy / maxEnergy
    print("FE: per", percent)
    
    mon.clear()
    mon.setTextScale(1)
    mon.setCursorPos(1,1)
    mon.write("FE存储:" .. math.floor(percent*1000) / 10 .. "%.    " .. string.format("%.2f", energy/1000000) .. "/" .. string.format("%.2f", maxEnergy/1000000) .. "M FE")

    -- 绘制进度条
    local width, height = mon.getSize()
    local barWidth = width - 2
    local filled = math.floor(barWidth * percent)

    -- 背景先清空
    mon.setBackgroundColor(colors.gray)
    mon.setCursorPos(2,2)
    mon.write(string.rep(" ", barWidth))

    -- 绘制已充能部分
    mon.setBackgroundColor(colors.green)
    mon.setCursorPos(2,2)
    mon.write(string.rep(" ", filled))

    -- 恢复文字颜色
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)
end