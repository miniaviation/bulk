local firesignal = firesignal or function(signal)
    if getconnections then
        for _, conn in pairs(getconnections(signal)) do
            if conn.Function then pcall(conn.Function) end
        end
    end
end

local p = game:GetService("Players").LocalPlayer
local pg = p.PlayerGui

-- 1. DockingRequest – first TextButton in the menu
local docking = pg:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
for _, btn in pairs(docking:GetChildren()) do
    if btn:IsA("TextButton") then
        firesignal(btn.MouseButton1Click)
        break
    end
end

-- ------------------------------------------------------------------
--  WAIT FOR DOCKING TO FINISH
-- ------------------------------------------------------------------
-- PortGui (and its LoadingBar) is created by the game right after the
-- docking request is accepted.
local portGui = pg:WaitForChild("PortGui")               -- wait for the whole port UI
local loadingBar = portGui:WaitForChild("LoadingBar")    -- the bar shown by ToggleLoading

repeat wait() until not loadingBar.Visible

-- Optional extra safety: make sure the main menu buttons are enabled.
-- (Some ports keep the menu hidden until the loading UI is cleared.)
local mainMenu = portGui:WaitForChild("PortMainMenu")
repeat wait() until mainMenu.Visible and mainMenu.MenuButtons.CargoManager.Visible

-- ------------------------------------------------------------------
--  EXTRA 3-SECOND BUFFER (as requested)
-- ------------------------------------------------------------------
wait(3)

-- 2. CargoManager Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.CargoManager.Button.MouseButton1Click)

wait(0.5)

-- 3. Load Button (16th child in ScrollingFrame)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.PortGui.BulkMenu.ScrollingFrame.ListItem.Load.MouseButton1Click)

wait(12)

-- 4. Back Button
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.PortGui.BulkMenu.Back.MouseButton1Click)

wait(0.5)

-- Gas menu
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.Refuel.Button.MouseButton1Click)
wait(0.5)

-- Refuel Button
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.PortGui.ShipServices.PurchaseFuel.MouseButton1Click)

-- Back to main menu
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.PortGui.ShipServices.Exit.MouseButton1Click)

-- 5. Undock Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.Undock.Button.MouseButton1Click)

-- ------------------------------------------------------------------
--  WAIT FOR UNDOCKING TO FINISH
-- ------------------------------------------------------------------
-- UndockShip() calls ToggleLoading(6, "Undocking Ship..."), which makes
-- LoadingBar visible again. Wait until it is hidden.
repeat wait() until not loadingBar.Visible

-- Optional extra safety: ensure ShipControlGui is re-enabled, as
-- UndockShip() sets it to Enabled = true after undocking.
repeat wait() until pg:WaitForChild("ShipControlGui").Enabled

-- ------------------------------------------------------------------
--  EXTRA 3-SECOND BUFFER (as requested)
-- ------------------------------------------------------------------
wait(3)
