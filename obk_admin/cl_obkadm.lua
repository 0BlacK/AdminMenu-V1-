ESX = nil
local inAnim = false

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end
		Citizen.Wait(0)
	end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

print("^1======================================================================^1")
print("^2[^4Menu admin by^2] ^7: ^2 Oblack#0001^2")
print("^1======================================================================^1")
print("^8======================================================================^8")
print("^5[^5Discord^5] ^1: ^1 https://discord.gg/UfFbWQ7^1")
print("^8======================================================================^8")

function give_bank()
	local amount = KeyboardInput("OBLACK_OBK_AMOUNT", 'Somme', "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('obk-menuobk:Admin_giveBank', amount)
		end
	end
end

-- NOCLIP 
function admin_no_clip()
	noclip = not noclip


	if noclip then
        SetEntityInvincible(plyPed, true)
        SetEntityVisible(plyPed, false, false)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification("Vous avez ~g~activé ~w~le ~o~NoClip") -- voir pq on est auto-freeze quand on active le noclip
	else
        SetEntityInvincible(plyPed, false)
        SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("Vous avez ~r~desactivé ~w~le ~o~NoClip")-- voir pq on est auto-freeze quand on active le noclip
	end
end

function getPosition()
    local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

    return x, y, z
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi/180.0)
    local y = math.cos(heading * math.pi/180.0)
    local z = math.sin(pitch * math.pi/180.0)

    local len = math.sqrt(x * x + y * y + z * z)

    if len ~= 0 then
        x = x/len
        y = y/len
        z = z/len
    end

    return x, y, z
end
-- FIN NOCLIP

function admin_tp_playertome()
	local plyId = KeyboardInput("OBLACK_OBK_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('obk-menuobk:Admin_BringS', plyId, plyPedCoords)
		end
	end
end

function admin_tp_toplayer()
	local plyId = KeyboardInput("OBLACK_OBK_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end

function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification("Mode Fantôme ~g~Activé")
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("Mode Fantôme ~r~Désactivé")
	end
end

function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end

function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification("GodMode ~g~Activé")
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification("GodMode ~r~Désactivé")
	end
end

function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("OBLACK_OBK_VEHICLE_NAME", 'Nom du véhicule', "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end

function admin_give_dirty()
	local amount = KeyboardInput("OBLACK_OBK_AMOUNT", 'Quantité', "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('obk-menuobk:Admin_giveDirtyMoney', amount)
		end
	end
end

function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		ESX.ShowNotification("Téléportation ~g~Effectuée")
	else
		ESX.ShowNotification("Aucun ~r~Marqueur")
	end
end

function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function changer_skin()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function show_coord()
	showcoord = not showcoord
end

function admin_heal_player()
	local plyId = KeyboardInput("OBLACK_OBK_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esxambulancejob:revive', plyId)
		end
	end
end

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

RegisterNetEvent('obk-menuobk:Admin_BringC')
AddEventHandler('obk-menuobk:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

function modo_showname()
	showname = not showname
end

local Admin = {

    Base = {Title = "Administration"},
    Data = {currentMenu = "Menu Staff"},
    Events = {

        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentSlt, result)
        	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            if btn.name == "TP un joueur" then
				admin_tp_playertome()
				ESX.ShowNotification("Vous avez TP un ~g~joueur")
            elseif btn.name == "Se TP sur un joueur" then
				admin_tp_toplayer()
				ESX.ShowNotification("Vous etes tp sur un ~g~joueur")
            elseif btn.name == "Give argent(banque)" then
                give_bank()
            elseif btn.name == "Modifier mon apparence" then
                changer_skin()
                self:CloseMenu(true)
            elseif btn.name == "Afficher Coordonnées" then
				show_coord()
				ESX.ShowNotification("Vous avez activer les ~g~Coordonnées")
            elseif btn.name == "Revive un joueur" then
				admin_heal_player()
				ESX.ShowNotification("Vous avez ~r~revive ~w~un ~g~joueur")
            elseif btn.name == "Sauvegarder mon apparence" then
            elseif btn.name == "TP sur marker" then
                admin_tp_marker()
            elseif btn.name == "Give argent sale" then
                admin_give_dirty()
            elseif btn.name == "Mode invisible" then 
                admin_mode_fantome()
            elseif btn.name == "Mode invincible" then
				admin_godmode()
			elseif btn.name == "Supprimer le véhicule" then
				TriggerEvent('esx:deleteVehicle')
				ESX.ShowNotification("Vous avez supprimez le ~r~Véhicule")
			elseif btn.name == "Affichier les noms" then
				modo_showname()
				ESX.ShowNotification("Vous avez ~p~Afficher ~w~Les noms des ~g~Joueurs")
			elseif btn.name == "NoClip" then
				admin_no_clip() -- voir pq on est auto-freeze quand on active le noclip
            elseif btn.name == "Réparer Véhicule" then
				admin_vehicle_repair()
				ESX.ShowNotification("Vous avez ~r~réparer ~w~votre ~o~Véhicule")
            elseif btn.name == "Faire spawn Véhicule" then
				admin_vehicle_spawn()
				ESX.ShowNotification("Vous avez fais spawn votre ~g~Véhicule")
			elseif btn == "~r~Fermer le Menu" then
				CloseMenu(true) 
			  ESX.ShowNotification("Vous avez ~r~Fermer ~w~le ~g~Menu Admin ~w~!")
            end
        end,
    },

    Menu = {
        ["Menu Staff"] = {
            b = {
				{name = "Interaction Joueur", ask = "→", askX = true},
				{name = "Action Staff", ask = "→", askX = true},
				{name = "Action Divers", ask = "→", askX = true},
				{name = "~r~Fermer le Menu", ask = ">", askX = true},
            }
        },

        ["interaction joueur"] = {
            b = {
                {name = "TP un joueur", askX = true},
                {name = "Se TP sur un joueur", ask = "", askX = true},
                {name = "Revive un joueur", askX = true},
            }
		},
		
		["action staff"] = {
            b = {
				{name = "NoClip", askX = true}, -- voir pq on est auto-freeze quand on active le noclip
                {name = "Mode invisible", ask = "", askX = true},
				{name = "Mode invincible", askX = true},
				{name = "Affichier les noms", askX = true},
				{name = "TP sur marker", askX = true},
				{name = "Réparer Véhicule", askX = true},
				{name = "Faire spawn Véhicule", askX = true},
				{name = "Supprimer le véhicule", askX = true},
            }
		},
		
		["action divers"] = {
            b = {
                {name = "Afficher Coordonnées", askX = true},
                {name = "Give argent(banque)", ask = "", askX = true},
				{name = "Give argent sale", askX = true},
				{name = "Modifier mon apparence", askX = true},
				{name = "Sauvegarder mon apparence", askX = true},
            }
        },


    }
}

--RegisterCommand("obk", function()
    --local text = 'Vous Venez d\'ouvrir le Menu Admin.' 
	--TriggerServerEvent('3dme:shareDisplay', text) 
    --CreateMenu(Admin)
--end)



Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
	   if IsControlJustPressed(0, 311) then
		local text = '~o~Vous ~w~venez ~g~d\'ouvrir ~w~le ~r~menu admin ~g~V~w~.~g~1~w~.~g~2' 
		TriggerServerEvent('3dme:shareDisplay', text) 
            CreateMenu(Admin)
        end
    end
end)