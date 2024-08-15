local maxDistance = 5

function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    SetTextColour(red, green, blue, 255)
    SetTextScale(0.0*scale, 0.55*scale)
    SetTextFont(0)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
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
    Wait(50)
    if IsPlayerOnline() then
            while true do
                local players = GetActivePlayers() -- get all of the online players
                for _, playerId in ipairs(players) do -- loop through the players
                    if NetworkIsPlayerActive(playerId) then -- check if the player is active
                            local player = GetPlayerPed(playerId) -- get the currently selected players ped
                            if not GetEntityCollisionDisabled(player) and HasEntityClearLosToEntity(PlayerPedId(), player) and IsPedVaulting(player) == false or 1 then -- check if the the entity is in no clip.
                                    local x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                    local x2, y2, z2 = table.unpack(GetEntityCoords(player, true))
                                    local distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                                    if distance < maxDistance then
                                            local id = GetPlayerServerId(playerId)
                                            local name = GetPlayerName(playerId)
                                            local pos = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 1.0)
                            
                                            -- local headtag = "~b~Headtag Example "

                                            -- if MumbleIsPlayerTalking(playerId) or NetworkIsPlayerTalking(playerId) then
                                            --     draw3dText(pos, headtag .. '~y~[' .. id .. ']')
                                            -- else
                                            --         draw3dText(pos, headtag .. '~w~[' .. id .. ']')
                                            -- end

                                            if MumbleIsPlayerTalking(playerId) or NetworkIsPlayerTalking(playerId) then
                                                draw3dText(pos, '~y~[' .. id .. ']')
                                            else
                                                    draw3dText(pos, '~w~[' .. id .. ']')
                                            end
                                    end 
                            end
                    end       
                end
                Wait(0)
            end
    end
end)