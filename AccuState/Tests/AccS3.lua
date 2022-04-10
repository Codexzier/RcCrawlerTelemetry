local testVal = 0

-- Init function
local function init_func()
	-- init_func is called once when model is loaded
	return 0
end

-- main methode it iterated 
local function run_func(event)
	lcd.clear()

	local testVal2 = 0.3 + testVal

	if testVal2 >= 100 then
		testVal2 = 0
	end
	
	-- lipo accu state calculate to percentage
	-- title
	lcd.drawText(0, 0, "Test State", MIDSIZE)
	-- total lipo voltage
	lcd.drawText(2, 20, "Full Lipo", SMLSIZE)
	lcd.drawText(44, 20, string.format("%.2f", testVal2), SMLSIZE)

	-- screensize
	-- 128 x 64
	-- position, size
	lcd.drawRectangle(5, 32, 128 - 5 - 5, 5)
	lcd.drawLine(7, 34, 128 - 7 - (100 - testVal2), 34, SOLID, FORCE)

	testVal = testVal2
	
	return 0
end

return { run=run_func, init=init_func  }