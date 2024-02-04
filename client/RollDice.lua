
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

RegisterNetEvent("RollDice:Client:Roll")
AddEventHandler("RollDice:Client:Roll", function(players, rolls)
    local firstPed = GetPlayerPed(players.first)
    local secondPed = GetPlayerPed(players.second)

    if firstPed ~= PlayerPedId() or secondPed ~= PlayerPedId() then return end

    FreezeEntityPosition(PlayerPedId(), true)
    DiceRollAnimation()

    
    CreateThread(function() 
        Wait(1000) --Waits the amount of seconds set from the config.
        ShowRoll("Rolled " .. rolls.firstRoll, firstPed)
        ShowRoll("Rolled " .. rolls.secondRoll, secondPed)
    end)

end)



RegisterCommand(RollDice.ChatCommand, function(source, args, rawCommand)
    local myCoords = GetEntityCoords(PlayerPedId())
    local ClosestPlayers = QBCore.Functions.GetPlayersFromCoords(myCoords, 15.0)

    local firstPlayer = ClosestPlayers[1]
    local secondPlayer = ClosestPlayers[2]

    if RollDice.debugging then secondPlayer = ClosestPlayers[1] end

    if not secondPlayer then print("second player: ".. tostring(secondPlayer)) return end    


    print(firstPlayer, secondPlayer)

    local players = {
        first = firstPlayer,
        second = secondPlayer
    }
    
    TriggerServerEvent("RollDice:Server:Event", players)


end, false)
