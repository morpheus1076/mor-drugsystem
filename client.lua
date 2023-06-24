ESX = exports['es_extended']:getSharedObject()
--print(json.encode(input))

local selldata,jobstand, job = nil,nil,nil
local afghaninput,kokaininput, price = nil,nil,nil
local PlayerData = nil


RegisterNetEvent('mordrug:jobstand')
AddEventHandler('mordrug:jobstand', function(data)
	jobstand = data
end)

CreateThread( function()
	--local PlayerData = ESX.GetPlayerData()
	--local job = PlayerData.job.name
	for _, points in pairs(Config.Points) do
		if points.enabled and points.group == nil then
			blip = AddBlipForCoord(points.coords.x,points.coords.y,points.coords.z)
			SetBlipSprite(blip, points.sprite)
			SetBlipColour(blip, points.colour)
			SetBlipAsShortRange(blip, true)
			SetBlipHiddenOnLegend(blip, points.hidden)
			SetBlipScale(blip, points.scale)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(points.text)
			EndTextCommandSetBlipName(blip)
		end

		if points.enabled and points.group ~= nil then
			blip = AddBlipForCoord(points.coords.x,points.coords.y,points.coords.z)
			SetBlipSprite(blip, points.sprite)
			SetBlipColour(blip, points.colour)
			SetBlipAsShortRange(blip, true)
			SetBlipHiddenOnLegend(blip, points.hidden)
			SetBlipScale(blip, points.scale)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(points.text)
			EndTextCommandSetBlipName(blip)
		end

		RequestModel(GetHashKey(points.ped))
		while not HasModelLoaded(GetHashKey(points.ped)) do
			Wait(1)
		end

		if points.pedenabled then
			local npc = CreatePed(4, points.pedhash, points.pedcoords.x, points.pedcoords.y, points.pedcoords.z, points.pedheading, false, true)
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, points.pedheading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			TaskStartScenarioInPlace(npc, points.scenario, -1, true)
		end

		if points.tarenabled or points.group == nil then
			exports.qtarget:AddBoxZone(points.text, points.coords, 1.5, 1.5, {
				name=points.text,
				heading=points.pedheading,
				debugPoly=false,
				minZ=points.pedcoords.z-1.5,
				maxZ=points.pedcoords.z+1.5,},
				{options = points.taroptions
			})
		end
	end
end)

AddEventHandler('mor-ds:verkauf', function()
	local PlayerData = ESX.GetPlayerData()
	local job = PlayerData.job.name
	local acount = exports.ox_inventory:Search('count', 'afghan')
	local kcount = exports.ox_inventory:Search('count', 'kokain')
	local input = lib.inputDialog('Verkauf',{
		{type = 'number', label = 'Afghan Kush', description = 'Bestand:  '..acount..' ||   Preis: $'..Config.Price.aprice, icon = 'hashtag',min= 0, max = acount},
		{type = 'number', label = 'Kokain', description = 'Bestand:  '..kcount..' ||   Preis: $'..Config.Price.kprice, icon = 'hashtag',min= 0, max = kcount}
		})
	if input ~= nil then
		afghaninput = input[1]
		kokaininput = input[2]
	else end
	
	if afghaninput ~= nil then
		price = Config.Price.aprice
		selldata = { afghaninput, job, price}
		TriggerServerEvent('mor-ds:afghanremove', selldata)
	end
	if kokaininput ~= nil then
		price = Config.Price.kprice
		selldata = { kokaininput, job, price}
		TriggerServerEvent('mor-ds:kokainremove', selldata)
	end
end)

AddEventHandler('mor-ds:hmenu', function()
	PlayerData = ESX.GetPlayerData()
	job = PlayerData.job.name
	TriggerServerEvent('mordrug:getjobstand', job)
	Wait(500)
	if jobstand == 'Kriminell' then
		lib.registerContext({
			id = 'johnson',
			title = 'Mister Johnson',
			options = {
				{
					title = 'Verkaufen',
					description = 'Drogenverkaufen',
					icon = 'hand',
					event = 'mor-ds:verkauf',
					arrow = true
				},
				{
					title = 'Auktionen',
					description = 'Auktionen ansehen und bieten',
					icon = 'hand',
					serverEvent = 'mor-ds:auktion',
					arrow = true
				},
				{
					title = 'Kontoabfrage',
					description = 'Kauf Angebot abgeben',
					icon = 'dollar',
					event = 'mor-ds:kontoabfrage',
					arrow = true
				},
				{
					title = 'Abheben',
					description = 'Ist nicht wieder einzalbar',
					icon = 'hand',
					event = 'mor-ds:kontoabhebung',
					arrow = true
				},
				{
					title = 'Stand: '..jobstand,
					icon = 'info'
				}
			}
		})
		lib.showContext('johnson')
	end
end)


AddEventHandler('mor-ds:angebot', function()
	lib.notify({title = 'Mister Johnson', position = 'top-right', description = 'Derzeit keine Angebote', style = {backgroundColor = '#000000',color = '#ffffff'},icon = 'hand',iconColor = '#800080'})
end)

AddEventHandler('mor-ds:kontoabfrage', function()
	local PlayerData = ESX.GetPlayerData()
	local job = PlayerData.job.name
	TriggerServerEvent('mor-ds:kontodaten', job)
end)

RegisterNetEvent('mor-ds:notify')
AddEventHandler('mor-ds:notify', function(msg, desc)
	lib.notify({title = msg, position = 'top-right', duration = 5000, style = {backgroundColor = '#000000',color = '#ffffff'},icon = 'hand',iconColor = '#800080'})
end)

RegisterNetEvent('mor-ds:kontoubersicht')
AddEventHandler('mor-ds:kontoubersicht', function(konto)
	local job = konto[1]
	local silber = konto[2]
	local schwarz = konto[3]
	lib.registerContext({
		id = 'mor-ds:konto',
		title = 'Kontoübersicht ',
		menu = 'johnson',
		options = {
			{
				title = 'Silbermünzen',
				description = ''..silber..'  Stück'
		  	},
			{
				title = 'Schwarzgeld',
				description = '$ '..schwarz..''
		  	}
		}
	})
	lib.showContext('mor-ds:konto')
end)

RegisterNetEvent('mor-ds:auktionsanzeige')
AddEventHandler('mor-ds:auktionsanzeige', function(auktion)
	lib.registerContext({
		id = 'mor-ds:auktionanzeigen',
		title = 'Auktionen',
		menu = 'johnson',
		options = {
			{
				title = 'ID: '..auktion[1].id..'  ||  ' ..auktion[1].type..'  ||  '..auktion[1].label,
				description = 'Menge: '..auktion[1].menge..'  ||   Preis: '..auktion[1].preis..' '..auktion[1].zahlungsart,
				event = ''
		  	},
			{
				title = 'ID: '..auktion[2].id..'  ||  ' ..auktion[2].type..'  ||  '..auktion[2].label,
				description = 'Menge: '..auktion[2].menge..'  ||   Preis: '..auktion[2].preis..' '..auktion[2].zahlungsart,
				event = ''
		  	},
			{
				title = 'ID: '..auktion[3].id..'  ||  ' ..auktion[3].type..'  ||  '..auktion[3].label,
				description = 'Menge: '..auktion[3].menge..'  ||   Preis: '..auktion[3].preis..' '..auktion[3].zahlungsart,
				event = ''
		  	},
			{
				title = 'ID: '..auktion[4].id..'  ||  ' ..auktion[4].type..'  ||  '..auktion[4].label,
				description = 'Menge: '..auktion[4].menge..'  ||   Preis: '..auktion[4].preis..' '..auktion[4].zahlungsart,
				event = ''
		  	},
			{
				title = 'ID: '..auktion[5].id..'  ||  ' ..auktion[5].type..'  ||  '..auktion[5].label,
				description = 'Menge: '..auktion[5].menge..'  ||   Preis: '..auktion[5].preis..' '..auktion[5].zahlungsart,
				event = ''
		  	}
		}
	})
	lib.showContext('mor-ds:auktionanzeigen')
end)

CreateThread( function()
	--local PlayerData = ESX.GetPlayerData()
	--local job = PlayerData.job.name
	for _, points in pairs(Config.Abgabe) do
		if points.enabled and points.group == nil then
			blip = AddBlipForCoord(points.coords.x,points.coords.y,points.coords.z)
			SetBlipSprite(blip, points.sprite)
			SetBlipColour(blip, points.colour)
			SetBlipAsShortRange(blip, true)
			SetBlipHiddenOnLegend(blip, points.hidden)
			SetBlipScale(blip, points.scale)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(points.text)
			EndTextCommandSetBlipName(blip)
		end

		if points.enabled and points.group ~= nil then
			blip = AddBlipForCoord(points.coords.x,points.coords.y,points.coords.z)
			SetBlipSprite(blip, points.sprite)
			SetBlipColour(blip, points.colour)
			SetBlipAsShortRange(blip, true)
			SetBlipHiddenOnLegend(blip, points.hidden)
			SetBlipScale(blip, points.scale)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(points.text)
			EndTextCommandSetBlipName(blip)
		end

		RequestModel(GetHashKey(points.ped))
		while not HasModelLoaded(GetHashKey(points.ped)) do
			Wait(1)
		end

		if points.pedenabled then
			local npc = CreatePed(4, points.pedhash, points.pedcoords.x, points.pedcoords.y, points.pedcoords.z, points.pedheading, false, true)
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, points.pedheading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			TaskStartScenarioInPlace(npc, points.scenario, -1, true)
		end

		if points.tarenabled or points.group == nil then
			exports.qtarget:AddBoxZone(points.text, points.coords, 1.5, 1.5, {
				name=points.text,
				heading=points.pedheading,
				debugPoly=false,
				minZ=points.pedcoords.z-1.5,
				maxZ=points.pedcoords.z+1.5,},
				{options = points.taroptions
			})
		end
	end
end)

RegisterNetEvent('mor-ds:paketverkauf')
AddEventHandler('mor-ds:paketverkauf', function()
	lib.registerContext({
		id = 'mor-ds:paketverkauf',
		title = 'Paketverkauf',
		options = {
			{
				title = 'Übersicht',
				description = 'Eine Übersicht über alle Gebiete.',
				event = 'mor-ds:paketuebersicht',
		  	},
			  {
				title = 'Pakete abgeben',
				description = 'Pakete abgeben.',
				event = '',
		  	},
		}
	})
	lib.showContext('mor-ds:paketverkauf')
end)

RegisterNetEvent('mor-ds:paketuebersicht')
AddEventHandler('mor-ds:paketuebersicht', function()
	local PlayerData = ESX.GetPlayerData()
	local job = PlayerData.job.name
	TriggerServerEvent('mor-ds:EFUebersicht', job)

end)