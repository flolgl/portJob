local PaletteActuelle 
local show, JobStarted, IsPaletteSpawned, isAttached, attachedEntity, salairetable = false, false, false, false, nil, {}


-- Blip jusqu'à livraison + destruction entités
-- Blip from pallet to delivery point 
function NewBlip()

    local objectif = math.randomchoice(Config.pos)
    local ped = GetPlayerPed(-1)

    local blip = AddBlipForCoord(objectif.x, objectif.y, objectif.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 2)

    local coords  = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(coords, objectif.x, objectif.y, objectif.z, true)

    while true do 
		Citizen.Wait(0)
        coords  = GetEntityCoords(ped)
        distance = GetDistanceBetweenCoords(coords, objectif.x, objectif.y, objectif.z, true)
        --print (distance)
        if distance <= 15 then
            --print (distance)
            DrawMarker(0, objectif.x, objectif.y, objectif.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            if distance <= 4 then
                local carpalette = GetVehiclePedIsIn(ped, false)
                local carentity = GetEntityModel(carpalette)
                local car_name = GetDisplayNameFromVehicleModel(carentity)
                if car_name == "FORK" then
                    local Palette = GetClosestObjectOfType(coords, 5.0, PaletteActuelle, false, false, false)
                    if DoesEntityExist(Palette) == 1 then
                        local salaire = math.random(Config.MinSalaire, Config.MaxSalaire)
                        --local salaire = Config.MaxSalaire

                        --print ("salaire: "..salaire)
                        RemoveBlip(blip)
                        table.insert(salairetable, salaire)
                        DeleteEntity(Palette)

                        --drawnotifcolor("Livraison effectuée", 25)
                        drawnotifcolor("Delivery is done", 25)
                        PaletteActuelle, attachedEntity = nil, nil
                        IsPaletteSpawned, isAttached = false, false
                        NotifChoise()
                        break
                    else
                        --drawnotifcolor("Tu n'as pas la palette",208)
                        drawnotifcolor("You're not carrying the pallet",208)
                    end
                end
            end
        end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            local Palette = GetClosestObjectOfType(coords, 5.0, PaletteActuelle, false, false, false)
            local DoesPaletteExist = DoesEntityExist(Palette)
            if DoesPaletteExist == 1 then
                DeleteEntity(Palette)
                IsPaletteSpawned = false
            end
            --drawnotifcolor ("Va voir le contremaitre pour ranger ton véhicule et récupérer ton argent.", 25)
            drawnotifcolor ("Bring back the forklift to get your money.", 25)
            FinService()
            break
        end
    end
end


-- Proposition choix entre continuer et s'arrêter
-- Stop or continue after objective is finished
function NotifChoise()

    --drawnotifcolor ("~g~E~g~ pour continuer.\n~r~X~r~ arrêter de travailler.", 140)
    drawnotifcolor ("~g~E~w~ to continue.\n~r~X~w~ to stop working.", 140)

    local timer = 1200
	while timer >= 1 do
		Citizen.Wait(10)
		timer = timer - 1

		if IsControlJustPressed(1, 38) then
            NewChoise()
			break
        end

		if IsControlJustPressed(1, 73) then
            --drawnotifcolor ("Va voir le contremaitre pour ranger ton véhicule et récupérer ton argent.", 140)
            drawnotifcolor ("Bring back the forklift to get your money.", 25)
            FinService()
            IsPaletteSpawned = false
			break
        end

        if timer == 1 then
            --drawnotifcolor ("Va voir le contremaitre pour ranger ton véhicule et récupérer ton argent.", 140)
            drawnotifcolor ("Bring back the forklift to get your money.", 25)
            FinService()
            IsPaletteSpawned = false
            break
        end

	end
end

-- Spawn de la première palette et du blip
-- Spawns first objetive and blip
function NewChoise()

    local prop = math.randomchoice(Config.props)
    local ped = GetPlayerPed(-1)

    while not HasModelLoaded(prop.model) do
        RequestModel(prop.model)
        Citizen.Wait(1)
    end



    local blip = AddBlipForCoord(prop.x, prop.y, prop.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 3)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)
    --drawnotifcolor("Nouvelle palette ajoutée sur ton gps.\n~r~X~w~ arrêter de travailler à tout moment.", 140)
    drawnotifcolor("New objective added to your gps.\n~r~X~w~ to stop at any moment.", 140)
    local coords  = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(coords, prop.x, prop.y, prop.z, true)

    while true do 
		Citizen.Wait(0)
		coords  = GetEntityCoords(ped)
        distance = GetDistanceBetweenCoords(coords, prop.x, prop.y, prop.z, true)
        if distance <= 60 then 
            if not IsPaletteSpawned then
                local objcreated2 = CreateObject(prop.model, prop.x, prop.y, prop.z, true, false, true)
                PaletteActuelle = prop.model
                SetModelAsNoLongerNeeded(objcreated2)
                IsPaletteSpawned = true
            end
            if distance <= 10 and IsControlJustPressed(0, 57) then
                RemoveBlip(blip)
                NewBlip()
                break
            end
        end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            --drawnotifcolor ("Va voir le contremaitre pour ranger ton véhicule et récupérer ton argent.", 140)
            drawnotifcolor ("Bring back the forklift to get your money.", 140)

            IsPaletteSpawned = false
            FinService()
            break
        end
    end
end

-- Fin de service
-- end job
function FinService()

    local coordsEndService = vector3(782.572, -2985.0231, 4.801)
    local ped = GetPlayerPed(-1)
    --AddTextEntry("press_ranger_fork", 'Appuie sur ~INPUT_CONTEXT~ pour ranger ton véhicule et récupérer ta paye')
    AddTextEntry("press_ranger_fork", 'Press ~INPUT_CONTEXT~ to store the forklift and get your money')

    local blip = AddBlipForCoord(coordsEndService)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)

    while true do 
		Citizen.Wait(0)
		local coords  = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coordsEndService, coords, true)
        --print (distance)
        if distance <= 5 then
            DisplayHelpTextThisFrame("press_ranger_fork")
            if IsControlPressed(1, 38) then
                local carpalette = GetVehiclePedIsIn(ped, false)
                local carentity = GetEntityModel(carpalette)
                local car_name = GetDisplayNameFromVehicleModel(carentity)
                if car_name ~= "FORK" then
                    --drawnotifcolor("Tu n'es pas dans ton chariot élévateur", 208)
                    drawnotifcolor("You're not in your forklift", 208)
                else
                    DeleteVehicle(carpalette)
                    if salairetable[1] ~= nil then
                        TriggerServerEvent("portjob:getMoney", salairetable)
                        for i = 1, #salairetable, 1 do
                            salairetable[i] = nil
                        end
                    end

                    RemoveBlip(blip)
                    JobStarted, show, PaletteActuelle = false, false, nil
                    break
                end
            end
        end
    end

end

-- Spawn forklift
function PriseService()

    local ped = GetPlayerPed(-1)
    local vehicleName = 'forklift'

    RequestModel(vehicleName)

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

    local vehicle = CreateVehicle(vehicleName, 782.084, -2977.7004, 4.80, 62.60, true, false)
    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(ped, vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    -- release the model
    SetModelAsNoLongerNeeded(vehicleName)
    JobStarted = true

    NewChoise()

end

-- Start job
Citizen.CreateThread(function()

    --AddTextEntry("press_start_job", "~INPUT_CONTEXT~ pour prendre ton service")
    AddTextEntry("press_start_job", "~INPUT_CONTEXT~ to start preparing orders")

    while true do 
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local coords  = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(vector3(785.8201, -2975.85644, 6.02), coords, true)
        if distance <= 5 then
            DisplayHelpTextThisFrame("press_start_job")
            if IsControlPressed(1, 38) then
                PriseService()
            end
        end
    end

end)

function drawnotifcolor(text, color)
    Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end

-- Le contremaitre
-- Blip + npc
Citizen.CreateThread(function()

    local blip = AddBlipForCoord(787.0050, -2975.77441, 5.033)

    SetBlipSprite (blip, 304)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.2)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    --AddTextComponentString("Préparateur de commandes")
    AddTextComponentString("Order preparer")
    EndTextCommandSetBlipName(blip)


    local playerCoords = GetEntityCoords(PlayerPedId())

    while GetDistanceBetweenCoords(playerCoords,787.0050, -2975.77441, 5.033,true) > 200 do
        Citizen.Wait(100)
        playerCoords = GetEntityCoords(PlayerPedId())
    end

    local modelped = -2039072303 
	RequestModel(modelped)
    while not HasModelLoaded(modelped) do
        Wait(1)
    end

    local ped = CreatePed(1, modelped, 787.0050, -2975.77441, 5.033, 87.4387, false, true)
    SetModelAsNoLongerNeeded(modelped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
	
end)


function math.randomchoice(d) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(d) do
        keys[#keys+1] = key --Store keys in another table
    end
    index = keys[math.random(1, #keys)]
    return d[index]
end


-- All credits to TheIndra 
-- A simple modification of Enhanced Forklift Script to make it word with the job
CreateThread(function()
	--AddTextEntry("press_attach_vehicle", "Appuie sur ~INPUT_DROP_AMMO~ pour soulever l'objet")
	AddTextEntry("press_attach_vehicle", "Press ~INPUT_DROP_AMMO~ to lift the pallet")

    while true do
        Wait(0)

        if JobStarted then
            if show then
                DisplayHelpTextThisFrame("press_attach_vehicle")
            end

            -- f10 to attach/detach
            if IsControlJustPressed(0, 57) then
                -- if already attached detach
                if isAttached then
                    DetachEntity(attachedEntity, true, true)
                    
                    attachedEntity = nil
                    isAttached = false
                else	
                    -- get vehicle infront
                    --print ("PaletteActuelle:"..PaletteActuelle)
                    local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
                    local veh = GetClosestVehicle(pos, 2.0, 0, 70)
                    local ped = GetPlayerPed(-1)
                    local coords  = GetEntityCoords(ped)
                    local object = GetClosestObjectOfType(coords, 5.0, PaletteActuelle, false, false, false)
                    
                    -- if vehicle is found
                    if object and IsPedInAnyVehicle(PlayerPedId(), false) then
                        --print ("oui")
                        -- check if player is in forklift
                        local carpalette = GetVehiclePedIsIn(ped, false)
                        local carentity = GetEntityModel(carpalette)
                        local car_name = GetDisplayNameFromVehicleModel(carentity)
                        if car_name == "FORK" then
                            --print ("encore oui")
                            isAttached = true
                            show = false
                            attachedEntity = object
                            
                            -- attach vehicle to forklift, you can change some values
                            AttachEntityToEntity(object, carpalette, 3, 0.0, 1.3, -0.09, 0.0, 0, 90.0, false, false, false, false, 2, true)
                        end
                    end
                end
            end
        end     
    end
end)

CreateThread(function()
	while true do
		-- check every 500ms if helptext should show
        Wait(500)
		if JobStarted then
            local ped = GetPlayerPed(-1)
            local carpalette = GetVehiclePedIsIn(ped, false)
            local carentity = GetEntityModel(carpalette)
            local car_name = GetDisplayNameFromVehicleModel(carentity)
            -- kinda nasty one-liner
            if not isAttached and IsPedInAnyVehicle(ped) and car_name == "FORK"  then
                
                local coords  = GetEntityCoords(ped)
                local object = GetClosestObjectOfType(coords, 5.0, PaletteActuelle, false, false, false)

                if object ~= 0 then 
                    show = true
                end
                
            else 
                show = false
            end
        end
	end
end)