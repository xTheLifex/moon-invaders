---@diagnostic disable: lowercase-global
utils = utils or {}

-- -------------------------------------------------------------------------- --
--                                    Misc                                    --
-- -------------------------------------------------------------------------- --
function table.pasteOver(into, from)
	local into = into
	for k,v in pairs(from) do
		into[k] = v
	end
	return into
end

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

table.copy = table.deepcopy

function table.clone(org)
  return {table.unpack(org)}
end

function utils.ScreenX()
	return love.graphics.getWidth()
end

function utils.ScreenY()
	return love.graphics.getHeight()
end

ScreenX = utils.ScreenX
ScreenY = utils.ScreenY


function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function string.replace(str, find, replace)
	return string.gsub(str, "%" .. find, replace)
end

function string.startsWith(str, start)
	return str:sub(1, #start) == start
end

function string.endsWith(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function table.Contains(table, value)
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end

	return false
end
table.contains = table.Contains


function table.ContainsKey(table, key)
	return table[key] ~= nil
end
table.containskey = table.ContainsKey

function table.AllEqual(table, value)
	for k,v in pairs(table) do
		if (v ~= value) then
			return false
		end
	end
	return true
end

-- Bit array order
function utils.oBit(n)
	return math.pow(2, n)
end
oBit = utils.oBit -- Global

function utils.Clamp(val, n, m)
	if (type(val) ~= "number") then return val end
	
	local min
	local max
	
	if (n == m) then return val end
	
	if (n > m) then
		max = n
		min = m
	end
	
	if (m > n) then
		max = m
		min = n
	end
	
	if (val > max) then return max end
	if (val < min) then return min end
	return val
end

utils.clamp = utils.Clamp
math.clamp = utils.clamp

function utils.RemoveExtension(str)
	if (type(str) ~= "string") then return "" end
	return string.match(str, "(.+)%..+$") or str
end

function utils.GetDirectoryContents(dir)
	-- TODO: Check dir existance.
	return love.filesystem.getDirectoryItems(dir)
end

function utils.DirFormat(dir)
	local dir = dir or 0
	assert(type(dir) == "number", "Invalid direction to convert")

	if dir > 0 then dir = math.floor(dir) end
	if dir < 0 then dir = math.ceil(dir) end

	if (dir > 8) then
		while dir > 8 do
			dir = dir - 8
		end
	end

	if (dir < 1) then
		while dir < 1 do
			dir = dir + 8
		end
	end

	return dir
end

-- -------------------------------------------------------------------------- --
--                                    Types                                   --
-- -------------------------------------------------------------------------- --

-- Default types

-- Returns if given value is a boolean
function utils.isbool(val)
	return type(val) == "boolean"
end

-- Returns if given value is a table
function utils.istable(val)
	return type(val) == "table"
end

-- Returns if given value is a string
function utils.isstring(val)
	return type(val) == "string"
end

-- Returns if given value is a number
function utils.isnumber(val)
	return type(val) == "number"
end

-- Returns if given value is a function
function utils.isfunction(val)
	return type(val) == "function"
end

-- Converts a given value into a boolean if possible
function utils.tobool(val)
	if (type(val) == "boolean") then
		return val
	end
	if (isstring(val)) then
		local lstr = string.lower(val)
		if (lstr == "yes" or lstr == "true" or lstr == "1") then
			return true
		end
	end
	if (isnumber(val)) then
		if (val == 1) then return true end
	end
	return false
end

utils.isfunc = utils.isfunction
utils.ismethod = utils.isfunction

-- Globals for default types
isbool 		= utils.isbool
istable		= utils.istable
isstring	= utils.isstring
isnumber	= utils.isnumber
isfunction	= utils.isfunction
isfunc		= utils.isfunc
ismethod	= utils.ismethod
tobool		= utils.tobool

-- -------------------------------------------------------------------------- --
--                                    Mouse                                   --
-- -------------------------------------------------------------------------- --

function utils.MousePos()
	local x,y = love.mouse.getPosition()
	return {
		["x"] = x,
		["y"] = y,
		[1] = x,
		[2] = y
	}
end

function utils.MouseX()
	local pos = utils.MousePos()
	return pos.x
end

function utils.MouseY()
	local pos = utils.MousePos()
	return pos.y
end

MousePos = utils.MousePos
MouseX = utils.MouseX
MouseY = utils.MouseY

function utils.Distance (x1,y1, x2,y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx * dx + dy * dy)
end

function utils.Vector(x,y)
	return {[1] = x,[2] = y, ["x"]=x, ["y"]=y}
end

Vector = utils.Vector
Vec = utils.Vector