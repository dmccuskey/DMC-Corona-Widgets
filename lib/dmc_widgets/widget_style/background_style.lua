--====================================================================--
-- dmc_widgets/widget_style/background_style.lua
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
--== DMC Corona Widgets : Widget Background Style
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data = _G.__dmc_widget
local dmc_widget_func = dmc_widget_data.func
local widget_find = dmc_widget_func.find



--====================================================================--
--== DMC Widgets : newBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local WidgetUtils = require(widget_find( 'widget_utils' ))

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sformat = string.format
local tinsert = table.insert

--== To be set in initialize()
local Widgets = nil
local StyleFactory = nil



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundStyle.TYPE = 'background'

BackgroundStyle.__base_style__ = nil

BackgroundStyle._DEFAULT_VIEWTYPE = nil -- set later

-- create multiple base-styles for Background class
-- one for each available view
--
BackgroundStyle._BASE_STYLES = {}

BackgroundStyle._CHILDREN = {
	view=true
}

BackgroundStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,
	type=true
}

BackgroundStyle._EXCLUDE_PROPERTY_CHECK = {
	type=true,
	view=true
}

BackgroundStyle._STYLE_DEFAULTS = {
	name='background-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	-- these values can change
	type=nil,
	view=nil
}

BackgroundStyle._TEST_DEFAULTS = {
	name='background-test-style',
	debugOn=true,
	width=301,
	height=302,
	anchorX=303,
	anchorY=304,

	-- these values can change
	type=nil,
	view=nil
}

BackgroundStyle.MODE = BaseStyle.RUN_MODE
BackgroundStyle._DEFAULTS = BackgroundStyle._STYLE_DEFAULTS

--== Event Constants

BackgroundStyle.EVENT = 'background-style-event'


--======================================================--
-- Start: Setup DMC Objects

function BackgroundStyle:__init__( params )
	-- print( "BackgroundStyle:__init__", params )
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

	self._type = nil

	--== Object Refs ==--

	self._view = nil -- Background View Style

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundStyle.initialize( manager, params )
	-- print( "BackgroundStyle.initialize", manager )
	params = params or {}
	if params.mode==nil then params.mode=BaseStyle.RUN_MODE end
	--==--
	Widgets = manager
	StyleFactory = Widgets.Style.BackgroundFactory

	if params.mode==BaseStyle.TEST_MODE then
		BackgroundStyle.MODE = BaseStyle.TEST_MODE
		BackgroundStyle._DEFAULTS = BackgroundStyle._TEST_DEFAULTS
	end
	local defaults = BackgroundStyle._DEFAULTS

	-- set LOCAL defaults before creating classes next
	BackgroundStyle._DEFAULT_VIEWTYPE = StyleFactory.Rounded.TYPE

	BackgroundStyle._setDefaults( BackgroundStyle, {defaults=defaults} )
end


-- create empty Background Style structure
function BackgroundStyle.createStyleStructure( data )
	-- print( "BackgroundStyle.createStyleStructure", data )
	data = data or BackgroundStyle._DEFAULT_VIEWTYPE
	return {
		type=data,
		view={}
	}
end


function BackgroundStyle.addMissingDestProperties( dest, srcs )
	-- print( "BackgroundStyle.addMissingDestProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = Utils.extend( srcs, {} )
	if lsrc.parent==nil then lsrc.parent=dest end
	if lsrc.main==nil then lsrc.main=BackgroundStyle._DEFAULTS end
	lsrc.widget = BackgroundStyle._DEFAULTS
	--==--

	dest = BaseStyle.addMissingDestProperties( dest, lsrc )

	for _, key in ipairs( { 'main', 'parent', 'widget' } ) do
		local src = lsrc[key] or {}

		if dest.type==nil then dest.type=src.type end

	end

	dest = BackgroundStyle._addMissingChildProperties( dest, lsrc )

	return dest
end


-- _addMissingChildProperties()
-- copy properties to sub-styles
--
function BackgroundStyle._addMissingChildProperties( dest, srcs )
	-- print( "BackgroundStyle._addMissingChildProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = { parent = dest }
	--==--
	local eStr = "ERROR: Style (BackgroundStyle) missing property '%s'"
	local StyleClass, child

	child = dest.view
	-- assert( child, sformat( eStr, 'view' ) )
	StyleClass = StyleFactory.getClass( dest.type )
	lsrc.main = srcs.main and srcs.main.view
	-- TODO create other local defaults for each view type
	dest.view = StyleClass.addMissingDestProperties( child, lsrc )

	return dest
end


-- to a new stucture
function BackgroundStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "BackgroundStyle.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	dest = BaseStyle.copyExistingSrcProperties( dest, src, params )

	if (src.type~=nil and dest.type==nil) or force then
		dest.type=src.type
	end

	return dest
end


function BackgroundStyle._verifyStyleProperties( src, exclude )
	-- print( "BackgroundStyle._verifyStyleProperties", src, exclude )
	local emsg = "Style (BackgroundStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src, exclude )

	if not src.type then
		print(sformat(emsg,'type')) ; is_valid=false
	end

	local child, StyleClass

	child = src.view
	StyleClass = child.class
	if not StyleClass._verifyStyleProperties( child, exclude ) then
		is_valid=false
	end

	return is_valid
end


-- _setDefaults()
-- create one of each style
--
function BackgroundStyle._setDefaults( StyleClass, params )
	-- print( "BackgroundStyle._setDefaults", StyleClass )
	params = params or {}
	if params.defaults==nil then params.defaults=StyleClass._STYLE_DEFAULTS end
	--==--
	local BASE_STYLES = StyleClass._BASE_STYLES
	local def = params.defaults

	local classes = StyleFactory.getStyleClasses()

	for _, Cls in ipairs( classes ) do
		local cls_type = Cls.TYPE
		local struct = BackgroundStyle.createStyleStructure( cls_type )
		local def = Utils.extend( def, struct )
		StyleClass._addMissingChildProperties( def, {def} )
		local style = StyleClass:new{ data=def }
		BASE_STYLES[ cls_type ] = style
	end

end



--====================================================================--
--== Public Methods


function BackgroundStyle:getBaseStyle( data )
	-- print( "BackgroundStyle:getBaseStyle", self, data )
	local BASE_STYLES = self._BASE_STYLES
	local viewType, style

	if data==nil then
		viewType = self._DEFAULT_VIEWTYPE
	elseif type(data)=='string' then
		viewType = data
	elseif data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		viewType = data.type
	else
		--== Lua structure
		viewType = data.type
	end

	style = BASE_STYLES[ viewType ]
	if not style then
		style = BASE_STYLES[ self._DEFAULT_VIEWTYPE ]
	end

	return style
end


-- copyProperties()
-- copy properties from a source
-- if no source, then copy from Base Style
--
function BackgroundStyle:copyProperties( src, params )
	-- print( "BackgroundStyle:copyProperties", src, self )
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local StyleClass = self.class
	if not src then src=StyleClass:getBaseStyle( self.type ) end
	StyleClass.copyExistingSrcProperties( self, src, params )
end


--======================================================--
-- Access to sub-styles

function BackgroundStyle.__getters:view()
	-- print( 'BackgroundStyle.__getters:view', self._view )
	return self._view
end
function BackgroundStyle.__setters:view( data )
	-- print( 'BackgroundStyle.__setters:view', data )
	assert( data==nil or type(data)=='string' or type( data )=='table' )
	--==--
	local inherit = self._inherit and self._inherit._view

	self._view = self:_createView{
		name=BackgroundStyle.VIEW_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Misc

function BackgroundStyle:_doChildrenInherit( value, params )
	-- print( "BackgroundStyle_doChildrenInherit", value, self )
	assert( params )
	--==--
	if not self._isInitialized then return end

	self:_updateViewStyle( { delta='inherit', cInherit=params.curr, nInherit=params.next, clearProperties=false } )
end


function BackgroundStyle:_doClearPropertiesInherit( reset, params )
	-- print( "BackgroundStyle:_doClearPropertiesInherit", self, reset, self._isInitialized )
	-- pass, we do everthing inside up updateView
	if self._isInitialized then return end

	BaseStyle._doClearPropertiesInherit( self, reset, params )
end


function BackgroundStyle:_clearChildrenProperties( style, params )
	-- print( "BackgroundStyle:_clearChildrenProperties", style, self )
	assert( style==nil or type(style)=='table' )
	if style and type(style.isa)=='function' then
		assert( style:isa( BackgroundStyle ) )
	end
	--==--
	local substyle

	substyle = style and style.view or style
	self._view:_clearProperties( substyle, params )
end


-- createStyleFromType()
-- method processes data from the 'view' setter
-- looks for style class based on type
-- then calls to create the style
--
function BackgroundStyle:createStyleFromType( params )
	-- print( "BackgroundStyle:createStyleFromType", params )
	params = params or {}
	--==--
	local data = params.data
	local style_type, StyleClass

	-- look around for our style 'type'
	if data==nil then
		style_type = self._DEFAULT_VIEWTYPE
	elseif type(data)=='string' then
		-- we have type already
		style_type = data
		params.data=nil
	elseif type(data)=='table' then
		-- Lua structure, of View
		style_type = self.type
	end
	assert( style_type and type(style_type)=='string', "Style: missing style property 'type'" )

	StyleClass = StyleFactory.getClass( style_type )

	return StyleClass:createStyleFrom( params )
end


-- checks to make sure parent/view type are equal, etc
-- two entrances to this method, via:
-- 'type' setter
-- 'inherit' setter
--
function BackgroundStyle:_updateViewStyle( params )
	-- print( "BackgroundStyle:_updateViewStyle", params )
	params = params or {}
	params.delta = params.delta
	params.cType = params.cType
	params.nType = params.nType
	params.cInherit = params.cInherit
	params.nInherit = params.nInherit
	params.clearProperties = params.clearProperties
	--==--
	local inheritIsActive = (self._type==nil)
	local haveInheritedStyle = (self._inherit~=nil)
	local styleType = self._type
	local styleInherit = self._inherit
	local viewStyle = self._view
	local viewType = viewStyle.type
	local viewInherit = viewStyle._inherit
	local StyleClass, StyleBase
	local doClear = params.clearProperties
	local doReset = false
	local delta = params.delta
	local doInherit = (delta=='inherit')
	local doType = (delta=='type')
	local cInherit, nInherit = params.cInherit, params.nInherit
	local cType, nType = params.cType, params.nType
	local bgType, bgInherit, bgData
	local bgType_dirty, bgInherit_dirty, bgData_dirty = false, false, false
	local vType, vInherit, vData
	local vType_dirty, vInherit_dirty, vData_dirty = false, false, false

	--== Sanity Check ==--

	if self.__isUpdatingView==true then
		-- protect against other entrances to updateViewStyle
		-- eg, like setting 'type' property
		return
	end
	self.__isUpdatingView = true

	-- coming in with one delta means the values for the
	-- other 'delta' aren't set
	if doType then
		cInherit=styleInherit
	else
		cType=styleType
	end

	-- print( "UPDATE ", delta, nInherit, nType, inheritIsActive )

	--== Process Matrix

	if delta=='inherit' and nInherit~=nil then
		if nInherit.type==viewType then
			-- new Inherit is of SAME type as current View
			bgType_dirty=true ; bgType = nil
			bgInherit_dirty=true ; bgInherit = nInherit
			bgData_dirty=true ; bgData = {src={}, force=true, clearChildren=false}
			vType_dirty=false ; vType = viewType -- no change
			vInherit_dirty=true ; vInherit = nInherit.view
			vData_dirty=true ; vData = {src={}, force=true, clearChildren=false}

		else
			-- new Inherit is of DIFFERENT type as current View
			bgType_dirty=true ; bgType = nil
			bgInherit_dirty=true ; bgInherit = nInherit
			bgData_dirty=true ; bgData = {src={}, force=true, clearChildren=false}
			vType_dirty=true ; vType = nInherit.type
			vInherit_dirty=true ; vInherit = nInherit.view
			vData_dirty=true ; vData = {src={}, force=true, clearChildren=false}
		end

	elseif delta=='inherit' and nInherit==nil then
		if not cInherit then
			print( sformat( "[NOTICE] Inherit is already set to '%s'", tostring(nInherit) ))

		elseif inheritIsActive then
			-- have full-inheritance, ie, inherited and no local type
			bgType_dirty=true ; bgType = self.type
			bgInherit_dirty=true ; bgInherit = nil
			bgData_dirty=true ; bgData = {src=cInherit, force=false, clearChildren=false}
			vType_dirty=false ; vType = viewType -- no change
			vInherit_dirty=true ; vInherit = nil
			vData_dirty=false ; vData = {src=viewInherit, force=false, clearChildren=false}

		else
			-- have inheritance, but not full. ie, have local type
			bgType_dirty=false ; bgType = nil -- no change
			bgInherit_dirty=true ; bgInherit = nil
			bgData_dirty=true ; bgData = {src=cInherit, force=false, clearChildren=false}
			vType_dirty=false ; vType = viewType -- no change
			vInherit_dirty=false ; vInherit = nil -- no change
			vData_dirty=true ; vData = {src=viewInherit, force=false, clearChildren=false}
		end

	elseif delta=='type' and cInherit==nil then
		if nType==nil then
			-- not a valid state
			print( sformat( "[WARNING] Setting uninherited Style type to 'nil' is not permitted" ) )

		elseif cType==nType then
			print( sformat( "[NOTICE] Type is already set to '%s'", tostring(nType) ))

		else
			-- new Type is DIFFERENT than current Background
			-- 'rect' to 'rounded'
			StyleBase = self:getBaseStyle( nType )

			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=false ; bgData = {src=StyleBase, force=false, clearChildren=false}
			vType_dirty=true ; vType = nType
			vInherit_dirty=false ; vInherit = nil -- no change
			vData_dirty=true ; vData = {src=StyleBase.view, force=true, clearChildren=false}
		end

	elseif delta=='type' and cInherit~=nil then
		if cType==nType then
			-- new Type is SAME as current Background
			print( sformat( "[NOTICE] Type is already set to '%s'", tostring(nType) ))

		elseif nType==nil and cInherit.type==viewType then
			-- unset type, view is correct
			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=true ; bgData = {src={}, force=true, clearChildren=false}
			vType_dirty=false ; vType = viewType -- no change
			vInherit_dirty=true ; vInherit = cInherit.view
			vData_dirty=true ; vData = {src={}, force=true, clearChildren=false}

		elseif nType==nil and cInherit.type~=viewType then
			-- unset type, view is incorrect
			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=true ; bgData = {src={}, force=true, clearChildren=false}
			vType_dirty=true ; vType = cInherit.type
			vInherit_dirty=true ; vInherit = cInherit.view
			vData_dirty=true ; vData = {src={}, force=true, clearChildren=false}

		elseif cType==nil and nType==viewType then
			-- new Type is SAME as inheritance
			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=true ; bgData = {src=cInherit, force=false, clearChildren=false}
			vType_dirty=false ; vType = nType -- no change
			vInherit_dirty=true ; vInherit = nil -- stop inheritance
			vData_dirty=true ; vData = {src=cInherit.view, force=true, clearChildren=false}

		elseif cType==nil and nType~=viewType then
			-- new Type is DIFFERENT than inheritance
			StyleBase = self:getBaseStyle( nType )

			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=true ; bgData = {src=StyleBase, force=false, clearChildren=false}
			vType_dirty=true ; vType = nType
			vInherit_dirty=true ; vInherit = nil -- stop inheritance
			vData_dirty=true ; vData = {src=StyleBase.view, force=true, clearChildren=false}

		else
			-- new Type is DIFFERENT than current Background, eg
			-- 'rect' to 'rounded'
			StyleBase = self:getBaseStyle( nType )

			bgType_dirty=true ; bgType = nType
			bgInherit_dirty=false ; bgInherit = nil -- no change
			bgData_dirty=false ; bgData = {src=StyleBase, force=false, clearChildren=false}
			vType_dirty=true ; vType = nType
			vInherit_dirty=false ; vInherit = nil -- no change
			vData_dirty=true ; vData = {src=StyleBase.view, force=true, clearChildren=false}
		end

	end

	-- print( "BG T, I, D", bgType_dirty, bgInherit_dirty, bgData_dirty )
	-- print( "VIEW T, I, D", vType_dirty, vInherit_dirty, vData_dirty )

	--== Do Work

	if bgType_dirty then
		-- print(">1 Set Type")
		self._type = bgType
		bgType_dirty=false
	end
	if bgInherit_dirty and not doInherit then
		-- print(">1 Change Inherit")
		self.inherit( bgData.src, bgData )
		bgInherit_dirty=false

		doReset=true
	end
	if bgData_dirty then
		-- print(">1 Clear background")
		self:_clearProperties( bgData.src, bgData )
		bgData_dirty=false

		doReset=true
	end

	if vType_dirty then
		-- print(">2 Create View")
		self._view = self:_createView{
			name=nil,
			inherit=nil,
			parent=self,
			data=vType
		}
		viewStyle = self._view
		vType_dirty=false

		doReset=true
	end
	if vInherit_dirty then
		-- print(">2 Change Inherit")
		viewStyle.inherit = vInherit
		vInherit_dirty=false

		doReset=true
	end
	if vData_dirty then
		-- print(">2 Clear Inherit", vData.src, vData.force )
		viewStyle:_clearProperties( vData.src, vData )
		vData_dirty=false

		doReset=true
	end

	if doReset then
		self:_dispatchResetEvent()
	end

	self.__isUpdatingView = nil
end


--== .inheritIsActive

function BackgroundStyle.__getters:inheritIsActive()
	return (self._inherit~=nil and self._type==nil)
end

--== type

function BackgroundStyle.__getters:type()
	-- print( "BackgroundStyle.__getters:type", self._inherit )
	local value = self._type
	if value==nil and self.inheritIsActive then
		value = self._inherit.type
	end
	return value
end
function BackgroundStyle.__setters:type( value )
	-- print( "BackgroundStyle.__setters:type", value, self, self._type )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	local cType, nType = self._type, value
	self._type = value
	if not self._isInitialized then return end

	self:_updateViewStyle( { delta='type', cType=cType, nType=nType, clearProperties=true } )
	self:_dispatchResetEvent()
end


--====================================================================--
--== Private Methods

function BackgroundStyle:_createView( params )
	-- print( 'BackgroundStyle:_createView', self._view )
	self:_destroyView()
	return self:createStyleFromType( params )
end

function BackgroundStyle:_destroyView()
	-- print( 'BackgroundStyle:_destroyView', self._view )
	if not self._view then return end
	self._view:removeSelf()
	self._view = nil
end

function BackgroundStyle:_destroyChildren()
	print( 'BackgroundStyle:_destroyChildren', self )
	error("TODO")
end


--[[
Prepare Data
we could have nil, Lua structure, or Instance

no data, no inherit - create structure, set default type
no data, inherit - create structure, use inherit value, unset type
data, inherit - inherit.type (unset) or data.type (set) or default (set)
--]]
-- _prepareData()
--
function BackgroundStyle:_prepareData( data )
	-- print( "BackgroundStyle:_prepareData", data, self )
	local inherit = self._inherit

	if not data then
		data = BackgroundStyle.createStyleStructure()
		if inherit then
			data.type = nil -- unset for inheritance
			data.view = inherit.type -- notify of type
		end

	elseif data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		local o = data
		data = BackgroundStyle.createStyleStructure( o.type )
		if inherit then
			data.type = nil -- unset for inheritance
			data.view = inherit.type -- notify of type
		end

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil
		local stype

		if inherit then
			stype = inherit.type
			src.type = nil -- unset for inheritance
		elseif src.type then
			stype = src.type
		else
			stype = self._DEFAULT_VIEWTYPE
			src.type = stype
		end

		if stype then
			--== set child properties

			StyleClass = StyleFactory.getClass( stype )

			-- before we copy our defaults, make sure
			-- structure for 'view' exists
			dest = src.view
			if not dest then
				dest = StyleClass.createStyleStructure()
				src.view = dest
			end
			StyleClass.copyExistingSrcProperties( dest, src )
		end

	end

	return data
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
