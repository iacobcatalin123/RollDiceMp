RollDice = {}

RollDice.debugging = true -- set <false> to disable debugging
RollDice.ChatCommand = "roll" --Command name.

RollDice.MaxDistance = 7.0 -- Distance players can see the rolldice in 3d text.

function dprint(msg)
    if RollDice.debugging then
        print(tostring(msg))
    end
end