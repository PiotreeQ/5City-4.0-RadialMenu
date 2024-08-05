local radialState = false
local radialItems = {['main_menu'] = {}}
local radialFunctions = {['main_menu'] = {}}

function addRadialItem(data)
    if not radialItems[data.menu] then
        radialItems[data.menu] = {}
    end

    table.insert(radialItems[data.menu], {
        id = data.id,
        label = data.label,
        icon = data.icon
    })
    if not radialFunctions[data.menu] then
        radialFunctions[data.menu] = {}
    end

    radialFunctions[data.menu][data.id] = data.onSelect
    UpdateRadial()
end

exports('addRadialItem', addRadialItem)

function removeRadialItem(menu, id)
    if radialItems[menu] then
        local itemExist = false
        for i = 1, #radialItems[menu], 1 do
            local item = radialItems[menu][i]
            if item.id == id then
                table.remove(radialItems[menu], i)
                if radialFunctions[menu][id] then
                    radialFunctions[menu][id] = nil
                end
                UpdateRadial()
                break
            end
        end
    end
end

exports('removeRadialItem', removeRadialItem)

function UpdateRadial()
    if not radialState then
        return
    end
    
    SendNUIMessage({action = 'UpdateRadial', items = radialItems})
end

-- RegisterCommand('test_add', function()
--     addRadialItem({
--         menu = 'kupa',
--         id = 'sraka',
--         label = 'Sraczka',
--         icon = 'fa-thin fa-file',
--         onSelect = function()
--             print('SRACZUŁKA')
--         end
--     })
-- end)

-- RegisterCommand('test_remove', function()
--     removeRadialItem('kupa', 'sraka')
-- end)

RegisterCommand('open_radial', function()
    OpenRadial()
end)

RegisterKeyMapping('open_radial', 'Open Radial Menu', 'keyboard', 'F1')

function OpenRadial()
    if radialState or #radialItems['main_menu'] < 1 then
        return
    end

    radialState = true
    SendNUIMessage({
        action = 'OpenRadial',
        items = radialItems
    })
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SetFrontendActive(false)
    Citizen.CreateThread(function()
        while radialState do
            Wait(1)
            DisableControlAction(0, 0, true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableFrontendThisFrame()
        end
    end)
end

RegisterNUICallback('CloseRadial', function()
    CloseRadial()
end)

function CloseRadial()
    if not radialState then
        return
    end

    SetNuiFocus(false, false)
    Citizen.Wait(150)
    radialState = false
end

function isRadialOpen()
    return isRadialOpen
end

RegisterNUICallback('SelectItem', function(data)
    if data.subMenu then
        radialFunctions[data.subMenu][data.item.id]()
    else
        radialFunctions['main_menu'][data.item.id]()
    end
end)

Citizen.CreateThread(function()
    Wait(250)
    addRadialItem({
        menu = 'main_menu',
        id = 'documents',
        label = 'Documents',
        icon = 'fa-thin fa-file',
        onSelect = function()
            print('Documents')
        end
    })
    addRadialItem({
        menu = 'main_menu',
        id = 'animations',
        label = 'Animations',
        icon = 'fa-thin fa-user',
        onSelect = function()
            print('Animations')
        end
    })
    addRadialItem({
        menu = 'documents',
        id = 'idcard',
        label = 'Dowód',
        icon = 'fa-thin fa-id-card',
        onSelect = function()
            print('ID CARD')
        end
    })
end)