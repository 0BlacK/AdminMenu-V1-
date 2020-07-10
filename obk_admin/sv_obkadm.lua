ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("obk-menuobk:Admin_BringS")
AddEventHandler("obk-menuobk:Admin_BringS", function(plyId, plyPedCoords)
	TriggerClientEvent('obk-menuobk:Admin_BringC', plyId, plyPedCoords)
end)

RegisterServerEvent("obk-menuobk:Admin_giveBank")
AddEventHandler("obk-menuobk:Admin_giveBank", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('bank', total)

	local item = '$ ~s~en banque'
	local message = 'Give de ~g~'
	TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
	TriggerEvent("esx:admingivemoneyalert",xPlayer.name,total)
end)

RegisterServerEvent("obk-menuobk:Admin_giveDirtyMoney")
AddEventHandler("obk-menuobk:Admin_giveDirtyMoney", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('black_money', total)

	local item = '$ ~s~sale.'
	local message = 'Give de ~r~'
	TriggerClientEvent('esx:showNotification', _source, message..total..item)
	TriggerEvent("esx:admingivemoneyalert",xPlayer.name,total)
end)