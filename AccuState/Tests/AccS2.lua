-- main methode it iterated 
local function run_func(event)
	lcd.clear()



	-- Auszulesenede Werte müssen in 
	-- der Fernsteuerung eingestellt werden
	local voltageTotal = getValue('Cels')
	local voltageCell_1 = getValue('cel1')
	local voltageCell_2 = getValue('cel2')

	-- lipo accu state calculate to percentage
	-- title
	lcd.drawText(0, 0, "Accu State", MIDSIZE)
	-- total lipo voltage
	lcd.drawText(2, 20, "Full Lipo", SMLSIZE)
	-- # ERROR
	lcd.drawText(42, 20, string.format("%.2f", voltageTotal), SMLSIZE)

	lcd.drawText(2, 40, "By Cel1", SMLSIZE)
	lcd.drawText(42, 40, string.format("%.2f", voltageCell_1), SMLSIZE)

	lcd.drawText(2, 50, "By Cel2", SMLSIZE)
	lcd.drawText(42, 50, voltageCell_2, SMLSIZE)

	-- screensize
	-- 128 x 64
	-- position, size
	lcd.drawRectangle(5, 32, 128 - 5 - 5, 5)
	lcd.drawLine(7, 34, 128 - 7 - 7 - (voltageCell_2 * 10), 34, SOLID, FORCE)

	return 0
end

return { run=run_func }