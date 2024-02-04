
--[[
   _____                              _   
  / ____|                            | |  
 | (___  _   _ _ __  _ __   ___  _ __| |_ 
  \___ \| | | | '_ \| '_ \ / _ \| '__| __|
  ____) | |_| | |_) | |_) | (_) | |  | |_ 
 |_____/ \__,_| .__/| .__/ \___/|_|   \__|
              | |   | |                   
              |_|   |_|                   


Discord: kraneq
]]


QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent("RollDiceMp:Client:Roll", function(players, rolls)
    players.first = GetPlayerFromServerId(players.first)
    players.second = GetPlayerFromServerId(players.second)
    local firstPed = GetPlayerPed(players.first)
    local secondPed = GetPlayerPed(players.second)

    FreezeEntityPosition(PlayerPedId(), true)
    DiceRollAnimation()

    
    CreateThread(function() 
        Wait(1000) --Waits the amount of seconds set from the config.
        ShowRoll("Rolled " .. rolls.firstRoll, firstPed)
        ShowRoll("Rolled " .. rolls.secondRoll, secondPed)
    end)

    Wait(2000)
    RollDiceMenu()


end)



RegisterCommand(RollDice.ChatCommand, function(source, args, rawCommand)
    local myCoords = GetEntityCoords(PlayerPedId())
    local closestPlayer, distance = QBCore.Functions.GetClosestPlayer(myCoords)


    local firstPlayer = GetPlayerServerId(PlayerId())
    local secondPlayer = GetPlayerServerId(closestPlayer)

    -- if RollDice.debugging then secondPlayer = ClosestPlayers[1] end

    if not secondPlayer then print("second player: ".. tostring(secondPlayer)) return end    


    print(firstPlayer, secondPlayer)

    local players = {
        first = firstPlayer,
        second = secondPlayer
    }
    QBCore.Functions.Notify("Invitation Sent", "primary", 3000)
    TriggerServerEvent("RollDiceMp:Server:CreateGame", players)


end, false)
