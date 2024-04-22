windowButton = nil
jumpWindow = nil

jumpingButton = nil
updateLeftMovementEvent = nil

function init()
    connect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    -- Create the jump window and hide it for later
    jumpWindow = g_ui.displayUI('jumpingbutton.otui')
    jumpWindow:hide()

    -- Create the jump window toggle button in the top right of the UI
    windowButton = modules.client_topmenu.addRightGameToggleButton('windowButton', tr('Jumping Button Window'),
        '/images/topbuttons/hotkeys', toggle)
    windowButton:setOn(false)

    -- Get reference to jumping button for later
    jumpingButton = jumpWindow:getChildById('jumpingButton');
end

function updateLeftMovement()
    -- calculate the minimum X value that would reset the button
    local minX = jumpWindow:getX() + 20

    local currentX = jumpingButton:getX()

    if jumpWindow:isVisible() then
        -- Check if the button is off the left side of the window
        if currentX >= minX then
            -- Since the button still has room to move left, then schedule another update call
            updateLeftMovementEvent = scheduleEvent(function() updateLeftMovement() end, 50)

            -- Move the button slightly to the left
            jumpingButton:setX(currentX - 10)
        else
            -- Since the button has gone off the window, reset it again
            resetButtonPosition()
        end

        return true
    end

    -- Remove the event if the window is closed
    stopLeftMovementEvent()
end

function stopLeftMovementEvent()
    if updateLeftMovementEvent then
        updateLeftMovementEvent:cancel()
        updateLeftMovementEvent = nil
    end
end

function terminate()
    disconnect(g_game, {
        onGameStart = online,
        onGameEnd = offline
    })

    jumpWindow:destroy()
    windowButton:destroy()
end

function toggle()
    -- Toggle the window on/off
    if windowButton:isOn() then
        windowButton:setOn(false)
        jumpWindow:hide()
    else
        windowButton:setOn(true)
        jumpWindow:show()
        jumpWindow:raise()
        jumpWindow:focus()

        -- Reset the jumping button position and start the movement
        resetButtonPosition()
    end
end

function resetButtonPosition()
    -- Move the button relative to the current parent position
    local parentPosition = jumpWindow:getPosition()
    jumpingButton:setX(parentPosition.x + 380)

    -- Use a random Y position
    local randY = math.random(30, 380)
    jumpingButton:setY(parentPosition.y + randY)

    -- Clear the current event loop
    stopLeftMovementEvent()

    -- Start a new event loop to move the button
    updateLeftMovement()
end

function online()
    windowButton:show()
end

function offline()

end
