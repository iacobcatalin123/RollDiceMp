QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('RollDice:Server:Event', function(players)
    print("args")
    print(json.encode(source))
    print(tostring(players))

    TriggerClientEvent("RollDice:Client:Roll", -1, players, {
        firstRoll = math.random(1, 6),
        secondRoll = math.random(1, 6)
    })
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
