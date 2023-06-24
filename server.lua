ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local amount, amount2, amount3, amo = nil,nil,nil,nil
local profit, pselldata ,sgselldata, price, sgprofit = nil, nil,nil,nil,nil
local job, konto = nil,nil
local emt, jobstand = nil,nil
local silber = nil
local schwarz = nil
local auktion, id = nil,nil

RegisterNetEvent('mor-ds:afghanremove')
AddEventHandler('mor-ds:afghanremove', function(data)
    job = data[2]
    amount = data[1]
    price = data[3]
    sgprofit = amount * price
    profit = amount * 0.08
    ox_inventory:RemoveItem(source, 'afghan', amount)
    pselldata = {job, profit}
    sgselldata = {job, sgprofit}
    emt = 'Eurem Konto wurden '.. profit .. ' Silbermünzen gutgeschrieben und $'..sgprofit.. ' Schwarzgeld.'
    TriggerClientEvent('mor-ds:notify',source , emt)
    TriggerEvent('mor-ds:addsilber', pselldata)
    TriggerEvent('mor-ds:addschwarzgeld', sgselldata)
end)

RegisterNetEvent('mor-ds:kokainremove')
AddEventHandler('mor-ds:kokainremove', function(data)
    job = data[2]
    amount = data[1]
    price = data[3]
    sgprofit = amount * price
    profit = amount * 0.12
    ox_inventory:RemoveItem(source, 'kokain', amount)
    pselldata = {job, profit}
    sgselldata = {job, sgprofit}
    emt = 'Eurem Konto wurden '.. profit .. ' Silbermünzen gutgeschrieben und $'..sgprofit.. ' Schwarzgeld.'
    TriggerClientEvent('mor-ds:notify',source , emt)
    TriggerEvent('mor-ds:addsilber', pselldata)
    TriggerEvent('mor-ds:addschwarzgeld', sgselldata)
end)

RegisterNetEvent('mor-ds:kontodaten')
AddEventHandler('mor-ds:kontodaten', function(data)
    src = source
    job = data
    local response = MySQL.Sync.fetchAll('SELECT * FROM schwarzmarkt_konten WHERE jobname = @job;', {['@job'] = job})
    if response ~= nil then
        for i = 1, #response do
            local row = response[i]
            silber = row.silbermuenzen
            schwarz = row.schwarzgeld
        end
    end
    konto = {job, silber, schwarz}
    TriggerClientEvent('mor-ds:kontoubersicht',src , konto)
end)

RegisterNetEvent('mor-ds:addsilber')
AddEventHandler('mor-ds:addsilber', function(data)
    amount = data[2]
    job = data[1]
    amount2 = MySQL.Sync.fetchAll('SELECT * FROM schwarzmarkt_konten WHERE jobname = @job;', {['@job'] = job})
    print(json.encode(amount2))
    amo = amount2[1].silbermuenzen
    amount3 = amount + amo
    MySQL.Sync.execute('UPDATE schwarzmarkt_konten SET silbermuenzen = @amount WHERE jobname = @job ', {['@job'] = job,['@amount'] = amount3})
end)

RegisterNetEvent('mor-ds:addschwarzgeld')
AddEventHandler('mor-ds:addschwarzgeld', function(data)
    samount = data[2]
    job = data[1]
    samount2 = MySQL.Sync.fetchAll('SELECT * FROM schwarzmarkt_konten WHERE jobname = @job;', {['@job'] = job})
    print(json.encode(samount2))
    samo = samount2[1].schwarzgeld
    samount3 = samount + samo
    MySQL.Sync.execute('UPDATE schwarzmarkt_konten SET schwarzgeld = @amount WHERE jobname = @job ', {['@job'] = job,['@amount'] = samount3})
end)

RegisterNetEvent('mor-ds:auktion')
AddEventHandler('mor-ds:auktion', function()
    src = source
    auktion = MySQL.Sync.fetchAll('SELECT * FROM schwarzmarkt_auktion')
    TriggerClientEvent('mor-ds:auktionsanzeige', src, auktion)
end)

RegisterNetEvent('mor-ds:EFUebersicht')
AddEventHandler('mor-ds:EFUebersicht', function(job)
    job = job
    src = sourcess
    einf = MySQL.Sync.fetchAll('SELECT * FROM schwarzmarkt_konten WHERE jobname = @job;', {['@job'] = job})
    print(json.encode(einf))
    print(einf[1].jobname)
    print(einf[1].rockforte)
end)

RegisterNetEvent('mordrug:getjobstand')
AddEventHandler('mordrug:getjobstand', function(data)
    src = source
    job = data
    print(job)
    local response = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE name = @job;', {['@job'] = job})
    if response ~= nil then
        for i = 1, #response do
            local row = response[i]
            jobstand = row.stand
        end
        TriggerClientEvent('mordrug:jobstand',src , jobstand)
    end
end)