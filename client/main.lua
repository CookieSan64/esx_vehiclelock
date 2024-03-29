
ESX = exports["es_extended"]:getSharedObject()

local isRunningWorkaround = false

function StartWorkaroundTask()
	if isRunningWorkaround then
		return
	end

	local timer = 0
	local playerPed = PlayerPedId()
	isRunningWorkaround = true

	while timer < 100 do
		Citizen.Wait(0)
		timer = timer + 1

		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if lockStatus == 4 then
				ClearPedTasks(playerPed)
			end
		end
	end

	isRunningWorkaround = false
end

function ToggleVehicleLock()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	Citizen.CreateThread(function()
		StartWorkaroundTask()
	end)

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
	end

	if not DoesEntityExist(vehicle) then
		return
	end

	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)
			
			if lockStatus == 1 then -- unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				lockAnimation()
				
				SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 0)
				Citizen.Wait(250)
				StartVehicleHorn (vehicle, 500, "NORMAL", -1)
				PlayVehicleDoorCloseSound(vehicle, 1)
				
				Citizen.Wait(450)
				PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)

				ESX.ShowNotification('Véhicule verrouillé')
				
			elseif lockStatus == 2 then -- locked
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				lockAnimation()
				
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 0)
				Citizen.Wait(250)
				StartVehicleHorn (vehicle, 500, "NORMAL", -1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				
				Citizen.Wait(450)
				PlaySoundFrontend(-1, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', 0)
				
				ESX.ShowNotification('Véhicule déverrouillé')
			end
		end

	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

function lockAnimation()
    local ply = PlayerPedId()
    RequestAnimDict("anim@heists@keycard@")
    while not HasAnimDictLoaded("anim@heists@keycard@") do
        Wait(0)
    end
    TaskPlayAnim(ply, "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(600)
    ClearPedTasks(ply)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 303) and IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(400)
			-- D-pad down on controllers works, too!
		elseif IsControlJustReleased(0, 173) and not IsInputDisabled(0) then
			ToggleVehicleLock()
			Citizen.Wait(400)
		end
	end
end)

