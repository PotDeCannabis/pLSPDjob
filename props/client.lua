Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

object = {}


local PropsLSPD = {
    {label = "Cone", props = "prop_roadcone02a"},
    {label = "Barrière", props = "prop_barrier_work05"},
    {label = "Gros carton", props = "prop_boxpile_07d"},
    {label = "Herse", props = "p_ld_stinger_s"},
}

local open = false 
local mainMenu = RageUI.CreateMenu("LSPD", "Interation")
local lspd = RageUI.CreateSubMenu(mainMenu, "LSPD", "Interation")
local suppr = RageUI.CreateSubMenu(mainMenu, "LSPD", "Interation")
mainMenu.Closed = function()
    open = false 
end

function OpenMenuProps()
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
			RageUI.IsVisible(mainMenu,function() 
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 263, true)


                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
                RageUI.Button("Poser un/des Objet(s)", nil, {RightLabel = "→"}, true, {
                    onSelected = function() 
                    end
                }, lspd)

                RageUI.Button("Supprimer un/plusieurs objet(s)", nil, {RightLabel = "→"}, true, {
                    onSelected = function() 
                    end
                }, suppr)
 
            end
		   	end)

               RageUI.IsVisible(lspd, function()

                    for k,v in pairs(PropsLSPD) do
                        RageUI.Button(v.label, "Appuyer sur ~y~[E] ~s~pour poser les ~y~objets ~s~!", {RightLabel = "→"}, true, {
                            onSelected = function() 
                                SpawnObj(v.props)
                            end
                        })
                    end
               end)

               RageUI.IsVisible(suppr, function()

                    for k,v in pairs(object) do
                        if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
                        RageUI.Button("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {RightLabel = ""}, true, {
                            onActive = function()
                                local entity = NetworkGetEntityFromNetworkId(v)
                                local ObjCoords = GetEntityCoords(entity)
                                DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                            end,
                            onSelected = function() 
                                RemoveObj(v, k)
                            end,
                        })
                    end

                end)

		Wait(0)
		end
		end)
  	end
end

RegisterCommand("props", function()
    OpenMenuProps()
end)