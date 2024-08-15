local maxDistance = 5

local currentHeadtag

local distances = {}

function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    SetTextColour(red, green, blue, 255)
    SetTextScale(0.0*scale, 0.55*scale)
    SetTextFont(0)
    SetTextOutline()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        local players = GetActivePlayers() -- get all of the online players
        for _, playerId in ipairs(players) do -- loop through the players
            local player = GetPlayerPed(playerId) -- get the currently selected players ped
            if distances[playerId] then
                if IsPedVaulting(player) or not GetEntityCollisionDisabled(player) then -- check if the the entity is in no clip.
                    if distances[playerId] < maxDistance then
                        local id = GetPlayerServerId(playerId)
                        local pos = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 1.0)
        
                        if currentHeadtag ~= nil then
                            if MumbleIsPlayerTalking(playerId) or NetworkIsPlayerTalking(playerId) then
                                draw3dText(pos, currentHeadtag .. ' ~y~[' .. id .. ']')
                            else
                                draw3dText(pos, currentHeadtag .. ' ~w~[' .. id .. ']')
                            end
                        else
                            if MumbleIsPlayerTalking(playerId) or NetworkIsPlayerTalking(playerId) then
                                draw3dText(pos, '~y~[' .. id .. ']')
                            else
                                draw3dText(pos, '~w~[' .. id .. ']')
                            end
                        end
                    end 
                end
            end      
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= ped then
                local distance = #(coords-GetEntityCoords(targetPed))
				distances[id] = distance
            end
        end
        Wait(1000)
    end
end)