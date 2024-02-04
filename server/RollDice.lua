QBCore = exports['qb-core']:GetCoreObject()


local games = {}

local function findGameBasedOnPlayer(player)
    for i = 1, #games do
        if games[i].players.first == player or games[i].players.second == player then
            return games[i]
        end
    end
end

-- RegisterServerEvent('RollDice:Server:Event', function(players)

--     -- TriggerClientEvent("RollDice:Client:Roll", -1, players, {
--     --     firstRoll = math.random(1, 6),
--     --     secondRoll = math.random(1, 6)
--     -- })

--     dprint("RollDice:Server:Event".. "with players" .. json.encode(players))
-- end)


RegisterServerEvent("RollDiceMp:Server:CreateGame", function(players) 

    local alreadyExists = findGameBasedOnPlayer(players.first) or findGameBasedOnPlayer(players.second)
    if alreadyExists then 
        dprint("Game already exists")
        return
    end

    table.insert(games, 
    {
        gameId = #games + 1,
        players = players,
        rolls = {
            firstRoll = math.random(1, 6),
            secondRoll = math.random(1, 6)
        },
        playersAcceptance = {
            first = true,
            second = false
        },
        readyToRoll = {
            first = false,
            second = false
        }
    })

    TriggerClientEvent("RollDiceMp:Client:RequestAcceptance", players.second)
end)


RegisterNetEvent("RollDiceMp:Server:InvitationDeclined", function() 

end)


RegisterNetEvent("RollDiceMp:Server:GameCreationAccepted",function()
    local src = source

    local gameData = findGameBasedOnPlayer(src)
    if not gameData then 
        dprint("No game found for player: " .. src)
        return
    end

    dprint("Game found for player: " .. src)


    if gameData.players.first == src then
        gameData.playersAcceptance.first = true
        dprint("First player accepted")
    elseif gameData.players.second == src then
        gameData.playersAcceptance.second = true
        dprint("Second player accepted")
    end
    
end)


RegisterNetEvent("RollDiceMp:Server:StartGame", function()
    local src = source
    local gameData = findGameBasedOnPlayer(src)
    if not gameData then 
        dprint("No game found for player: " .. src)
        return
    end

    dprint("Game data: " .. json.encode(gameData))

    TriggerClientEvent("RollDiceMp:client:RollDiceMenu", gameData.players.first)
    TriggerClientEvent("RollDiceMp:client:RollDiceMenu", gameData.players.second)
    

    -- if gameData.playersAcceptance.first and gameData.playersAcceptance.second then
    --     dprint("Both players accepted")
    --     TriggerClientEvent("RollDiceMp:Client:Roll", -1, gameData.players, gameData.rolls)
    -- else
    --     dprint("Not all players accepted")
    -- end 

end)

RegisterNetEvent("RollDiceMp:Server:ReadyToRoll",function()
    local src = source
    local gameData = findGameBasedOnPlayer(src)

    if not gameData then 
        dprint("No game found for player: " .. src)
        return
    end

    if gameData.players.first == src then
        gameData.readyToRoll.first = true
        dprint("First player is ready")
    elseif gameData.players.second == src then
        gameData.readyToRoll.second = true
        dprint("Second player is ready")
    end

    if gameData.readyToRoll.first and gameData.readyToRoll.second then
        dprint("Both players are ready")
        TriggerClientEvent("RollDiceMp:Client:Roll", gameData.players.first, gameData.players, gameData.rolls)
        TriggerClientEvent("RollDiceMp:Client:Roll", gameData.players.second, gameData.players, gameData.rolls)
        gameData.readyToRoll.first = false
        gameData.readyToRoll.second = false
        gameData.rolls = {
            firstRoll = math.random(1, 6),
            secondRoll = math.random(1, 6)
        }        
    end

end)

RegisterNetEvent("RollDiceMp:Server:DeleteGame", function() 

end)

CreateThread(function()                                                        --Creates a suggestion box if you are using the /roll command through the config.
    while true do 
        Wait(10000)
        dprint(json.encode(games))
    end
end)










































CreateThread(function ()
    print("\
   _____                              _   \
  / ____|                            | |  \
 | (___  _   _ _ __  _ __   ___  _ __| |_ \
  \\___ \\| | | | '_ \\| '_ \\ / _ \\| '__| __|\
  ____) | |_| | |_) | |_) | (_) | |  | |_ \
 |_____/ \\__,_| .__/| .__/ \\___/|_|   \\__|\
              | |   | |                   \
              |_|   |_|                   \
\
\
Discord: kraneq")
end)
