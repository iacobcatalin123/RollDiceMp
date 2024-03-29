


---Draws a 3D text on the screen
---@param x number
---@param y number
---@param z number
---@param text string
function DrawText3D(x, y, z, text) --Just a simple generic 3d text function. Copy pasted from my own core.
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 100)
    end
end

---Plays the dice roll animation
function DiceRollAnimation()
    local pedid = PlayerPedId()
    RequestAnimDict("anim@mp_player_intcelebrationmale@wank")                  --Request animation dict.

    while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do --Waits till it has been loaded.
        Citizen.Wait(0)
    end

    TaskPlayAnim(pedid, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, -8.0, -1, 49, 0, false, false, false) --Plays the animation.
    Citizen.Wait(2400)
    ClearPedTasks(pedid)
end

---Text on player after roll
---@param text string
---@param pedId number
function ShowRoll(text, pedId)
    CreateThread(function()
        local starttime = GetGameTimer()                                              --Gets the current game time.
        while (GetGameTimer() - starttime) < 5000 do                                  --While the time is less than the time set in the config.
            local currentCoords = GetEntityCoords(pedId)                              --Finds the coords of the roller's ped.
            DrawText3D(currentCoords.x, currentCoords.y, currentCoords.z + 1.0, text) --Prints the 3d text at the current coords of the roller's ped.
            Wait(7)
        end
        FreezeEntityPosition(pedId, false)
    end)
end

-- qb menu
function Acceptance()
    local menu = {
        {

            isMenuHeader = true,
            header = "Dice game acceptance",
            icon = 'fa-solid fa-dice',

        },
        {
            header = 'Accept',
            txt = 'Accept the dice game!',
            icon = 'fa-solid fa-check',
            params = {
                event = 'RollDiceMp:client:acceptedDiceGame',
                args = {}
            }
        },
        {
            header = 'Decline',
            txt = 'Refuse the dice game!',
            icon = 'fa-solid fa-times',
            params = {
                event = 'RollDiceMp:client:declinedDiceGame',
                args = {}
            }
        },
    }

    exports['qb-menu']:openMenu(menu)
end



function RollDiceMenu(closeIt)
    local menu = {
        {

            isMenuHeader = true,
            header = "Roll Dice",
            icon = 'fa-solid fa-dice',

        },
        {
            header = 'Roll',
            txt = 'Roll the dice!',
            icon = 'fa-solid fa-dice',
            params = {
                isServer = true,
                event = 'RollDiceMp:Server:ReadyToRoll',
                args = {}
            }
        },
        {
            header = 'Exit Game',
            txt = 'Exit the game',
            icon = 'fa-solid fa-times',
            params = {
                isServer = true,
                event = 'RollDiceMp:Server:DeleteGame',
                args = {}
            }
        },
    }
    exports['qb-menu']:openMenu(menu)
end





RegisterNetEvent("RollDiceMp:Client:RequestAcceptance",function()
    AcceptancePromise = promise:new()
    Acceptance()

    Citizen.Await(AcceptancePromise)
    
    local accepted = AcceptancePromise.value
    
    dprint("Accepted: " .. tostring(accepted))


    if not accepted then 
        AcceptancePromise = promise:new()
        TriggerServerEvent("RollDiceMp:Server:DeleteGame")
        dprint("Declined")
        return 
    end

    TriggerServerEvent("RollDiceMp:Server:GameCreationAccepted")    

end)


RegisterNetEvent('RollDiceMp:client:acceptedDiceGame', function()
    AcceptancePromise:resolve(true)
    TriggerServerEvent("RollDiceMp:Server:StartGame")
end)

RegisterNetEvent('RollDiceMp:client:declinedDiceGame', function()
    AcceptancePromise:resolve(false)
    TriggerServerEvent("RollDiceMp:Server:DeleteGame")
end)

RegisterNetEvent("RollDiceMp:client:GameOver", function()
    exports['qb-menu']:closeMenu()
    QBCore.Functions.Notify("Game Over", "primary", 5000)
end)

RegisterNetEvent("RollDiceMp:client:RollDiceMenu", function() 
    RollDiceMenu()
end)

Citizen.CreateThread(function()                                                        --Creates a suggestion box if you are using the /roll command through the config.
    TriggerEvent('chat:addSuggestion', '/' .. RollDice.ChatCommand, 'roll the dice', { --Adds the suggestion box.
    })
end)
