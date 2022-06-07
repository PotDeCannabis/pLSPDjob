ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

    ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

-- Armurerie

local open = false 
local mainMenu6 = RageUI.CreateMenu('Armurerie', 'Actions armurerie')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  FreezeEntityPosition(PlayerPedId(), false)
  open = false
end

function OpenArmuriePolice()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 
              
                RageUI.Separator("↓ ~y~ Votre casier ~s~↓")

                RageUI.Button("Déposer vos armes", nil, {RightLabel = "→"}, true , {
                onSelected = function() 
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ESX.ShowNotification("Vous avez ~y~déposé ~s~vos ~y~armes ~s~dans votre casier !")
                end
                })
            
                RageUI.Button("Prendre un Pistolet", nil, {RightLabel = "→"}, true , {
                onSelected = function() 
                    TriggerServerEvent('pLSPDjob:pistolet')
                end
                })

                RageUI.Button("Prendre un Tazer", nil, {RightLabel = "→"}, true , {
                onSelected = function() 
                    TriggerServerEvent('pLSPDjob:tazer')
                end
                })

                RageUI.Button("Prendre une Carabine d'assaut", nil, {RightLabel = "→"}, true , {
                onSelected = function() 
                    TriggerServerEvent('pLSPDjob:carabinedassaut')
                end
                })

                RageUI.Button("Prendre une Matraque", nil, {RightLabel = "→"}, true , {
                onSelected = function() 
                    TriggerServerEvent('pLSPDjob:matraque')
                end
                })

                end)
                Wait(0)
               end
            end)
         end
      end

Citizen.CreateThread(function()
    while true do
      local wait = 750
        for k in pairs(Config.Position.Armurerie) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 
            local pos = Config.Position.Armurerie
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
            if dist <= 5.0 then
            wait = 0
            DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~y~[E]~s~ pour accèder à ~y~l'armurerie ~s~!", 1) 
                if IsControlJustPressed(1,51) then
                  OpenArmuriePolice()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)

Citizen.CreateThread(function()
  local hash = GetHashKey("mp_m_securoguard_01")
  while not HasModelLoaded(hash) do
  RequestModel(hash)
  Wait(20)
  end
  ped = CreatePed("PED_TYPE_CIVMALE", "mp_m_securoguard_01",480.40377, -996.63244, 29.689, 87.9034, false, true) 
  SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- Patron

societypolice = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

    ESX.PlayerData = ESX.GetPlayerData()

    end
end)

local open = false 
local mainMenu = RageUI.CreateMenu('Patron', 'Actions Patron')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  open = false
end

function BossPolice()
  if open then 
    open = false
    RageUI.Visible(mainMenu, false)
    return
  else
    open = true 
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
    RefreshMoney()
    while open do 
       RageUI.IsVisible(mainMenu,function() 
            
            if societylspd ~= nil then
                RageUI.Button('Argent société:', nil, {RightLabel = "~g~"..societylspd.."$"}, true, {onSelected = function()end});   
            end

            RageUI.Button('Déposer de l\'argent.', nil, {RightLabel = "→"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous déposer ?', '', 10)
                TriggerServerEvent("pLSPDjob:depositMoney","society_lspd" ,money)
                RefreshMoney()
                RefreshMoney()
            end});  

            RageUI.Button('Retirer de l\'argent.', nil, {RightLabel = "→"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer ?', '', 10)
                TriggerServerEvent("pLSPDjob:withdrawMoney","society_lspd" ,money)
                RefreshMoney()
                RefreshMoney()
            end});   

       end)
     Wait(0)
    end
   end)
  end
end

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('pEMSjob:getSocietyMoney', function(money)
            societylspd = money
        end, "society_lspd")
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

Citizen.CreateThread(function()
    while true do
        local wait = 750
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
            for k in pairs(Config.Position.Boss) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Position.Boss
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
                if dist <= 5.0 then
                    wait = 0
                    DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
                end
                if dist <= 1.0 then
                    wait = 0
                    Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour pour accèder au ~y~actions patron ~s~!", 1)
                    if IsControlJustPressed(1,51) then
                        BossPolice()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- Coffre

local PlayerInventory, GangInventoryItem, GangInventoryWeapon, PlayerWeapon = {}, {}, {}, {}
local mainMenu = RageUI.CreateMenu("Coffre", "Coffre entreprise")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"Coffre", "Coffre entreprise")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"Coffre", "Coffre entreprise")
local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
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

    
function ChestPolice() 
    if open then 
    open = false
    RageUI.Visible(mainMenu, false)
    return
  else
    open = true 
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
    while open do 
        RageUI.IsVisible(mainMenu, function()

            RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getInventory()
            end},PutMenu);
            
            RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getStock()
            end},GetMenu);

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en prendre ?",nil,4)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("pLSPDjob:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'avez pas cette quantité.")
                    end
                    getStock()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer ?",nil,4)
                    count = tonumber(count)
                    TriggerServerEvent("pLSPDjob:putStockItems",v.item, count)
                    getInventory()
                end});
            end
            

       end)


        Wait(0)
    end
 end)
 end
 end


function getInventory()
    ESX.TriggerServerCallback('pLSPDjob:playerinventory', function(inventory)                     
        all_items = inventory
    end)
end

function getStock()
    ESX.TriggerServerCallback('pLSPDjob:getStockItems', function(inventory)                 
        all_items = inventory
    end)
end


Citizen.CreateThread(function()
    while true do
    local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
        for k in pairs(Config.Position.Coffre) do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local pos = Config.Position.Coffre
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
        if dist <= 5.0 then
          wait = 0
          DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
        end
        if dist <= 2.0 then
          wait = 0
          Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~coffre ~s~!", 1)
          if IsControlJustPressed(1,51) then
            ChestPolice()
          end
        end
      end
    end
    Citizen.Wait(wait)
    end
end)

-- Garage Véhicule

local open = false 
local mainMenu6 = RageUI.CreateMenu('Garage', 'Garage entreprise')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenuGaragePolice()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 

              RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 4 then
                      DeleteEntity(veh)
                      RageUI.CloseAll()
                  end
                 end
             })

              RageUI.Separator("↓ ~y~Véhicules de serice ~s~↓")

                for k,v in pairs(Config.VehiculeLSPD) do
                RageUI.Button(v.buttoname, nil, {RightLabel = "→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                        ESX.ShowNotification("La sortie du garage est bloquer.")
                        else
                        local model = GetHashKey(v.spawnname)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local lspdveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                        SetVehicleNumberPlateText(lspdveh, "lspd"..math.random(50, 999))
                        SetVehicleFixed(lspdveh)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  lspdveh,  -1)
                        SetVehRadioStation(lspdveh, 0)
                        RageUI.CloseAll()
                        end
                    end
                })


              end
            end)
          Wait(0)
         end
      end)
   end
end

Citizen.CreateThread(function()
  while true do 
      local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
          for k in pairs(Config.Position.GarageVehicule) do 
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = Config.Position.GarageVehicule
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= 5.0 then 
                  wait = 0
                  DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
              end

              if dist <= 2.0 then 
                  wait = 0
                  Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~garage ~s~!", 1)
                  if IsControlJustPressed(1,51) then
                    OpenMenuGaragePolice()
                  end
              end
          end
      end
  Citizen.Wait(wait)
  end
end)

-- Garage Helicoptère

local open = false 
local mainMenu6 = RageUI.CreateMenu('Garage', 'Garage entreprise')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenuGarageHeliPolice()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 
              RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 4 then
                      DeleteEntity(veh)
                      RageUI.CloseAll()
                  end
                    end
                  })
              RageUI.Separator("↓ ~y~Véhicules de serice ~s~↓")
                for k,v in pairs(Config.HelicoLSPD) do
                RageUI.Button(v.buttonameheli, nil, {RightLabel = "→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzoneheli.x, v.spawnzoneheli.y, v.spawnzoneheli.z), 10.0) then
                        ESX.ShowNotification("La sortie du garage est bloquer.")
                        else
                        local model = GetHashKey(v.spawnnameheli)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local lspdheli = CreateVehicle(model, v.spawnzoneheli.x, v.spawnzoneheli.y, v.spawnzoneheli.z, v.headingspawnheli, true, false)
                        SetVehicleNumberPlateText(lspdheli, "lspd"..math.random(50, 999))
                        SetVehicleFixed(lspdheli)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  lspdheli,  -1)
                        SetVehRadioStation(lspdheli, 0)
                        RageUI.CloseAll()
                        end
                    end
                })
              end
            end)
          Wait(0)
         end
      end)
   end
end


Citizen.CreateThread(function()
  while true do 
      local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
          for k in pairs(Config.Position.GarageHeli) do 
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = Config.Position.GarageHeli
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
              if dist <= 5.0 then 
                  wait = 0
                  DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
              end
              if dist <= 2.0 then 
                  wait = 0
                  Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~garage ~s~!", 1)
                  if IsControlJustPressed(1,51) then
                    OpenMenuGarageHeliPolice()
                  end
              end
          end
      end
  Citizen.Wait(wait)
  end
end)

-- Menu

local Items = {}      
local Armes = {}    
local ArgentSale = {} 
local PlayerData = {}

local function MarquerJoueur()
    local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local pos = GetEntityCoords(ped)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <= 4.0 then
        DrawMarker(6, pos.x, pos.y, pos.z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
    end
end

local function getPlayerInv(player)
  Items = {}
  Armes = {}
  ArgentSale = {}
  
  ESX.TriggerServerCallback('pLSPDjob:getOtherPlayerData', function(data)
    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
        table.insert(ArgentSale, {
          label    = ESX.Math.Round(data.accounts[i].money),
          value    = 'black_money',
          itemType = 'item_account',
          amount   = data.accounts[i].money
        })
        break
      end
    end
  
    for i=1, #data.weapons, 1 do
      table.insert(Armes, {
        label    = ESX.GetWeaponLabel(data.weapons[i].name),
        value    = data.weapons[i].name,
        right    = data.weapons[i].ammo,
        itemType = 'item_weapon',
        amount   = data.weapons[i].ammo
      })
    end
  
    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(Items, {
          label    = data.inventory[i].label,
          right    = data.inventory[i].count,
          value    = data.inventory[i].name,
          itemType = 'item_standard',
          amount   = data.inventory[i].count
        })
      end
    end
  end, GetPlayerServerId(player))
end

local open = false 
local mainMenu8 = RageUI.CreateMenu('LSPD', 'Interaction')
local subMenu8 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu9 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu10 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu11 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu12 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu13 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu14 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
local subMenu16 = RageUI.CreateSubMenu(mainMenu8, "LSPD", "Interaction")
mainMenu8.Display.Header = true 
mainMenu8.Closed = function()
  open = false
end

function OpenMenuPolice()
  if open then 
    open = false
    RageUI.Visible(mainMenu8, false)
    return
  else
    open = true 
    RageUI.Visible(mainMenu8, true)
    CreateThread(function()
    while open do 
       RageUI.IsVisible(mainMenu8,function()
      RageUI.Checkbox("Prendre son service", nil, servicepolice, {}, {
                onChecked = function(index, items)
                    servicepolice = true
                    local info = 'prise'
                    ESX.ShowNotification("~g~Vous avez pris votre service !")
                end,
                onUnChecked = function(index, items)
                    servicepolice = false
                    local info = 'fin'
                    ESX.ShowNotification("~r~Vous avez fini votre service !")
                end
            })
      if servicepolice then

        RageUI.Separator('↓ ~y~Intération ~s~↓')

        RageUI.Button("Gerés les license", nil, {RightLabel = "→"}, true , {
          onSelected = function()
          end
         }, subMenu16)

        RageUI.Button("Intéraction Personnel", nil, {RightLabel = "→"}, true , {
          onSelected = function()
          end
        }, subMenu12)

        RageUI.Button("Intéraction sur un Citoyen", nil, {RightLabel = "→"}, true , {
          onSelected = function()
          end
        }, subMenu10)

        RageUI.Button("Intéraction sur un Véhicule", nil, {RightLabel = "→"}, true , {
          onSelected = function()
          end
        }, subMenu11)

      end
      end)

      RageUI.IsVisible(subMenu8,function() 
        RageUI.Button("Petite demande", nil, {RightLabel = "→"}, not codesCooldown1 , {
          onSelected = function()
            codesCooldown1 = true 
            local raison = 'petit'
            local elements  = {}
            local playerPed = PlayerPedId()
            local coords  = GetEntityCoords(playerPed)
            local name = GetPlayerName(PlayerId())
          TriggerServerEvent('renfort', coords, raison)
          Citizen.SetTimeout(10000, function() codesCooldown1 = false end)
        end
      })
    
      RageUI.Button("Moyenne demande", nil, {RightLabel = "→"}, not codesCooldown2 , {
        onSelected = function()
          codesCooldown2 = true 
          local raison = 'importante'
          local elements  = {}
          local playerPed = PlayerPedId()
          local coords  = GetEntityCoords(playerPed)
          local name = GetPlayerName(PlayerId())
        TriggerServerEvent('renfort', coords, raison)
        Citizen.SetTimeout(10000, function() codesCooldown2 = false end)
      end
    })
    
    RageUI.Button("Grosse demande", nil, {RightLabel = "→"}, not codesCooldown3 , {
      onSelected = function()
        codesCooldown3 = true 
        local raison = 'omgad'
        local elements  = {}
        local playerPed = PlayerPedId()
        local coords  = GetEntityCoords(playerPed)
        local name = GetPlayerName(PlayerId())
      TriggerServerEvent('renfort', coords, raison)
      Citizen.SetTimeout(10000, function() codesCooldown3 = false end)
    end
  })
       end)
       RageUI.IsVisible(subMenu9,function() 

      RageUI.Button("Pause de service", nil, {RightLabel = "→"}, not codesCooldown4 , {
        onSelected = function()
          codesCooldown4 = true 
          local info = 'pause'
          TriggerServerEvent('pLSPDjob:alert', info)
          Citizen.SetTimeout(10000, function() codesCooldown4 = false end)
          end
  })
      RageUI.Button("Standby", nil, {RightLabel = "→"}, not codesCooldown5 , {
        onSelected = function()
          codesCooldown5 = true 
          local info = 'standby'
          TriggerServerEvent('pLSPDjob:alert', info)
          Citizen.SetTimeout(10000, function() codesCooldown5 = false end)
          end
  })
      RageUI.Button("Control en cours", nil, {RightLabel = "→"}, not codesCooldown6 , {
        onSelected = function()
          codesCooldown6 = true 
          local info = 'control'
          TriggerServerEvent('pLSPDjob:alert', info)
          Citizen.SetTimeout(10000, function() codesCooldown6 = false end)
          end
  })
      RageUI.Button("Refus d'obtempérer", nil, {RightLabel = "→"}, not codesCooldown7 , {
        onSelected = function()
          codesCooldown7 = true 
          local info = 'refus'
          TriggerServerEvent('pLSPDjob:alert', info)
          Citizen.SetTimeout(10000, function() codesCooldown7 = false end)
          end
  })
      RageUI.Button("Crime en cours", nil, {RightLabel = "→"}, not codesCooldown8 , {
        onSelected = function()
          codesCooldown8 = true 
          local info = 'crime'
          TriggerServerEvent('pLSPDjob:alert', info)
          Citizen.SetTimeout(10000, function() codesCooldown8 = false end)
          end
  })

end)

    RageUI.IsVisible(subMenu10,function() 

    RageUI.Separator("↓ ~y~Citoyen ~s~↓")

    RageUI.Button("Amender une Personne", nil, {RightLabel = "→"}, true , {
      onSelected = function()
      end
    }, subMenu14)

      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

      if closestDistance <= 3.0 then 
        RageUI.Button("Fouiller", nil, {RightLabel = "→"}, true, {
          onActive = function()
            if closestPlayer ~= -1 then
              MarquerJoueur()
            end
          end,
          onSelected = function() 
            if closestDistance <= 5.0 then 
              getPlayerInv(closestPlayer)
              ExecuteCommand("me fouille l'autre l'individu") 
            end
          end,
        }, subMenu13)
      else
        RageUI.Button("Fouiller", "~r~Aucune personne à proximité.", {RightLabel = ">"}, false, {
          onSelected = function() 
          end
        })
      end

      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      RageUI.Button("Menotter/démenotter", nil, {RightLabel = "→"}, true, {
        onSelected = function() 
          if closestDistance <= 5.0 then 
            TriggerServerEvent('pLSPDjob:handcuff', GetPlayerServerId(closestPlayer))
          else
            ESX.ShowNotification('~r~Aucune personne à proximité.')
        end
      end
    })


  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  RageUI.Button("Escorter", nil, {RightLabel = "→"}, true, {
    onSelected = function() 
      if closestDistance <= 5.0 then 
      TriggerServerEvent('pLSPDjob:drag', GetPlayerServerId(closestPlayer))
    else
      ESX.ShowNotification('~r~Aucune personne à proximité.')
    end
  end
})

      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      RageUI.Button("Mettre dans un véhicule", nil, {RightLabel = "→"}, true, {
         onSelected = function() 
    if closestDistance <= 5.0 then 
    TriggerServerEvent('pLSPDjob:putInVehicle', GetPlayerServerId(closestPlayer))
  else
    ESX.ShowNotification('~r~Aucune personne à proximité.')
  end
end
})

      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      RageUI.Button("Sortir du véhicule", nil, {RightLabel = "→"}, true, {
       onSelected = function() 
     if closestDistance <= 5.0 then 
     TriggerServerEvent('pLSPDjob:OutVehicle', GetPlayerServerId(closestPlayer))
   else
     ESX.ShowNotification('~r~Aucune personne à proximité.')
   end
  end
  })

end)

RageUI.IsVisible(subMenu11,function() 

    RageUI.Separator("↓ ~y~Véhicules ~s~↓")

  RageUI.Button("Rechercher une plaque", nil, {RightLabel = "→"}, true , {
    onSelected = function()
      local numplaque = KeyboardInput("Combien ?", "", 10)
      local length = string.len(numplaque)
      if not numplaque or length < 2 or length > 8 then
        ESX.ShowNotification("Ce n'est ~r~pas~s~ un numéro enregistrement dans les fichier de police")
      else
        Rechercherplaquevoiture(numplaque)
        RageUI.CloseAll()
      end
    end,})

  RageUI.Button("Mettre le véhicule en fourriere", nil, {RightLabel = "→"}, true , {
    onSelected = function()
      local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
      local playerPed = PlayerPedId()
      if dist4 < 5 then
        TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Citizen.Wait(7500)
        DeleteEntity(veh)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification("Le ~y~véhicule ~s~a été mis en ~y~fourrière ~s~!")
      end
    end,})

  RageUI.Button("Ouvrir le véhicule de force", nil, {RightLabel = "→"}, true , {
    onSelected = function()
      local playerPed = PlayerPedId()
      local vehicle = ESX.Game.GetVehicleInDirection()
      local coords = GetEntityCoords(playerPed)

      if IsPedSittingInAnyVehicle(playerPed) then
        ESX.ShowNotification('Action impossible')
        return
      end

      if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
        Citizen.CreateThread(function()
          Citizen.Wait(10000)
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
          ClearPedTasksImmediately(playerPed)

          ESX.ShowNotification('Véhicule dévérouiller')
          isBusy = false
        end)
      else
        ESX.ShowNotification('Pas de véhicules à proximité')
      end
  end,})

    end)

  RageUI.IsVisible(subMenu12, function()

    RageUI.Separator("↓ ~y~Personnel ~s~↓")

    RageUI.Button("Intéraction objets", nil , {RightLabel = "→"}, true , {
      onSelected = function()
        ExecuteCommand("props")
      RageUI.CloseAll()
    end
    })

    RageUI.Button("Envoyer une demande de renfort", nil , {RightLabel = "→"}, true , {
      onSelected = function()
      end
    }, subMenu8)

    RageUI.Button("Envoyer un code radio", nil , {RightLabel = "→"}, true , {
      onSelected = function()
      end
    }, subMenu9)

    RageUI.Checkbox("Sortir/Rentrer un Bouclier", nil, bouclier, {}, {
       onChecked = function(index, items)
            bouclier = true
            EnableShield()
        end,
        onUnChecked = function(index, items)
            bouclier = false
            DisableShield()
        end
    })


  end)
      RageUI.IsVisible(subMenu13,function()

      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
      RageUI.Separator("↓ ~y~Argent(s) sale(s) ~s~↓")
      for k,v  in pairs(ArgentSale) do
        RageUI.Button("Argent sale :", nil, {RightLabel = "~g~"..v.label.."$"}, true, {
          onSelected = function() 
            local combien = KeyboardInput("Combien ?",nil,8)
            if tonumber(combien) > v.amount then
              RageUI.Popup({message = "~r~Quantité invalide.."})
            else
              TriggerServerEvent('pLSPDjob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
            end
            RageUI.GoBack()
          end
        })
      end
  
      RageUI.Separator("↓ ~y~Objet(s) ~s~↓")
      for k,v  in pairs(Items) do
        RageUI.Button(v.label, nil, {RightLabel = "~y~x"..v.right}, true, {
          onSelected = function() 
            local combien = KeyboardInput("Combien ?",nil,8)
            if tonumber(combien) > v.amount then
              RageUI.Popup({message = "~r~Quantité invalide."})
            else
              TriggerServerEvent('pLSPDjob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
            end
            RageUI.GoBack()
          end
        })
      end

      RageUI.Separator("↓ ~y~Arme(s) ~s~↓")

      for k,v  in pairs(Armes) do
        RageUI.Button(v.label, nil, {RightLabel = "~y~"..v.right.. " ~s~munitions"}, true, {
          onSelected = function() 
            local combien = KeyboardInput("Combien ?",nil,8)
            if tonumber(combien) > v.amount then
              RageUI.Popup({message = "~r~Quantité invalide."})
            else
              TriggerServerEvent('pLSPDjob:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
            end
            RageUI.GoBack()
          end
        })
      end
  
      end)

      RageUI.IsVisible(subMenu14,function()

        RageUI.Button("Amende personnalisé", nil , {RightLabel = "→"}, true , {
         onSelected = function()
            amount = KeyboardInput("Quel est le montant de l'amende ?",nil,5)
            amount = tonumber(amount)
            local player, distance = ESX.Game.GetClosestPlayer()
    
            if player ~= -1 and distance <= 3.0 then
            
            if amount == nil then
                ESX.ShowNotification("~r~Montant invalide")
            else
                local playerPed = GetPlayerPed(-1)
                Citizen.Wait(5)
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_lspd', ('LSPD'), amount)
                Citizen.Wait(1)
                ESX.ShowNotification("~g~Vous avez bien envoyer l'amende.")
            end
            
            else
            ESX.ShowNotification("~r~Aucune personne à proximité.")
            end
        end
        });

        for k,v in pairs(Config.amende) do
        for _,i in pairs(v) do
        RageUI.Button(i.label, nil, {RightLabel = "~g~"..i.price.."$"}, true , {
          onSelected = function() 
            local player, distance = ESX.Game.GetClosestPlayer()
            local sID = GetPlayerServerId(player)

            if player ~= -1 and distance <= 3.0 then
              TriggerServerEvent("pLSPDjob:SendFacture", sID, i.price)
              RageUI.CloseAll()
              open = false
            else
              TriggerEvent("esx:showNotification", "~r~Aucune personne à proximité.", 3000, "warning") 
            end
          end
        })

      end
      end
      end)

      RageUI.IsVisible(subMenu16, function()

        RageUI.Separator("↓ ~y~Licenses ~s~↓")

  RageUI.Button('Saisir le permis de conduire (Voiture)', nil, {RightLabel = "→"}, true , {
    onHovered = function()
      DisplayClosetPlayer()
    end,
    onSelected = function()
      local player, dst = GetClosestPlayer()
      if dst ~= nil and dst < 2 then
        local sID = GetPlayerServerId(player)
        TriggerServerEvent("esx_license:removeLicense", sID, "drive")
        ESX.ShowNotification("Vous avez retiré le permis de la personne.")
      end
    end,
  })

  RageUI.Button('Saisir le permis de conduire (Poids lourd)', nil, {RightLabel = "→"}, true , {
    onHovered = function()
      DisplayClosetPlayer()
    end,
    onSelected = function()
      local player, dst = GetClosestPlayer()
      if dst ~= nil and dst < 2 then
        local sID = GetPlayerServerId(player)
        TriggerServerEvent("esx_license:removeLicense", sID, "drive_truck")
        ESX.ShowNotification("Vous avez retiré le permis de la personne.")
      end
    end,
  })

  RageUI.Button('Saisir le permis de conduire (Moto)', nil, {RightLabel = "→"}, true , {
    onHovered = function()
      DisplayClosetPlayer()
    end,
    onSelected = function()
      local player, dst = GetClosestPlayer()
      if dst ~= nil and dst < 2 then
        local sID = GetPlayerServerId(player)
        TriggerServerEvent("esx_license:removeLicense", sID, "drive_bike")
        ESX.ShowNotification("Vous avez retiré le permis de la personne.")
      end
    end,
  })

  RageUI.Button("Donner le permis de port d'armes", nil, {RightLabel = "→"}, true , {
    onSelected = function()
      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
        ESX.ShowNotification('~g~Vous avez attribué le permis de port d\'armes à la personne.')
      else
        ESX.ShowNotification('~r~Aucune personne à proximité.')
      end
    end
    })

    RageUI.Button('Saisir le permis de port d\'armes', nil, {RightLabel = "→"}, true , {
      onHovered = function()
        DisplayClosetPlayer()
      end,
      onSelected = function()
        local player, dst = GetClosestPlayer()
        if dst ~= nil and dst < 2 then
          local sID = GetPlayerServerId(player)
          TriggerServerEvent("esx_license:removeLicense", sID, "weapon")
          ESX.ShowNotification("~r~Vous avez retiré le permis de port d\'armes à la personne.")
        end
      end,
    })

      
      
      end)

     Wait(0)
    end
   end)
  end
end

Keys.Register('F6', 'yrz', 'Ouvrir le menu yrz', function()
  if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
    OpenMenuPolice()
  end
end)

RegisterNetEvent('pLSPDjob:InfoService')
AddEventHandler('pLSPDjob:InfoService', function(service, nom)
  if service == 'prise' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Prise de service', 'Agent: '..nom..'\n~w~Code: 10-8\n~w~Information: ~g~Prise de service.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'fin' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Fin de service', 'Agent: '..nom..'\n~w~Code: 10-10\n~w~Information: ~r~Fin de service.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'pause' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Pause de service', 'Agent: '..nom..'\n~w~Code: 10-6\n~w~Information: ~o~Pause de service.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'standby' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Mise en standby', 'Agent: '..nom..'\n~w~Code: 10-12\n~w~Information: Standby, en attente de dispatch.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'control' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Control routier', 'Agent: '..nom..'\n~w~Code: 10-48\n~w~Information: Control routier en cours.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'refus' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Refus d\'obtemperer', 'Agent: '..nom..'\n~w~Code: 10-30\n~w~Information: Refus d\'obtemperer / Delit de fuite en cours.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  elseif service == 'crime' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Crime en cours', 'Agent: '..nom..'\n~w~Code: 10-31\n~w~Information: Crime en cours / poursuite en cours.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
  end
end)

RegisterNetEvent('renfort:setBlip')
AddEventHandler('renfort:setBlip', function(coords, raison)
  if raison == 'petit' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Demande de renfort', 'Demande de renfort demandé.\nRéponse: CODE-2\n~w~Importance: Légère.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    color = 2
  elseif raison == 'importante' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Demande de renfort', 'Demande de renfort demandé.\nRéponse: CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    color = 47
  elseif raison == 'omgad' then
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
    ESX.ShowAdvancedNotification('LSPD INFORMATIONS', 'Demande de renfort', 'Demande de renfort demandé.\nRéponse: CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_ABIGAIL', 8)
    Wait(1000)
    PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
    color = 1
  end
  local blipId = AddBlipForCoord(coords)
  SetBlipSprite(blipId, 161)
  SetBlipScale(blipId, 1.2)
  SetBlipColour(blipId, color)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Demande renfort')
  EndTextCommandSetBlipName(blipId)
  Wait(80 * 1000)
  RemoveBlip(blipId)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
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

RegisterNetEvent('pLSPDjob:handcuff')
AddEventHandler('pLSPDjob:handcuff', function()
  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)
  Citizen.CreateThread(function()
    if IsHandcuffed then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end
      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      DisableControlAction(2, 37, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
      DisableControlAction(0, 24, true)
      DisableControlAction(0, 257, true)
      DisableControlAction(0, 25, true)
      DisableControlAction(0, 263, true)
      DisableControlAction(0, 37, true)
      DisableControlAction(0, 47, true)
    else
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
    end
  end)
end)

RegisterNetEvent('pLSPDjob:putInVehicle')
AddEventHandler('pLSPDjob:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)


RegisterNetEvent("pLSPDjob:OutVehicle")
AddEventHandler("pLSPDjob:OutVehicle", function()
    TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
end)


local EnTrainEscorter = false
local PolicierEscorte = nil
RegisterNetEvent("pLSPDjob:drag")
AddEventHandler("pLSPDjob:drag", function(player)
    EnTrainEscorter = not EnTrainEscorter
    print(EnTrainEscorter)
    PolicierEscorte = tonumber(player)
    if EnTrainEscorter then
        escort()
    end
end)

function escort()
    Citizen.CreateThread(function()
        local pPed = GetPlayerPed(-1)
      while EnTrainEscorter do
            Wait(1)
            pPed = GetPlayerPed(-1)
        local targetPed = GetPlayerPed(GetPlayerFromServerId(PolicierEscorte))

        if not IsPedSittingInAnyVehicle(targetPed) then
          AttachEntityToEntity(pPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        else
          EnTrainEscorter = false
          DetachEntity(pPed, true, false)
        end

        if IsPedDeadOrDying(targetPed, true) then
          EnTrainEscorter = false
          DetachEntity(pPed, true, false)
        end
        end
        DetachEntity(pPed, true, false)
    end)
end

function GetClosestPlayer()
  local pPed = GetPlayerPed(-1)
  local players = GetActivePlayers()
  local coords = GetEntityCoords(pPed)
  local pCloset = nil
  local pClosetPos = nil
  local pClosetDst = nil
  for k,v in pairs(players) do
    if GetPlayerPed(v) ~= pPed then
      local oPed = GetPlayerPed(v)
      local oCoords = GetEntityCoords(oPed)
      local dst = GetDistanceBetweenCoords(oCoords, coords, true)
      if pCloset == nil then
        pCloset = v
        pClosetPos = oCoords
        pClosetDst = dst
      else
        if dst < pClosetDst then
          pCloset = v
          pClosetPos = oCoords
          pClosetDst = dst
        end
      end
    end
  end

  return pCloset, pClosetDst
end


function Rechercherplaquevoiture(plaquerechercher)
    local PlaqueMenu = RageUI.CreateMenu("plaque d'immatriculation", "Informations")
    ESX.TriggerServerCallback('pLSPDjob:getVehicleInfos', function(retrivedInfo)
    RageUI.Visible(PlaqueMenu, not RageUI.Visible(PlaqueMenu))
        while PlaqueMenu do
            Citizen.Wait(0)
          RageUI.IsVisible(PlaqueMenu,function()
                            RageUI.Button("Numéro de plaque : ", nil, {RightLabel = retrivedInfo.plate}, true, {
                                  onSelected = function()
                                    end
                                })
            
                            if not retrivedInfo.owner then
                                RageUI.Button("Propriétaire : ", nil, {RightLabel = "Inconnu"}, true, {
                                      onSelected = function()
                                    end
                                    })
                            else
                                RageUI.Button("Propriétaire : ", nil, {RightLabel = retrivedInfo.owner}, true, {
                                      onSelected = function()
                    end
                                    })

                local hashvoiture = retrivedInfo.vehicle.model
                local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
                local nomvoituretexte  = GetLabelText(nomvoituremodele)

                                RageUI.Button("Modèle du véhicule : ", nil, {RightLabel = nomvoituretexte}, true, {
                                      onSelected = function()
                    end
                                    })
                            end
                end, function()
                end)
            if not RageUI.Visible(PlaqueMenu) then
            PlaqueMenu = RMenu:DeleteType("plaque d'immatriculation", true)
        end
    end
end, plaquerechercher)
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = "prop_ballistic_shield"

function EnableShield()
    shieldActive = true
    local ped = GetPlayerPed(-1)
    local pedPos = GetEntityCoords(ped, false)
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(250)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(250)
    end

    local shield = CreateObject(GetHashKey(prop), pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
    shieldEntity = shield
    AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
    SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))
    SetEnableHandcuffs(ped, true)
end

function DisableShield()
    local ped = GetPlayerPed(-1)
    DeleteEntity(shieldEntity)
    ClearPedTasksImmediately(ped)
    SetWeaponAnimationOverride(ped, GetHashKey("Default"))
    SetEnableHandcuffs(ped, false)
    shieldActive = false
end

Citizen.CreateThread(function()
    while true do
        if shieldActive then
            local ped = GetPlayerPed(-1)
            if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(100)
                end
            
                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
            end
        end
        Citizen.Wait(500)
    end
end)

-- Vestiaire

function applySkinSpecific(infos)
  TriggerEvent('skinchanger:getSkin', function(skin)
    local uniformObject
    if skin.sex == 0 then
      uniformObject = infos.variations.male
    else
      uniformObject = infos.variations..female
    end
    if uniformObject then
      TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
    end

    infos.onEquip()
  end)
end

local open = false 
local mainMenu6 = RageUI.CreateMenu('Vestiaire', 'Votre vestiaire')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function VestiairePolice()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 

                RageUI.Separator("↓ ~y~Vos Tenues ~s~↓")
                for _,infos in pairs(Config.Tenues) do
                    RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                    onSelected = function()
                        applySkinSpecific(infos)
                    end
                    })
                end

            end)
          Wait(0)
         end
      end)
   end
end

Citizen.CreateThread(function()
  while true do
  local wait = 750
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
    for k in pairs(Config.Position.Vestaire) do
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = Config.Position.Vestaire
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= 5.0 then
                  wait = 0
                    DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
              end

              if dist <= 1.0 then
                  wait = 0
                  Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour pour accèder au ~y~vestaire ~s~!", 1)
                  if IsControlJustPressed(1,51) then
                    VestiairePolice()
                  end
              end
          end
  end
  Citizen.Wait(wait)
  end
end)


function vgillet()
  local model = GetEntityModel(GetPlayerPed(-1))

  AddArmourToPed(playerPed,100)
  SetPedArmour(playerPed, 100)
  TriggerEvent('skinchanger:getSkin', function(skin)
      if model == GetHashKey("mp_m_freemode_01") then
          clothesSkin = {
              ['bproof_1'] = 12,  ['bproof_2'] = 3
          }
      end
      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  end)
end

function vgilletj()
  local model = GetEntityModel(GetPlayerPed(-1))
  TriggerEvent('skinchanger:getSkin', function(skin)
      if model == GetHashKey("mp_m_freemode_01") then
          clothesSkin = {
              ['bproof_1'] = 18,  ['bproof_2'] = 0
          }
      end
      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  end)
end   

function vsac()
  local model = GetEntityModel(GetPlayerPed(-1))
  TriggerEvent('skinchanger:getSkin', function(skin)
      if model == GetHashKey("mp_m_freemode_01") then
          clothesSkin = {
              ['bags_1'] = 44,  ['bags_2'] = 0
          }
      end
      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
  end)
end  

--- Blips

local pos = vector3(Config.Position.Blips.x, Config.Position.Blips.y,Config.Position.Blips.z)
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(pos)

  SetBlipSprite (blip, 60)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 3)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName('STRING')
  AddTextComponentSubstringPlayerName('Commissariat')
  EndTextCommandSetBlipName(blip)
end)
