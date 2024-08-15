local maxDistance = 5

Citizen.CreateThread(function()
    Wait(50)
    if IsPlayerOnline() then
            while true do
                local players = GetActivePlayers() -- get all of the online players
                for _, playerId in ipairs(players) do -- loop through the players
                    if NetworkIsPlayerActive(playerId) then -- check if the player is active
                            local player = GetPlayerPed(playerId) -- get the currently selected players ped
                            if not GetEntityCollisionDisabled(player) and HasEntityClearLosToEntity(PlayerPedId(), player) and player ~= PlayerPedId() then -- check if the the entity is in no clip.
                                    local x1, y1, z1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                    local x2, y2, z2 = table.unpack(GetEntityCoords(player, true))
                                    local distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                                    if distance < maxDistance then
                                            local id = GetPlayerServerId(player)
                                            local name = GetPlayerName(playerId)
                            
                                            if NetworkIsPlayerTalking(player) then
                                                    DrawText3D(x2, y2, z2+1, '~b~[' .. id .. '] ' .. name, 247, 124, 24)
                                            else
                                                    DrawText3D(x2, y2, z2+1, '~w~[' .. id .. '] ' .. name, 255, 255, 255)
                                            end
                                    end 
                            end
                    end       
                end
                Wait(0)
            end
    end
end)

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end