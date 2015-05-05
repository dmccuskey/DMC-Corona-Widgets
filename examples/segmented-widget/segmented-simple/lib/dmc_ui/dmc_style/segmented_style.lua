--====================================================================--
-- dmc_widget/widget_background/rounded_style.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2015 David McCuskey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]



--====================================================================--
--== DMC Corona UI : Rounded Background Style
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find
local ui_file = dmc_ui_func.file



--====================================================================--
--== DMC UI : newRoundedBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local uiConst = require( ui_find( 'ui_constants' ) )

local BaseStyle = require( ui_find( 'core.style' ) )



--====================================================================--
--== Setup, Constants


local sfmt = string.format
local tinsert = table.insert

--== To be set in initialize()
local Style = nil



--====================================================================--
--== 9-Slice Background Style Class
--====================================================================--


--- 9-Slice View Style Class.
-- a style object for a 9-Slice Background View.
--
-- **Inherits from:** <br>
-- * @{Core.Style}
--
-- **Child style of:** <br>
-- * @{Style.Background}
--
-- @classmod Style.BackgroundView.9Slice
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.newBackgroundStyle{
--   type='9-slice',
-- }
--
-- local widget = dUI.new9SliceBackgroundStyle()

local SegmentedStyle = newClass( BaseStyle, {name="Segmented Control Style"} )

--- Class Constants.
-- @section

--== Class Constants

SegmentedStyle.TYPE = uiConst.SEGMENTEDCTRL

SegmentedStyle.__base_style__ = nil

SegmentedStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	offsetBottom=true,
	offsetLeft=true,
	offsetRight=true,
	offsetTop=true,

	sheetInfo=true,
	sheetImage=true,
	spriteFrames=true,
}

SegmentedStyle._EXCLUDE_PROPERTY_CHECK = nil

SegmentedStyle._STYLE_DEFAULTS = {
	debugOn=false,
	width=0,
	height=0,
	anchorX=0.5,
	anchorY=0,

	offsetBottom=0,
	offsetLeft=1,
	offsetRight=0,
	offsetTop=0,

	active = {
		anchorX=0.5,
		anchorY=0.5,
		align='center',
		fillColor={0,0,0,0},
		font=native.systemFont,
		fontSize=14,
		marginX=0,
		marginY=0,
		textColor={1,0,0,1},
		strokeColor={0,0,0,0},
		strokeWidth=0,
	},

	disabled = {
		anchorX=0.5,
		anchorY=0.5,
		align='center',
		fillColor={0,0,0,0},
		font=native.systemFont,
		fontSize=14,
		marginX=0,
		marginY=0,
		textColor={0,1,0,1},
		strokeColor={0,0,0,0},
		strokeWidth=0,
	},

	inactive = {
		anchorX=0.5,
		anchorY=0.5,
		align='center',
		fillColor={0,0,0,0},
		font=native.systemFont,
		fontSize=14,
		marginX=0,
		marginY=0,
		textColor={0,0,1,1},
		strokeColor={0,0,0,0},
		strokeWidth=0,
	},

	spriteFrames = {
		leftInactive=1,
		middleInactive=2,
		rightInactive=3,
		leftActive=4,
		middleActive=5,
		rightActive=6,
		dividerAI=7,
		dividerII=8,
		dividerIA=9,
	},

	sheetInfo=ui_find('theme.default.segmented.ios-sheet'),
	sheetImage=ui_file('theme/default/segmented/ios-sheet.jpg'),
}

SegmentedStyle._TEST_DEFAULTS = {
	name='segmented-control-test-style',
	debugOn=false,
	width=301,
	height=302,
	anchorX=303,
	anchorY=304,

	cornerRadius=305,
	fillColor={301,302,303,304},
	strokeColor={311,312,313,314},
	strokeWidth=311
}

SegmentedStyle.MODE = uiConst.RUN_MODE
SegmentedStyle._DEFAULTS = SegmentedStyle._STYLE_DEFAULTS


--== Event Constants

SegmentedStyle.EVENT = 'segmented-control-style-event'


--======================================================--
-- Start: Setup DMC Objects

function SegmentedStyle:__init__( params )
	-- print( "SegmentedStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._data
	-- self._inherit
	-- self._widget
	-- self._parent
	-- self._onProperty

	-- self._name
	-- self._debugOn
	-- self._width
	-- self._height
	-- self._anchorX
	-- self._anchorY

	self._offsetBottom = nil
	self._offsetLeft = nil
	self._offsetRight = nil
	self._offsetTop = nil
	self._sheetInfo = nil
	self._sheetImage = nil
	self._spriteFrames = nil

	self._active = nil
	self._inactive = nil
	self._disabled = nil
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function SegmentedStyle.initialize( manager, params )
	-- print( "SegmentedStyle.initialize", manager, params )
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	Style = manager

	if params.mode==uiConst.TEST_MODE then
		SegmentedStyle.MODE = params.mode
		SegmentedStyle._DEFAULTS = SegmentedStyle._TEST_DEFAULTS
	end
	local defaults = SegmentedStyle._DEFAULTS

	SegmentedStyle._setDefaults( SegmentedStyle, {defaults=defaults} )
end



function SegmentedStyle.addMissingDestProperties( dest, src )
	-- print( "SegmentedStyle.addMissingDestProperties", dest, src )
	assert( dest )
	--==--
	local srcs = { SegmentedStyle._DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	dest = BaseStyle.addMissingDestProperties( dest, src )

	for i=1,#srcs do
		local src = srcs[i]

		if dest.offsetBottom==nil then dest.offsetBottom=src.offsetBottom end
		if dest.offsetLeft==nil then dest.offsetLeft=src.offsetLeft end
		if dest.offsetRight==nil then dest.offsetRight=src.offsetRight end
		if dest.offsetTop==nil then dest.offsetTop=src.offsetTop end
		if dest.sheetImage==nil then dest.sheetImage=src.sheetImage end
		if dest.sheetInfo==nil then dest.sheetInfo=src.sheetInfo end
		if dest.spriteFrames==nil then dest.spriteFrames=src.spriteFrames end

	end

	dest = SegmentedStyle._addMissingChildProperties( dest, src )

	return dest
end


-- _addMissingChildProperties()
-- copy properties to sub-styles
--
function SegmentedStyle._addMissingChildProperties( dest, src )
	-- print("SegmentedStyle._addMissingChildProperties", dest, srcs )
	assert( dest )
	src = dest
	--==--
	local eStr = "ERROR: Style (SegmentedStyle) missing property '%s'"
	local StyleClass = Style.Text
	local child

	child = dest.active
	-- assert( child, sfmt( eStr, 'active' ) )
	dest.active = StyleClass.addMissingDestProperties( child, src )

	child = dest.disabled
	-- assert( child, sfmt( eStr, 'disabled' ) )
	dest.disabled = StyleClass.addMissingDestProperties( child, src )

	child = dest.inactive
	-- assert( child, sfmt( eStr, 'inactive' ) )
	dest.inactive = StyleClass.addMissingDestProperties( child, src )

	return dest
end



function SegmentedStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "SegmentedStyle.copyExistingSrcProperties", dest, src, params )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	dest = BaseStyle.copyExistingSrcProperties( dest, src, params )

	if (src.offsetBottom~=nil and dest.offsetBottom==nil) or force then
		dest.offsetBottom=src.offsetBottom
	end
	if (src.offsetLeft~=nil and dest.offsetLeft==nil) or force then
		dest.offsetLeft=src.offsetLeft
	end
	if (src.offsetRight~=nil and dest.offsetRight==nil) or force then
		dest.offsetRight=src.offsetRight
	end
	if (src.offsetTop~=nil and dest.offsetTop==nil) or force then
		dest.offsetTop=src.offsetTop
	end
	if (src.sheetImage~=nil and dest.sheetImage==nil) or force then
		dest.sheetImage=src.sheetImage
	end
	if (src.sheetInfo~=nil and dest.sheetInfo==nil) or force then
		dest.sheetInfo=src.sheetInfo
	end
	if (src.spriteFrames~=nil and dest.spriteFrames==nil) or force then
		dest.spriteFrames=src.spriteFrames
	end

	return dest
end


function SegmentedStyle._verifyStyleProperties( src, exclude )
	-- print( "SegmentedStyle._verifyStyleProperties", src )
	assert( src, "SegmentedStyle:verifyStyleProperties requires source")
	--==--
	local emsg = "Style (SegmentedStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src, exclude )

	if not src.offsetBottom then
		print(sfmt(emsg,'offsetBottom')) ; is_valid=false
	end
	if not src.offsetLeft then
		print(sfmt(emsg,'offsetLeft')) ; is_valid=false
	end
	if not src.offsetRight then
		print(sfmt(emsg,'offsetRight')) ; is_valid=false
	end
	if not src.offsetTop then
		print(sfmt(emsg,'offsetTop')) ; is_valid=false
	end
	if not src.sheetImage then
		print(sfmt(emsg,'sheetImage')) ; is_valid=false
	end
	if not src.sheetInfo then
		print(sfmt(emsg,'sheetInfo')) ; is_valid=false
	end
	if not src.spriteFrames then
		print(sfmt(emsg,'spriteFrames')) ; is_valid=false
	end

	local StyleClass = Style.Text
	local child

	child = src.active
	if not child then
		print( "SegmentedStyle child test skipped for 'active'" )
		is_valid=false
	else
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	child = src.disabled
	if not child then
		print( "SegmentedStyle child test skipped for 'disabled'" )
		is_valid=false
	else
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	child = src.inactive
	if not child then
		print( "SegmentedStyle child test skipped for 'inactive'" )
		is_valid=false
	else
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	return is_valid
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles


--== .active

function SegmentedStyle.__getters:active()
	-- print( "SegmentedStyle.__getters:active" )
	return self._active
end
function SegmentedStyle.__setters:active( data )
	-- print( "SegmentedStyle.__setters:active", data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Style.Text
	local inherit = self._inherit and self._inherit._active or self._inherit

	local o = StyleClass:createStyleFrom{
		name=nil,
		inherit=inherit,
		parent=self,
		data=data
	}
	o:excludeParentProperty( 'anchorX' )
	o:excludeParentProperty( 'anchorY' )
	self._active = o
end

--== .disabled

function SegmentedStyle.__getters:disabled()
	-- print( 'SegmentedStyle.__getters:disabled', self._background )
	return self._disabled
end
function SegmentedStyle.__setters:disabled( data )
	-- print( 'SegmentedStyle.__setters:disabled', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Style.Text
	local inherit = self._inherit and self._inherit._disabled or self._inherit

	local o = StyleClass:createStyleFrom{
		name=nil,
		inherit=inherit,
		parent=self,
		data=data
	}
	o:excludeParentProperty( 'anchorX' )
	o:excludeParentProperty( 'anchorY' )
	self._disabled = o
end

--== .inactive

function SegmentedStyle.__getters:inactive()
	-- print( 'SegmentedStyle.__getters:inactive', self._background )
	return self._inactive
end
function SegmentedStyle.__setters:inactive( data )
	-- print( 'SegmentedStyle.__setters:inactive', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Style.Text
	local inherit = self._inherit and self._inherit._inactive or self._inherit

	local o = StyleClass:createStyleFrom{
		name=nil,
		inherit=inherit,
		parent=self,
		data=data
	}
	o:excludeParentProperty( 'anchorX' )
	o:excludeParentProperty( 'anchorY' )
	self._inactive = o
end


--======================================================--
-- Access to style properties

--== .offsetBottom

function SegmentedStyle.__getters:offsetBottom()
	-- print( "SegmentedStyle.__getters:offsetBottom", self )
	local value = self._offsetBottom
	if value==nil and self._inherit then
		value = self._inherit.offsetBottom
	end
	return value
end
function SegmentedStyle.__setters:offsetBottom( value )
	-- print( "SegmentedStyle.__setters:offsetBottom", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._offsetBottom then return end
	self._offsetBottom = value
	self:_dispatchChangeEvent( 'offsetBottom', value )
end

--== .offsetLeft

function SegmentedStyle.__getters:offsetLeft()
	-- print( "SegmentedStyle.__getters:offsetLeft", self )
	local value = self._offsetLeft
	if value==nil and self._inherit then
		value = self._inherit.offsetLeft
	end
	return value
end
function SegmentedStyle.__setters:offsetLeft( value )
	-- print( "SegmentedStyle.__setters:offsetLeft", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._offsetLeft then return end
	self._offsetLeft = value
	self:_dispatchChangeEvent( 'offsetLeft', value )
end

--== .offsetRight

function SegmentedStyle.__getters:offsetRight()
	-- print( "SegmentedStyle.__getters:offsetRight", self )
	local value = self._offsetRight
	if value==nil and self._inherit then
		value = self._inherit.offsetRight
	end
	return value
end
function SegmentedStyle.__setters:offsetRight( value )
	-- print( "SegmentedStyle.__setters:offsetRight", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._offsetRight then return end
	self._offsetRight = value
	self:_dispatchChangeEvent( 'offsetRight', value )
end

--== .offsetTop

function SegmentedStyle.__getters:offsetTop()
	-- print( "SegmentedStyle.__getters:offsetTop", self )
	local value = self._offsetTop
	if value==nil and self._inherit then
		value = self._inherit.offsetTop
	end
	return value
end
function SegmentedStyle.__setters:offsetTop( value )
	-- print( "SegmentedStyle.__setters:offsetTop", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._offsetTop then return end
	self._offsetTop = value
	self:_dispatchChangeEvent( 'offsetTop', value )
end

--== .sheetImage

function SegmentedStyle.__getters:sheetImage()
	-- print( "SegmentedStyle.__getters:sheetImage", self )
	local value = self._sheetImage
	if value==nil and self._inherit then
		value = self._inherit.sheetImage
	end
	return value
end
function SegmentedStyle.__setters:sheetImage( value )
	-- print( "SegmentedStyle.__setters:sheetImage", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._sheetImage then return end
	self._sheetImage = value
	self:_dispatchChangeEvent( 'sheetImage', value )
end

--== .sheetInfo

function SegmentedStyle.__getters:sheetInfo()
	-- print( "SegmentedStyle.__getters:sheetInfo", self )
	local value = self._sheetInfo
	if value==nil and self._inherit then
		value = self._inherit.sheetInfo
	end
	return value
end
function SegmentedStyle.__setters:sheetInfo( value )
	-- print( "SegmentedStyle.__setters:sheetInfo", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._sheetInfo then return end
	self._sheetInfo = value
	self:_dispatchChangeEvent( 'sheetInfo', value )
end

--== .spriteFrames

function SegmentedStyle.__getters:spriteFrames()
	-- print( "SegmentedStyle.__getters:spriteFrames", self )
	local value = self._spriteFrames
	if value==nil and self._inherit then
		value = self._inherit.spriteFrames
	end
	return value
end
function SegmentedStyle.__setters:spriteFrames( value )
	-- print( "SegmentedStyle.__setters:spriteFrames", value )
	assert( type(value)=='table' or (value==nil and (self._inherit or self._isClearing) ) )
	--==--
	if value == self._spriteFrames then return end
	self._spriteFrames = value
	self:_dispatchChangeEvent( 'spriteFrames', value )
end




--====================================================================--
--== Private Methods


function SegmentedStyle:_doChildrenInherit( value )
	-- print( "SegmentedStyle:_doChildrenInherit", value )
	if not self._isInitialized then return end

	self._active.inherit = value and value.active or value
	self._disabled.inherit = value and value.disabled or value
	self._inactive.inherit = value and value.inactive or value
end


function SegmentedStyle:_clearChildrenProperties( style, params )
	-- print( "SegmentedStyle:_clearChildrenProperties", style, self )
	assert( style==nil or type(style)=='table' )
	if style and type(style.isa)=='function' then
		assert( style:isa(SegmentedStyle) )
	end
	--==--
	local substyle

	substyle = style and style.active
	self._active:_clearProperties( substyle, params )

	substyle = style and style.disabled
	self._disabled:_clearProperties( substyle, params )

	substyle = style and style.inactive
	self._inactive:_clearProperties( substyle, params )
end


function SegmentedStyle:_destroyChildren()
	self._active:removeSelf()
	self._active=nil

	self._inactive:removeSelf()
	self._inactive=nil

	self._disabled:removeSelf()
	self._disabled=nil
end




-- TODO: more work when inheriting, etc (Background Style)
function SegmentedStyle:_prepareData( data, dataSrc, params )
	-- print("SegmentedStyle:_prepareData", data, self )
	params = params or {}
	--==--
	-- local inherit = params.inherit
	local StyleClass
	local src, dest, tmp

	if not data then
		data = SegmentedStyle.createStyleStructure( dataSrc )
	end

	src, dest = data, nil

	--== make sure we have structure for children

	StyleClass = Style.Text

	if not src.active then
		tmp = dataSrc and dataSrc.active
		src.active = StyleClass.createStyleStructure( tmp )
	end
	if not src.disabled then
		tmp = dataSrc and dataSrc.disabled
		src.disabled = StyleClass.createStyleStructure( tmp )
	end
	if not src.inactive then
		tmp = dataSrc and dataSrc.inactive
		src.inactive = StyleClass.createStyleStructure( tmp )
	end

	--== process children

	dest = src.active
	src.active = StyleClass.copyExistingSrcProperties( dest, src )

	dest = src.disabled
	src.disabled = StyleClass.copyExistingSrcProperties( dest, src )

	dest = src.inactive
	src.inactive = StyleClass.copyExistingSrcProperties( dest, src )

	return data
end



--====================================================================--
--== Event Handlers


-- none




return SegmentedStyle
