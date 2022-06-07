TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'lspd', 'alerte police', true, true)

TriggerEvent('esx_society:registerSociety', 'lspd', 'lspd', 'society_lspd', 'society_lspd', 'society_lspd', {type = 'public'})


-- Coffre

ESX.RegisterServerCallback('pLSPDjob:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end

	cb(all_items)

	
end)


ESX.RegisterServerCallback('pLSPDjob:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('pLSPDjob:putStockItems')
AddEventHandler('pLSPDjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer ~y~"..itemName.."~s~ au nombre de ~y~"..count.."~s~.")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez pas cette quantité.")
		end
	end)
end)

RegisterServerEvent('pLSPDjob:takeStockItems')
AddEventHandler('pLSPDjob:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer ~y~"..itemName.."~s~ au nombre de ~y~"..count.."~s~.")
	end)
end)




-- Boss

RegisterServerEvent('pLSPDjob:withdrawMoney')
AddEventHandler('pLSPDjob:withdrawMoney', function(society, amount, money_soc)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if account.money >= tonumber(amount) then
		  xPlayer.addMoney(amount)
		  account.removeMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "Vous avez retirer~g~ "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "~rL'entreprise n'as pas asser d'argent.")
	  end
	end)
	  
  end)

RegisterServerEvent('pLSPDjob:depositMoney')
AddEventHandler('pLSPDjob:depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if money >= tonumber(amount) then
		  xPlayer.removeMoney(amount)
		  account.addMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "Vous avez déposer~r~ "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "~rVous n'avez pas asser d'argent.")
	  end
	end)
	
end)

ESX.RegisterServerCallback('pLSPDjob:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

-- Renfort

RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lspd' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- FOUILLE ----
-----------------

RegisterNetEvent('pLSPDjob:confiscatePlayerItem')
AddEventHandler('pLSPDjob:confiscatePlayerItem', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		
			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem(itemName, amount)
            TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~y~"..amount..' '..sourceItem.label.."~s~.")
            TriggerClientEvent("esx:showNotification", target, "L'agent vous a confisqué ~y~"..amount..' '..sourceItem.label.."~s~.")
        else
			--TriggerClientEvent("esx:showNotification", source, "~r~quantité invalide")
		end
        
    if itemType == 'item_account' then
        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney   (itemName, amount)
        
        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~y~"..amount.."$ ~s~Argent sale~s~.")
        TriggerClientEvent("esx:showNotification", target, "L'agent vous a confisqué ~y~"..amount.."$ ~s~Argent sale~s~.")
        
    elseif itemType == 'item_weapon' then
        if amount == nil then amount = 0 end
        targetXPlayer.removeWeapon(itemName, amount)
        sourceXPlayer.addWeapon   (itemName, amount)

        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~y~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~y~"..amount.."~s~ munitions.")
        TriggerClientEvent("esx:showNotification", target, "L'agent vous a confisqué ~y~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~y~"..amount.."~s~ munitions.")
    end
end)


ESX.RegisterServerCallback('pLSPDjob:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", target, "~r~Tu es fouillé...")

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }

        cb(data)
    end
end)

--- Addon Citoyen

RegisterServerEvent('pLSPDjob:handcuff')
AddEventHandler('pLSPDjob:handcuff', function(target)
  TriggerClientEvent('pLSPDjob:handcuff', target)
end)

RegisterServerEvent('pLSPDjob:drag')
AddEventHandler('pLSPDjob:drag', function(target)
  local _source = source
  TriggerClientEvent('pLSPDjob:drag', target, _source)
end)

RegisterServerEvent('pLSPDjob:putInVehicle')
AddEventHandler('pLSPDjob:putInVehicle', function(target)
  TriggerClientEvent('pLSPDjob:putInVehicle', target)
end)

RegisterServerEvent('pLSPDjob:OutVehicle')
AddEventHandler('pLSPDjob:OutVehicle', function(target)
    TriggerClientEvent('pLSPDjob:OutVehicle', target)
end)

-- Ppa

RegisterNetEvent('donner:ppa')
AddEventHandler('donner:ppa', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2500
    local xMoney = xPlayer.getMoney()
	local societyAccount

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_lspd', function(account)
        societyAccount = account
	end)


            if price < societyAccount.money then

					societyAccount.removeMoney(price)

    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez assez ~r~d\'argent dans votre société")
end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- FOUILLE ----
-----------------

ESX.RegisterServerCallback('pLSPDjob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent("esx:showAdvancedNotification", target, "Vous êtes en train de vous faire fouiller.", 5000, "danger")

	if xPlayer then
		local data = {
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		cb(data)
	end
end)


RegisterNetEvent('pLSPDjob:confiscatePlayerItem')
AddEventHandler('pLSPDjob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then

			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem(itemName, amount)
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon(itemName, amount)

	end
	--TriggerEvent('Logger:SendToDiscordIfPossible', 'police-confiscate', false, 0, GetPlayerName(source), itemName, amount, GetPlayerName(target));

end)


-- Aarmurerie

RegisterNetEvent('pLSPDjob:pistolet')
AddEventHandler('pLSPDjob:pistolet', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

	xPlayer.addWeapon('weapon_pistol', 42)
	TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~y~Pistolet ~s~!")
end)

RegisterNetEvent('pLSPDjob:tazer')
AddEventHandler('pLSPDjob:tazer', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

	xPlayer.addWeapon('weapon_stungun', 42)
	TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~y~Tazer ~s~!")
end)

RegisterNetEvent('pLSPDjob:matraque')
AddEventHandler('pLSPDjob:matraque', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

	xPlayer.addWeapon('weapon_nightstick', 42)
	TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~y~Matraque ~s~!")
end)

RegisterNetEvent('pLSPDjob:carabinedassaut')
AddEventHandler('pLSPDjob:carabinedassaut', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

	xPlayer.addWeapon('weapon_carbinerifle', 42)
	TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~y~Carabine d'assaut ~s~!")
end)

-- Plaque

ESX.RegisterServerCallback('pLSPDjob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

-- Amende

RegisterNetEvent("pLSPDjob:SendFacture")
AddEventHandler("pLSPDjob:SendFacture", function(target, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'lspd' then
		TriggerEvent("AC:Violations", 24, "Event: pLSPDjob:SendFacture job: "..xPlayer.job.name, source)
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_lspd', function(account)
        if account ~= nil then
			societyAccount = account
			local xPlayer = ESX.GetPlayerFromId(target)
			xPlayer.removeAccountMoney('bank', price)
			societyAccount.addMoney(price)
			TriggerClientEvent("esx:showNotification", target, "Votre compte en banque à été réduit de ~y~"..price.."$~s~.", 5000, "danger")
			TriggerClientEvent("esx:showNotification", source, "Vous avez donné une amende de ~y~"..price.."~s~$", 5000, "danger")
		end
	end)
end)

-- Alerte

RegisterServerEvent('pLSPDjob:alert')
AddEventHandler('pLSPDjob:alert', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lspd' then
			TriggerClientEvent('pLSPDjob:InfoService', xPlayers[i], _raison, name)
		end
	end
end)