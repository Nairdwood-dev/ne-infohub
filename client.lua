local QBCore = exports['qb-core']:GetCoreObject()
local isUIOpen = false

-- Ensure Config is loaded
local Config = Config or {}
Config.AllowedJobs = { "police", "ambulance", "firetruck" }

-- Function to check if a job is allowed
local function IsJobAllowed(job)
    for _, allowedJob in ipairs(Config.AllowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end

RegisterCommand("infohub", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name

    -- Check if the player's job is allowed
    if not IsJobAllowed(playerJob) then
        QBCore.Functions.Notify("You do not have access to the Info Hub!", "error")
        return
    end

    if not isUIOpen then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "open", url = Config.InfoHubURL })
        isUIOpen = true

        -- Start the tablet2 emote
        if exports["scully_emotemenu"] then
            exports["scully_emotemenu"]:playEmoteByCommand("tablet2")
        end
    end
end, false)

RegisterNUICallback("closeUI", function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
    isUIOpen = false

    -- Stop the emote when closing the NUI
    if exports["scully_emotemenu"] then
        exports["scully_emotemenu"]:cancelEmote()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isUIOpen then
            DisableControlAction(0, 1, true) -- Disable camera movement
            DisableControlAction(0, 2, true) -- Disable camera movement
            DisableControlAction(0, 24, true) -- Disable attack
            DisableControlAction(0, 25, true) -- Disable aim
            DisableControlAction(0, 37, true) -- Disable weapon wheel
            DisableControlAction(0, 199, true) -- Disable pause menu
            DisableControlAction(0, 200, true) -- Disable pause menu

            if IsControlJustReleased(0, 177) then -- ESC key
                SetNuiFocus(false, false)
                SendNUIMessage({ action = "close" })
                isUIOpen = false

                -- Stop the emote when exiting via ESC key
                if exports["scully_emotemenu"] then
                    exports["scully_emotemenu"]:cancelEmote()
                end
            end
        end
    end
end)

-- Ensure the NUI is hidden on player join and resource start
RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Citizen.Wait(1000)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
    isUIOpen = false
end)

Citizen.CreateThread(function()
    Citizen.Wait(500) -- Small delay to ensure NUI is loaded before sending message
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
    isUIOpen = false
end)

-- Register the /infohub command in QBCore
if QBCore.Commands then
    QBCore.Commands.Add("infohub", "Opens the InfoHub tablet", {}, false, function(source, args)
        TriggerClientEvent("infohub:open", source)
    end, "user")
end

RegisterNetEvent("infohub:open")
AddEventHandler("infohub:open", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name

    -- Check if the player's job is allowed
    if not IsJobAllowed(playerJob) then
        QBCore.Functions.Notify("You do not have access to the Info Hub!", "error")
        return
    end

    if not isUIOpen then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "open", url = Config.InfoHubURL })
        isUIOpen = true

        -- Start the tablet2 emote
        if exports["scully_emotemenu"] then
            exports["scully_emotemenu"]:playEmoteByCommand("tablet2")
        end
    end
end)