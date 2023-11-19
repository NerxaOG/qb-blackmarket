local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local currentModel = "CSB_ARY"
    RequestModel(currentModel)

    while not HasModelLoaded(currentModel) do
        Wait(0)
    end

    local currentLocation = Config.blackmarket[math.random(#Config.blackmarket)]
	
    local blackmarket = CreatePed(0, currentModel, currentLocation.x, currentLocation.y, currentLocation.z - 1, currentLocation.h, false, false)
    FreezeEntityPosition(blackmarket, true)
    SetEntityInvincible(blackmarket, true)

    TaskStartScenarioInPlace(blackmarket, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)

    exports['qb-target']:AddTargetEntity(blackmarket, {
        options = {
            {
                type = "client",
                label = "Shady Guy",
                icon = "fa-handshake-o ",
                event = "qb-blackmarket:client:Openblackmarket"
            },
        },
        distance = 2.0
    })	
end)

RegisterNetEvent('qb-blackmarket:client:Openblackmarket')
AddEventHandler('qb-blackmarket:client:Openblackmarket', function()
    QBCore.Functions.Progressbar("random_task", "Doing something", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "oddjobs@assassinate@vice@hooker",
        anim = "argue_a",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Black Market", Config.Items)    
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "oddjobs@assassinate@vice@hooker", "argue_a", 1.0)
    end)
end)
