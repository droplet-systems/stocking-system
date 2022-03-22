local Players = game:GetService('Players')

local Stocking = script.Parent.Parent
local Shared = Stocking.Shared
local Functions = require(Shared.Functions)
local warn = require(Shared.Warn)

return function(Objects, Events, Configuration)
    local Items = Objects.Items
    local Supplies = Objects.Supplies
    local SupplyTool = Objects.SupplyTool

    for _, Obj in pairs(Supplies:GetChildren()) do
        local Detector = Functions.CreateDetector()
        Detector.Parent = Obj

        Functions.BindDetectorToEvent(Detector, function(Player)
            if table.find(Configuration.Stocking.Whitelisted, Player:GetRankInGroup(Configuration.Stocking.Group)) then
                local Backpack = Player:WaitForChild('Backpack')

                local Tool = SupplyTool:Clone()
                Tool.Parent = Backpack

                Events.SupplyToolPickup:Fire(Player)

                Tool.Activated:Connect(function()
                    for _, Item in pairs(Items:GetChildren()) do
                        if not Item:GetAttribute('Stock') then
                            local Character = Player.Character
                            local HumanoidRootPart = Character.HumanoidRootPart

                            local Magnitude = math.round((HumanoidRootPart.Position - Item.Position or Item:GetPivot()).Magnitude)

                            if Magnitude <= Configuration.Stocking.MaxDistance then
                                Functions.SetProductTransparency(Item, 0)
                                Item:SetAttribute('Stock', true)

                                Events.Restock:Fire(Player, Obj)
                            end
                        end
                    end
                end)
            end
        end)
    end
end