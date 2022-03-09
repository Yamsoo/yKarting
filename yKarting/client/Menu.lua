Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

  local kartblip = AddBlipForCoord(KartingCFG.PosMenu)
  SetBlipSprite(kartblip, 736)
  SetBlipColour(kartblip, 1)
  SetBlipScale(kartblip, 0.80)
  SetBlipAsShortRange(kartblip, true)
  local kartblipradius = AddBlipForRadius(KartingCFG.PosMenu, 500.0)
  SetBlipSprite(kartblipradius,1)
  SetBlipColour(kartblipradius,1)
  SetBlipAlpha(kartblipradius,75)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString("Karting")
  EndTextCommandSetBlipName(kartblip)

  local hash = GetHashKey(KartingCFG.Ped)
  while not HasModelLoaded(hash) do
  RequestModel(hash)
    Wait(20)
  end
  ped = CreatePed("PED_TYPE_CIVFEMALE", KartingCFG.Ped, KartingCFG.PosMenu.x, KartingCFG.PosMenu.y, KartingCFG.PosMenu.z-1, KartingCFG.h, false, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(Ped, true)
end)

local open = false 
local YamsKart = RageUI.CreateMenu('~r~Karting', ' ')
YamsKart.Display.Header = true 
YamsKart.Closed = function()
  RageUI.Visible(YamsKart, false)
  open = false
end

function OpenMenuKarting()
  if open then 
    open = false
    RageUI.Visible(YamsKart, false)
    return
  else
    open = true 
    RageUI.Visible(YamsKart, true)
    CreateThread(function()
      while open do 
        RageUI.IsVisible(YamsKart,function() 

          RageUI.Separator('Bienvenue ~r~'..GetPlayerName(PlayerId())..'~s~ au Karting ~y~'..KartingCFG.NomBase, 18)
          RageUI.Separator("")
          RageUI.Separator("~r~Attention : Séances de 10 Minutes")
          RageUI.Separator("~r~Toute sortie de Kart est définitive")

          RageUI.Separator("~h~↓ Kart Dispo ↓")

          for i = 1, #KartingCFG.KartCar do
            local v = KartingCFG.KartCar[i]

              RageUI.Button("~h~→ "..v.nom, nil, {RightLabel = "~g~"..v.prix.." $"}, true , {
                onSelected = function()
                  TriggerServerEvent('Yams:PayKart', v.prix)
                  local model = GetHashKey(v.car)
                  RequestModel(model)
                  while not HasModelLoaded(model) do Wait(10) end
                  local kartveh = CreateVehicle(model, v.spawn, v.h, true, false)
                  SetVehicleNumberPlateText(kartveh, "KART"..math.random(50, 999))
                  SetVehicleFixed(kartveh)
                  TaskWarpPedIntoVehicle(PlayerPedId(),  kartveh,  -1)
                  SetVehRadioStation(kartveh, 0)
                  YamsKart.Closed()
                  Kart10min(v.car, kartveh)
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
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, KartingCFG.PosMenu)

    if dist < 4.0 then
      wait = 0
      DrawMarker(22, KartingCFG.PosMenu, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)  
      Visual.Subtitle("Appuyez sur ~r~[E]~s~ pour pour accèder au ~r~Karting ", 1)
      if IsControlJustPressed(1,51) then
        OpenMenuKarting()
      end
    end
  Citizen.Wait(wait)
  end
end)


function Kart10min(car)
  local car = GetHashKey(car)
  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)

  RequestModel(car)
  while not HasModelLoaded(car) do
      RequestModel(car)
      Citizen.Wait(0)
  end
ESX.ShowNotification("<C>Karting ~y~"..KartingCFG.NomBase.."\n~s~Vous avez ~r~10 Minutes de Karting.")
local timer = 600
local breakable = false
breakable = false
while not breakable do
  Wait(1000)
  timer = timer - 1
  while IsPedInAnyVehicle(PlayerPedId()) == false do
    Wait(10)
    DeleteEntity(veh)
    ESX.ShowNotification("<C>Karting ~y~"..KartingCFG.NomBase.."\n~r~Vous avez quittez votre Kart, la séance est términé.")
    breakable = true
    break
  end
  if timer == 300 then
    ESX.ShowNotification("<C>>Karting ~y~"..KartingCFG.NomBase.."\n~r~Il ne vous reste plus que 5 Minutes.")
  end
  if timer == 60 then
    ESX.ShowNotification("<C>>Karting ~y~"..KartingCFG.NomBase.."\n~r~Il ne vous reste plus que 1 Minutes.")
  end
  if timer <= 0 then
    local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
    DeleteEntity(veh)
    ESX.ShowNotification("<C>Karting ~y~"..KartingCFG.NomBase.."\n~r~Vous avez terminé la période de Karting.")
    breakable = true
    break
  end
end
end
