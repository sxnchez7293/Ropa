-- Script para comprar artículos del Catálogo de Creación de Avatar en Roblox

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Función para obtener los artículos en el carrito
local function getCartItems()
    local cart = ReplicatedStorage:WaitForChild("Cart") -- Asegúrate de que "Cart" sea el nombre correcto del RemoteEvent o RemoteFunction
    local itemsInCart = cart:InvokeServer("GetCartItems") -- Asegúrate de que "GetCartItems" sea el nombre correcto de la función en el servidor
    return itemsInCart
end

-- Función para mostrar una interfaz de usuario
local function showUI(itemsInCart)
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local textLabel = Instance.new("TextLabel")
    local buyButton = Instance.new("TextButton")

    screenGui.Parent = player:WaitForChild("PlayerGui")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = screenGui

    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Text = "Artículos en el carrito:\n"
    textLabel.Parent = frame

    buyButton.Size = UDim2.new(1, 0, 0.5, 0)
    buyButton.Position = UDim2.new(0, 0, 0.5, 0)
    buyButton.BackgroundColor3 = Color3.new(0, 1, 0)
    buyButton.Text = "Comprar"
    buyButton.Parent = frame

    for _, item in ipairs(itemsInCart) do
        textLabel.Text = textLabel.Text .. "- " .. item.Name .. " (ID: " .. item.AssetId .. ")\n"
    end

    buyButton.MouseButton1Click:Connect(function()
        local successCount = 0
        for _, item in ipairs(itemsInCart) do
            local success, errorMessage = pcall(function()
                MarketplaceService:PromptPurchase(player, item.AssetId)
            end)
            if success then
                successCount = successCount + 1
            else
                warn("Error al comprar el artículo " .. item.Name .. ": " .. errorMessage)
            end
        end
        textLabel.Text = "Se pudieron comprar " .. successCount .. " de " .. #itemsInCart .. " artículos."
    end)
end

-- Ejecutar la interfaz de usuario
local itemsInCart = getCartItems()
showUI(itemsInCart)
