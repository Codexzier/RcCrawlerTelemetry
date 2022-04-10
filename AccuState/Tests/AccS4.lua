
local fieldCells = nil

local function getTelemetryId(name)
    local field = getFieldInfo(name)
    if field then
      return field.id
    else
      return -1
    end
end

-- Init function
local function init_func()

	fieldCells = getTelemetryId("Cels")
end

-- main methode it iterated 
local function run_func(event)
	lcd.clear()

	local resultValue = getValue(fieldCells)

	local voltageTotal  = 0
	if(type(resultValue) == "table") then

		lcd.drawText(0, 0, "Is table", SMLSIZE)

		
		for i, v in ipairs(resultValue) do
			voltageTotal = voltageTotal .. i .. ": " .. v .. " "
		end

	else
		voltageTotal = "FEHLER"
	end

	lcd.drawText(0, 0, voltageTotal, SMLSIZE)

	return 0
end

return { init=init_func, run=run_func  }