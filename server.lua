function ReadFile(filePath)
    local file = io.open(filePath, "r") 
    if not file then return nil end 
    
    local content = file:read("*a") 
    file:close() 
    return content 
end

RegisterCommand("playtime", function(source, args)
    local steamID = GetPlayerIdentifier(source, 0)

    local playerData = ReadFile("/txData/default/data/playersDB.json")
    if not playerData then
        print("Error: Unable to read playersDB.json")
        return
    end
    
    local players = json.decode(playerData)
    if not players then
        print("Error: Unable to parse playersDB.json")
        return
    end
    
    local playtime = nil
    for _, player in ipairs(players.players) do
        for _, id in ipairs(player.ids) do
            if id == steamID then
                playtime = player.playTime
                break
            end
        end
        if playtime then
            break
        end
    end
    
    if not playtime then
        print("Error: Playtime not found for player")
        return
    end
    
    local days = math.floor(playtime / (24 * 60)) -- 1 day = 24 hours * 60 minutes
    local remainingHours = math.floor((playtime % (24 * 60)) / 60)
    local remainingMinutes = playtime % 60
    local hours = playtime / 60
    TriggerClientEvent("chatMessage", source, "^1[Server]", {255, 255, 255}, "Total Hours:" ..string.format("%.2f", hours).. "hours")

TriggerClientEvent("chatMessage", source, "^1[Server]", {255, 255, 255}, "Your playtime: " .. days .. " days, " .. remainingHours .. " hours, and " .. remainingMinutes .. " minutes.")
end, false)


