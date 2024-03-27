engine = {}
engine.quitReady = false
engine.libs = engine.libs or {}
love.filesystem.setIdentity("RexEngine")
game = {}

function love.load()
	-- ---------------------------------- Utils --------------------------------- --
	require("engine/utils")
	
	-- --------------------------------- Modules -------------------------------- --
	require("engine/logging")
	engine.Log("[Core] " .. os.date("Logging started for: %d/%m/%y"))
	require("engine/hooks")
	engine.Log("[Core] " .. "Loaded hook module.")
	require("engine/cvars")
	engine.Log("[Core] " .. "Loaded cvar module.")
	require("engine/time")
	engine.Log("[Core] " .. "Loaded time module.")
	require("engine/files")
	engine.Log("[Core] " .. "Loaded file module.")
	require("engine/routines")
	engine.Log("[Core] " .. "Loaded routines module.")
	engine.Log("[Core] " .. "Finished loading engine modules.")
	
	--love.math.setRandomSeed( CurTime() )
	math.randomseed( CurTime() )
	---@diagnostic disable-next-line: param-type-mismatch
	engine.Log("[Core] " .. "Applied seed to random generator: " .. os.time(os.date("!*t")))
	-- ---------------------------------- Setup --------------------------------- --
	engine.Log("[Core] " .. "Setting up CVars...")
	hooks.Fire("OnSetupCVars")
	hooks.Fire("PostSetupCVars")

	hooks.Fire("PreEngineLoad")
	hooks.Fire("OnEngineLoad")
	hooks.Fire("PostEngineLoad")

	engine.quitReady = true

	hooks.Fire("PreGameLoad")
	hooks.Fire("OnGameLoad")
	hooks.Fire("PostGameLoad")
end


function love.keyreleased(key, scancode, isrepeat)
	hooks.Fire("OnKeyReleased", key, scancode, isrepeat)	
end

function love.textinput(text)
	hooks.Fire("OnTextInput", text)
end

function love.mousepressed(x, y, button)
	hooks.Fire("OnMousePress", x, y, button)
end

function love.mousereleased(x, y, button)
	hooks.Fire("OnMouseRelease", x, y, button)
end

function love.update(deltaTime)
	if engine.loading == true then hooks.Fire("EngineLoadingScreenUpdate") end

	hooks.Fire("PreEngineUpdate", deltaTime)
	hooks.Fire("OnEngineUpdate", deltaTime)
	hooks.Fire("PostEngineUpdate", deltaTime)
	
	hooks.Fire("PreGameUpdate", deltaTime)
	hooks.Fire("OnGameUpdate", deltaTime)
	hooks.Fire("PostGameUpdate", deltaTime)
end

function love.wheelmoved(x, y)
	hooks.Fire("OnMouseWheel", x, y)
    if y > 0 then
        -- mouse wheel moved up
		hooks.Fire("OnMouseWheelUp", y)
    elseif y < 0 then
        -- mouse wheel moved down
		hooks.Fire("OnMouseWheelDown", y)
    end
end

function love.draw()
	hooks.Fire("PreDraw")

	if engine.loading == true then hooks.Fire("EngineLoadingScreenDraw") end
	
	hooks.Fire("OnCameraAttach")
	hooks.Fire("PreGameDraw")
	hooks.Fire("OnGameDraw")
	hooks.Fire("PostGameDraw")
	hooks.Fire("OnCameraDetach")
	
	hooks.Fire("PreInterfaceDraw")
	hooks.Fire("OnInterfaceDraw")
	hooks.Fire("PostInterfaceDraw")

	hooks.Fire("PreEngineDraw")
	hooks.Fire("OnEngineDraw")
	hooks.Fire("PostEngineDraw")
	
	hooks.Fire("PostDraw")
end

function love.quit()
	if (not engine.quitReady) then
		engine.Log("[Core] " .. "An attempt was made to shutdown, but the engine isn't ready to shutdown yet. Ignoring...")
		return true
	else
		engine.Log("[Core] " .. "Preparing for shutdown...")
		hooks.Fire("OnEngineShutdown")
		engine.Log("[Core] " .. "Shutting down...")
		return false
	end
end

function love.keypressed(key, scancode, isrepeat)

	if (scancode == "f12" and not isrepeat) then
		local v = engine.GetCVar("debug_hooks", false)
		engine.SetCVar("debug_hooks", not v)
		engine.SetCVar("debug_cvars", not v)
		return
	end

	if (scancode == "f6" and not isrepeat) then
		local v = engine.GetCVar("debug_rendering", false)
		engine.SetCVar("debug_rendering", not v)
		return
	end

	if (scancode == "f3" and not isrepeat) then
		local v = engine.GetCVar("debug_entities", false)
		engine.SetCVar("debug_entities", not v)
		return
	end

	if (scancode == "f2" and not isrepeat) then
		local v = engine.GetCVar("debug_physics", false)
		engine.SetCVar("debug_physics", not v)
		return
	end

	hooks.Fire("OnKeyPressed", key, scancode, isrepeat)
end
