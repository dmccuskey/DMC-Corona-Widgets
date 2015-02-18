--====================================================================--
-- Themed Background
--
-- Shows themed use of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local background
local theme, style



--===================================================================--
-- Support Functions


-- Setup Visual Screen Items
--
local function setupBackground()
	print( 'Main: setupBackground' )
	local width, height = 100, 36
	local o

	o = display.newRect(0,0,W,H)
	o:setFillColor(0.5,0.5,0.5)
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect(0,0,width+4,height+4)
	o:setStrokeColor(0,0,0)
	o.strokeWidth=2
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect( 0,0,10,10)
	o:setFillColor(1,0,0)
	o.x, o.y = H_CENTER, V_CENTER
end



local function widgetOnPropertyEvent_handler( event )
	print( 'Main: widgetOnPropertyEvent_handler', event.id, event.phase )
	local etype= event.type
	local property= event.property
	local value = event.value

	print( "Widget Property Changed", etype, property, value )

end

-- handles button-type taps
--
local function widgetEvent_handler( event )
	print( 'Main: widgetEvent_handler', event.type )
	local etype= event.type
	local target=event.target

	if etype==target.PRESSED then
		print( "Background: touch started" )
	elseif etype==target.MOVED then
		print( "Background: moved ", event.isWithinBounds )
	elseif etype==target.RELEASED then
		print( "Background: touch ended" )
	end

end



--===================================================================--
--== Main
--===================================================================--

setupBackground()


--======================================================--
--== create background widget, default style

function run_example1()

	local bw1 = Widgets.newBackground{}

	bw1:addEventListener( bw1.EVENT, widgetEvent_handler )
	-- bw1.onProperty = widgetOnPropertyEvent_handler

	bw1.x = H_CENTER
	bw1.y = V_CENTER-50
	bw1.width, bw1.height = 10,10
	-- bw1:setAnchor( {0,0} )
	bw1:setAnchor( {0.5,0.5} )
	-- bw1:setAnchor( {1,1} )
	bw1:setViewFillColor(1,0,0 )


	timer.performWithDelay( 1000, function()
		bw1.style=nil -- shouldn't change, already default
	end)

	timer.performWithDelay( 2000, function()
		bw1:clearStyle() -- clear our changes
	end)

end

-- run_example1()


--======================================================--
--== create background, inline style

function run_example2()
	local bw2 = Widgets.newBackground{
		x=100,
		y=100,

		style={

			width=100,
			height=20,

			anchorX=1,
			anchorY=0.5,

			view={
				type='rectangle',
				strokeWidth=5,
				strokeColor={0,0,1},
				fillColor={0.5,1,0.5,0.5}
			}
		}
	}
	bw2:addEventListener( bw2.EVENT, widgetEvent_handler )
	-- bw2.onProperty = widgetOnPropertyEvent_handler

	timer.performWithDelay( 1000, function()
		print( "\n\nUpdate properties" )

		bw2.x = H_CENTER
		bw2.y = V_CENTER

		bw2.width=220
		bw2.height=70

		bw2:setAnchor( {0,1} )

		bw2:setFillColor( 1,0.5,0.2,0.5 )
		bw2:setStrokeColor( 2,0,0,1 )
		bw2.strokeWidth = 1
	end)


	timer.performWithDelay( 2000, function()
		print( "\n\nUpdate properties" )
		bw2.style=nil
	end)

end

-- run_example2()


--======================================================--
--== Create Style, add to Widget

function run_example3()

	local st3, bw3

	st3 = Widgets.newBackgroundStyle{
		name='my-background-style',

		width=150,
		height=70,

		anchorX=1,
		anchorY=0.5,

		view={
			type='rounded',
			-- cornerRadius=10,
			strokeWidth=5,
			strokeColor={0,0,0},
			fillColor={1,1,0.5,0.5}
		}

	}

	-- add style to widget

	bw3 = Widgets.newBackground{
		x=H_CENTER,
		y=50,
		style=st3
	}
	bw3:addEventListener( bw3.EVENT, widgetEvent_handler )
	-- bw3.onProperty = widgetOnPropertyEvent_handler


	timer.performWithDelay( 2000, function()
		print( "\n\nUpdate properties" )
		bw3.style=nil
		bw3.y=100
		bw3:setViewFillColor( 0.7, 0.5, 0.6, 1)
	end)

end

-- run_example3()


--======================================================--
--== create background widget, test hit area

function run_example4()

	local bw4 = Widgets.newBackground{}
	bw4:addEventListener( bw4.EVENT, widgetEvent_handler )

	bw4.x = H_CENTER
	bw4.y = V_CENTER-100

	bw4:setFillColor( 0.2,0.6,1, 0.5 )

	bw4:setAnchor( {0,0} )
	bw4:setAnchor( {0.5,0.5} )
	-- bw4:setAnchor( {1,1} )

	bw4.hitMarginX=5
	bw4.hitMarginY=10
	-- bw4:setHitMargin( {0,8} )

	bw4.isHitActive=true
	bw4.debugOn = true

	timer.performWithDelay( 1000, function()
		print("\n\nUpdate Properties")
		bw4.hitMarginX=5
		bw4.hitMarginY=10
		bw4.y = 400
		bw4:setHitMargin( {3,5} )
	end)


	timer.performWithDelay( 2000, function()
		bw4:clearStyle()
	end)

end

run_example4()

