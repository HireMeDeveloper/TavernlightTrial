spellWindow = nil
spellButton = nil

function init()
	connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    -- Create the jump window and hide it for later
    spellWindow = g_ui.displayUI('frigo.otui')
    spellWindow:disableResize()
    spellWindow:setup()
    spellWindow:hide()

    -- Create the jump window toggle button in the top right of the UI
    spellButton = modules.client_topmenu.addRightGameToggleButton('frigoButton', tr('Frigo Button'),
        '/images/topbuttons/hotkeys', toggle)
    spellButton:setOn(false)
end

function terminate()
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })
end

function online()
    spellButton:show()
end

function offline()

end

function toggle()
  if spellButton:isOn() then
    spellWindow:close()
    spellButton:setOn(false)
  else
    spellWindow:open()
    spellButton:setOn(true)
  end
end

function onMiniWindowClose()
    toggle()
end

function castFrigo()
    --local player = getCreatureTarget(cid)
    --local origin = getCreaturePosition(player)

    g_game.talk("Frigo!")
    --doSendMagicEffect(Position{0, 0, 0}, CONST_ME_ICETORNADO)

    local combat = createCombatObject()
    setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    setCombatArea(combat, createCombatArea(AREA_CIRCLE2X2))
    doCombat(vid, combat, var)
end