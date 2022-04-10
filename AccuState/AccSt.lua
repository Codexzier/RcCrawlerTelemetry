-- ========================================================================================
--      Meine Welt in meinem Kopf
-- ========================================================================================
-- Projekt:       Accu Status in Prozent und mit Kapazitätsstandsanzeige
-- Author:        Johannes P. Langner
-- Transceiver:   FrSky XLite Pro und Lipo Sensor
-- Description:   Einlesen des Lipo Sensors über die Telemetrie sensor.
-- Stand:         10.04.2022
-- ========================================================================================

-- Globals
-- Lipo total
local mLipoTotalFull = 8.4
local mLipoTolalLow = 7.4

-- lipo cell
local mLipoCellVoltage = 4.2
local mLipoCellVoltageLow = 3.7

-- results
local mTotalResult = 0

local mCellResult1 = 0
local mCellResult2 = 0
local mTotalCellsResult  = 0

local mCells = 0
local mCell1 = 0
local mCell2 = 0

local mCellId = nil
local mField = nil

local mActivity = 1
local mConsumption = 0

-- read from telemetry pool by name
local function getTelemetryId(name)
    mField = getFieldInfo(name)
    if mField then
      return mField.id
    else
      return -1
    end
end

local function init()
	mCellId = getTelemetryId("Cels")
end

local function animActivity()
	if mActivity >= 60 then
		mActivity = 0
	else
		mActivity = mActivity + 1
	end

	lcd.drawRectangle(116, 0, 11, 11)

	if mActivity < 15 then
		lcd.drawLine(116, 5, 126, 5, SOLID, FORCE)
	end

	if mActivity >= 15 and mActivity < 30 then
		lcd.drawLine(119, 3, 123, 7, SOLID, FORCE)
	end

	if mActivity >= 30 and mActivity < 45 then
		lcd.drawLine(121, 1, 121, 9, SOLID, FORCE)
	end

	if mActivity >= 45  then
		lcd.drawLine(123, 3, 119, 7, SOLID, FORCE)
	end

	return 0
end

local function calculateCellsState()

	if mCellId == -1 then
		return 0
	end	

	mCells = 0
	local cells = getValue(mCellId)

	if(type(cells) == "table") then
		
		for index, voltage in ipairs(cells) do
			mCells = mCells + voltage

			if index == 1 then
				mCell1 = voltage
			end

			if index == 2 then
				mCell2 = voltage
			end
		end
	end

	-- total voltage 
	local totalFull = mLipoTotalFull - mLipoTolalLow
	local totalState = mCells - mLipoTolalLow
	mTotalResult = math.ceil(totalState / totalFull * 100)

	-- cell
	local cellFull = mLipoCellVoltage - mLipoCellVoltageLow
	
	-- cell 1 voltage
	local cellState1 = mCell1 - mLipoCellVoltageLow
	mCellResult1 = cellState1 / cellFull * 100

	-- cell 2 voltage
	local cellState2 = mCell2 - mLipoCellVoltageLow
	mCellResult2 = cellState2 / cellFull * 100

	-- total result
	mTotalCellsResult = math.ceil((mCellResult1 + mCellResult2) / 2.0)

	return 1
end

local function drawTextAndBars()
	-- lipo accu state calculate to percentage
	-- title
	lcd.drawText(0, 0, "Accu State", MIDSIZE)

	-- total lipo voltage
	lcd.drawText(2, 12, "Lipo Accu:", SMLSIZE)
	lcd.drawText(46, 12, mTotalResult.."%", SMLSIZE)
	-- sum of cells lipo voltage
	lcd.drawText(64, 12, "By Cells", SMLSIZE)
	lcd.drawText(102, 12, mTotalCellsResult.."%", SMLSIZE)

	-- Cell voltage
	lcd.drawText(2, 20, string.format("%.2f", mCells).."V", SMLSIZE)
	lcd.drawText(32, 20, string.format("%.2f", mCell1).."V", SMLSIZE)
	lcd.drawText(62, 20, string.format("%.2f", mCell2).."V", SMLSIZE)

	-- screensize
	-- 128 x 64
	
	-- cells
	lcd.drawRectangle(5, 28, 118, 5)
	lcd.drawLine(7, 30, math.ceil(mTotalResult * 1.18), 30, SOLID, FORCE)

	-- cell 1
	lcd.drawRectangle(5, 34, 118, 5, SOLID)
	lcd.drawLine(7, 36, math.ceil(mCellResult1 * 1.18), 36, SOLID, FORCE)

	-- cell 2
	lcd.drawRectangle(5, 41, 118, 5, SOLID)
	lcd.drawLine(7, 43, math.ceil(mCellResult2 * 1.18), 43, SOLID, FORCE)

	return 0
end

local function warning()

	if mTotalResult < 5 then
		lcd.drawText(10, 58, "Warnung: Accu leer", SMLSIZE)
		return 0
	end
	
	return 1
end

local function bg_func()
	-- bg_func is called periodically (always, the screen visibility does not matter)
	return 0
  end

-- main methode it iterated 
local function run_func(event)

	if calculateCellsState() == 0 then
		mCellResult1 = 1
		mCellResult2 = 1
		mTotalCellsResult  = 1
		mCells = mLipoTolalLow
		mCell1 = mLipoCellVoltageLow
		mCell2 = mLipoCellVoltageLow
	end

	lcd.clear()
	drawTextAndBars()
	animActivity()

	if warning() == 0 then
		return 0
	end

	return 0
end

return { init=init, background=bg_func, run=run_func }