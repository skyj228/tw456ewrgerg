local tick = tick
local math_abs = math.abs
local math_clamp = math.clamp
local math_max = math.max
local math_min = math.min
local math_floor = math.floor
local Vector3_new = Vector3.new
local Vector2_new = Vector2.new
local CFrame_new = CFrame.new
local table_insert = table.insert
local table_sort = table.sort

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser
pcall(function()
    VirtualUser = game:GetService("VirtualUser")
end)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local function getSafeGuiParent()
    local ok, h = pcall(function()
        return gethui and gethui()
    end)
    if ok and h then
        return h
    end
    local okCG, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if okCG and cg then
        return cg
    end
    local lp = Players.LocalPlayer
    return lp and lp:FindFirstChildOfClass("PlayerGui")
end
local function getViewportSize()
    local cam = Workspace.CurrentCamera
    if cam and cam.ViewportSize and cam.ViewportSize.X > 0 and cam.ViewportSize.Y > 0 then
        return cam.ViewportSize
    end
    return Vector2.new(1280, 720)
end
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
repeat
    task.wait(0.1)
until LocalPlayer.Character
    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    and LocalPlayer.Character:FindFirstChild("Humanoid")
    and LocalPlayer.Character.Parent
local Endpoints = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server")
local Camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")
if getgenv().AJ_HUB_SAVE_CONFIG then
    pcall(getgenv().AJ_HUB_SAVE_CONFIG)
end
if getgenv().AJ_HUB_AUTOSAVE_THREAD then
    pcall(task.cancel, getgenv().AJ_HUB_AUTOSAVE_THREAD)
    getgenv().AJ_HUB_AUTOSAVE_THREAD = nil
end
if getgenv().AJ_HUB_AUTOSUMMON_THREAD then
    pcall(task.cancel, getgenv().AJ_HUB_AUTOSUMMON_THREAD)
    getgenv().AJ_HUB_AUTOSUMMON_THREAD = nil
end
if getgenv().AJ_HUB_HEARTBEAT then
    getgenv().AJ_HUB_HEARTBEAT:Disconnect()
    getgenv().AJ_HUB_HEARTBEAT = nil
end
if _G.AA_BUFF_STOP then
    pcall(_G.AA_BUFF_STOP)
end
if getgenv and getgenv().AA_BUFF_STOP then
    pcall(getgenv().AA_BUFF_STOP)
end
if getgenv and getgenv().AJ_HUB_BUFF_STOP then
    pcall(getgenv().AJ_HUB_BUFF_STOP)
end
do
    local prevVisuals = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
    if prevVisuals then prevVisuals:Destroy() end
    local prevGhost = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
    if prevGhost then prevGhost:Destroy() end
    local prevMarker = Camera:FindFirstChild("_AJ_HUB_PlacementMarker") or Workspace:FindFirstChild("_AJ_HUB_PlacementMarker")
    if prevMarker then prevMarker:Destroy() end
    local prevHover = Camera:FindFirstChild("_AJ_HUB_HoverMarker") or Workspace:FindFirstChild("_AJ_HUB_HoverMarker")
    if prevHover then prevHover:Destroy() end
end
if getgenv().AJ_HUB_CLEANUP then
    pcall(getgenv().AJ_HUB_CLEANUP)
    getgenv().AJ_HUB_CLEANUP = nil
end
if getgenv().AJ_HUB_LIBRARY and getgenv().AJ_HUB_LIBRARY.unload_menu then
    pcall(function() getgenv().AJ_HUB_LIBRARY:unload_menu() end)
    getgenv().AJ_HUB_LIBRARY = nil
end
getgenv().AJ_HUB_LOADED = nil
pcall(function()
    local function cleanParent(p)
        if not p then return end
        for _, g in ipairs(p:GetChildren()) do
            if g:IsA("ScreenGui") then
                local shouldClean = false
                if g.Name == "AJ_HUB_SCREEN_GUI" or g.Name == "AJ_HUB_OTHER_GUI" or g.Name == "AJ_HUB_DiscordPrompt" or g.Name == "AJ_HUB_MobileToggle" or g:GetAttribute("AJ_HUB") then
                    shouldClean = true
                elseif g.Name == "\0" or g.Name == "" then
                    for _, d in ipairs(g:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Text and (d.Text == "AJ HUB" or d.Text:find("AJ HUB")) then
                            shouldClean = true
                            break
                        end
                    end
                end
                if shouldClean then
                    pcall(function() g:Destroy() end)
                end
            end
        end
    end
    pcall(function()
        if gethui then
            cleanParent(gethui())
        end
    end)
    pcall(function()
        cleanParent(game:GetService("CoreGui"))
    end)
    cleanParent(LocalPlayer:FindFirstChild("PlayerGui"))
end)
local library
for attempt = 1, 5 do
    local ok, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/werthjgwdfhuisdf/b2345v345b345b/refs/heads/main/library.lua")
    end)
    if ok and res and #res > 1000 then
        res = res:gsub('local coregui = game:GetService%("CoreGui"%)', 'local coregui = (function() local ok, h = pcall(function() return gethui and gethui() end); if ok and h then return h end; local ok2, cg = pcall(function() return game:GetService("CoreGui") end); if ok2 and cg then return cg end; return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end)()')
        res = res:gsub('items%[%s*"toggle_button"%s*%]%.MouseButton1Click:Connect%(function%(%)%s*cfg%.enabled%s*=%s*not%s*cfg%.enabled%s*cfg%.set%(cfg%.enabled%)%s*end%)', '')
        res = res:gsub('items%[%s*"toggle"%s*%]%.MouseButton1Click:Connect%(function%(%)%s*cfg%.enabled%s*=%s*not%s*cfg%.enabled%s*cfg%.set%(cfg%.enabled%)%s*end%)', '')
        local fn = loadstring(res)
        if fn then
            library = fn()
            break
        end
    end
    task.wait(0.5)
end
assert(library, "Failed to load UI library after retries")
local function collectAncestorScrollFrames(inst)
    local saved = {}
    local cur = inst and inst.Parent
    while cur do
        if cur:IsA("ScrollingFrame") then
            table.insert(saved, { frame = cur, wasEnabled = cur.ScrollingEnabled })
            cur.ScrollingEnabled = false
        end
        cur = cur.Parent
    end
    return saved
end
local function restoreAncestorScrollFrames(saved)
    if not saved then return end
    for _, entry in ipairs(saved) do
        pcall(function()
            if entry.frame and entry.frame.Parent then
                entry.frame.ScrollingEnabled = entry.wasEnabled
            end
        end)
    end
end
local function clampFrameToViewport(frame, targetX, targetY)
    local vp = getViewportSize()
    local absW = frame.AbsoluteSize.X
    local absH = frame.AbsoluteSize.Y
    if absW <= 0 then absW = frame.Size.X.Offset end
    if absH <= 0 then absH = frame.Size.Y.Offset end
    local maxX = math.max(0, vp.X - absW)
    local maxY = math.max(0, vp.Y - absH)
    return UDim2.new(0, math.clamp(targetX, 0, maxX), 0, math.clamp(targetY, 0, maxY))
end
local _dragStateMap = setmetatable({}, { __mode = "k" })
library._dragStateMap = _dragStateMap
function library:attachDragHandle(handle, targetFrame)
    if not handle or not targetFrame then return end
    local st = _dragStateMap[targetFrame]
    if not st then
        st = {
            dragging = false,
            dragInput = nil,
            isTouch = false,
            startPos = targetFrame.Position,
            startInput = Vector3.new(),
            savedScrolls = nil
        }
        _dragStateMap[targetFrame] = st
        library:connection(UserInputService.InputChanged, function(input)
            if not st.dragging or library._sliderDragging then return end
            if st.isTouch then
                if input ~= st.dragInput and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
            else
                if input.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
            end
            local deltaX = input.Position.X - st.startInput.X
            local deltaY = input.Position.Y - st.startInput.Y
            targetFrame.Position = clampFrameToViewport(
                targetFrame,
                st.startPos.X.Offset + deltaX,
                st.startPos.Y.Offset + deltaY
            )
            if library and library.close_element then
                pcall(function() library:close_element() end)
            end
        end)
        library:connection(UserInputService.InputEnded, function(input)
            if not st.dragging then return end
            local endedMatch = (st.isTouch and (input == st.dragInput or input.UserInputType == Enum.UserInputType.Touch))
                or (not st.isTouch and input.UserInputType == Enum.UserInputType.MouseButton1)
            if endedMatch then
                st.dragging = false
                st.dragInput = nil
                restoreAncestorScrollFrames(st.savedScrolls)
                st.savedScrolls = nil
            end
        end)
    end
    handle.InputBegan:Connect(function(input)
        if library._sliderDragging then return end
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
        if not isTouch and not isMouse then return end
        st.dragging = true
        st.isTouch = isTouch
        st.dragInput = isTouch and input or nil
        st.startInput = input.Position
        st.startPos = targetFrame.Position
        if isTouch then
            st.savedScrolls = collectAncestorScrollFrames(targetFrame)
        end
    end)
end
function library:draggify(frame)
    library:attachDragHandle(frame, frame)
end
function library:resizify(frame)
    local grabSize = UserInputService.TouchEnabled and 24 or 12
    local grip = Instance.new("TextButton")
    grip.Name = "AJResizeGrip"
    grip.Position = UDim2.new(1, -grabSize, 1, -grabSize)
    grip.BorderColor3 = Color3.fromRGB(0, 0, 0)
    grip.Size = UDim2.new(0, grabSize, 0, grabSize)
    grip.BorderSizePixel = 0
    grip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    grip.Parent = frame
    grip.BackgroundTransparency = 1
    grip.Text = ""
    grip.ZIndex = 50
    local resizing = false
    local resizeInput = nil
    local isTouchResize = false
    local startSize = frame.Size
    local startInput = Vector3.new()
    local minW = math.min(frame.Size.X.Offset > 0 and frame.Size.X.Offset or 480, 480)
    local minH = math.min(frame.Size.Y.Offset > 0 and frame.Size.Y.Offset or 320, 320)
    grip.InputBegan:Connect(function(input)
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
        if not isTouch and not isMouse then return end
        resizing = true
        isTouchResize = isTouch
        resizeInput = isTouch and input or nil
        startInput = input.Position
        startSize = frame.Size
    end)
    library:connection(UserInputService.InputChanged, function(input)
        if not resizing then return end
        if isTouchResize then
            if input ~= resizeInput and input.UserInputType ~= Enum.UserInputType.Touch then return end
        else
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        end
        local vp = getViewportSize()
        local maxW = math.max(minW, vp.X - 12)
        local maxH = math.max(minH, vp.Y - 12)
        frame.Size = UDim2.new(
            startSize.X.Scale,
            math.clamp(startSize.X.Offset + (input.Position.X - startInput.X), minW, maxW),
            startSize.Y.Scale,
            math.clamp(startSize.Y.Offset + (input.Position.Y - startInput.Y), minH, maxH)
        )
    end)
    library:connection(UserInputService.InputEnded, function(input)
        if not resizing then return end
        if (isTouchResize and (input == resizeInput or input.UserInputType == Enum.UserInputType.Touch))
            or (not isTouchResize and input.UserInputType == Enum.UserInputType.MouseButton1) then
            resizing = false
            resizeInput = nil
        end
    end)
end
local Config
local State
local syncWithXTHub = function() end
local saveConfigToFile
local loadConfigFromFile
local saveConfigToCloud
local loadConfigFromCloud
local _isLoadingConfig = false

local function triggerAutoSave()
    if _isLoadingConfig then return end
    local targetProf = (State and State.CurrentProfile) or "Default"
    if saveConfigToFile then
        pcall(saveConfigToFile, targetProf)
    elseif getgenv().AJ_HUB_SAVE_CONFIG then
        pcall(getgenv().AJ_HUB_SAVE_CONFIG, targetProf)
    end
end
getgenv().AJ_HUB_TRIGGER_AUTOSAVE = triggerAutoSave
local function wrapWithAutoSave(options)
    if type(options) ~= "table" then return end
    local userCb = options.callback
    options.callback = function(...)
        if userCb then
            pcall(userCb, ...)
        end
        triggerAutoSave()
    end
end
local function setExclusiveAutoJoin(key, val)
    if not Config then return end
    Config[key] = val
    if val then
        local otherKeys = {
            "AutoJoinStory", "AutoFindMatchStory", "JoinLastAct",
            "AutoJoinLegend", "AutoFindMatchLegend",
            "AutoJoinRaid", "AutoFindMatchRaid",
            "AutoJoinMansion", "AutoFindMatchMansion",
            "AutoJoinArtifact",
            "AutoJoinChallenge", "AutoFindMatchChallenge",
            "AutoJoinDailyChallenge", "AutoFindMatchDailyChallenge",
            "AutoJoinSummer", "AutoFindMatchSummer"
        }
        for _, otherKey in ipairs(otherKeys) do
            if otherKey ~= key then
                Config[otherKey] = false
            end
        end
    end
    if syncWithXTHub then
        pcall(syncWithXTHub)
    end
    triggerAutoSave()
end
local _origToggle = library.toggle
function library.toggle(self, options)
    if type(options) == "table" then
        options.type = "toggle"
        if options.enabled == nil and options.default ~= nil then
            options.enabled = options.default
        end
    end
    wrapWithAutoSave(options)
    local res = _origToggle(self, options)
    if res and res.items then
        res.enabled = (options and options.default ~= nil) and options.default or false
        if getconnections then
            pcall(function()
                if res.items["toggle_button"] then
                    for _, conn in ipairs(getconnections(res.items["toggle_button"].MouseButton1Click)) do
                        conn:Disable()
                    end
                end
                if res.items["toggle"] then
                    for _, conn in ipairs(getconnections(res.items["toggle"].MouseButton1Click)) do
                        conn:Disable()
                    end
                end
            end)
        end
        local lastClick = 0
        local function onToggleClicked()
            local now = tick()
            if now - lastClick < 0.15 then return end
            lastClick = now
            res.enabled = not res.enabled
            res.set(res.enabled)
        end
        if res.items["toggle"] then
            res.items["toggle"].MouseButton1Click:Connect(onToggleClicked)
        end
        if res.items["toggle_button"] then
            res.items["toggle_button"].MouseButton1Click:Connect(onToggleClicked)
        end
        local origSet = res.set
        res.set = function(bool)
            res.enabled = bool
            local r = origSet(bool)
            triggerAutoSave()
            return r
        end
    end
    return res
end
local _origDropdown = library.dropdown
function library.dropdown(self, options)
    wrapWithAutoSave(options)
    options = options or {}
    local rawItems = options.items or options.options or options.content or {}
    options.items = rawItems
    options.options = rawItems
    local dropWidth = options.width or 115
    options.width = dropWidth
    local res = _origDropdown(self, options)
    if res and res.items then
        if res.items["name"] and options.name then
            res.items["name"].Text = options.name
        end
        if res.items["name"] and res.items["dropdown"] then
            res.items["dropdown"].Size = UDim2.new(0, dropWidth, 0, 16)
            res.items["dropdown"].ClipsDescendants = true
            res.items["name"].AutomaticSize = Enum.AutomaticSize.None
            res.items["name"].Size = UDim2.new(1, -(dropWidth + 10), 0, 16)
            res.items["name"].TextTruncate = Enum.TextTruncate.AtEnd
            res.items["name"].ClipsDescendants = true
        end
        if res.items["sub_text"] then
            res.items["sub_text"].Size = UDim2.new(1, -22, 1, 0)
            res.items["sub_text"].Position = UDim2.new(0, 5, 0, 0)
            res.items["sub_text"].TextTruncate = Enum.TextTruncate.AtEnd
            res.items["sub_text"].ClipsDescendants = true
            res.items["sub_text"].TextXAlignment = Enum.TextXAlignment.Left
        end
        if res.items["indicator"] then
            res.items["indicator"].Image = "rbxassetid://10709790948"
            res.items["indicator"].ImageColor3 = Color3.fromRGB(160, 160, 175)
            res.items["indicator"].Size = UDim2.new(0, 12, 0, 12)
        end
        if res.items["dropdown"] and res.items["dropdown_holder"] then
            local dropBtn = res.items["dropdown"]
            local holder = res.items["dropdown_holder"]
            local outline = res.items["outline"]
            holder.ZIndex = 5000
            holder.ClipsDescendants = true
            holder.Visible = false
            if outline then
                outline.ZIndex = 5001
                outline.ClipsDescendants = true
            end
            local clickOutsideConn = nil
            local function disconnectClickOutside()
                if clickOutsideConn then
                    pcall(function() clickOutsideConn:Disconnect() end)
                    clickOutsideConn = nil
                end
            end
            res.set_visible = function(bool)
                res.open = bool
                if bool then
                    if library.current_open and library.current_open ~= res and library.current_open.set_visible then
                        pcall(function() library.current_open.set_visible(false) end)
                    end
                    library.current_open = res
                    local fullHeight = res.y_size or 0
                    if fullHeight == 0 and res.option_instances then
                        for _, opt in ipairs(res.option_instances) do
                            fullHeight = fullHeight + (opt.AbsoluteSize.Y > 0 and opt.AbsoluteSize.Y or 18) + 5
                        end
                    end
                    local maxOptW = dropBtn.AbsoluteSize.X
                    if res.option_instances then
                        for _, opt in ipairs(res.option_instances) do
                            local txt = opt.Text or ""
                            local estW = string.len(txt) * 9 + 36
                            pcall(function()
                                local sz = TextService:GetTextSize(txt, opt.TextSize or 14, opt.Font or Enum.Font.SourceSans, Vector2.new(2000, 50))
                                if sz.X + 36 > estW then
                                    estW = sz.X + 36
                                end
                            end)
                            if estW > maxOptW then
                                maxOptW = estW
                            end
                        end
                    end
                    local holderWidth = math.max(maxOptW, dropBtn.AbsoluteSize.X, 175)
                    local targetX = dropBtn.AbsolutePosition.X + dropBtn.AbsoluteSize.X - holderWidth
                    if targetX < 10 then
                        targetX = 10
                    end
                    local targetY = dropBtn.AbsolutePosition.Y + dropBtn.AbsoluteSize.Y + 3
                    local vpH = 1080
                    pcall(function()
                        vpH = workspace.CurrentCamera.ViewportSize.Y
                    end)
                    if targetY + fullHeight > vpH - 25 and dropBtn.AbsolutePosition.Y - fullHeight - 3 > 0 then
                        targetY = dropBtn.AbsolutePosition.Y - fullHeight - 3
                    end
                    holder.Position = UDim2.new(0, targetX, 0, targetY)
                    holder.Size = UDim2.new(0, holderWidth, 0, 0)
                    holder.Visible = true
                    pcall(function()
                        library:tween(holder, {Size = UDim2.new(0, holderWidth, 0, fullHeight)}, Enum.EasingStyle.Quad, 0.12)
                    end)
                    if res.option_instances then
                        for _, opt in ipairs(res.option_instances) do
                            opt.ZIndex = 5002
                            opt.Size = UDim2.new(1, -6, 0, (opt.AbsoluteSize.Y > 0 and opt.AbsoluteSize.Y or 18))
                            opt.TextTruncate = Enum.TextTruncate.None
                            opt.ClipsDescendants = false
                        end
                    end
                    disconnectClickOutside()
                    task.delay(0.05, function()
                        if res.open and not clickOutsideConn then
                            clickOutsideConn = UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                    local pos = input.Position
                                    local mX = pos.X
                                    local mY = pos.Y
                                    local hPos = holder.AbsolutePosition
                                    local hSize = holder.AbsoluteSize
                                    local bPos = dropBtn.AbsolutePosition
                                    local bSize = dropBtn.AbsoluteSize
                                    local inHolder = (mX >= hPos.X and mX <= hPos.X + hSize.X and mY >= hPos.Y and mY <= hPos.Y + hSize.Y)
                                    local inButton = (mX >= bPos.X and mX <= bPos.X + bSize.X and mY >= bPos.Y and mY <= bPos.Y + bSize.Y)
                                    if not inHolder and not inButton then
                                        res.set_visible(false)
                                    end
                                end
                            end)
                        end
                    end)
                else
                    disconnectClickOutside()
                    if library.current_open == res then
                        library.current_open = nil
                    end
                    pcall(function()
                        library:tween(holder, {Size = UDim2.new(0, holder.AbsoluteSize.X, 0, 0)}, Enum.EasingStyle.Quad, 0.1)
                    end)
                    task.delay(0.1, function()
                        if not res.open then
                            holder.Visible = false
                        end
                    end)
                end
            end
            local origRefresh = res.refresh_options
            if origRefresh then
                res.refresh_options = function(list)
                    origRefresh(list)
                    pcall(function()
                        if res.option_instances then
                            for _, opt in ipairs(res.option_instances) do
                                opt.ZIndex = 5002
                                opt.Size = UDim2.new(1, -6, 0, (opt.AbsoluteSize.Y > 0 and opt.AbsoluteSize.Y or 18))
                                opt.TextTruncate = Enum.TextTruncate.None
                                opt.ClipsDescendants = false
                            end
                        end
                    end)
                end
            end
        end
    end
    if res and res.set then
        local origSet = res.set
        res.set = function(value)
            origSet(value)
            pcall(function()
                if res.items and res.items["sub_text"] then
                    res.items["sub_text"].TextTruncate = Enum.TextTruncate.AtEnd
                    res.items["sub_text"].ClipsDescendants = true
                    local curText = res.items["sub_text"].Text
                    if options.multi and (not curText or curText == "" or curText == " ") then
                        res.items["sub_text"].Text = "None"
                    end
                end
            end)
        end
        pcall(function()
            if res.items and res.items["sub_text"] then
                res.items["sub_text"].TextTruncate = Enum.TextTruncate.AtEnd
                res.items["sub_text"].ClipsDescendants = true
                local curText = res.items["sub_text"].Text
                if options.multi and (not curText or curText == "" or curText == " ") then
                    res.items["sub_text"].Text = "None"
                end
            end
        end)
    end
    return res
end
local _origSlider = library.slider
function library.slider(self, options)
    options = options or {}
    local sliderDraggingNow = false
    local rawCb = options.callback
    local lastSliderSave = 0
    options.callback = function(val, ...)
        if rawCb then
            pcall(rawCb, val, ...)
        end
        if not sliderDraggingNow or (tick() - lastSliderSave >= 0.35) then
            lastSliderSave = tick()
            triggerAutoSave()
        end
    end
    local res = _origSlider(self, options)
    if res and res.items and res.items["slider"] then
        local bar = res.items["slider"]
        local rowBtn = res.items["slider_object"] or bar
        local valLbl = res.items["value"]
        local minV = res.min or options.min or options.minimum or 0
        local maxV = res.max or options.max or options.maximum or 100
        if res.items["right_components"] then
            res.items["right_components"].Size = UDim2.new(1, 0, 0, 22)
        end
        local function applySliderAtX(posX)
            local absW = bar.AbsoluteSize.X
            if absW <= 1 then return end
            local frac = math.clamp((posX - bar.AbsolutePosition.X) / absW, 0, 1)
            local targetVal = minV + (maxV - minV) * frac
            if res.set then
                res.set(targetVal)
            end
        end
        local activeTouch = nil
        local lockedScrolls = nil
        local function releaseTouchSlider()
            if not activeTouch then return end
            activeTouch = nil
            sliderDraggingNow = false
            restoreAncestorScrollFrames(lockedScrolls)
            lockedScrolls = nil
            if valLbl then
                pcall(function()
                    TweenService:Create(valLbl, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextColor3 = Color3.fromRGB(72, 72, 73) }):Play()
                end)
            end
            triggerAutoSave()
        end
        local function handleBegan(input, checkYBounds)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if checkYBounds then
                    local py = input.Position.Y
                    local by = bar.AbsolutePosition.Y
                    local bh = math.max(bar.AbsoluteSize.Y, 4)
                    if py < by - 10 or py > by + bh + 10 then
                        return
                    end
                end
                sliderDraggingNow = true
                applySliderAtX(input.Position.X)
            elseif input.UserInputType == Enum.UserInputType.Touch then
                if checkYBounds then
                    local py = input.Position.Y
                    local by = bar.AbsolutePosition.Y
                    local bh = math.max(bar.AbsoluteSize.Y, 4)
                    if py < by - 18 or py > by + bh + 18 then
                        return
                    end
                end
                activeTouch = input
                sliderDraggingNow = true
                lockedScrolls = collectAncestorScrollFrames(bar)
                if valLbl then
                    pcall(function()
                        TweenService:Create(valLbl, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                    end)
                end
                applySliderAtX(input.Position.X)
            end
        end
        bar.InputBegan:Connect(function(input)
            handleBegan(input, false)
        end)
        if rowBtn and rowBtn ~= bar then
            rowBtn.InputBegan:Connect(function(input)
                handleBegan(input, true)
            end)
        end
        library:connection(UserInputService.InputChanged, function(input)
            if activeTouch and (input == activeTouch or input.UserInputType == Enum.UserInputType.Touch) then
                applySliderAtX(input.Position.X)
            end
        end)
        library:connection(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if sliderDraggingNow and not activeTouch then
                    sliderDraggingNow = false
                    triggerAutoSave()
                end
            elseif activeTouch and (input == activeTouch or input.UserInputType == Enum.UserInputType.Touch) then
                releaseTouchSlider()
            end
        end)
    end
    return res
end
local _origColorpicker = library.colorpicker
function library.colorpicker(self, options)
    wrapWithAutoSave(options)
    local res = _origColorpicker(self, options)
    if res and res.items and res.set then
        local satBtn = res.items["sat"]
        local hueBtn = res.items["hue_gradient"]
        local alphaBtn = res.items["alpha_gradient"]
        local activePickerTouch = nil
        local activeMode = nil
        local pickerScrolls = nil
        local function applyPickerTouch(pos)
            local colObj = res.items["colorpicker"] and res.items["colorpicker"].BackgroundColor3 or Color3.new(1, 1, 1)
            local h, s, v = colObj:ToHSV()
            local flagData = res.flag and library.flags and library.flags[res.flag]
            local a = (type(flagData) == "table" and tonumber(flagData.Transparency)) or 0
            if activeMode == "sat" and satBtn and satBtn.AbsoluteSize.X > 0 and satBtn.AbsoluteSize.Y > 0 then
                s = math.clamp((pos.X - satBtn.AbsolutePosition.X) / satBtn.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((pos.Y - satBtn.AbsolutePosition.Y) / satBtn.AbsoluteSize.Y, 0, 1)
            elseif activeMode == "hue" and hueBtn and hueBtn.AbsoluteSize.X > 0 then
                h = math.clamp((pos.X - hueBtn.AbsolutePosition.X) / hueBtn.AbsoluteSize.X, 0, 1)
            elseif activeMode == "alpha" and alphaBtn and alphaBtn.AbsoluteSize.X > 0 then
                a = math.clamp(1 - (pos.X - alphaBtn.AbsolutePosition.X) / alphaBtn.AbsoluteSize.X, 0, 1)
            end
            res.set(Color3.fromHSV(h, s, v), a)
        end
        local function bindTouchSurface(btn, mode)
            if not btn then return end
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    activePickerTouch = input
                    activeMode = mode
                    pickerScrolls = collectAncestorScrollFrames(btn)
                    applyPickerTouch(input.Position)
                end
            end)
        end
        bindTouchSurface(satBtn, "sat")
        bindTouchSurface(hueBtn, "hue")
        bindTouchSurface(alphaBtn, "alpha")
        library:connection(UserInputService.InputChanged, function(input)
            if activePickerTouch and (input == activePickerTouch or input.UserInputType == Enum.UserInputType.Touch) then
                applyPickerTouch(input.Position)
            end
        end)
        library:connection(UserInputService.InputEnded, function(input)
            if activePickerTouch and (input == activePickerTouch or input.UserInputType == Enum.UserInputType.Touch) then
                activePickerTouch = nil
                activeMode = nil
                restoreAncestorScrollFrames(pickerScrolls)
                pickerScrolls = nil
            end
        end)
    end
    return res
end
local _origKeybind = library.keybind
function library.keybind(self, options)
    wrapWithAutoSave(options)
    return _origKeybind(self, options)
end
local _origTextbox = library.textbox
function library.textbox(self, options)
    wrapWithAutoSave(options)
    return _origTextbox(self, options)
end
local TAB_ICONS = {
    ["main"] = "rbxassetid://7072718631",
    ["auto play"] = "rbxassetid://7072720722",
    ["event"] = "rbxassetid://7072723105",
    ["configs"] = "rbxassetid://7072987508",
    ["settings"] = "rbxassetid://7072721682"
}
local function updateSidebarIcons()
    pcall(function()
        local root = library and library.items
        if not root then return end
        for _, img in ipairs(root:GetDescendants()) do
            if img:IsA("ImageLabel") and img.Image:find("6034767608") then
                local p = img.Parent
                if p and p:IsA("TextButton") then
                    for _, ch in ipairs(p:GetChildren()) do
                        if ch:IsA("TextLabel") and ch.Text then
                            local t = ch.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
                            if TAB_ICONS[t] then
                                img.Image = TAB_ICONS[t]
                            end
                        end
                    end
                end
            end
        end
    end)
end
local _origWindow = library.window
function library.window(self, properties)
    local win = _origWindow(self, properties)
    if win and win.items and win.items["main"] then
        local mainFrame = win.items["main"]
        library:attachDragHandle(mainFrame, mainFrame)
        if win.items["title"] then library:attachDragHandle(win.items["title"], mainFrame) end
        if win.items["side_frame"] then library:attachDragHandle(win.items["side_frame"], mainFrame) end
        if win.items["multi_holder"] then library:attachDragHandle(win.items["multi_holder"], mainFrame) end
        if win.items["info"] then library:attachDragHandle(win.items["info"], mainFrame) end
        local uiScale = mainFrame:FindFirstChild("AJMobileScale") or Instance.new("UIScale")
        uiScale.Name = "AJMobileScale"
        uiScale.Parent = mainFrame
        local function applyResponsiveLayout(centerIfNeeded)
            local vp = getViewportSize()
            local baseW = (mainFrame.Size.X.Offset > 0 and mainFrame.Size.X.Offset) or 760
            local baseH = (mainFrame.Size.Y.Offset > 0 and mainFrame.Size.Y.Offset) or 560
            local scale = 1
            if UserInputService.TouchEnabled or vp.X < (baseW + 32) or vp.Y < (baseH + 32) then
                scale = math.clamp(math.min((vp.X * 0.92) / baseW, (vp.Y * 0.88) / baseH), 0.44, 1)
            end
            uiScale.Scale = scale
            local scaledW = baseW * scale
            local scaledH = baseH * scale
            if centerIfNeeded then
                mainFrame.Position = UDim2.new(
                    0, math.max(0, math.floor((vp.X - scaledW) * 0.5)),
                    0, math.max(0, math.floor((vp.Y - scaledH) * 0.5))
                )
            else
                mainFrame.Position = clampFrameToViewport(mainFrame, mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
            end
        end
        applyResponsiveLayout(true)
        local cam = Workspace.CurrentCamera
        if cam then
            library:connection(cam:GetPropertyChangedSignal("ViewportSize"), function()
                applyResponsiveLayout(false)
            end)
        end
    end
    return win
end
local _origTab = library.tab
function library.tab(self, properties)
    properties = properties or {}
    local tabName = properties.name or properties.Name or ""
    local desiredIcon = properties.icon or properties.Icon or TAB_ICONS[tabName:lower()]
    local pages = {_origTab(self, properties)}
    task.spawn(function()
        for _ = 1, 5 do
            task.wait(0.1)
            updateSidebarIcons()
        end
    end)
    return unpack(pages)
end
Config = {
    AutoPlaceEnabled = true,
    PlaceStickToPlayers = false,
    AutoEquipPreset = false,
    TeamPreset = {},
    PathPercentage = 30,
    PlaceAnywhere = true,
    UseCustomPlacementArea = true,
    CustomPlacementAreas = {},
    AdvancedLanes = true,
    FlankSide = "Both Sides",
    ShowPlaceArea = true,
    ShowNextPlacement = true,
    FarmPathPercentage = 85,
    UpgradeFarmsFirst = false,
    SmartFarmUpgrade = false,
    AutoUpgradeEnabled = true,
    SmartCostBalancing = true,
    GlobalMaxUpgrades = 10,
    UpgradeInterval = 0.25,
    PlacementInterval = 0.3,
    PhoenixReincarnate = true,
    AutoAbilitiesEnabled = true,
    AbilityMode = "Whenever Ready",
    AbilityStartWave = 1,
    BossDetectionRange = 75,
    AbilityInterval = 0.35,
    AntiPunishments = true,
    AntiPunishment = false,
    AutoLoad = true,
    AutoLoadUrl = "https://raw.githubusercontent.com/antihypeCM/AA/refs/heads/main/AJHUB.lua",
    AutoStart = true,
    AutoWaveSkip = true,
    AutoReplay = false,
    AutoNextStory = false,
    AutoNextRoom = false,
    AutoNextPortal = false,
    AutoLeave = true,
    AutoBuffWendy = false,
    AutoBuffCommander = false,
    AutoGriffith = false,
    AutoGriffithWave = 1,
    MenuAccent = { R = 183, G = 176, B = 205, Hex = "B7B0CD" },
    MenuBind = { key = "NONE", mode = "Toggle", active = true },
    AutoFindMatchSummer = false,
    AutoJoinSummer = false,
    SummerSkipMap = "None",
    SummerSkipMaps = {},
    SummerSkipWeatherOpt = "None",
    SummerSkipWeather = {},
    AutoClaimMapBoard = false,
    AutoEventQuests = false,
    SummerLeaveLowLevel = false,
    SummerLowLevelUnder = 10,
    SummerLeaveWhenFound = 1,
    SummerLeaveFewPlayers = false,
    SummerLeaveUnder = 5,
    AutoBuyMerchant = false,
    MerchantItem = "All",
    MerchantItems = {"All"},
    KeepSummerPearls = 0,
    KeepGems = 0,
    AutoPickCards = true,
    PrimaryTakeCard = "Attack Damage",
    TakeCards = {"Summer Pearls", "Attack Damage", "Range", "Cooldown", "Boss Damage"},
    TakeCardsPriority = {},
    PrimaryAvoidCard = "Physical Resist",
    AvoidCards = {"Physical Resist", "Magic Resist", "Enemy Regen", "Enemy Speed", "Enemy Health"},
    AvoidCardsPriority = {},
    WebhookEnabled = false,
    WebhookUrl = "",
    WebhookPingSecret = true,
    AutoSummonEnabled = false,
    AutoSummonBanner = "Summer2026",
    AutoSummonType = "10x",
    AutoSummonSkipAnim = true,
    AutoSummonDelay = 0.5,
    AutoSummonSellUnits = false,
    AutoSummonSellUnitRarities = {"Rare", "Epic"},
    AutoSummonSellSkins = false,
    AutoSummonSellSkinRarities = {"Rare", "Epic"},
    AutoSummonKeepShiny = true,
    AutoPartyEnabled = true,
    PartyAutoInvite = true,
    PartyAutoAccept = true,
    PartyMainUser = "",
    PartyAltUsers = "",
    PartyWaitForMembers = false,
    BestForEventCurrency = true,
    DontShowDiscordPrompt = false,
    HybridGround = "None",
    HybridHill = "None",
    StoryWorld = "Planet Greenie",
    StoryAct = "Act 1",
    StoryDifficulty = "Normal",
    StoryFriendsOnly = false,
    AutoJoinStory = false,
    AutoFindMatchStory = false,
    JoinLastAct = false,
    WorldSkip = false,
    LegendStage = "Magic Hills (Elf Invasion)",
    LegendAct = "Act 1",
    AutoJoinLegend = false,
    AutoFindMatchLegend = false,
    RaidWorld = "Current Raid",
    RaidAct = "Act 1",
    AutoJoinRaid = false,
    AutoFindMatchRaid = false,
    ArtifactJoinMode = "Find Match",
    AutoJoinArtifact = false,
    AutoClaimArtifactRewards = false,
    MansionRoom = 1,
    MansionDifficulty = "Hard",
    AutoJoinMansion = false,
    JoinLastMansionRoom = false,
    AutoFindMatchMansion = false,
    ChallengeRewardFilter = "All / Any",
    AutoJoinChallenge = false,
    AutoFindMatchChallenge = false,
    AutoJoinDailyChallenge = false,
    AutoFindMatchDailyChallenge = false,
    UseCustomPlacementOrder = true,
    UseCustomUpgradeOrder = true,
    GlobalTargetPriority = "Auto",
    PlacementOrder = {1, 3, 6, 5, 2, 4},
    UpgradeOrder = {1, 3, 6, 5, 2, 4},
    SlotPlacement = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
    },
    SlotLimits = {
        [1] = 6,
        [2] = 6,
        [3] = 6,
        [4] = 6,
        [5] = 4,
        [6] = 4,
    },
    SlotMaxUpgrades = {
        [1] = 10,
        [2] = 10,
        [3] = 10,
        [4] = 10,
        [5] = 10,
        [6] = 10,
    },
    UnitCustomSettings = {
        [1] = { Amount = 6, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
        [2] = { Amount = 6, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
        [3] = { Amount = 6, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
        [4] = { Amount = 6, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
        [5] = { Amount = 4, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
        [6] = { Amount = 4, MaxUpgrade = 10, CustomPath = 0, Target = "Default", Ability = "Default", AbilityWave = 1, Reincarnate = false, IdealLoop = false, AutoGriffith = false, AutoGriffithWave = 1 },
    },
}
local function getAccountInfo()
    local p = LocalPlayer or game:GetService("Players").LocalPlayer
    local userId = (p and p.UserId and p.UserId > 0) and tostring(p.UserId) or "0"
    local rawName = (p and p.Name and #p.Name > 0) and p.Name or "Unknown"
    local cleanName = rawName:gsub("[^%w_%-]", "")
    return userId, cleanName, rawName
end
local function ensureConfigDirectories()
    pcall(function()
        if makefolder and isfolder then
            if not isfolder("AJ_HUB") then makefolder("AJ_HUB") end
            if not isfolder("AJ_HUB/accounts") then makefolder("AJ_HUB/accounts") end
        end
    end)
end
local function getAccountConfigPath(profileName)
    local userId, cleanName = getAccountInfo()
    ensureConfigDirectories()
    if profileName and #profileName > 0 and profileName ~= "Default" then
        local safeProfile = profileName:gsub("[^%w_%-]", "")
        return string.format("AJ_HUB/accounts/%s_%s_%s.json", cleanName, userId, safeProfile)
    end
    return string.format("AJ_HUB/accounts/%s_%s.json", cleanName, userId)
end
local function listAccountProfiles()
    local userId, cleanName = getAccountInfo()
    local prefix = string.format("%s_%s", cleanName, userId)
    local profiles = {"Default"}
    pcall(function()
        if listfiles and isfolder and isfolder("AJ_HUB/accounts") then
            for _, f in ipairs(listfiles("AJ_HUB/accounts")) do
                local filename = f:match("([^/\\]+)%.json$")
                if filename then
                    if filename == prefix then
                    elseif filename:sub(1, #prefix + 1) == prefix .. "_" then
                        local prof = filename:sub(#prefix + 2)
                        if #prof > 0 and not table.find(profiles, prof) then
                            table.insert(profiles, prof)
                        end
                    end
                end
            end
        end
    end)
    return profiles
end
local function deleteAccountConfig(profileName)
    if not profileName or profileName == "Default" then return false end
    local filePath = getAccountConfigPath(profileName)
    if delfile and isfile and isfile(filePath) then
        pcall(function() delfile(filePath) end)
        return true
    end
    return false
end
local function sanitizeLoadedConfig(tbl)
    if type(tbl) ~= "table" then return tbl end
    local clean = {}
    for k, v in pairs(tbl) do
        local numKey = tonumber(k)
        local finalKey = (numKey ~= nil) and numKey or k
        if type(v) == "table" then
            clean[finalKey] = sanitizeLoadedConfig(v)
        else
            clean[finalKey] = v
        end
    end
    if clean.TakeCardsPriority and type(clean.TakeCardsPriority) == "table" then
        local valid = {}
        for _, it in pairs(clean.TakeCardsPriority) do
            if type(it) == "table" and it.name then
                table.insert(valid, { name = tostring(it.name), limit = tonumber(it.limit) or 0 })
            elseif type(it) == "string" then
                table.insert(valid, { name = it, limit = 5 })
            end
        end
        clean.TakeCardsPriority = valid
    else
        clean.TakeCardsPriority = {}
    end
    if clean.AvoidCardsPriority and type(clean.AvoidCardsPriority) == "table" then
        local valid = {}
        for _, it in pairs(clean.AvoidCardsPriority) do
            if type(it) == "table" and it.name then
                table.insert(valid, { name = tostring(it.name), limit = tonumber(it.limit) or 0 })
            elseif type(it) == "string" then
                table.insert(valid, { name = it, limit = 0 })
            end
        end
        clean.AvoidCardsPriority = valid
    else
        clean.AvoidCardsPriority = {}
    end
    if clean.CustomPlacementAreas and type(clean.CustomPlacementAreas) == "table" then
        local validAreas = {}
        for mk, pData in pairs(clean.CustomPlacementAreas) do
            if type(pData) == "table" then
                local px = tonumber(pData.x or pData.X)
                local py = tonumber(pData.y or pData.Y)
                local pz = tonumber(pData.z or pData.Z)
                if px and py and pz then
                    validAreas[tostring(mk)] = {
                        x = px,
                        y = py,
                        z = pz,
                        name = pData.name and tostring(pData.name) or tostring(mk)
                    }
                end
            end
        end
        clean.CustomPlacementAreas = validAreas
    else
        clean.CustomPlacementAreas = {}
    end
    clean.UseCustomPlacementArea = (clean.UseCustomPlacementArea ~= false)
    clean.WebhookEnabled = (clean.WebhookEnabled == true)
    clean.WebhookUrl = tostring(clean.WebhookUrl or "")
    clean.WebhookPingSecret = (clean.WebhookPingSecret ~= false)
    if type(clean.AutoLoadUrl) == "string" and #clean.AutoLoadUrl > 10 then
        clean.AutoLoadUrl = clean.AutoLoadUrl
    else
        clean.AutoLoadUrl = "https://raw.githubusercontent.com/antihypeCM/AA/refs/heads/main/AJHUB.lua"
    end
    if clean.MenuAccent and type(clean.MenuAccent) == "table" then
        local hex = tostring(clean.MenuAccent.Hex or ""):lower()
        if hex == "f59e0b" or (clean.MenuAccent.R == 245 and clean.MenuAccent.G == 158 and clean.MenuAccent.B == 11) then
            clean.MenuAccent = { R = 183, G = 176, B = 205, Hex = "B7B0CD" }
        end
    end
    return clean
end
local _lastSavedSignature = nil
local _lastSavedPath = nil
saveConfigToFile = function(profileName, forceWrite)
    pcall(function()
        if not writefile then return end
        ensureConfigDirectories()
        local filePath = getAccountConfigPath(profileName)
        pcall(function()
            if library and library.flags then
                if library.flags["menu_accent"] and library.flags["menu_accent"].Color then
                    local c = library.flags["menu_accent"].Color
                    Config.MenuAccent = {
                        R = math.floor(c.R * 255),
                        G = math.floor(c.G * 255),
                        B = math.floor(c.B * 255),
                        Hex = c:ToHex()
                    }
                end
                if library.flags["menu_bind"] then
                    local b = library.flags["menu_bind"]
                    local kStr = "NONE"
                    if typeof(b.key) == "EnumItem" then
                        kStr = tostring(b.key)
                    elseif type(b.key) == "string" then
                        kStr = b.key
                    end
                    Config.MenuBind = {
                        key = kStr,
                        mode = b.mode or "Toggle",
                        active = b.active ~= false
                    }
                end
            end
        end)
        local flagsSnapshot = {}
        pcall(function()
            if library and library.flags then
                for k, v in pairs(library.flags) do
                    if type(v) == "table" and v.key then
                        local kStr = typeof(v.key) == "EnumItem" and tostring(v.key) or tostring(v.key or "NONE")
                        flagsSnapshot[k] = { active = v.active, mode = v.mode, key = kStr }
                    elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                        local hexCol = typeof(v["Color"]) == "Color3" and v["Color"]:ToHex() or tostring(v["Color"])
                        flagsSnapshot[k] = { Transparency = v["Transparency"], Color = hexCol }
                    elseif typeof(v) == "Color3" then
                        flagsSnapshot[k] = { Color = v:ToHex() }
                    elseif typeof(v) == "EnumItem" then
                        flagsSnapshot[k] = tostring(v)
                    else
                        flagsSnapshot[k] = v
                    end
                end
            end
        end)
        local userId, cleanName, rawName = getAccountInfo()
        local signature = HttpService:JSONEncode({
            Profile = profileName or "Default",
            Config = Config,
            LibraryFlags = flagsSnapshot
        })
        if not forceWrite and _lastSavedSignature == signature and _lastSavedPath == filePath then
            return
        end
        local payload = {
            Version = "2.1",
            SavedAt = os.time(),
            Account = {
                UserId = userId,
                Username = rawName,
            },
            Profile = profileName or "Default",
            Config = Config,
            LibraryFlags = flagsSnapshot
        }
        local json = HttpService:JSONEncode(payload)
        writefile(filePath, json)
        pcall(writefile, "AJ_HUB_Config.json", json)
        _lastSavedSignature = signature
        _lastSavedPath = filePath
        if getgenv().AJ_HUB_CONFIG then
            getgenv().AJ_HUB_CONFIG = Config
        end
    end)
end
loadConfigFromFile = function(profileName)
    local ok, count = pcall(function()
        if not readfile or not isfile then return 0 end
        ensureConfigDirectories()
        local filePath = getAccountConfigPath(profileName)
        local raw = nil
        if isfile(filePath) then
            raw = readfile(filePath)
        elseif not profileName or profileName == "Default" then
            local userId, cleanName = getAccountInfo()
            local fallbackPaths = {
                string.format("AJ_HUB/accounts/%s.json", userId),
                string.format("AJ_HUB_Config_%s.json", userId),
                string.format("AJ_HUB_Config_%s.json", cleanName),
                string.format("Anime-Adventures_%s.json", cleanName),
                "AJ_HUB_Config.json"
            }
            for _, altPath in ipairs(fallbackPaths) do
                if isfile(altPath) then
                    local testRaw = readfile(altPath)
                    if testRaw and #testRaw > 5 then
                        raw = testRaw
                        break
                    end
                end
            end
        end
        if not raw or #raw < 5 then return 0 end
        local data = HttpService:JSONDecode(raw)
        if not data or not data.Config then return 0 end
        _isLoadingConfig = true
        local clean = sanitizeLoadedConfig(data.Config)
        local loaded = 0
        for k, v in pairs(clean) do
            Config[k] = v
            loaded = loaded + 1
        end
        if data.LibraryFlags and type(data.LibraryFlags) == "table" and library and library.config_flags then
            for flagKey, flagVal in pairs(data.LibraryFlags) do
                local setFn = library.config_flags[flagKey]
                if setFn and flagKey ~= "config_name_text" and flagKey ~= "cloud_cfg_code_input" then
                    pcall(function()
                        if type(flagVal) == "table" and flagVal["Transparency"] and flagVal["Color"] then
                            local hexCol = tostring(flagVal["Color"]):gsub("#", "")
                            setFn(Color3.fromHex(hexCol), flagVal["Transparency"])
                        elseif type(flagVal) == "table" and flagVal["Color"] and not flagVal["key"] then
                            local hexCol = tostring(flagVal["Color"]):gsub("#", "")
                            setFn(Color3.fromHex(hexCol))
                        elseif type(flagVal) == "table" and flagVal["key"] then
                            local kEnum = library:convert_enum(flagVal.key)
                            setFn({
                                mode = flagVal.mode or "Toggle",
                                key = kEnum or flagVal.key,
                                active = flagVal.active ~= false
                            })
                        else
                            setFn(flagVal)
                        end
                    end)
                end
            end
        end
        if State then
            State.CurrentProfile = profileName or "Default"
            if State.TakePriorityUI and State.TakePriorityUI.refresh then
                pcall(State.TakePriorityUI.refresh)
            end
            if State.AvoidPriorityUI and State.AvoidPriorityUI.refresh then
                pcall(State.AvoidPriorityUI.refresh)
            end
            if State.updatePlacementMarker then
                pcall(State.updatePlacementMarker)
            end
        end
        if getgenv().AJ_HUB_UPDATE_CARDS then
            pcall(getgenv().AJ_HUB_UPDATE_CARDS)
        end
        _isLoadingConfig = false
        if not isfile(filePath) then
            task.delay(0.5, function()
                saveConfigToFile(profileName)
            end)
        end
        return loaded
    end)
    _isLoadingConfig = false
    return ok and count or 0
end

saveConfigToCloud = function(profileName)
    local ok, result = pcall(function()
        local flagsSnapshot = {}
        pcall(function()
            if library and library.flags then
                for k, v in pairs(library.flags) do
                    if type(v) == "table" and v.key then
                        local kStr = typeof(v.key) == "EnumItem" and tostring(v.key) or tostring(v.key or "NONE")
                        flagsSnapshot[k] = { active = v.active, mode = v.mode, key = kStr }
                    elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                        local hexCol = typeof(v["Color"]) == "Color3" and v["Color"]:ToHex() or tostring(v["Color"])
                        flagsSnapshot[k] = { Transparency = v["Transparency"], Color = hexCol }
                    elseif typeof(v) == "Color3" then
                        flagsSnapshot[k] = { Color = v:ToHex() }
                    elseif typeof(v) == "EnumItem" then
                        flagsSnapshot[k] = tostring(v)
                    else
                        flagsSnapshot[k] = v
                    end
                end
            end
        end)

        local cfgCopy = {}
        for k, v in pairs(Config) do
            cfgCopy[k] = v
        end
        -- Privacy: do not export personal webhook or party usernames to cloud
        cfgCopy.WebhookUrl = ""
        cfgCopy.WebhookEnabled = false
        cfgCopy.PartyMainUser = ""
        cfgCopy.PartyAltUsers = ""

        if flagsSnapshot then
            flagsSnapshot["party_main_user"] = ""
            flagsSnapshot["party_alt_users"] = ""
            flagsSnapshot["webhook_url_input"] = ""
        end

        local payload = {
            Version = "2.1",
            Type = "AJ_HUB_CLOUD_CONFIG",
            SavedAt = os.time(),
            Account = {
                UserId = "0",
                Username = "Anonymous"
            },
            Profile = profileName or (State and State.CurrentProfile) or "Default",
            Config = cfgCopy,
            LibraryFlags = flagsSnapshot
        }

        local jsonStr = HttpService:JSONEncode(payload)
        local finalCode = nil
        local req = request or http_request or (syn and syn.request) or (http and http.request)

        -- Provider 1: dpaste.com (produces clean codes like AJ-8AT2FAKR6)
        if req then
            pcall(function()
                local postBody = "content=" .. HttpService:UrlEncode(jsonStr) .. "&expiry_days=365&title=AJ_HUB"
                local res = req({
                    Url = "https://dpaste.com/api/v2/",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/x-www-form-urlencoded"
                    },
                    Body = postBody
                })
                if res and type(res) == "table" and res.Body then
                    local pasteUrl = tostring(res.Body):gsub("^%s+", ""):gsub("%s+$", "")
                    local id = pasteUrl:match("dpaste%.com/([%w]+)")
                    if id and #id >= 3 then
                        finalCode = "AJ-" .. id:upper()
                    end
                end
            end)
        end

        -- Provider 2: api.pastes.dev fallback
        if not finalCode and req then
            pcall(function()
                local res = req({
                    Url = "https://api.pastes.dev/post",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "text/plain"
                    },
                    Body = jsonStr
                })
                if res and type(res) == "table" and res.Body then
                    local id = tostring(res.Body):match('"key"%s*:%s*"([^"]+)"')
                    if id and #id >= 3 then
                        finalCode = "AJ-" .. id
                    end
                end
            end)
        end

        -- Provider 3: haste.zneix.eu fallback
        if not finalCode and req then
            pcall(function()
                local res = req({
                    Url = "https://haste.zneix.eu/documents",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "text/plain"
                    },
                    Body = jsonStr
                })
                if res and type(res) == "table" and res.Body then
                    local id = tostring(res.Body):match('"key"%s*:%s*"([^"]+)"')
                    if id and #id >= 3 then
                        finalCode = "AJ-H-" .. id
                    end
                end
            end)
        end

        if finalCode then
            pcall(function()
                if setclipboard then
                    setclipboard(finalCode)
                elseif toclipboard then
                    toclipboard(finalCode)
                end
            end)
            return finalCode
        end
        error("Cloud upload failed across all providers")
    end)

    if ok and result then
        return true, result
    end
    return false, tostring(result or "Upload failed")
end

loadConfigFromCloud = function(cloudCode)
    if not cloudCode or type(cloudCode) ~= "string" then
        return false, "Invalid code"
    end
    local raw = cloudCode:gsub("^%s+", ""):gsub("%s+$", "")
    if #raw == 0 then
        return false, "Empty code"
    end

    local urlCandidates = {}
    if raw:find("dpaste%.com") then
        local id = raw:match("dpaste%.com/([%w]+)")
        if id then
            table.insert(urlCandidates, "https://dpaste.com/" .. id .. ".txt")
        end
    elseif raw:find("pastes%.dev") then
        local id = raw:match("pastes%.dev/([%w]+)")
        if id then
            table.insert(urlCandidates, "https://api.pastes.dev/" .. id)
        end
    elseif raw:find("haste") then
        local id = raw:match("/raw/([%w]+)") or raw:match("/([%w]+)$")
        if id then
            table.insert(urlCandidates, "https://haste.zneix.eu/raw/" .. id)
        end
    elseif raw:upper():sub(1, 5) == "AJ-P-" then
        local id = raw:sub(6):gsub("%s+", "")
        table.insert(urlCandidates, "https://api.pastes.dev/" .. id)
    elseif raw:upper():sub(1, 5) == "AJ-H-" then
        local id = raw:sub(6):gsub("%s+", "")
        table.insert(urlCandidates, "https://haste.zneix.eu/raw/" .. id)
    elseif raw:upper():sub(1, 5) == "AJ-D-" then
        local id = raw:sub(6):gsub("%s+", "")
        table.insert(urlCandidates, "https://dpaste.com/" .. id .. ".txt")
    else
        local cleanId = raw
        if raw:upper():sub(1, 3) == "AJ-" then
            cleanId = raw:sub(4):gsub("^%s+", ""):gsub("%s+$", "")
        end
        table.insert(urlCandidates, "https://dpaste.com/" .. cleanId .. ".txt")
        table.insert(urlCandidates, "https://dpaste.com/" .. cleanId:upper() .. ".txt")
        table.insert(urlCandidates, "https://api.pastes.dev/" .. cleanId)
        table.insert(urlCandidates, "https://haste.zneix.eu/raw/" .. cleanId)
    end

    local content = nil
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    for _, targetUrl in ipairs(urlCandidates) do
        local okG, resG = pcall(function()
            return game:HttpGet(targetUrl)
        end)
        if okG and type(resG) == "string" and #resG > 10 and not resG:find("<!DOCTYPE") and not resG:find("Page not found") and not resG:find("Invalid path") then
            content = resG
            break
        end
        if req then
            local okR, resR = pcall(function()
                return req({
                    Url = targetUrl,
                    Method = "GET"
                })
            end)
            if okR and type(resR) == "table" and (resR.StatusCode == 200 or resR.Status == 200) and type(resR.Body) == "string" and #resR.Body > 10 then
                if not resR.Body:find("<!DOCTYPE") and not resR.Body:find("Page not found") and not resR.Body:find("Invalid path") then
                    content = resR.Body
                    break
                end
            end
        end
    end

    if not content or #content < 5 then
        return false, "Could not fetch configuration data for code: " .. raw
    end

    local okDecode, decoded = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if not okDecode or type(decoded) ~= "table" then
        return false, "Failed to parse JSON config"
    end

    local cfgData = decoded.Config or decoded
    if type(cfgData) ~= "table" then
        return false, "No valid config object found"
    end

    _isLoadingConfig = true
    local existingMainUser = Config.PartyMainUser
    local existingAltUsers = Config.PartyAltUsers
    local existingWebhookUrl = Config.WebhookUrl
    local existingWebhookEnabled = Config.WebhookEnabled

    local clean = sanitizeLoadedConfig(cfgData)
    local loadedCount = 0
    for k, v in pairs(clean) do
        Config[k] = v
        loadedCount = loadedCount + 1
    end

    -- Keep player's own party usernames and webhook intact
    if existingMainUser and #existingMainUser > 0 then
        Config.PartyMainUser = existingMainUser
    end
    if existingAltUsers and #existingAltUsers > 0 then
        Config.PartyAltUsers = existingAltUsers
    end
    if existingWebhookUrl and #existingWebhookUrl > 0 then
        Config.WebhookUrl = existingWebhookUrl
        Config.WebhookEnabled = existingWebhookEnabled
    end

    if decoded.LibraryFlags and type(decoded.LibraryFlags) == "table" and library and library.config_flags then
        for flagKey, flagVal in pairs(decoded.LibraryFlags) do
            local setFn = library.config_flags[flagKey]
            if setFn and flagKey ~= "config_name_text" and flagKey ~= "cloud_cfg_code_input" and flagKey ~= "party_main_user" and flagKey ~= "party_alt_users" and flagKey ~= "webhook_url_input" then
                pcall(function()
                    if type(flagVal) == "table" and flagVal["Transparency"] and flagVal["Color"] then
                        local hexCol = tostring(flagVal["Color"]):gsub("#", "")
                        setFn(Color3.fromHex(hexCol), flagVal["Transparency"])
                    elseif type(flagVal) == "table" and flagVal["Color"] and not flagVal["key"] then
                        local hexCol = tostring(flagVal["Color"]):gsub("#", "")
                        setFn(Color3.fromHex(hexCol))
                    elseif type(flagVal) == "table" and flagVal["key"] then
                        local kEnum = library:convert_enum(flagVal.key)
                        setFn({
                            mode = flagVal.mode or "Toggle",
                            key = kEnum or flagVal.key,
                            active = flagVal.active ~= false
                        })
                    else
                        setFn(flagVal)
                    end
                end)
            end
        end
    end

    local cleanProfileName = "Cloud_" .. (raw:upper():gsub("[^%w_%-]", ""))
    if State then
        State.CurrentProfile = cleanProfileName
        if State.TakePriorityUI and State.TakePriorityUI.refresh then
            pcall(State.TakePriorityUI.refresh)
        end
        if State.AvoidPriorityUI and State.AvoidPriorityUI.refresh then
            pcall(State.AvoidPriorityUI.refresh)
        end
        if State.updatePlacementMarker then
            pcall(State.updatePlacementMarker)
        end
    end
    if getgenv().AJ_HUB_UPDATE_CARDS then
        pcall(getgenv().AJ_HUB_UPDATE_CARDS)
    end

    pcall(function()
        saveConfigToFile(cleanProfileName, true)
        saveConfigToFile(nil, true)
    end)

    _isLoadingConfig = false
    return true, loadedCount, cleanProfileName
end

getgenv().AJ_HUB_SAVE_CONFIG = saveConfigToFile
getgenv().AJ_HUB_LOAD_CONFIG = loadConfigFromFile
getgenv().AJ_HUB_SAVE_CLOUD_CONFIG = saveConfigToCloud
getgenv().AJ_HUB_LOAD_CLOUD_CONFIG = loadConfigFromCloud
local loadedFields = loadConfigFromFile()
if loadedFields == 0 then
    saveConfigToFile()
end
State = {
    UIInitialized = false,
    CurrentProfile = "Default",
    CurrentMapKey = nil,
    CurrentMapName = nil,
    CurrentMapData = nil,
    PickingPlacementArea = false,
    PlacementPickConn = nil,
    Lanes = {},
    Spots = {},
    NextSpot = nil,
    NextSlot = nil,
    NextUnitInfo = nil,
    FailedSpots = {},
    PhoenixSold = {},
    LastPlacementTime = 0,
    LastUpgradeTime = 0,
    LastAbilityTime = 0,
    LastTargetCheckTime = 0,
    LastSkipTime = 0,
    LastAntiAfkTime = 0,
    AntiAfkConnection = nil,
    AntiPunishIdx = nil,
    AntiPunishForward = true,
    AntiPunishWaypointStartTime = 0,
    AntiPunishLastMoveTime = 0,
    AntiPunishWalking = false,
    LastStartVoteTime = 0,
    LastMatchActionTime = 0,
    GriffinBuffCompleted = false,
    LastGriffinAction = 0,
    LastGridCompute = 0,
    LastLobbyCheck = 0,
    WebhookSentForCurrentMatch = false,
    WebhookInProgress = false,
    MatchStartTime = tick(),
    LastMatchSettings = nil,
    LastDroppedItems = nil,
    LastDroppedUnits = nil,
    MatchSessionDrops = {
        items = {},
        normalItems = {},
        units = {},
        dropMessages = {},
        hasSecret = false,
    },
    _clearDropsOnNextMatch = false,
}
getgenv().AJ_HUB_CONFIG = Config
getgenv().AJ_HUB_STATE = State

local resetMatchSessionDrops = function()
    State.MatchSessionDrops = {
        items = {},
        normalItems = {},
        units = {},
        dropMessages = {},
        hasSecret = false,
    }
end

local hookResultsUI = function()
    local sinks = getgenv()._AJ_HUB_WEBHOOK_SINKS
    if not sinks then
        sinks = {}
        getgenv()._AJ_HUB_WEBHOOK_SINKS = sinks
    end

    sinks.isInMatch = function()
        if game.PlaceId == 8304191830 then return false end
        return Workspace:FindFirstChild("_DATA") ~= nil and Workspace:FindFirstChild("_BASES") ~= nil
    end

    sinks.onGameFinished = function(data)
        if type(data) == "table" then
            State.LastMatchSettings = data
        end
    end

    sinks.onShowUnitAndItemRewards = function(new_items, new_units, opts)
        if type(new_items) == "table" then
            State.LastDroppedItems = new_items
        end
        if type(new_units) == "table" then
            State.LastDroppedUnits = new_units
        end
        if type(opts) == "table" and type(opts.new_resources) == "table" then
            State.MatchSessionDrops = State.MatchSessionDrops or {items = {}, normalItems = {}, units = {}, dropMessages = {}, hasSecret = false}
            for _, nr in ipairs(opts.new_resources) do
                if type(nr) == "table" and nr.resource and tonumber(nr.amount) then
                    table.insert(State.MatchSessionDrops.dropMessages, {resource = nr.resource, amount = tonumber(nr.amount)})
                end
            end
        end
        pcall(function()
            local autoSellHook = getgenv()._AJ_HUB_AUTOSUMMON_ON_REWARDS
            if autoSellHook then
                autoSellHook(new_items, new_units)
            end
        end)
    end

    sinks.onResetForRematch = function()
        if not State.WebhookInProgress then
            State.LastMatchSettings = nil
            State.LastDroppedItems = nil
            State.LastDroppedUnits = nil
            State.WebhookSentForCurrentMatch = false
            State._clearDropsOnNextMatch = false
            resetMatchSessionDrops()
        else
            State._clearDropsOnNextMatch = true
        end
    end

    sinks.onUniqueItemAdded = function(itemObj)
        if not sinks.isInMatch() then return end
        if type(itemObj) ~= "table" then return end
        State.MatchSessionDrops = State.MatchSessionDrops or {items = {}, normalItems = {}, units = {}, dropMessages = {}, hasSecret = false}
        table.insert(State.MatchSessionDrops.items, itemObj)
    end

    sinks.onNormalItemAdded = function(itemId, amount)
        if not sinks.isInMatch() then return end
        local amt = tonumber(amount) or 1
        if not itemId or amt <= 0 then return end
        State.MatchSessionDrops = State.MatchSessionDrops or {items = {}, normalItems = {}, units = {}, dropMessages = {}, hasSecret = false}
        State.MatchSessionDrops.normalItems[itemId] = (State.MatchSessionDrops.normalItems[itemId] or 0) + amt
    end

    sinks.onUnitAdded = function(unitObj)
        if not sinks.isInMatch() then return end
        if type(unitObj) ~= "table" and type(unitObj) ~= "string" then return end
        State.MatchSessionDrops = State.MatchSessionDrops or {items = {}, normalItems = {}, units = {}, dropMessages = {}, hasSecret = false}
        table.insert(State.MatchSessionDrops.units, unitObj)
    end

    sinks.onDropMessage = function(itemId, amount, extra)
        if not sinks.isInMatch() then return end
        State.MatchSessionDrops = State.MatchSessionDrops or {items = {}, normalItems = {}, units = {}, dropMessages = {}, hasSecret = false}
        if itemId ~= nil then
            table.insert(State.MatchSessionDrops.dropMessages, {
                itemId = itemId,
                amount = tonumber(amount) or 1,
                extra = type(extra) == "table" and extra or nil,
            })
        elseif type(extra) == "table" then
            table.insert(State.MatchSessionDrops.dropMessages, {
                amount = tonumber(amount) or 1,
                extra = extra,
            })
        end
    end

    pcall(function()
        local endpoints = game:GetService("ReplicatedStorage"):FindFirstChild("endpoints")
        local s2c = endpoints and endpoints:FindFirstChild("server_to_client")
        if s2c then
            if s2c:FindFirstChild("game_finished") and not s2c.game_finished:GetAttribute("AJHookedV2") then
                s2c.game_finished:SetAttribute("AJHookedV2", true)
                s2c.game_finished.OnClientEvent:Connect(function(data)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onGameFinished then s.onGameFinished(data) end
                end)
            end
            if s2c:FindFirstChild("show_unit_and_item_rewards") and not s2c.show_unit_and_item_rewards:GetAttribute("AJHookedV2") then
                s2c.show_unit_and_item_rewards:SetAttribute("AJHookedV2", true)
                s2c.show_unit_and_item_rewards.OnClientEvent:Connect(function(new_items, new_units, _, _, _, opts)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onShowUnitAndItemRewards then s.onShowUnitAndItemRewards(new_items, new_units, opts) end
                end)
            end
            if s2c:FindFirstChild("unique_item_added") and not s2c.unique_item_added:GetAttribute("AJHookedV2") then
                s2c.unique_item_added:SetAttribute("AJHookedV2", true)
                s2c.unique_item_added.OnClientEvent:Connect(function(itemObj)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onUniqueItemAdded then s.onUniqueItemAdded(itemObj) end
                end)
            end
            if s2c:FindFirstChild("normal_item_added") and not s2c.normal_item_added:GetAttribute("AJHookedV2") then
                s2c.normal_item_added:SetAttribute("AJHookedV2", true)
                s2c.normal_item_added.OnClientEvent:Connect(function(itemId, amount)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onNormalItemAdded then s.onNormalItemAdded(itemId, amount) end
                end)
            end
            if s2c:FindFirstChild("unit_added") and not s2c.unit_added:GetAttribute("AJHookedV2") then
                s2c.unit_added:SetAttribute("AJHookedV2", true)
                s2c.unit_added.OnClientEvent:Connect(function(unitObj)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onUnitAdded then s.onUnitAdded(unitObj) end
                end)
            end
            if s2c:FindFirstChild("show_drop_message") and not s2c.show_drop_message:GetAttribute("AJHookedV2") then
                s2c.show_drop_message:SetAttribute("AJHookedV2", true)
                s2c.show_drop_message.OnClientEvent:Connect(function(itemId, amount, extra)
                    local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                    if s and s.onDropMessage then s.onDropMessage(itemId, amount, extra) end
                end)
            end
        end
    end)
    pcall(function()
        local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
        local guiService = Loader.load_client_service(nil, "GUIService")
        local rUI = guiService and guiService.results_ui
        if rUI then
            local mt = getmetatable(rUI)
            if mt and mt.__index then
                if mt.__index.show_results and not mt.__index._aj_hooked_v2 then
                    mt.__index._aj_hooked_v2 = true
                    local old_show_results = mt.__index.show_results
                    mt.__index.show_results = function(self, settings, ...)
                        pcall(function()
                            local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                            if s and s.onGameFinished then s.onGameFinished(settings) end
                        end)
                        return old_show_results(self, settings, ...)
                    end
                end
                if mt.__index.show_unit_and_item_rewards and not mt.__index._aj_items_hooked_v2 then
                    mt.__index._aj_items_hooked_v2 = true
                    local old_show_items = mt.__index.show_unit_and_item_rewards
                    mt.__index.show_unit_and_item_rewards = function(self, ...)
                        local st = self and self.settings
                        if st and type(st) == "table" then
                            local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                            if s and s.onGameFinished then s.onGameFinished(st) end
                        end
                        return old_show_items(self, ...)
                    end
                end
                if mt.__index.reset_for_rematch and not mt.__index._aj_reset_hooked_v2 then
                    mt.__index._aj_reset_hooked_v2 = true
                    local old_reset = mt.__index.reset_for_rematch
                    mt.__index.reset_for_rematch = function(self, ...)
                        pcall(function()
                            local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                            if s and s.onResetForRematch then s.onResetForRematch() end
                        end)
                        return old_reset(self, ...)
                    end
                end
            end
        end
        local summonService = Loader.load_client_service(nil, "SummonServiceClient")
        if summonService then
            local smt = getmetatable(summonService) or summonService
            local targetTable = (smt and smt.__index and type(smt.__index) == "table") and smt.__index or summonService
            if targetTable.show_unit_and_item_rewards and not targetTable._aj_rewards_hooked_v5 then
                targetTable._aj_rewards_hooked_v5 = true
                local old_rewards = targetTable.show_unit_and_item_rewards
                targetTable.show_unit_and_item_rewards = function(a1, a2, a3, a4, a5, a6, ...)
                    local extraOpts = select(1, ...)
                    pcall(function()
                        local s = getgenv()._AJ_HUB_WEBHOOK_SINKS
                        if s and s.onShowUnitAndItemRewards then
                            if a1 == summonService or a1 == targetTable then
                                s.onShowUnitAndItemRewards(a2, a3, type(extraOpts) == "table" and extraOpts or a6)
                            else
                                s.onShowUnitAndItemRewards(a1, a2, a6)
                            end
                        end
                    end)
                    pcall(function()
                        local autoSellHook = getgenv()._AJ_HUB_AUTOSUMMON_ON_REWARDS
                        if autoSellHook then
                            local itm = (a1 == summonService or a1 == targetTable) and a2 or a1
                            local unt = (a1 == summonService or a1 == targetTable) and a3 or a2
                            if not unt and type(itm) == "table" and #itm > 0 and type(itm[1]) == "string" then
                                unt = itm
                                itm = nil
                            end
                            autoSellHook(itm, unt)
                        end
                    end)
                    return old_rewards(a1, a2, a3, a4, a5, a6, ...)
                end
            end
        end
    end)
end
hookResultsUI()

do
    local function hookSummonAnimationSkip()
        pcall(function()
            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local sfx = Loader.load_client_service(nil, "SummonFX")
            if sfx and not sfx._aj_open_star_hooked then
                sfx._aj_open_star_hooked = true
                local orig_open_star = sfx.open_star_new
                sfx.open_star_new = function(...)
                    if Config.AutoSummonSkipAnim then
                        local args = {...}
                        local callback = args[5]
                        if callback then
                            task.spawn(callback)
                        end
                        pcall(function()
                            local gs = Loader.load_client_service(nil, "GUIService")
                            if gs and gs.summon_ui then
                                gs.summon_ui.hatching = false
                                if gs.summon_ui.screenGUI then
                                    gs.summon_ui.screenGUI.Enabled = false
                                end
                            end
                            local lp = Players.LocalPlayer
                            if lp then
                                lp.CameraMinZoomDistance = 0.5
                            end
                        end)
                        return
                    end
                    return orig_open_star(...)
                end
            end

            local ssc = Loader.load_client_service(nil, "SummonServiceClient")
            if ssc and not ssc._aj_hatch_fx_hooked then
                ssc._aj_hatch_fx_hooked = true
                local orig_hatch_fx = ssc.on_show_hatch_effect
                ssc.on_show_hatch_effect = function(...)
                    if Config.AutoSummonSkipAnim then
                        return
                    end
                    return orig_hatch_fx(...)
                end
                local orig_item_hatch_fx = ssc.on_show_item_hatch_effect
                ssc.on_show_item_hatch_effect = function(...)
                    if Config.AutoSummonSkipAnim then
                        return
                    end
                    return orig_item_hatch_fx(...)
                end
            end
        end)
    end
    hookSummonAnimationSkip()
end

local isLobby = function()
    if game.PlaceId == 8304191830 then return true end
    if not Workspace:FindFirstChild("_DATA") or not Workspace:FindFirstChild("_BASES") then
        return true
    end
    return false
end

State.getLoader = function()
    if not State._CachedLoader then
        pcall(function()
            State._CachedLoader = require(ReplicatedStorage:WaitForChild("src"):WaitForChild("Loader"))
        end)
    end
    return State._CachedLoader
end

State.getUnitsData = function()
    if not State._CachedUnitsData then
        local l = State.getLoader()
        if l and l.load_data then
            pcall(function()
                State._CachedUnitsData = l.load_data(nil, "Units")
            end)
        end
    end
    return State._CachedUnitsData
end
local getUnitsData = function() return State.getUnitsData() end
local getLoader = function() return State.getLoader() end
local isFarmUnit = function(unitInput)
    if not unitInput then return false end
    local name = ""
    local id = ""
    if type(unitInput) == "table" then
        name = tostring(unitInput.name or unitInput.Name or ""):lower()
        id = tostring(unitInput.id or unitInput.unitId or ""):lower()
    elseif type(unitInput) == "string" then
        name = unitInput:lower()
    elseif typeof and typeof(unitInput) == "Instance" then
        name = unitInput.Name:lower()
        local stats = unitInput:FindFirstChild("_stats")
        id = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
        if stats then
            local fa = stats:FindFirstChild("farm_amount")
            if fa and type(fa.Value) == "number" and fa.Value > 0 then
                return true
            end
            local bfa = stats:FindFirstChild("base_farm_amount")
            if bfa and type(bfa.Value) == "number" and bfa.Value > 0 then
                return true
            end
            local isF = stats:FindFirstChild("is_farm")
            if isF and isF.Value == true then
                return true
            end
        end
        if unitInput:GetAttribute("is_farm") or unitInput:GetAttribute("farm") then
            return true
        end
    end
    local combined = (name .. " " .. id):lower()
    if combined:find("bulm") ~= nil
        or combined:find("bulb") ~= nil
        or combined:find("ceo") ~= nil
        or combined:find("c%.e%.o") ~= nil
        or combined:find("speedwagon") ~= nil
        or combined:find("speedcart") ~= nil
        or combined:find("speed_cart") ~= nil
        or combined:find("idol") ~= nil
        or combined:find("hoshino") ~= nil
        or combined:find("otaku") ~= nil
        or combined:find("farm") ~= nil
        or combined:find("nami") ~= nil
        or combined:find("burglar") ~= nil
        or combined:find("weather girl") ~= nil
        or combined:find("chiyo") ~= nil
        or combined:find("celeb") ~= nil
        or combined:find("money") ~= nil
        or combined:find("income") ~= nil then
        return true
    end
    local UnitsData = getUnitsData()
    local db = UnitsData and (UnitsData[id] or UnitsData[name])
    if db then
        if db.farm_amount ~= nil or db.is_farm == true or db._show_as_farm_unit == true or db.money ~= nil or db.income ~= nil then
            return true
        end
    end
    return false
end
State.isFarmUnit = isFarmUnit
local isCEOUnit = function(unitInput)
    if not unitInput then return false end
    local name = ""
    local id = ""
    if type(unitInput) == "table" then
        name = tostring(unitInput.name or unitInput.Name or ""):lower()
        id = tostring(unitInput.id or unitInput.unitId or ""):lower()
    elseif type(unitInput) == "string" then
        name = unitInput:lower()
    elseif typeof and typeof(unitInput) == "Instance" then
        name = unitInput.Name:lower()
        local stats = unitInput:FindFirstChild("_stats")
        id = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
    end
    local cleanName = name:gsub("[%s%.%-_]", "")
    local cleanId = id:gsub("[%s%.%-_]", "")
    return cleanName == "ceo"
        or cleanName:find("ceo") ~= nil
        or cleanName:find("speedwagon") ~= nil
        or cleanName:find("speedcart") ~= nil
        or cleanId == "ceo"
        or cleanId:find("ceo") ~= nil
        or cleanId:find("speedwagon") ~= nil
        or cleanId:find("speedcart") ~= nil
end
local isShadowgirlUnit = function(unitInput)
    if not unitInput then return false end
    local name = ""
    local id = ""
    if type(unitInput) == "table" then
        name = tostring(unitInput.name or unitInput.Name or ""):lower()
        id = tostring(unitInput.id or unitInput.unitId or ""):lower()
    elseif type(unitInput) == "string" then
        name = unitInput:lower()
        id = unitInput:lower()
    elseif typeof and typeof(unitInput) == "Instance" then
        name = unitInput.Name:lower()
        local stats = unitInput:FindFirstChild("_stats")
        id = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
    end
    local cleanName = name:gsub("[%s%.%-_]", "")
    local cleanId = id:gsub("[%s%.%-_]", "")
    return cleanName:find("shadowgirl") ~= nil
        or cleanName:find("homura") ~= nil
        or cleanId:find("shadowgirl") ~= nil
        or cleanId:find("homura") ~= nil
end
State.isGriffinUnit = function(unitInput)
    if not unitInput then return false end
    local name = ""
    local id = ""
    if type(unitInput) == "table" then
        name = tostring(unitInput.name or unitInput.Name or ""):lower()
        id = tostring(unitInput.id or unitInput.unitId or ""):lower()
    elseif type(unitInput) == "string" then
        name = unitInput:lower()
        id = unitInput:lower()
    elseif typeof and typeof(unitInput) == "Instance" then
        name = unitInput.Name:lower()
        local stats = unitInput:FindFirstChild("_stats")
        id = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
    end
    local cleanName = name:gsub("[%s%.%-_]", "")
    local cleanId = id:gsub("[%s%.%-_]", "")
    return cleanName:find("griff") ~= nil
        or cleanName:find("femto") ~= nil
        or cleanId:find("griff") ~= nil
        or cleanId:find("femto") ~= nil
end
State.isBuffFodderUnit = function(unitInput)
    if not unitInput then return false end
    local name = ""
    local id = ""
    if type(unitInput) == "table" then
        name = tostring(unitInput.name or unitInput.Name or ""):lower()
        id = tostring(unitInput.id or unitInput.unitId or ""):lower()
    elseif type(unitInput) == "string" then
        name = unitInput:lower()
        id = unitInput:lower()
    elseif typeof and typeof(unitInput) == "Instance" then
        name = unitInput.Name:lower()
        local stats = unitInput:FindFirstChild("_stats")
        id = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
    end
    local combined = (name .. " " .. id):lower()
    if combined:find("wendy") ~= nil
        or combined:find("erwin") ~= nil
        or combined:find("commander") ~= nil
        or combined:find("leafy") ~= nil
        or combined:find("brook") ~= nil
        or combined:find("soulking") ~= nil
        or combined:find("shunsui") ~= nil
        or combined:find("buff") ~= nil then
        return true
    end
    local UnitsData = getUnitsData and getUnitsData()
    local db = UnitsData and (UnitsData[id] or UnitsData[name])
    if db and db._show_as_buff_unit == true then
        return true
    end
    return false
end
local refreshAllLanes = function()
    local lanes = {}
    local pveBases = Workspace:FindFirstChild("_BASES") and Workspace._BASES:FindFirstChild("pve")
    local lanesFolder = pveBases and pveBases:FindFirstChild("LANES")
    if lanesFolder then
        for _, laneObj in ipairs(lanesFolder:GetChildren()) do
            local pts = {}
            local spawnPart = laneObj:FindFirstChild("spawn")
            if spawnPart and spawnPart:IsA("BasePart") then
                table.insert(pts, spawnPart.Position)
            end
            for i = 1, 60 do
                local pt = laneObj:FindFirstChild(tostring(i))
                if pt and pt:IsA("BasePart") then
                    table.insert(pts, pt.Position)
                end
            end
            local finalPart = laneObj:FindFirstChild("final")
            if finalPart and finalPart:IsA("BasePart") then
                table.insert(pts, finalPart.Position)
            end
            if #pts >= 2 then
                lanes[laneObj.Name] = pts
            end
        end
    end
    if next(lanes) == nil then
        local pts = {}
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            table.insert(pts, pos)
            table.insert(pts, pos + char.HumanoidRootPart.CFrame.LookVector * 100)
        else
            table.insert(pts, Vector3.new(0, 0, 0))
            table.insert(pts, Vector3.new(0, 0, 100))
        end
        lanes["1"] = pts
    end
    State.Lanes = lanes
    return lanes
end
local getPointAndDirectionAtDistance = function(distFromStart, waypoints)
    local accumulated = 0
    for i = 1, #waypoints - 1 do
        local p0 = waypoints[i]
        local p1 = waypoints[i + 1]
        local segLen = (p1 - p0).Magnitude
        if distFromStart <= (accumulated + segLen) or i == (#waypoints - 1) then
            local alpha = 0
            if segLen > 0 then
                alpha = math.clamp((distFromStart - accumulated) / segLen, 0, 1)
            end
            local pos = p0:Lerp(p1, alpha)
            local dir = Vector3.new(0, 0, -1)
            if segLen > 0 then
                dir = (p1 - p0).Unit
            end
            return pos, dir
        end
        accumulated = accumulated + segLen
    end
    return waypoints[#waypoints], Vector3.new(0, 0, -1)
end

local _CachedUnitCollection = nil
local function getUnitCollectionServiceClient()
    if not _CachedUnitCollection then
        local l = getLoader()
        if l and l.load_client_service then
            pcall(function()
                _CachedUnitCollection = l.load_client_service(nil, "UnitCollectionServiceClient")
            end)
        end
    end
    return _CachedUnitCollection
end
local _CachedEndpointsClient = nil
local function getEndpointsClient()
    if not _CachedEndpointsClient then
        local l = getLoader()
        if l and l.load_client_service then
            pcall(function()
                _CachedEndpointsClient = l.load_client_service(nil, "EndpointsClient")
            end)
        end
    end
    return _CachedEndpointsClient
end
local _CachedGUIService = nil
local function getGUIService()
    if not _CachedGUIService then
        local l = getLoader()
        if l and l.load_client_service then
            pcall(function()
                _CachedGUIService = l.load_client_service(nil, "GUIService")
            end)
        end
    end
    return _CachedGUIService
end
local _CachedUnitServiceCore = nil
local function getUnitServiceCore()
    if not _CachedUnitServiceCore then
        local l = getLoader()
        if l and l.load_core_service then
            pcall(function()
                _CachedUnitServiceCore = l.load_core_service(nil, "UnitServiceCore")
            end)
        end
    end
    return _CachedUnitServiceCore
end
local _lastOwnedCheck = 0
local _cachedOwned = {}
local getOwnedUnitsInGame = function(force)
    local now = tick()
    if not force and (now - _lastOwnedCheck < 0.15) and #_cachedOwned > 0 then
        return _cachedOwned
    end
    _lastOwnedCheck = now
    local owned = {}
    local unitsFolder = Workspace:FindFirstChild("_UNITS")
    if not unitsFolder then
        _cachedOwned = owned
        return owned
    end
    for _, unit in ipairs(unitsFolder:GetChildren()) do
        local stats = unit:FindFirstChild("_stats")
        if stats and stats:FindFirstChild("player") and stats.player.Value == LocalPlayer then
            table.insert(owned, unit)
        end
    end
    _cachedOwned = owned
    return owned
end
local _lastEquippedCheck = 0
local _cachedEquipped = {}
local getEquippedUnits = function(force)
    local now = tick()
    if not force and (now - _lastEquippedCheck < 0.25) and #_cachedEquipped > 0 then
        local owned = getOwnedUnitsInGame()
        local placedCounts = {}
        for _, u in ipairs(owned) do
            local stats = u:FindFirstChild("_stats")
            if stats and stats:FindFirstChild("id") then
                local id = stats.id.Value
                placedCounts[id] = (placedCounts[id] or 0) + 1
            end
        end
        for _, eq in ipairs(_cachedEquipped) do
            local curPlaced = (eq.unitId and placedCounts[eq.unitId]) or 0
            eq.cur = curPlaced
            eq.canPlaceMore = (curPlaced < eq.max)
        end
        State.EquippedUnits = _cachedEquipped
        return _cachedEquipped
    end
    _lastEquippedCheck = now
    local units = {}
    local UnitsData = getUnitsData()
    local UnitCollectionServiceClient = getUnitCollectionServiceClient()
    local owned = getOwnedUnitsInGame(true)
    local placedCounts = {}
    for _, u in ipairs(owned) do
        local stats = u:FindFirstChild("_stats")
        if stats and stats:FindFirstChild("id") then
            local id = stats.id.Value
            placedCounts[id] = (placedCounts[id] or 0) + 1
        end
    end
    local spawnGui = LocalPlayer.PlayerGui:FindFirstChild("spawn_units")
    if spawnGui and spawnGui:FindFirstChild("Lives") and spawnGui.Lives:FindFirstChild("Frame") then
        local grid = spawnGui.Lives.Frame:FindFirstChild("Units")
        if grid then
            for slotIndex = 1, 6 do
                local slotFrame = grid:FindFirstChild(tostring(slotIndex))
                if slotFrame and slotFrame:IsA("GuiObject") then
                    local uuid = slotFrame:GetAttribute("_equipped_frame_unit_uuid")
                    if uuid and uuid ~= "" then
                        local nameLabel = slotFrame:FindFirstChild("name", true)
                        local textLabel = slotFrame:FindFirstChild("text", true)
                        local unitName = nameLabel and nameLabel.Text or ("Slot " .. slotIndex)
                        local cost = 500
                        if textLabel and textLabel.Text then
                            local stripped = (string.gsub(textLabel.Text, "%D", ""))
                            local parsed = tonumber(stripped)
                            if parsed and parsed > 0 then
                                cost = parsed
                            end
                        end
                        local unitId = nil
                        local isHillUnit = false
                        local isHybrid = false
                        local isUniqueTrait = false
                        local dbCap = Config.SlotLimits[slotIndex] or 4
                        if UnitCollectionServiceClient then
                            local uData = UnitCollectionServiceClient.get_equipped_unit_by_uuid(uuid)
                            if uData then
                                unitId = uData.unit_id
                                if uData.traits then
                                    for _, t in ipairs(uData.traits) do
                                        if t.trait == "unique" then
                                            isUniqueTrait = true
                                            break
                                        end
                                    end
                                end
                                if UnitsData and UnitsData[unitId] then
                                    local db = UnitsData[unitId]
                                    if db.cost and cost == 500 then
                                        cost = db.cost
                                    end
                                    if db.spawn_cap then
                                        dbCap = db.spawn_cap
                                    end
                                    isHillUnit = (db.hill_unit == true)
                                    isHybrid = (db.hybrid_placement == true)
                                end
                            end
                        end
                        local maxPlaced = isUniqueTrait and 1 or math.min(Config.SlotLimits[slotIndex] or 6, dbCap)
                        local curPlaced = (unitId and placedCounts[unitId]) or 0
                        table.insert(units, {
                            slot = slotIndex,
                            uuid = uuid,
                            name = unitName,
                            unitId = unitId,
                            cost = cost,
                            cur = curPlaced,
                            max = maxPlaced,
                            spawnCap = dbCap,
                            canPlaceMore = (curPlaced < maxPlaced),
                            isHill = isHillUnit,
                            isHybrid = isHybrid
                        })
                    end
                end
            end
        end
    end
    _cachedEquipped = units
    State.EquippedUnits = units
    return units
end
local getUnitSlot = function(unit, equippedUnits)
    local stats = unit:FindFirstChild("_stats")
    if not stats then return nil end
    local unitUuid = stats:FindFirstChild("uuid") and stats.uuid.Value
    if not unitUuid then return nil end
    local unitId = stats:FindFirstChild("id") and stats.id.Value
    for _, eq in ipairs(equippedUnits) do
        if eq.uuid == unitUuid and (not unitId or not eq.unitId or eq.unitId == unitId) then
            return eq.slot, eq.name
        end
    end
    return nil, unit.Name
end
local getCurrentWave = function()
    local waveGui = LocalPlayer.PlayerGui:FindFirstChild("Waves") or LocalPlayer.PlayerGui:FindFirstChild("wave_gui")
    if waveGui then
        local waveNum = waveGui:FindFirstChild("WaveNumber", true)
        if waveNum and waveNum:IsA("TextLabel") then
            local w = tonumber(waveNum.Text:match("%d+"))
            if w then return w end
        end
        local waveTxt = waveGui:FindFirstChild("Wave", true)
        if waveTxt and waveTxt:IsA("TextLabel") then
            local w = tonumber(waveTxt.Text:match("%d+"))
            if w then return w end
        end
    end
    local topStats = Workspace:FindFirstChild("_stats")
    if topStats and topStats:FindFirstChild("wave") then
        return topStats.wave.Value
    end
    return 1
end
local getPlayerMoney = function()
    local playerStats = LocalPlayer:FindFirstChild("_stats")
    if playerStats and playerStats:FindFirstChild("resource") then
        return playerStats.resource.Value
    end
    return 0
end

local computeCompactGrid, renderVisualGrid

State.getUnitRealRadius = function(unitOrInfo)
    if not unitOrInfo then return 1.55 end
    if not State.UnitRadiusCache then
        State.UnitRadiusCache = setmetatable({}, { __mode = "k" })
    end

    if typeof(unitOrInfo) == "Instance" then
        if State.UnitRadiusCache[unitOrInfo] then
            return State.UnitRadiusCache[unitOrInfo]
        end
        local stats = unitOrInfo:FindFirstChild("_stats")
        local id = stats and stats:FindFirstChild("id") and stats.id.Value
        if id and State.UnitRadiusCache[id] then
            State.UnitRadiusCache[unitOrInfo] = State.UnitRadiusCache[id]
            return State.UnitRadiusCache[id]
        end
        local hb = unitOrInfo:FindFirstChild("_hitbox")
        if hb and hb:IsA("BasePart") then
            local r = math.max(hb.Size.X, hb.Size.Z) * 0.5
            r = math.clamp(r, 1.15, 3.2)
            if id then State.UnitRadiusCache[id] = r end
            State.UnitRadiusCache[unitOrInfo] = r
            return r
        end
        local root = (unitOrInfo:IsA("Model") and unitOrInfo.PrimaryPart) or unitOrInfo:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            local r = math.max(root.Size.X, root.Size.Z) * 0.5
            r = math.clamp(r, 1.15, 3.2)
            if id then State.UnitRadiusCache[id] = r end
            State.UnitRadiusCache[unitOrInfo] = r
            return r
        end
        State.UnitRadiusCache[unitOrInfo] = 1.55
        return 1.55
    end

    local unitId = unitOrInfo.unitId
    local unitName = (unitOrInfo.name or ""):lower()
    if unitId and State.UnitRadiusCache[unitId] then
        return State.UnitRadiusCache[unitId]
    end

    local unitsFolder = Workspace:FindFirstChild("_UNITS")
    if unitsFolder then
        for _, u in ipairs(unitsFolder:GetChildren()) do
            local stats = u:FindFirstChild("_stats")
            if stats and stats:FindFirstChild("id") and (stats.id.Value == unitId or u.Name:lower():find(unitName, 1, true)) then
                local r = State.getUnitRealRadius(u)
                if unitId then State.UnitRadiusCache[unitId] = r end
                return r
            end
        end
    end

    if unitName:find("erwin") or unitName:find("buddha") or unitName:find("broly") or unitName:find("titan") or unitName:find("whitebeard") or unitName:find("edward") or unitName:find("susanoo") then
        return 2.35
    elseif unitName:find("speedwagon") or unitName:find("bulma") or unitName:find("idol") or unitName:find("farm") or unitName:find("todoroki") or unitName:find("luffy") or unitName:find("zoro") then
        return 1.25
    elseif unitOrInfo.isHill then
        return 1.35
    end

    return 1.55
end

State.isSummonUnit = function(unit, stats, UnitsData)
    if not unit then return true end
    if not stats and typeof and typeof(unit) == "Instance" then
        stats = unit:FindFirstChild("_stats")
    end
    if not stats then return true end
    local uuidVal = stats:FindFirstChild("uuid")
    if not uuidVal or uuidVal.Value == nil or uuidVal.Value == "" then return true end
    for _, flag in ipairs({"is_summon", "summoned", "summon", "parent_unit", "summoner", "owner_unit", "spawned_by"}) do
        local v = stats:FindFirstChild(flag) or unit:FindFirstChild(flag)
        if v and (not v:IsA("ValueBase") or (v.Value ~= nil and v.Value ~= false and v.Value ~= "")) then
            return true
        end
        if unit:GetAttribute(flag) then return true end
    end
    local idVal = stats:FindFirstChild("id")
    local id = idVal and tostring(idVal.Value) or ""
    local db = UnitsData and UnitsData[id]
    if db and (db.is_summon or db.summon or db.summoned_unit or db.spawn_script or db.not_humanoid_rig or db.cost == 0) then return true end
    local n = (unit.Name .. " " .. id):lower()
    return n:find("summon") ~= nil or n:find("minion") ~= nil or n:find("clone") ~= nil
        or n:find("jellyfish") ~= nil or n:find("abyssal") ~= nil or n:find("eel") ~= nil
        or n:find("rider") ~= nil or n:find("scout corps") ~= nil or n:find("generic") ~= nil
        or n:find("summer2_") ~= nil
end

State.getOtherPlayersAnchors = function()
    if isLobby() then
        State.StickClusterCenter = nil
        State.PlayerAnchors = {}
        return State.PlayerAnchors
    end

    if State.StickClusterCenter then
        State.PlayerAnchors = { State.StickClusterCenter }
        State.PlayerAnchorsTime = tick()
        return State.PlayerAnchors
    end

    local cacheDuration = (State.PlayerAnchors and #State.PlayerAnchors > 0) and 2.5 or 1.2
    if State.PlayerAnchors and tick() - (State.PlayerAnchorsTime or 0) < cacheDuration then
        return State.PlayerAnchors
    end

    if not State.CachedMapSpawns or #State.CachedMapSpawns == 0 then
        local spawns = {}
        local pveBases = Workspace:FindFirstChild("_BASES") and Workspace._BASES:FindFirstChild("pve")
        local lanesFolder = pveBases and pveBases:FindFirstChild("LANES")
        if lanesFolder then
            for _, laneObj in ipairs(lanesFolder:GetChildren()) do
                local spawnPart = laneObj:FindFirstChild("spawn")
                if spawnPart and spawnPart:IsA("BasePart") then
                    table.insert(spawns, spawnPart.Position)
                else
                    local pt1 = laneObj:FindFirstChild("1")
                    if pt1 and pt1:IsA("BasePart") then
                        table.insert(spawns, pt1.Position)
                    end
                end
            end
        end
        if #spawns == 0 and State.Lanes then
            for _, pts in pairs(State.Lanes) do
                if pts and #pts > 0 then
                    table.insert(spawns, pts[1])
                end
            end
        end
        State.CachedMapSpawns = spawns
    end
    local spawns = State.CachedMapSpawns or {}

    local otherUnits = {}
    local myUnits = {}
    local folder = Workspace:FindFirstChild("_UNITS")
    local UnitsData = getUnitsData()
    if folder then
        for _, unit in ipairs(folder:GetChildren()) do
            local stats = unit:FindFirstChild("_stats")
            local ownerVal = stats and stats:FindFirstChild("player")
            local owner = ownerVal and ownerVal.Value
            if owner and owner:IsA("Player") then
                local isFarm = isFarmUnit(unit)
                if not isFarm and stats then
                    local fa = stats:FindFirstChild("farm_amount")
                    local bfa = stats:FindFirstChild("base_farm_amount")
                    if (fa and type(fa.Value) == "number" and fa.Value > 0) or (bfa and type(bfa.Value) == "number" and bfa.Value > 0) then
                        isFarm = true
                    end
                    local isF = stats:FindFirstChild("is_farm")
                    if isF and isF.Value == true then
                        isFarm = true
                    end
                end
                local idVal = stats and stats:FindFirstChild("id")
                local id = idVal and idVal.Value
                local db = UnitsData and id and UnitsData[id]
                if not isFarm and db then
                    if db.farm_amount ~= nil or db.is_farm == true or db._show_as_farm_unit == true or db.money ~= nil or db.income ~= nil then
                        isFarm = true
                    end
                end
                if not isFarm and not State.isSummonUnit(unit, stats, UnitsData) then
                    local root = unit.PrimaryPart or unit:FindFirstChild("HumanoidRootPart") or unit:FindFirstChildWhichIsA("BasePart")
                    local pos = root and root.Position
                    if pos then
                        local minDistToSpawn = math.huge
                        for _, sPos in ipairs(spawns) do
                            local d = (pos - sPos).Magnitude
                            if d < minDistToSpawn then minDistToSpawn = d end
                        end
                        local entry = { pos = pos, distToSpawn = minDistToSpawn }
                        if owner == LocalPlayer then
                            table.insert(myUnits, entry)
                        else
                            table.insert(otherUnits, entry)
                        end
                    end
                end
            end
        end
    end

    if #otherUnits > 1 then
        table.sort(otherUnits, function(a, b)
            return a.distToSpawn < b.distToSpawn
        end)
    end

    local chosenAnchor = nil
    if #otherUnits > 0 then
        chosenAnchor = otherUnits[1].pos
        State.StickClusterCenter = chosenAnchor
        State.LastGridCompute = 0
        if not State._computingGrid then
            task.spawn(computeCompactGrid)
        end
    end

    local anchors = {}
    if chosenAnchor then
        table.insert(anchors, chosenAnchor)
    end

    State.PlayerAnchors = anchors
    State.PlayerAnchorsTime = tick()
    return anchors
end

State.getMapKey = function()
    if isLobby() then return nil end
    if State.CurrentMapKey and State.CurrentMapKey ~= "" then
        return State.CurrentMapKey
    end
    local mapCfg = Workspace:FindFirstChild("_MAP_CONFIG")
    if mapCfg then
        local rFunc = mapCfg:FindFirstChild("GetLevelData")
        if rFunc and rFunc:IsA("RemoteFunction") then
            local ok, data = pcall(function() return rFunc:InvokeServer() end)
            if ok and type(data) == "table" then
                State.CurrentMapData = data
                local k = data.id or data.map or data.name or data._location_name
                if k and tostring(k) ~= "" then
                    State.CurrentMapKey = tostring(k)
                    State.CurrentMapName = tostring(data.name or data._location_name or data.map or k)
                    return State.CurrentMapKey
                end
            end
        end
        if mapCfg:FindFirstChild("MapName") and mapCfg.MapName.Value and mapCfg.MapName.Value ~= "" then
            local diff = mapCfg:FindFirstChild("Difficulty") and ("_" .. mapCfg.Difficulty.Value) or ""
            State.CurrentMapKey = tostring(mapCfg.MapName.Value) .. diff
            State.CurrentMapName = tostring(mapCfg.MapName.Value)
            return State.CurrentMapKey
        end
        if mapCfg:FindFirstChild("Level") and mapCfg.Level.Value and mapCfg.Level.Value ~= "" then
            State.CurrentMapKey = tostring(mapCfg.Level.Value)
            State.CurrentMapName = State.CurrentMapKey
            return State.CurrentMapKey
        end
        if mapCfg:FindFirstChild("Area") and mapCfg.Area.Value and mapCfg.Area.Value ~= "" then
            State.CurrentMapKey = tostring(mapCfg.Area.Value)
            State.CurrentMapName = State.CurrentMapKey
            return State.CurrentMapKey
        end
    end
    if State.CurrentMatchLevel and tostring(State.CurrentMatchLevel) ~= "" then
        State.CurrentMapKey = tostring(State.CurrentMatchLevel)
        State.CurrentMapName = State.CurrentMapKey
        return State.CurrentMapKey
    end
    State.CurrentMapKey = "Place_" .. tostring(game.PlaceId)
    State.CurrentMapName = State.CurrentMapKey
    return State.CurrentMapKey
end

State.getCustomPlacementArea = function()
    if isLobby() then return nil end
    if not Config.UseCustomPlacementArea then return nil end
    if not Config.CustomPlacementAreas then return nil end
    local mapKey = State.getMapKey()
    if mapKey and Config.CustomPlacementAreas[mapKey] then
        local entry = Config.CustomPlacementAreas[mapKey]
        local px = tonumber(entry.x or entry.X)
        local py = tonumber(entry.y or entry.Y)
        local pz = tonumber(entry.z or entry.Z)
        if px and py and pz then return Vector3.new(px, py, pz) end
    end
    if State.CurrentMapData and type(State.CurrentMapData) == "table" then
        local altKeys = { State.CurrentMapData.id, State.CurrentMapData.map, State.CurrentMapData._location_name, State.CurrentMapData.name }
        for _, altKey in ipairs(altKeys) do
            if altKey and Config.CustomPlacementAreas[tostring(altKey)] then
                local entry = Config.CustomPlacementAreas[tostring(altKey)]
                local px = tonumber(entry.x or entry.X)
                local py = tonumber(entry.y or entry.Y)
                local pz = tonumber(entry.z or entry.Z)
                if px and py and pz then return Vector3.new(px, py, pz) end
            end
        end
    end
    return nil
end

State.findClosestLanePoint = function(pos)
    local bestPoint = nil
    local bestDist = math.huge
    if State.Lanes then
        for _, waypoints in pairs(State.Lanes) do
            for _, wp in ipairs(waypoints) do
                local d = (wp - pos).Magnitude
                if d < bestDist then
                    bestDist = d
                    bestPoint = wp
                end
            end
        end
    end
    return bestPoint or (pos + Vector3.new(0, 0, 10))
end

State.updatePlacementMarker = function()
    local markerFolder = Camera:FindFirstChild("_AJ_HUB_PlacementMarker") or Workspace:FindFirstChild("_AJ_HUB_PlacementMarker")
    if isLobby() or not Config.UseCustomPlacementArea then
        if markerFolder then markerFolder:Destroy() end
        return
    end
    local customPos = State.getCustomPlacementArea()
    if not customPos then
        if markerFolder then markerFolder:Destroy() end
        return
    end
    if not markerFolder then
        markerFolder = Instance.new("Folder")
        markerFolder.Name = "_AJ_HUB_PlacementMarker"
        markerFolder.Parent = Camera
    end

    local freeGround = 0
    local freeHills = 0
    if State.Spots then
        for _, s in ipairs(State.Spots) do
            if s.isCustomArea and not s.occupied and not State.FailedSpots[s.index] then
                if s.isHill then
                    freeHills = freeHills + 1
                else
                    freeGround = freeGround + 1
                end
            end
        end
    end

    local oldPillar = markerFolder:FindFirstChild("CenterPillar")
    if oldPillar then oldPillar:Destroy() end
    local oldDisc = markerFolder:FindFirstChild("AreaDisc")
    if oldDisc then oldDisc:Destroy() end

    local ringPart = markerFolder:FindFirstChild("CustomArea_Ring")
    if not ringPart then
        ringPart = Instance.new("Part")
        ringPart.Name = "CustomArea_Ring"
        ringPart.Size = Vector3.new(36, 0.08, 36)
        ringPart.CFrame = CFrame.new(customPos + Vector3.new(0, 0.04, 0))
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CanQuery = false
        ringPart.CanTouch = false
        ringPart.Transparency = 1
        ringPart.Parent = markerFolder

        local sg = Instance.new("SurfaceGui")
        sg.Face = Enum.NormalId.Top
        sg.CanvasSize = Vector2.new(256, 256)
        sg.AlwaysOnTop = false
        sg.Parent = ringPart

        local img = Instance.new("ImageLabel")
        img.Name = "RingImage"
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://126246915031212"
        img.ImageColor3 = Color3.fromRGB(245, 158, 11)
        img.ImageTransparency = 0.35
        img.Parent = sg
    else
        ringPart.CFrame = CFrame.new(customPos + Vector3.new(0, 0.04, 0))
    end

    local tagPart = markerFolder:FindFirstChild("CustomArea_TagPart")
    if not tagPart then
        tagPart = Instance.new("Part")
        tagPart.Name = "CustomArea_TagPart"
        tagPart.Size = Vector3.new(0.1, 0.1, 0.1)
        tagPart.Position = customPos
        tagPart.Anchored = true
        tagPart.CanCollide = false
        tagPart.CanQuery = false
        tagPart.CanTouch = false
        tagPart.Transparency = 1
        tagPart.Parent = markerFolder

        local bb = Instance.new("BillboardGui")
        bb.Name = "MarkerBillboard"
        bb.Size = UDim2.new(0, 240, 0, 26)
        bb.StudsOffset = Vector3.new(0, 5.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = tagPart
        bb.Parent = tagPart

        local card = Instance.new("Frame")
        card.Name = "Card"
        card.Size = UDim2.new(1, 0, 1, 0)
        card.BackgroundColor3 = Color3.fromRGB(20, 20, 21)
        card.BackgroundTransparency = 0.15
        card.Parent = bb

        local pc = Instance.new("UICorner")
        pc.CornerRadius = UDim.new(0, 6)
        pc.Parent = card

        local ps = Instance.new("UIStroke")
        ps.Name = "Stroke"
        ps.Color = Color3.fromRGB(245, 158, 11)
        ps.Thickness = 1.2
        ps.Transparency = 0.10
        ps.Parent = card

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(251, 191, 36)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = string.format("Custom Area  ·  Saved  ·  %d ground  ·  %d hill", freeGround, freeHills)
        lbl.Parent = card
    else
        tagPart.Position = customPos
        local bb = tagPart:FindFirstChild("MarkerBillboard")
        local card = bb and bb:FindFirstChild("Card")
        local lbl = card and card:FindFirstChild("Label")
        if lbl then
            lbl.Text = string.format("Custom Area  ·  Saved  ·  %d ground  ·  %d hill", freeGround, freeHills)
        end
    end
end

State.startPickingPlacementArea = function()
    if isLobby() then
        if library and library.notifications and library.notifications.create_notification then
            library.notifications:create_notification({
                name = "AJ HUB",
                info = "Enter a match first to click and set placement area for that map!"
            })
        end
        return
    end
    if State.PickingPlacementArea then
        State.PickingPlacementArea = false
        if State.PlacementPickConn then
            State.PlacementPickConn:Disconnect()
            State.PlacementPickConn = nil
        end
        local hoverFolder = Camera:FindFirstChild("_AJ_HUB_HoverMarker")
        if hoverFolder then hoverFolder:Destroy() end
        if library and library.notifications and library.notifications.create_notification then
            library.notifications:create_notification({
                name = "AJ HUB",
                info = "Cancelled placement area picker."
            })
        end
        return
    end
    State.PickingPlacementArea = true
    if library and library.notifications and library.notifications.create_notification then
        library.notifications:create_notification({
            name = "AJ HUB",
            info = "Click on the map to set placement area! (Right-click or ESC to cancel)"
        })
    end

    local hoverFolder = Camera:FindFirstChild("_AJ_HUB_HoverMarker")
    if not hoverFolder then
        hoverFolder = Instance.new("Folder")
        hoverFolder.Name = "_AJ_HUB_HoverMarker"
        hoverFolder.Parent = Camera
    end
    hoverFolder:ClearAllChildren()

    local hoverRing = Instance.new("Part")
    hoverRing.Name = "HoverRing"
    hoverRing.Size = Vector3.new(36, 0.08, 36)
    hoverRing.Anchored = true
    hoverRing.CanCollide = false
    hoverRing.CanQuery = false
    hoverRing.CanTouch = false
    hoverRing.Transparency = 1
    hoverRing.Parent = hoverFolder

    local sg = Instance.new("SurfaceGui")
    sg.Face = Enum.NormalId.Top
    sg.CanvasSize = Vector2.new(256, 256)
    sg.AlwaysOnTop = false
    sg.Parent = hoverRing

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://126246915031212"
    img.ImageColor3 = Color3.fromRGB(76, 195, 138)
    img.ImageTransparency = 0.25
    img.Parent = sg

    local hoverTag = Instance.new("Part")
    hoverTag.Name = "HoverTag"
    hoverTag.Size = Vector3.new(0.1, 0.1, 0.1)
    hoverTag.Anchored = true
    hoverTag.CanCollide = false
    hoverTag.CanQuery = false
    hoverTag.CanTouch = false
    hoverTag.Transparency = 1
    hoverTag.Parent = hoverFolder

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 240, 0, 26)
    bb.StudsOffset = Vector3.new(0, 5.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hoverTag
    bb.Parent = hoverTag

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 21)
    card.BackgroundTransparency = 0.15
    card.Parent = bb

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 6)
    pc.Parent = card

    local ps = Instance.new("UIStroke")
    ps.Color = Color3.fromRGB(76, 195, 138)
    ps.Thickness = 1.2
    ps.Transparency = 0.10
    ps.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Click Ground to Set Placement  ·  ESC to Cancel"
    lbl.TextColor3 = Color3.fromRGB(76, 195, 138)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.Parent = card

    local function isClickInsideHubWindow(screenX, screenY)
        local win = State.HubWindow
        if not (win and win.items and win.items["main"]) then return false end
        local main = win.items["main"]
        if not main.Visible then return false end
        local pos = main.AbsolutePosition
        local size = main.AbsoluteSize
        return screenX >= pos.X and screenX <= (pos.X + size.X) and screenY >= pos.Y and screenY <= (pos.Y + size.Y)
    end

    local function getPickPosition(screenPos)
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit and mouse.Target then
            local t = mouse.Target
            local isIgnored = t:IsDescendantOf(Camera)
                or (hoverFolder and t:IsDescendantOf(hoverFolder))
                or (Workspace:FindFirstChild("_AJ_HUB_PlacementMarker") and t:IsDescendantOf(Workspace._AJ_HUB_PlacementMarker))
                or (Workspace:FindFirstChild("_AJ_HUB_VisualGrid") and t:IsDescendantOf(Workspace._AJ_HUB_VisualGrid))
            if not isIgnored then
                return mouse.Hit.Position
            end
        end
        local ray = Camera:ScreenPointToRay(screenPos.X, screenPos.Y)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.RespectCanCollide = true
        local ignore = {}
        if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
        if Workspace:FindFirstChild("_UNITS") then table.insert(ignore, Workspace._UNITS) end
        if Workspace:FindFirstChild("_ENEMIES") then table.insert(ignore, Workspace._ENEMIES) end
        if Workspace:FindFirstChild("_EFFECTS") then table.insert(ignore, Workspace._EFFECTS) end
        if Workspace:FindFirstChild("_AJ_HUB_VisualGrid") then table.insert(ignore, Workspace._AJ_HUB_VisualGrid) end
        if Workspace:FindFirstChild("_AJ_HUB_PlacementMarker") then table.insert(ignore, Workspace._AJ_HUB_PlacementMarker) end
        if hoverFolder then table.insert(ignore, hoverFolder) end
        rayParams.FilterDescendantsInstances = ignore
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
        if hit and hit.Position then
            return hit.Position
        end
        return nil
    end

    local hoverConn
    hoverConn = RunService.RenderStepped:Connect(function()
        if not State.PickingPlacementArea or not hoverFolder or not hoverFolder.Parent then
            if hoverConn then hoverConn:Disconnect(); hoverConn = nil end
            return
        end
        local mousePos = UserInputService:GetMouseLocation()
        local pos = getPickPosition(mousePos)
        if pos then
            hoverRing.CFrame = CFrame.new(pos + Vector3.new(0, 0.06, 0))
            hoverTag.Position = pos
            img.ImageTransparency = 0.25
            card.BackgroundTransparency = 0.15
            lbl.TextTransparency = 0
            ps.Transparency = 0.10
        else
            img.ImageTransparency = 1
            card.BackgroundTransparency = 1
            lbl.TextTransparency = 1
            ps.Transparency = 1
        end
    end)

    if State.PlacementPickConn then
        State.PlacementPickConn:Disconnect()
        State.PlacementPickConn = nil
    end

    State.PlacementPickConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not State.PickingPlacementArea then
            if State.PlacementPickConn then State.PlacementPickConn:Disconnect(); State.PlacementPickConn = nil end
            if hoverConn then hoverConn:Disconnect(); hoverConn = nil end
            if hoverFolder then hoverFolder:Destroy() end
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.Escape then
            State.PickingPlacementArea = false
            if State.PlacementPickConn then State.PlacementPickConn:Disconnect(); State.PlacementPickConn = nil end
            if hoverConn then hoverConn:Disconnect(); hoverConn = nil end
            if hoverFolder then hoverFolder:Destroy() end
            if library and library.notifications and library.notifications.create_notification then
                library.notifications:create_notification({
                    name = "AJ HUB",
                    info = "Cancelled placement area picker."
                })
            end
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mLoc = (input.Position and input.Position.X > 0) and Vector2.new(input.Position.X, input.Position.Y) or UserInputService:GetMouseLocation()
            if isClickInsideHubWindow(mLoc.X, mLoc.Y) then
                return
            end
            local hitPos = getPickPosition(mLoc)
            if hitPos then
                State.PickingPlacementArea = false
                if State.PlacementPickConn then State.PlacementPickConn:Disconnect(); State.PlacementPickConn = nil end
                if hoverConn then hoverConn:Disconnect(); hoverConn = nil end
                if hoverFolder then hoverFolder:Destroy() end

                local mapKey = State.getMapKey() or "CurrentMap"
                Config.CustomPlacementAreas = Config.CustomPlacementAreas or {}
                Config.CustomPlacementAreas[mapKey] = {
                    x = math.floor(hitPos.X * 10) / 10,
                    y = math.floor(hitPos.Y * 10) / 10,
                    z = math.floor(hitPos.Z * 10) / 10,
                    name = State.CurrentMapName or mapKey
                }
                Config.UseCustomPlacementArea = true
                saveConfigToFile()
                computeCompactGrid()
                State.updatePlacementMarker()
                renderVisualGrid()
                if library and library.notifications and library.notifications.create_notification then
                    library.notifications:create_notification({
                        name = "AJ HUB",
                        info = string.format("Placement area saved for [%s]! (%.1f, %.1f, %.1f)", mapKey, hitPos.X, hitPos.Y, hitPos.Z)
                    })
                end
            end
        end
    end)
end

State.clearPlacementArea = function()
    if isLobby() then
        if library and library.notifications and library.notifications.create_notification then
            library.notifications:create_notification({
                name = "AJ HUB",
                info = "Enter a match to clear placement area for that map."
            })
        end
        return
    end
    local mapKey = State.getMapKey()
    if mapKey and Config.CustomPlacementAreas and Config.CustomPlacementAreas[mapKey] then
        Config.CustomPlacementAreas[mapKey] = nil
        saveConfigToFile()
        State.updatePlacementMarker()
        computeCompactGrid()
        renderVisualGrid()
        if library and library.notifications and library.notifications.create_notification then
            library.notifications:create_notification({
                name = "AJ HUB",
                info = string.format("Cleared custom placement area for [%s]!", mapKey)
            })
        end
    else
        if library and library.notifications and library.notifications.create_notification then
            library.notifications:create_notification({
                name = "AJ HUB",
                info = "No custom placement area set for this map."
            })
        end
    end
end
computeCompactGrid = function()
    if tick() - (State.LastGridCompute or 0) < 2.5 and #State.Spots > 0 then
        return State.Spots
    end
    if isLobby() then
        State.Spots = {}
        State.FailedSpots = {}
        State.NextSpot = nil
        State.NextSlot = nil
        State.NextUnitInfo = nil
        State.WebhookSentForCurrentMatch = false
        State.MatchStartTime = tick()
        State.CurrentMapKey = nil
        State.CurrentMapName = nil
        State.CurrentMapData = nil
        State.AntiPunishIdx = nil
        State.AntiPunishWalking = false
        State.PlayerAnchors = nil
        State.StickClusterCenter = nil
        State.GriffinBuffCompleted = false
        local v = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
        if v then v:Destroy() end
        local g = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
        if g then g:Destroy() end
        local m = Camera:FindFirstChild("_AJ_HUB_PlacementMarker") or Workspace:FindFirstChild("_AJ_HUB_PlacementMarker")
        if m then m:Destroy() end
        local h = Camera:FindFirstChild("_AJ_HUB_HoverMarker")
        if h then h:Destroy() end
        return
    end
    refreshAllLanes()
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            table.insert(ignore, p.Character)
        end
    end
    if Workspace:FindFirstChild("_UNITS") then
        table.insert(ignore, Workspace._UNITS)
    end
    if Workspace:FindFirstChild("_ENEMIES") then
        table.insert(ignore, Workspace._ENEMIES)
    end
    if Workspace:FindFirstChild("_EFFECTS") then
        table.insert(ignore, Workspace._EFFECTS)
    end
    if Camera:FindFirstChild("_AJ_HUB_VisualGrid") then
        table.insert(ignore, Camera._AJ_HUB_VisualGrid)
    end
    if Camera:FindFirstChild("_AJ_HUB_GhostPreview") then
        table.insert(ignore, Camera._AJ_HUB_GhostPreview)
    end
    rayParams.FilterDescendantsInstances = ignore
    local spots = {}
    local spotIndex = 1
    local gridRadius = 25.0
    local stepX = 1.55
    local stepZ = 1.55 * 0.86602540378
    local seenCells = {}
    local roadFolder = Workspace:FindFirstChild("_road")
    local activePercentages = {[Config.PathPercentage] = true}
    local equippedUnits = getEquippedUnits()
    for _, eq in ipairs(equippedUnits) do
        local custom = eq.slot and Config.UnitCustomSettings and Config.UnitCustomSettings[eq.slot]
        if isCEOUnit(eq) and (not custom or not custom.CustomPath or custom.CustomPath == 0) then
            activePercentages[95] = true
        elseif isFarmUnit(eq) and (not custom or not custom.CustomPath or custom.CustomPath == 0) then
            activePercentages[Config.FarmPathPercentage or 85] = true
        end
    end
    if State.hasAutoGriffithConfigured and State.hasAutoGriffithConfigured() then
        activePercentages[60] = true
    end
    if Config.UnitCustomSettings then
        for s = 1, 6 do
            local c = Config.UnitCustomSettings[s]
            if c and c.CustomPath and c.CustomPath > 0 then
                activePercentages[c.CustomPath] = true
            end
        end
    end
    if State._computingGrid then
        return State.Spots
    end
    State._computingGrid = true
    local function finishCompute(resSpots)
        State._computingGrid = false
        return resSpots
    end
    local overlap = OverlapParams.new()
    overlap.FilterType = Enum.RaycastFilterType.Exclude
    overlap.FilterDescendantsInstances = ignore
    local terrainFolder = Workspace:FindFirstChild("_terrain")
    local mapFolder = Workspace:FindFirstChild("_map")
    local basesFolder = Workspace:FindFirstChild("_BASES")
    local yieldInterval = UserInputService.TouchEnabled and 40 or 120
    local checkedPoints = 0
    local isSpotValidAndClear = function(rayRes, pY, isCustom)
        if not rayRes or not rayRes.Instance then return false end
        local hPart = rayRes.Instance
        if hPart.CanCollide == false or (hPart.Transparency and hPart.Transparency > 0.8) then
            return false
        end
        local minNormalY = isCustom and 0.70 or 0.80
        if rayRes.Normal and rayRes.Normal.Y < minNormalY then
            return false
        end
        if not isCustom then
            local vOffset = rayRes.Position.Y - pY
            if vOffset < -1.8 then
                return false
            end
        end
        local p = rayRes.Position
        local upRay = Workspace:Raycast(p + Vector3.new(0, 0.2, 0), Vector3.new(0, 4.2, 0), rayParams)
        if upRay then
            return false
        end
        local bounds = Workspace:GetPartBoundsInRadius(p + Vector3.new(0, 1.6, 0), 1.05, overlap)
        if bounds and #bounds > 0 then
            for _, bPart in ipairs(bounds) do
                if bPart.CanCollide
                    and bPart ~= hPart
                    and not (terrainFolder and bPart:IsDescendantOf(terrainFolder))
                    and not (mapFolder and bPart:IsDescendantOf(mapFolder))
                    and not (basesFolder and bPart:IsDescendantOf(basesFolder))
                    and not (roadFolder and bPart:IsDescendantOf(roadFolder)) then
                    return false
                end
            end
        end
        return true
    end
    for laneName, waypoints in pairs(State.Lanes) do
        if #waypoints >= 2 then
            local totalLength = 0
            for i = 1, #waypoints - 1 do
                totalLength = totalLength + (waypoints[i + 1] - waypoints[i]).Magnitude
            end
            for pct, _ in pairs(activePercentages) do
                local currentRadius = 17.5
                local centerDistance = math.clamp(pct / 100, 0, 1) * totalLength
                local pathPos, pathDir = getPointAndDirectionAtDistance(centerDistance, waypoints)
                local rowIndex = 0
                for dz = -currentRadius, currentRadius, stepZ do
                    rowIndex = rowIndex + 1
                    local rowShift = (rowIndex % 2 == 1) and (stepX * 0.5) or 0
                    for dx = -currentRadius, currentRadius, stepX do
                        local shiftedDx = dx + rowShift
                        if (shiftedDx * shiftedDx + dz * dz) <= (currentRadius * currentRadius) then
                            checkedPoints = checkedPoints + 1
                            if checkedPoints % yieldInterval == 0 then
                                task.wait()
                                if isLobby() then
                                    return finishCompute(State.Spots)
                                end
                            end
                            local candidatePos = pathPos + Vector3.new(shiftedDx, 0, dz)
                            local rayResult = Workspace:Raycast(candidatePos + Vector3.new(0, 25, 0), Vector3.new(0, -50, 0), rayParams)
                            if rayResult and isSpotValidAndClear(rayResult, pathPos.Y) then
                                local hitPart = rayResult.Instance
                                local vertOffset = rayResult.Position.Y - pathPos.Y
                                local isRoad = (roadFolder and hitPart:IsDescendantOf(roadFolder)) or hitPart.Name:lower():find("road") ~= nil
                                if Config.PlaceAnywhere or not isRoad then
                                    local isHill = vertOffset > 2.0 or hitPart.Name:lower():find("hill") ~= nil
                                    local cellKey = math.floor(rayResult.Position.X / 1.45) .. "_" .. math.floor(rayResult.Position.Z / 1.45)
                                    if not seenCells[cellKey] then
                                        seenCells[cellKey] = true
                                        table.insert(spots, {
                                            index = spotIndex,
                                            lane = laneName,
                                            pathPercent = pct,
                                            position = rayResult.Position,
                                            lookTarget = pathPos,
                                            isHill = isHill,
                                            isRoad = isRoad,
                                            centerDistance = (rayResult.Position - pathPos).Magnitude,
                                            occupied = false,
                                            unit = nil
                                        })
                                        spotIndex = spotIndex + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local lateralOffsets = {-25, -20, -15, -10, -5, 5, 10, 15, 20, 25}
            for d = 5, totalLength - 5, 6.0 do
                local pPos, pDir = getPointAndDirectionAtDistance(d, waypoints)
                local pPct = math.clamp(math.floor((d / totalLength) * 100), 1, 99)
                local flatDir = Vector3.new(pDir.X, 0, pDir.Z)
                local perp = Vector3.new(1, 0, 0)
                if flatDir.Magnitude > 0.01 then
                    perp = Vector3.new(-flatDir.Z, 0, flatDir.X).Unit
                end
                for _, lat in ipairs(lateralOffsets) do
                    checkedPoints = checkedPoints + 1
                    if checkedPoints % yieldInterval == 0 then
                        task.wait()
                        if isLobby() then
                            return finishCompute(State.Spots)
                        end
                    end
                    local candPos = pPos + perp * lat
                    local rayResult = Workspace:Raycast(candPos + Vector3.new(0, 25, 0), Vector3.new(0, -50, 0), rayParams)
                    if rayResult and isSpotValidAndClear(rayResult, pPos.Y) then
                        local hitPart = rayResult.Instance
                        local vertOffset = rayResult.Position.Y - pPos.Y
                        local isRoad = (roadFolder and hitPart:IsDescendantOf(roadFolder)) or hitPart.Name:lower():find("road") ~= nil
                        if Config.PlaceAnywhere or not isRoad then
                            local isHill = vertOffset > 2.0 or hitPart.Name:lower():find("hill") ~= nil
                            local cellKey = math.floor(rayResult.Position.X / 1.45) .. "_" .. math.floor(rayResult.Position.Z / 1.45)
                            if not seenCells[cellKey] then
                                seenCells[cellKey] = true
                                table.insert(spots, {
                                    index = spotIndex,
                                    lane = laneName,
                                    pathPercent = pPct,
                                    position = rayResult.Position,
                                    lookTarget = pPos,
                                    isHill = isHill,
                                    isRoad = isRoad,
                                    centerDistance = 60 + math.abs(lat),
                                    occupied = false,
                                    unit = nil
                                })
                                spotIndex = spotIndex + 1
                            end
                        end
                    end
                end
            end
        end
    end
    local customAreaPos = State.getCustomPlacementArea()
    if customAreaPos then
        local customRadius = 26.0
        local lookTarget = State.findClosestLanePoint(customAreaPos)
        local baseGroundY = customAreaPos.Y
        local exactRay = Workspace:Raycast(customAreaPos + Vector3.new(0, 15, 0), Vector3.new(0, -35, 0), rayParams)
        if exactRay and isSpotValidAndClear(exactRay, customAreaPos.Y, true) then
            baseGroundY = exactRay.Position.Y
            local hitPart = exactRay.Instance
            local isRoad = (roadFolder and hitPart:IsDescendantOf(roadFolder)) or hitPart.Name:lower():find("road") ~= nil
            if Config.PlaceAnywhere or not isRoad then
                local isHill = (exactRay.Position.Y - customAreaPos.Y) > 2.0 or hitPart.Name:lower():find("hill") ~= nil
                local cellKey = math.floor(exactRay.Position.X / 1.5) .. "_" .. math.floor(exactRay.Position.Z / 1.5)
                seenCells[cellKey] = true
                table.insert(spots, {
                    index = spotIndex,
                    lane = "custom",
                    pathPercent = Config.PathPercentage,
                    position = exactRay.Position,
                    lookTarget = lookTarget,
                    isHill = isHill,
                    isRoad = isRoad,
                    centerDistance = 0,
                    occupied = false,
                    unit = nil,
                    isCustomArea = true
                })
                spotIndex = spotIndex + 1
            end
        end
        local rowIndex = 0
        for dz = -customRadius, customRadius, stepZ do
            rowIndex = rowIndex + 1
            local rowShift = (rowIndex % 2 == 1) and (stepX * 0.5) or 0
            for dx = -customRadius, customRadius, stepX do
                local shiftedDx = dx + rowShift
                local distFromCenter = math.sqrt(shiftedDx * shiftedDx + dz * dz)
                if distFromCenter <= customRadius and distFromCenter > 0.5 then
                    checkedPoints = checkedPoints + 1
                    if checkedPoints % yieldInterval == 0 then
                        task.wait()
                        if isLobby() then
                            return finishCompute(State.Spots)
                        end
                    end
                    local candidatePos = customAreaPos + Vector3.new(shiftedDx, 0, dz)
                    local rayResult = Workspace:Raycast(candidatePos + Vector3.new(0, 25, 0), Vector3.new(0, -50, 0), rayParams)
                    if rayResult and isSpotValidAndClear(rayResult, baseGroundY, true) then
                        local hitPart = rayResult.Instance
                        local vertOffset = rayResult.Position.Y - baseGroundY
                        local isRoad = (roadFolder and hitPart:IsDescendantOf(roadFolder)) or hitPart.Name:lower():find("road") ~= nil
                        if Config.PlaceAnywhere or not isRoad then
                            local isHill = vertOffset > 2.0 or hitPart.Name:lower():find("hill") ~= nil
                            local cellKey = math.floor(rayResult.Position.X / 1.5) .. "_" .. math.floor(rayResult.Position.Z / 1.5)
                            if not seenCells[cellKey] then
                                seenCells[cellKey] = true
                                table.insert(spots, {
                                    index = spotIndex,
                                    lane = "custom",
                                    pathPercent = Config.PathPercentage,
                                    position = rayResult.Position,
                                    lookTarget = lookTarget,
                                    isHill = isHill,
                                    isRoad = isRoad,
                                    centerDistance = (rayResult.Position - customAreaPos).Magnitude,
                                    occupied = false,
                                    unit = nil,
                                    isCustomArea = true
                                })
                                spotIndex = spotIndex + 1
                            end
                        end
                    end
                end
            end
        end
    end
    local stickAnchors = nil
    if Config.PlaceStickToPlayers then
        local a = State.getOtherPlayersAnchors()
        if #a > 0 then stickAnchors = a end
    end
    if stickAnchors and #stickAnchors > 0 then
        local anchorRadius = 16.0
        local anchorPos = stickAnchors[1]
        local lookTarget = State.findClosestLanePoint(anchorPos) or anchorPos
        local baseGroundY = anchorPos.Y
        local rowIndex = 0
        local anchorStepX = 1.85
        local anchorStepZ = 1.60
        for dz = -anchorRadius, anchorRadius, anchorStepZ do
            rowIndex = rowIndex + 1
            local rowShift = (rowIndex % 2 == 1) and (anchorStepX * 0.5) or 0
            for dx = -anchorRadius, anchorRadius, anchorStepX do
                local shiftedDx = dx + rowShift
                local distFromAnchor = math.sqrt(shiftedDx * shiftedDx + dz * dz)
                if distFromAnchor <= anchorRadius and distFromAnchor >= 1.2 then
                    checkedPoints = checkedPoints + 1
                    if checkedPoints % yieldInterval == 0 then
                        task.wait()
                        if isLobby() then return finishCompute(State.Spots) end
                    end
                    local candPos = anchorPos + Vector3.new(shiftedDx, 0, dz)
                    local rayResult = Workspace:Raycast(candPos + Vector3.new(0, 25, 0), Vector3.new(0, -50, 0), rayParams)
                    if rayResult and isSpotValidAndClear(rayResult, baseGroundY, true) then
                        local hitPart = rayResult.Instance
                        local vertOffset = rayResult.Position.Y - baseGroundY
                        local isRoad = (roadFolder and hitPart:IsDescendantOf(roadFolder)) or hitPart.Name:lower():find("road") ~= nil
                        if Config.PlaceAnywhere or not isRoad then
                            local isHill = vertOffset > 2.0 or hitPart.Name:lower():find("hill") ~= nil
                            local cellKey = math.floor(rayResult.Position.X / 1.45) .. "_" .. math.floor(rayResult.Position.Z / 1.45)
                            if not seenCells[cellKey] then
                                seenCells[cellKey] = true
                                table.insert(spots, {
                                    index = spotIndex,
                                    lane = "anchor",
                                    pathPercent = Config.PathPercentage,
                                    position = rayResult.Position,
                                    lookTarget = lookTarget,
                                    isHill = isHill,
                                    isRoad = isRoad,
                                    centerDistance = distFromAnchor,
                                    occupied = false,
                                    unit = nil,
                                    isPlayerAnchorSpot = true,
                                    anchorDist = distFromAnchor
                                })
                                spotIndex = spotIndex + 1
                            end
                        end
                    end
                end
            end
        end
    end
    State.Spots = spots
    State.LastGridCompute = tick()
    task.spawn(State.updatePlacementMarker)
    return finishCompute(spots)
end
local _lastOccCheck = 0
local _lastUnitsCount = -1
local refreshGridOccupancy = function(force)
    local now = tick()
    local unitsFolder = Workspace:FindFirstChild("_UNITS")
    if not unitsFolder or #State.Spots == 0 then return end

    local currentTowers = 0
    for _, u in ipairs(unitsFolder:GetChildren()) do
        local st = u:FindFirstChild("_stats")
        if st and st:FindFirstChild("player") and st.player.Value then
            currentTowers = currentTowers + 1
        end
    end

    if not force and (currentTowers == _lastUnitsCount) and (now - _lastOccCheck < 2.0) then
        return
    end
    _lastOccCheck = now
    _lastUnitsCount = currentTowers
    State.refreshGridOccupancy = refreshGridOccupancy

    local unitPositions = {}
    for _, unit in ipairs(unitsFolder:GetChildren()) do
        local st = unit:FindFirstChild("_stats")
        if st and st:FindFirstChild("player") and st.player.Value then
            local root = unit.PrimaryPart or unit:FindFirstChild("HumanoidRootPart") or unit:FindFirstChild("_hitbox") or unit:FindFirstChildWhichIsA("BasePart")
            if root then
                local p = root.Position
                local r = State.getUnitRealRadius(unit)
                local safeDist = (r or 1.55) + 0.30
                table.insert(unitPositions, {
                    x = p.X,
                    y = p.Y,
                    z = p.Z,
                    safeDist = safeDist,
                    safeDistSq = safeDist * safeDist,
                    unit = unit
                })
            end
        end
    end
    local numUnits = #unitPositions
    for _, spot in ipairs(State.Spots) do
        spot.occupied = false
        spot.unit = nil
        if numUnits > 0 then
            local sx, sy, sz = spot.position.X, spot.position.Y, spot.position.Z
            for i = 1, numUnits do
                local u = unitPositions[i]
                local dx = math.abs(u.x - sx)
                if dx <= u.safeDist then
                    local dz = math.abs(u.z - sz)
                    if dz <= u.safeDist and math.abs(u.y - sy) <= 4.0 then
                        if (dx * dx + dz * dz) <= u.safeDistSq then
                            spot.occupied = true
                            spot.unit = u.unit
                            break
                        end
                    end
                end
            end
        end
    end
end
State.refreshGridOccupancy = refreshGridOccupancy
local _visualGridRenderToken = 0
renderVisualGrid = function()
    _visualGridRenderToken = _visualGridRenderToken + 1
    local myToken = _visualGridRenderToken
    local folder = Workspace:FindFirstChild("_AJ_HUB_VisualGrid") or Camera:FindFirstChild("_AJ_HUB_VisualGrid")
    if isLobby() or not Config.ShowPlaceArea then
        if folder then folder:Destroy() end
        return
    end
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "_AJ_HUB_VisualGrid"
        folder.Parent = Workspace
    elseif folder.Parent ~= Workspace then
        folder.Parent = Workspace
    end
    folder:ClearAllChildren()
    local freeGround = 0
    local freeHills = 0
    for _, s in ipairs(State.Spots) do
        if not s.occupied then
            if s.isHill then
                freeHills = freeHills + 1
            else
                freeGround = freeGround + 1
            end
        end
    end
    local equipped = getEquippedUnits()
    local mainPct = Config.PathPercentage
    for laneName, waypoints in pairs(State.Lanes) do
        if #waypoints >= 2 then
            local totalLength = 0
            for i = 1, #waypoints - 1 do
                totalLength = totalLength + (waypoints[i + 1] - waypoints[i]).Magnitude
            end
            local centerDistance = math.clamp(mainPct / 100, 0, 1) * totalLength
            local pathPos, _ = getPointAndDirectionAtDistance(centerDistance, waypoints)
            local freeGround = 0
            local freeHills = 0
            for _, s in ipairs(State.Spots) do
                if s.lane == laneName and not s.occupied and not State.FailedSpots[s.index] and (s.position - pathPos).Magnitude <= 18.0 then
                    if s.isHill then
                        freeHills = freeHills + 1
                    else
                        freeGround = freeGround + 1
                    end
                end
            end
            local ringPart = Instance.new("Part")
            ringPart.Name = "Ring_" .. laneName .. "_" .. mainPct
            ringPart.Size = Vector3.new(36, 0.08, 36)
            ringPart.CFrame = CFrame.new(pathPos + Vector3.new(0, 0.04, 0))
            ringPart.Anchored = true
            ringPart.CanCollide = false
            ringPart.CanQuery = false
            ringPart.CanTouch = false
            ringPart.Transparency = 1
            ringPart.Parent = folder
            local sg = Instance.new("SurfaceGui")
            sg.Face = Enum.NormalId.Top
            sg.CanvasSize = Vector2.new(256, 256)
            sg.AlwaysOnTop = false
            sg.Parent = ringPart
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://126246915031212"
            img.ImageColor3 = Color3.fromRGB(148, 163, 184)
            img.ImageTransparency = 0.75
            img.Parent = sg
            local tagPart = Instance.new("Part")
            tagPart.Name = "TagPart_" .. laneName .. "_" .. mainPct
            tagPart.Size = Vector3.new(0.1, 0.1, 0.1)
            tagPart.Position = pathPos
            tagPart.Anchored = true
            tagPart.CanCollide = false
            tagPart.CanQuery = false
            tagPart.CanTouch = false
            tagPart.Transparency = 1
            tagPart.Parent = folder
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 240, 0, 26)
            bb.StudsOffset = Vector3.new(0, 5.5, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = tagPart
            bb.Parent = tagPart
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 1, 0)
            card.BackgroundColor3 = Color3.fromRGB(20, 20, 21)
            card.BackgroundTransparency = 0.15
            card.Parent = bb
            local pc = Instance.new("UICorner")
            pc.CornerRadius = UDim.new(0, 6)
            pc.Parent = card
            local ps = Instance.new("UIStroke")
            ps.Color = Color3.fromRGB(48, 48, 54)
            ps.Thickness = 1.0
            ps.Transparency = 0.20
            ps.Parent = card
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = string.format("Lane %s  ·  %d%% mark  ·  %d ground  ·  %d hill", laneName, mainPct, freeGround, freeHills)
            lbl.TextColor3 = Color3.fromRGB(226, 232, 240)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamMedium
            lbl.Parent = card
        end
    end
    local spotsToRender = {}
    local usedSpotIndices = {}
    for _, eq in ipairs(equipped) do
        local custom = eq.slot and Config.UnitCustomSettings and Config.UnitCustomSettings[eq.slot]
        local isCEO = isCEOUnit(eq)
        local isFarm = isFarmUnit(eq)
        local targetPct
        if custom and custom.CustomPath and custom.CustomPath > 0 then
            targetPct = custom.CustomPath
        elseif isCEO then
            targetPct = 95
        elseif isFarm then
            targetPct = Config.FarmPathPercentage or 85
        else
            targetPct = Config.PathPercentage
        end
        local placeLimit = 2
        if custom and custom.Amount and custom.Amount > 0 then
            placeLimit = custom.Amount
        elseif Config.SlotLimits and Config.SlotLimits[eq.slot] and Config.SlotLimits[eq.slot] > 0 then
            placeLimit = Config.SlotLimits[eq.slot]
        elseif eq.max then
            placeLimit = eq.max
        end
        local isCustom = (custom and custom.CustomPath and custom.CustomPath > 0) or isFarm
        local candidates = {}
        for _, spot in ipairs(State.Spots) do
            if not spot.occupied and not State.FailedSpots[spot.index] and not usedSpotIndices[spot.index] then
                local typeMatches = false
                if eq.isHybrid then
                    typeMatches = true
                elseif eq.isHill then
                    typeMatches = spot.isHill
                else
                    typeMatches = not spot.isHill
                end
                if typeMatches then
                    table.insert(candidates, spot)
                end
            end
        end
        local stickAnchors = Config.PlaceStickToPlayers and State.getOtherPlayersAnchors()
        if Config.PlaceStickToPlayers and (not stickAnchors or #stickAnchors == 0) then
            candidates = {}
        elseif stickAnchors and #stickAnchors > 0 and not isFarm then
            local center = stickAnchors[1]
            table.sort(candidates, function(a, b)
                local distA = (a.position - center).Magnitude
                local distB = (b.position - center).Magnitude
                local inCircleA = distA <= 22.0
                local inCircleB = distB <= 22.0
                if inCircleA ~= inCircleB then
                    return inCircleA
                end
                return distA < distB
            end)
        else
            local targetPos = nil
            local customAreaPos = State.getCustomPlacementArea()
            if customAreaPos then
                targetPos = customAreaPos
            elseif State.Lanes then
                local targetLane = State.Lanes["1"] or select(2, next(State.Lanes))
                if targetLane and #targetLane >= 2 then
                    local totalLength = 0
                    for i = 1, #targetLane - 1 do
                        totalLength = totalLength + (targetLane[i + 1] - targetLane[i]).Magnitude
                    end
                    local d = math.clamp(targetPct / 100, 0, 1) * totalLength
                    targetPos, _ = getPointAndDirectionAtDistance(d, targetLane)
                end
            end
            table.sort(candidates, function(a, b)
                local distA = targetPos and (a.position - targetPos).Magnitude or a.centerDistance
                local distB = targetPos and (b.position - targetPos).Magnitude or b.centerDistance
                local inCircleA = distA <= 18.0
                local inCircleB = distB <= 18.0
                if inCircleA ~= inCircleB then
                    return inCircleA
                end
                return distA < distB
            end)
        end
        local realRad = State.getUnitRealRadius(eq)
        local minSeparation = math.max(realRad * 1.85, 2.1)
        local minSepSq = minSeparation * minSeparation
        local selectedCandidates = {}
        for _, spot in ipairs(candidates) do
            if #selectedCandidates >= placeLimit then break end
            local tooClose = false
            for _, prev in ipairs(selectedCandidates) do
                local dx = spot.position.X - prev.position.X
                local dz = spot.position.Z - prev.position.Z
                if (dx * dx + dz * dz) < minSepSq then
                    tooClose = true
                    break
                end
            end
            if not tooClose then
                table.insert(selectedCandidates, spot)
            end
        end
        local count = #selectedCandidates
        for i = 1, count do
            local spot = selectedCandidates[i]
            usedSpotIndices[spot.index] = true
            spotsToRender[spot.index] = {
                spot = spot,
                isCustom = isCustom,
                unitName = eq.name,
                spotNum = i,
                totalNeed = count,
                isTarget = true
            }
        end
    end
    if State.NextSpot and not spotsToRender[State.NextSpot.index] then
        spotsToRender[State.NextSpot.index] = {
            spot = State.NextSpot,
            isCustom = true,
            unitName = State.NextUnitInfo and State.NextUnitInfo.name or "Next",
            spotNum = 1,
            totalNeed = 1,
            isTarget = true
        }
    end

    local laneWaypoints = State.Lanes["1"] or select(2, next(State.Lanes))
    local circleCenter = nil
    if laneWaypoints and #laneWaypoints >= 2 then
        local totalLength = 0
        for i = 1, #laneWaypoints - 1 do
            totalLength = totalLength + (laneWaypoints[i + 1] - laneWaypoints[i]).Magnitude
        end
        local d = math.clamp(Config.PathPercentage / 100, 0, 1) * totalLength
        circleCenter, _ = getPointAndDirectionAtDistance(d, laneWaypoints)
    end

    if circleCenter then
        local circleSpots = {}
        for _, spot in ipairs(State.Spots) do
            if not spotsToRender[spot.index] and not State.FailedSpots[spot.index] and spot.lane ~= "custom" and spot.lane ~= "anchor" then
                local dist = (spot.position - circleCenter).Magnitude
                if dist <= 18.0 then
                    table.insert(circleSpots, { spot = spot, dist = dist })
                end
            end
        end

        table.sort(circleSpots, function(a, b)
            return a.dist < b.dist
        end)

        for _, item in ipairs(circleSpots) do
            spotsToRender[item.spot.index] = {
                spot = item.spot,
                isCustom = false,
                isTarget = false
            }
        end
    end

    if Config.PlaceStickToPlayers then
        local added = 0
        for _, spot in ipairs(State.Spots) do
            if added >= 30 then break end
            if not spotsToRender[spot.index] and not State.FailedSpots[spot.index] and spot.lane == "anchor" then
                spotsToRender[spot.index] = {
                    spot = spot,
                    isCustom = true,
                    isTarget = false
                }
                added = added + 1
            end
        end
    end

    if Config.UseCustomPlacementArea then
        local added = 0
        for _, spot in ipairs(State.Spots) do
            if added >= 40 then break end
            if not spotsToRender[spot.index] and not State.FailedSpots[spot.index] and spot.lane == "custom" then
                spotsToRender[spot.index] = {
                    spot = spot,
                    isCustom = true,
                    isTarget = false
                }
                added = added + 1
            end
        end
    end

    local renderedSpots = 0
    local maxVisualSpots = UserInputService.TouchEnabled and 60 or 500
    local yieldedCount = 0
    for spotIndex, info in pairs(spotsToRender) do
        if _visualGridRenderToken ~= myToken or isLobby() or not Config.ShowPlaceArea or not folder.Parent then
            return
        end
        local spot = info.spot
        local isTargetSpot = (State.NextSpot and State.NextSpot.index == spot.index)
        local isTarget = isTargetSpot or info.isTarget
        if isTarget or renderedSpots < maxVisualSpots then
            renderedSpots = renderedSpots + 1
            yieldedCount = yieldedCount + 1
            if yieldedCount % 10 == 0 then
                task.wait()
                if _visualGridRenderToken ~= myToken or isLobby() or not Config.ShowPlaceArea or not folder.Parent then
                    return
                end
            end
            local isCustom = info.isCustom
            local dot = Instance.new("Part")
            dot.Name = "Spot_" .. spotIndex
            dot.Size = Vector3.new(1, 1, 1)
            dot.CFrame = CFrame.new(spot.position + Vector3.new(0, 0.5, 0))
            dot.Anchored = true
            dot.CanCollide = false
            dot.CanQuery = false
            dot.CanTouch = false
            dot.CastShadow = false
            dot.Material = Enum.Material.Plastic
            dot.TopSurface = Enum.SurfaceType.Studs
            dot.BottomSurface = Enum.SurfaceType.Inlet

            local baseColor
            if isTargetSpot then
                baseColor = Color3.fromRGB(245, 158, 11)
            elseif isTarget then
                baseColor = Color3.fromRGB(234, 179, 8)
            elseif spot.isHill then
                baseColor = Color3.fromRGB(80, 120, 180)
            elseif isCustom then
                baseColor = Color3.fromRGB(168, 85, 247)
            else
                baseColor = Color3.fromRGB(115, 170, 215)
            end
            dot.Color = baseColor
            dot.Transparency = spot.occupied and 0.85 or (isTargetSpot and 0.10 or (isTarget and 0.20 or 0.35))
            dot.Parent = folder

            if isTarget then
                local sb = Instance.new("SelectionBox")
                sb.Name = "TargetOutline"
                sb.Adornee = dot
                sb.Color3 = isTargetSpot and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(245, 158, 11)
                sb.LineThickness = 0.03
                sb.Transparency = 0.2
                sb.Parent = dot
            end
        end
    end
    getgenv().AJ_HUB_RENDER_GRID = renderVisualGrid
    getgenv().AJ_HUB_COMPUTE_GRID = computeCompactGrid
end
local markSpotVisualOccupied = function(spotIndex)
    if isLobby() or not Config.ShowPlaceArea then return end
    local folder = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
    if not folder then
        task.spawn(renderVisualGrid)
        return
    end
    local dot = folder:FindFirstChild("Spot_" .. tostring(spotIndex))
    if dot then
        dot.Transparency = 0.90
        local sb = dot:FindFirstChildOfClass("SelectionBox")
        if sb then
            sb:Destroy()
        end
    end
end
local updateGhostHologram = function()
    local ghostFolder = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
    if isLobby() or not Config.ShowNextPlacement or not State.NextSpot or not State.NextUnitInfo then
        if ghostFolder then ghostFolder:Destroy() end
        return
    end
    if not ghostFolder then
        ghostFolder = Instance.new("Folder")
        ghostFolder.Name = "_AJ_HUB_GhostPreview"
        ghostFolder.Parent = Camera
    end
    local spot = State.NextSpot
    local unitInfo = State.NextUnitInfo
    local money = getPlayerMoney()
    local affordable = money >= unitInfo.cost
    local ghostPart = ghostFolder:FindFirstChild("GhostAvatar")
    if not ghostPart then
        ghostPart = Instance.new("Part")
        ghostPart.Name = "GhostAvatar"
        ghostPart.Size = Vector3.new(2.2, 5.0, 2.2)
        ghostPart.Anchored = true
        ghostPart.CanCollide = false
        ghostPart.Material = Enum.Material.SmoothPlastic
        ghostPart.Transparency = 0.70
        ghostPart.Color = affordable and Color3.fromRGB(76, 195, 138) or Color3.fromRGB(183, 176, 205)
        ghostPart.Parent = ghostFolder
        local highlight = Instance.new("Highlight")
        highlight.Name = "GhostHighlight"
        highlight.Adornee = ghostPart
        highlight.FillColor = affordable and Color3.fromRGB(76, 195, 138) or Color3.fromRGB(183, 176, 205)
        highlight.OutlineColor = affordable and Color3.fromRGB(76, 195, 138) or Color3.fromRGB(183, 176, 205)
        highlight.FillTransparency = 0.82
        highlight.OutlineTransparency = 0.40
        highlight.Parent = ghostPart
        local bb = Instance.new("BillboardGui")
        bb.Name = "GhostOverhead"
        bb.Size = UDim2.new(0, 210, 0, 48)
        bb.StudsOffset = Vector3.new(0, 3.8, 0)
        bb.AlwaysOnTop = true
        bb.Parent = ghostPart
        local frame = Instance.new("Frame")
        frame.Name = "ContentFrame"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
        frame.BackgroundTransparency = 0.12
        frame.Parent = bb
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = frame
        local stroke = Instance.new("UIStroke")
        stroke.Name = "Stroke"
        stroke.Thickness = 1.0
        stroke.Color = Color3.fromRGB(48, 48, 54)
        stroke.Parent = frame
        local title = Instance.new("TextLabel")
        title.Name = "UnitTitle"
        title.Size = UDim2.new(1, -16, 0.5, 0)
        title.Position = UDim2.new(0, 8, 0, 2)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(237, 237, 237)
        title.Parent = frame
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Size = UDim2.new(1, -16, 0.5, -2)
        status.Position = UDim2.new(0, 8, 0.5, 0)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.Gotham
        status.TextSize = 11
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = frame
    end
    ghostPart.Position = spot.position + Vector3.new(0, 2.5, 0)
    ghostPart.Color = affordable and Color3.fromRGB(76, 195, 138) or Color3.fromRGB(183, 176, 205)
    local hl = ghostPart:FindFirstChild("GhostHighlight")
    if hl then
        hl.FillColor = ghostPart.Color
        hl.OutlineColor = ghostPart.Color
    end
    local bb = ghostPart:FindFirstChild("GhostOverhead")
    if bb and bb:FindFirstChild("ContentFrame") then
        local frame = bb.ContentFrame
        local title = frame:FindFirstChild("UnitTitle")
        if title then
            title.Text = string.format("Slot %d  \194\183  %s", unitInfo.slot, unitInfo.name)
        end
        local st = frame:FindFirstChild("Status")
        if st then
            if affordable then
                st.Text = string.format("Ready  \194\183  $%d / $%d", money, unitInfo.cost)
                st.TextColor3 = Color3.fromRGB(76, 195, 138)
            else
                local pct = math.clamp(math.floor((money / unitInfo.cost) * 100), 0, 99)
                st.Text = string.format("Saving  \194\183  $%d / $%d (%d%%)", money, unitInfo.cost, pct)
                st.TextColor3 = Color3.fromRGB(161, 161, 166)
            end
        end
    end
end
State.getPlacedGriffin = function()
    local owned = getOwnedUnitsInGame()
    for _, u in ipairs(owned) do
        if State.isGriffinUnit(u) then
            return u
        end
    end
    return nil
end

State.getEquippedGriffinInfo = function()
    local equipped = getEquippedUnits()
    for _, eq in ipairs(equipped) do
        if State.isGriffinUnit(eq) then
            local custom = eq.slot and Config.UnitCustomSettings and Config.UnitCustomSettings[eq.slot]
            return eq, custom
        end
    end
    return nil, nil
end

State.hasAutoGriffithConfigured = function()
    local eqGriffin, custom = State.getEquippedGriffinInfo()
    return (eqGriffin ~= nil and State.isGriffinUnit(eqGriffin) and custom ~= nil and custom.AutoGriffith == true)
end

State.isGriffinBuffCompleted = function()
    if State.GriffinBuffCompleted then return true end
    local griffin = State.getPlacedGriffin()
    if griffin then
        local gStats = griffin:FindFirstChild("_stats")
        local gId = gStats and gStats:FindFirstChild("id") and tostring(gStats.id.Value):lower() or ""
        -- Note: femto_egg is the PRE-SACRIFICE egg! Only femto or griffith_reincarnation is completed!
        if (gId == "femto" or gId == "griffith_reincarnation" or (gId:find("femto") and not gId:find("egg"))) then
            State.GriffinBuffCompleted = true
            return true
        end
    end

    local owned = getOwnedUnitsInGame()
    for _, u in ipairs(owned) do
        local stats = u:FindFirstChild("_stats")
        if stats then
            if stats:FindFirstChild("damage_buff__griffith")
                or stats:FindFirstChild("buff_damage_buff__griffith")
                or stats:FindFirstChild("griffith_buff") then
                State.GriffinBuffCompleted = true
                return true
            end
        end
    end
    return false
end

State.isAutoGriffithActive = function()
    if isLobby() then return false end
    local eqGriffin, custom = State.getEquippedGriffinInfo()
    if not eqGriffin or not custom or not custom.AutoGriffith then
        return false
    end
    local currentWave = getCurrentWave()
    local startWave = tonumber(custom.AutoGriffithWave) or 1
    if currentWave < startWave then
        return false
    end
    if State.isGriffinBuffCompleted() then
        return false
    end
    return true
end

State.isGriffinSacrifice100 = function(griffin)
    if not griffin or not griffin.Parent then return false end
    if State.isGriffinBuffCompleted() then return true end

    -- 1. Check text labels on griffin
    for _, desc in ipairs(griffin:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Text then
            local txt = desc.Text:lower()
            if txt:find("100%%") or txt:find("100%.0%%") or txt:find("100%s*/%s*100") then
                return true
            end
            local pct = tonumber(txt:match("(%d+)%s*%%"))
            if pct and pct >= 100 then
                return true
            end
        end
    end

    -- 2. Check UI ActiveButton in PlayerGui.UnitUpgrade2
    local pgui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    local upgGui = pgui and pgui:FindFirstChild("UnitUpgrade2")
    if upgGui and upgGui.Enabled then
        local ab = upgGui:FindFirstChild("ActiveButton", true)
        if ab and ab.Visible and ab:FindFirstChild("BlackedOut") and not ab.BlackedOut.Visible then
            local lvl = ab:FindFirstChild("Level", true)
            if lvl and lvl.Text:lower():find("sacrifice") then
                return true
            end
        end
    end

    -- 3. Check game's AttacksReplicate client service for active ready state
    local okAr, res = pcall(function()
        local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
        local ar = Loader.load_client_service(script, "AttacksReplicate")
        if ar and ar.get_current_active_attack_cooldown then
            local _, isReady = ar.get_current_active_attack_cooldown(griffin, "femto_egg:sacrifice")
            return isReady == true
        end
    end)
    if okAr and res == true then
        return true
    end

    -- 4. Check attributes on griffin
    for _, attr in ipairs({"sacrifice", "sacrifice_percent", "sacrifice_progress", "progress"}) do
        local aVal = griffin:GetAttribute(attr)
        if aVal and type(aVal) == "number" and aVal >= 100 then
            return true
        end
    end

    -- 5. Check stats for sacrifice progress
    local stats = griffin:FindFirstChild("_stats")
    if stats then
        for _, name in ipairs({"sacrifice", "sacrifice_percent", "sacrifice_progress", "sacrifice_pct", "progress", "behelit"}) do
            local val = stats:FindFirstChild(name)
            if val and val.Value then
                if val.Value >= 100 or (val.Value >= 1 and val.Value <= 1.05 and val.Value > 0.99) then
                    return true
                end
            end
        end
        local actReady = stats:FindFirstChild("active_attack_ready") or stats:FindFirstChild("can_use_active")
        if actReady and actReady.Value == true then
            return true
        end
    end

    return false
end

local getUnitUpgradeCost = function(unit)
    local GUIService = getGUIService()
    local UnitServiceCore = getUnitServiceCore()
    if GUIService and GUIService.get_next_upgrade_info then
        local success, nextInfo, isMaxed = pcall(function()
            return GUIService.get_next_upgrade_info(unit)
        end)
        if not success or isMaxed or not nextInfo then
            return nil, true
        end
        local rawCost = nextInfo.cost or 0
        local mult = 1
        if UnitServiceCore and UnitServiceCore.calculate_upgrade_cost_multiplier and GUIService.session then
            pcall(function()
                mult = UnitServiceCore.calculate_upgrade_cost_multiplier(unit, GUIService.session) or 1
            end)
        end
        return math.floor(rawCost * mult), false
    end
    local stats = unit:FindFirstChild("_stats")
    if stats then
        local costVal = stats:FindFirstChild("upgrade_cost") and stats.upgrade_cost.Value
        if costVal and costVal > 0 then
            return costVal, false
        end
    end
    return 500, false
end
State.getUnitUpgradeCost = getUnitUpgradeCost

State.processAutoGriffith = function()
    if not State.isAutoGriffithActive() then return end
    if tick() - (State.LastGriffinAction or 0) < 0.25 then return end
    State.LastGriffinAction = tick()

    local griffin = State.getPlacedGriffin()
    local eqGriffin, custom = State.getEquippedGriffinInfo()
    local money = getPlayerMoney()

    if not griffin then
        if not eqGriffin or (eqGriffin.cur and eqGriffin.cur >= 1) then return end
        if money < eqGriffin.cost then return end
        if State.IsPlacingUnit and (tick() - (State.PlacingStartTime or 0)) < 4.0 then return end

        local targetLane = State.Lanes and (State.Lanes["1"] or select(2, next(State.Lanes)))
        local pPos60 = nil
        local totalLength = 0
        if targetLane and #targetLane >= 2 then
            for i = 1, #targetLane - 1 do
                totalLength = totalLength + (targetLane[i + 1] - targetLane[i]).Magnitude
            end
            local d = 0.60 * totalLength
            pPos60 = getPointAndDirectionAtDistance(d, targetLane)
        end

        local function getDistToLane(pos, lane)
            if not lane or #lane < 2 then return 0 end
            local minD = math.huge
            local p2d = Vector3.new(pos.X, 0, pos.Z)
            for i = 1, #lane - 1 do
                local a = Vector3.new(lane[i].X, 0, lane[i].Z)
                local b = Vector3.new(lane[i + 1].X, 0, lane[i + 1].Z)
                local ab = b - a
                local len = ab.Magnitude
                if len > 0.001 then
                    local t = math.clamp((p2d - a):Dot(ab) / (len * len), 0, 1)
                    local proj = a + ab * t
                    local d = (p2d - proj).Magnitude
                    if d < minD then minD = d end
                end
            end
            return minD
        end

        local bestSpot = nil
        local bestScore = math.huge
        local isHill = (eqGriffin.isHill == true)

        -- 1. Search State.Spots for ground spot at ~60% lane, off the road to the side
        for _, spot in ipairs(State.Spots) do
            if not spot.occupied and not State.FailedSpots[spot.index] then
                local typeMatches = eqGriffin.isHybrid or (spot.isHill == isHill)
                if typeMatches and not spot.isHill and not spot.isRoad then
                    local dLane = getDistToLane(spot.position, targetLane)
                    local d60 = pPos60 and (Vector3.new(spot.position.X, 0, spot.position.Z) - Vector3.new(pPos60.X, 0, pPos60.Z)).Magnitude or 0
                    if dLane >= 7.5 and dLane <= 35 and d60 <= 45 then
                        local score = d60 + math.abs(dLane - 13) * 1.2
                        if score < bestScore then
                            bestScore = score
                            bestSpot = spot
                        end
                    end
                end
            end
        end

        -- Fallback: relax constraints slightly
        if not bestSpot then
            for _, spot in ipairs(State.Spots) do
                if not spot.occupied and not State.FailedSpots[spot.index] then
                    local typeMatches = eqGriffin.isHybrid or (spot.isHill == isHill)
                    if typeMatches and not spot.isHill and not spot.isRoad then
                        local dLane = getDistToLane(spot.position, targetLane)
                        local d60 = pPos60 and (Vector3.new(spot.position.X, 0, spot.position.Z) - Vector3.new(pPos60.X, 0, pPos60.Z)).Magnitude or 0
                        if dLane >= 6.0 and d60 <= 65 then
                            local score = d60 + math.abs(dLane - 13) * 1.5
                            if score < bestScore then
                                bestScore = score
                                bestSpot = spot
                            end
                        end
                    end
                end
            end
        end

        -- Secondary fallback: direct raycast perpendicular to lane at 60%
        if not bestSpot and pPos60 and targetLane then
            local _, pDir60 = getPointAndDirectionAtDistance(0.60 * totalLength, targetLane)
            local flatDir = Vector3.new(pDir60.X, 0, pDir60.Z)
            local perp = (flatDir.Magnitude > 0.01) and Vector3.new(-flatDir.Z, 0, flatDir.X).Unit or Vector3.new(1, 0, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {Workspace:FindFirstChild("_UNITS"), LocalPlayer.Character}
            for _, side in ipairs({1, -1}) do
                for dist = 12, 24, 3 do
                    local candPos = pPos60 + (perp * side * dist)
                    local rayRes = Workspace:Raycast(candPos + Vector3.new(0, 25, 0), Vector3.new(0, -50, 0), rayParams)
                    if rayRes and rayRes.Instance and rayRes.Instance.CanCollide then
                        local hitPart = rayRes.Instance
                        local isRoad = (Workspace:FindFirstChild("_road") and hitPart:IsDescendantOf(Workspace._road)) or hitPart.Name:lower():find("road") ~= nil
                        if not isRoad then
                            local bounds = Workspace:GetPartBoundsInRadius(rayRes.Position + Vector3.new(0, 1.2, 0), 1.2)
                            local clear = true
                            for _, b in ipairs(bounds) do
                                if b.CanCollide and b:IsDescendantOf(Workspace._UNITS) then
                                    clear = false
                                    break
                                end
                            end
                            if clear then
                                bestSpot = { position = rayRes.Position, index = -999 }
                                break
                            end
                        end
                    end
                end
                if bestSpot then break end
            end
        end

        if bestSpot then
            State.IsPlacingUnit = true
            State.PlacingStartTime = tick()
            State.LastPlacementTime = tick()
            local spawnCFrame = CFrame.new(bestSpot.position)
            local endpointsClient = getEndpointsClient()
            task.spawn(function()
                local ok, res = pcall(function()
                    if endpointsClient and endpointsClient.invoke_server then
                        return endpointsClient.invoke_server("spawn_unit", eqGriffin.uuid, spawnCFrame)
                    else
                        return Endpoints.spawn_unit:InvokeServer(eqGriffin.uuid, spawnCFrame)
                    end
                end)
                if ok and res == true then
                    if bestSpot.index and bestSpot.index > 0 then
                        bestSpot.occupied = true
                        markSpotVisualOccupied(bestSpot.index)
                    end
                    eqGriffin.cur = (eqGriffin.cur or 0) + 1
                    eqGriffin.canPlaceMore = (eqGriffin.cur < eqGriffin.max)
                else
                    if bestSpot.index and bestSpot.index > 0 then
                        bestSpot.occupied = true
                        State.FailedSpots[bestSpot.index] = tick() + 180.0
                    end
                end
                State.IsPlacingUnit = false
            end)
        end
        return
    end

    -- Griffin IS placed: verify if already completed
    if State.isGriffinBuffCompleted() then
        return
    end

    local griffinPos = (griffin.PrimaryPart and griffin.PrimaryPart.Position) or griffin:GetPivot().Position
    local gStats = griffin:FindFirstChild("_stats")
    local griffinRange = (gStats and gStats:FindFirstChild("range") and gStats.range.Value) or 20

    -- Refresh occupancy so newly freed spots from sacrifices are detected
    if type(State.refreshGridOccupancy) == "function" then pcall(State.refreshGridOccupancy) end

    -- Reset tracked sacrifice total if target Griffin changed
    local griffinUuid = (gStats and gStats:FindFirstChild("uuid") and gStats.uuid.Value) or tostring(griffin)
    if State._AutoGriffithLastTargetUuid ~= griffinUuid then
        State._AutoGriffithLastTargetUuid = griffinUuid
        State.GriffinAccumulatedSacrifice = 0
    end

    local TARGET_SACRIFICE = 100000
    local UnitsData = getUnitsData and getUnitsData()

    -- 1. Read already sacrificed amount (from server attributes/stats or local tracked accumulator)
    local serverSacrificed = griffin:GetAttribute("total_spent_buff")
        or griffin:GetAttribute("sacrifice_amount")
        or (gStats and gStats:FindFirstChild("total_spent_buff") and gStats.total_spent_buff.Value)
        or 0
    local alreadySacrificed = math.max(State.GriffinAccumulatedSacrifice or 0, serverSacrificed)

    -- 2. Inspect units currently on field in Griffin's range
    local owned = getOwnedUnitsInGame()
    local buffsInRange = {}
    local upgradableBuffs = {}
    local fieldSpent = 0
    local fieldRemainingPotential = 0

    for _, u in ipairs(owned) do
        if State.isBuffFodderUnit(u) and u.PrimaryPart then
            local dist = (u.PrimaryPart.Position - griffinPos).Magnitude
            if dist <= (griffinRange + 2.0) then
                table.insert(buffsInRange, u)
                local stats = u:FindFirstChild("_stats")
                local curSpent = (stats and stats:FindFirstChild("total_spent") and stats.total_spent.Value) or 0
                fieldSpent = fieldSpent + curSpent

                local curUpg = stats and stats:FindFirstChild("upgrade") and stats.upgrade.Value or 0
                local maxUpg = stats and stats:FindFirstChild("max_upgrade") and stats.max_upgrade.Value or 15
                local unitId = stats and stats:FindFirstChild("id") and stats.id.Value
                local db = UnitsData and unitId and UnitsData[unitId]

                -- Calculate remaining upgrade potential for this unit
                local uRemainingPot = 0
                if db and db.upgrade then
                    for stage = curUpg + 1, math.min(#db.upgrade, maxUpg) do
                        local stCost = db.upgrade[stage] and db.upgrade[stage].cost or 0
                        uRemainingPot = uRemainingPot + stCost
                    end
                end
                fieldRemainingPotential = fieldRemainingPotential + uRemainingPot

                -- Check if next upgrade is available
                if curUpg < maxUpg then
                    local cost, isMaxed = getUnitUpgradeCost(u)
                    if not isMaxed and cost and cost > 0 then
                        table.insert(upgradableBuffs, {
                            unit = u,
                            cost = cost,
                            upgrade = curUpg,
                            unitId = unitId
                        })
                        if uRemainingPot == 0 then
                            fieldRemainingPotential = fieldRemainingPotential + cost
                        end
                    end
                end
            end
        end
    end

    local totalCommitted = alreadySacrificed + fieldSpent
    local remainingNeeded = math.max(0, TARGET_SACRIFICE - totalCommitted)

    -- Helper to execute sacrifice
    local function tryTriggerSacrifice()
        if #buffsInRange == 0 then return false end
        local now = tick()
        local cooldownOk = (now - (State.LastSacrificeTime or 0) >= 5.0)

        local okAr, isReady = pcall(function()
            local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local ar = Loader.load_client_service(script, "AttacksReplicate")
            if ar and ar.get_current_active_attack_cooldown then
                local _, ready = ar.get_current_active_attack_cooldown(griffin, "femto_egg:sacrifice")
                return ready == true
            end
        end)
        if okAr and isReady ~= nil then
            cooldownOk = isReady
        end

        if cooldownOk then
            State.LastSacrificeTime = now
            -- Accumulate current field spent into State.GriffinAccumulatedSacrifice
            State.GriffinAccumulatedSacrifice = (State.GriffinAccumulatedSacrifice or 0) + fieldSpent
            pcall(function()
                local epc = getEndpointsClient()
                if epc and epc.invoke_server then
                    epc.invoke_server("use_active_attack", griffin)
                end
                if Endpoints:FindFirstChild("use_active_attack") then
                    Endpoints.use_active_attack:InvokeServer(griffin)
                end
            end)
            task.wait(0.5)
            if State.isGriffinBuffCompleted() then
                return true
            end
            return true
        end
        return false
    end

    -- 3. If target reached or exceeded: stop placing/upgrading and trigger sacrifice!
    if remainingNeeded <= 0 then
        tryTriggerSacrifice()
        return
    end

    -- 4. Check equipped buff units that have free placement capacity
    local equipped = getEquippedUnits(true)
    local freeBuffEquip = nil
    for _, eq in ipairs(equipped) do
        if State.isBuffFodderUnit(eq) then
            local cur = eq.cur or 0
            local realCap = eq.spawnCap or (UnitsData and eq.unitId and UnitsData[eq.unitId] and UnitsData[eq.unitId].spawn_cap) or 6
            if cur < realCap then
                freeBuffEquip = eq
                break
            end
        end
    end

    -- 5. Place a new buff unit ONLY if existing units in range cannot cover remainingNeeded!
    -- If fieldRemainingPotential >= remainingNeeded, existing units can satisfy the rest via upgrades.
    local needMoreUnits = (remainingNeeded > fieldRemainingPotential)
    if needMoreUnits and freeBuffEquip and money >= freeBuffEquip.cost then
        if not (State.IsPlacingUnit and (tick() - (State.PlacingStartTime or 0)) < 4.0) then
            local buffSpot = nil
            local bestBuffDist = math.huge
            local isHill = freeBuffEquip.isHill == true
            for _, spot in ipairs(State.Spots) do
                if not spot.occupied and not State.FailedSpots[spot.index] then
                    local typeMatches = freeBuffEquip.isHybrid or (spot.isHill == isHill)
                    if typeMatches and not spot.isHill and not spot.isRoad then
                        local d = (spot.position - griffinPos).Magnitude
                        if d <= (griffinRange - 2.0) and d >= 2.5 then
                            if d < bestBuffDist then
                                bestBuffDist = d
                                buffSpot = spot
                            end
                        end
                    end
                end
            end

            local targetSpawnCFrame = nil
            if buffSpot then
                targetSpawnCFrame = CFrame.new(buffSpot.position)
            else
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {Workspace:FindFirstChild("_UNITS"), LocalPlayer.Character}
                local radii = {4.0, 7.0, 10.5, 14.0, 17.0}
                local angles = {0, 45, 90, 135, 180, 225, 270, 315}
                for _, r in ipairs(radii) do
                    if r > (griffinRange - 2.0) then break end
                    for _, deg in ipairs(angles) do
                        local rad = math.rad(deg)
                        local cand = griffinPos + Vector3.new(math.cos(rad) * r, 0, math.sin(rad) * r)
                        local rayRes = Workspace:Raycast(cand + Vector3.new(0, 15, 0), Vector3.new(0, -35, 0), rayParams)
                        if rayRes and rayRes.Instance and rayRes.Instance.CanCollide then
                            local bounds = Workspace:GetPartBoundsInRadius(rayRes.Position + Vector3.new(0, 1.2, 0), 1.2)
                            local clear = true
                            for _, b in ipairs(bounds) do
                                if b.CanCollide and b:IsDescendantOf(Workspace._UNITS) then
                                    clear = false
                                    break
                                end
                            end
                            if clear then
                                targetSpawnCFrame = CFrame.new(rayRes.Position)
                                break
                            end
                        end
                    end
                    if targetSpawnCFrame then break end
                end
            end

            if targetSpawnCFrame then
                State.IsPlacingUnit = true
                State.PlacingStartTime = tick()
                State.LastPlacementTime = tick()
                local endpointsClient = getEndpointsClient()
                task.spawn(function()
                    local ok, res = pcall(function()
                        if endpointsClient and endpointsClient.invoke_server then
                            return endpointsClient.invoke_server("spawn_unit", freeBuffEquip.uuid, targetSpawnCFrame)
                        else
                            return Endpoints.spawn_unit:InvokeServer(freeBuffEquip.uuid, targetSpawnCFrame)
                        end
                    end)
                    if ok and res == true then
                        if buffSpot and buffSpot.index and buffSpot.index > 0 then
                            buffSpot.occupied = true
                            markSpotVisualOccupied(buffSpot.index)
                        end
                        freeBuffEquip.cur = (freeBuffEquip.cur or 0) + 1
                        freeBuffEquip.canPlaceMore = (freeBuffEquip.cur < (freeBuffEquip.spawnCap or 6))
                    end
                    State.IsPlacingUnit = false
                end)
                return
            end
        end
    end

    -- 6. Upgrade buff units optimally to meet remainingNeeded without overspending
    local affordableUpgrades = {}
    for _, cand in ipairs(upgradableBuffs) do
        if money >= cand.cost then
            -- Score calculation:
            -- If cost <= remainingNeeded: score = (remainingNeeded - cost), range [0, remainingNeeded]
            -- If cost > remainingNeeded: overshoot! score = 1000000 + (cost - remainingNeeded)
            local score = 0
            if cand.cost <= remainingNeeded then
                score = (remainingNeeded - cand.cost)
            else
                score = 1000000 + (cand.cost - remainingNeeded)
            end
            table.insert(affordableUpgrades, {cand = cand, score = score, cost = cand.cost})
        end
    end

    if #affordableUpgrades > 0 then
        table.sort(affordableUpgrades, function(a, b) return a.score < b.score end)
        local bestUpgrade = affordableUpgrades[1].cand
        if not State.IsUpgradingUnit or (tick() - (State.UpgradingStartTime or 0)) >= 3.0 then
            State.IsUpgradingUnit = true
            State.UpgradingStartTime = tick()
            State.LastUpgradeTime = tick()
            task.spawn(function()
                pcall(function()
                    Endpoints.upgrade_unit_ingame:InvokeServer(bestUpgrade.unit)
                end)
                State.IsUpgradingUnit = false
            end)
            return
        end
    end

    -- 7. If cannot upgrade further and cannot place further, but have buff units placed, sacrifice them
    if #buffsInRange > 0 then
        local cannotUpgradeFurther = (#affordableUpgrades == 0)
        local cannotPlaceFurther = (not freeBuffEquip) or (money < freeBuffEquip.cost) or (not needMoreUnits)
        if cannotUpgradeFurther and cannotPlaceFurther then
            tryTriggerSacrifice()
        end
    end
end

local _lastPlaceLoopCheck = 0
local processAutoPlace = function()
    if isLobby() or not Config.AutoPlaceEnabled then return end
    if State.isAutoGriffithActive and State.isAutoGriffithActive() then return end
    if State.IsPlacingUnit and (tick() - (State.PlacingStartTime or 0)) < 4.0 then return end

    local now = tick()
    if (now - _lastPlaceLoopCheck) < 0.15 then return end
    _lastPlaceLoopCheck = now

    if (now - State.LastPlacementTime) < Config.PlacementInterval then return end

    local stickAnchors = nil
    if Config.PlaceStickToPlayers then
        stickAnchors = State.getOtherPlayersAnchors()
        if not stickAnchors or #stickAnchors == 0 then
            State.NextSpot = nil
            State.NextSlot = nil
            State.NextUnitInfo = nil
            updateGhostHologram()
            return
        end
    end
    if State.FailedSpots then
        for k, exp in pairs(State.FailedSpots) do
            if now > exp then
                State.FailedSpots[k] = nil
            end
        end
    else
        State.FailedSpots = {}
    end
    local equipped = getEquippedUnits()
    if #equipped == 0 then return end
    if #State.Spots == 0 then
        if not State._computingGrid then
            task.spawn(computeCompactGrid)
        end
        return
    end
    refreshGridOccupancy()
    local owned = getOwnedUnitsInGame()
    local laneCounts = {}
    for laneName, _ in pairs(State.Lanes) do
        laneCounts[laneName] = 0
    end
    for _, spot in ipairs(State.Spots) do
        if spot.occupied and laneCounts[spot.lane] then
            laneCounts[spot.lane] = laneCounts[spot.lane] + 1
        end
    end
    local targetUnitInfo = nil
    local order = Config.UseCustomPlacementOrder and Config.PlacementOrder or {1, 2, 3, 4, 5, 6}
    local grifConfigured = State.hasAutoGriffithConfigured and State.hasAutoGriffithConfigured() and not State.isGriffinBuffCompleted()
    for _, slotIndex in ipairs(order) do
        if Config.SlotPlacement[slotIndex] ~= false and (Config.SlotLimits[slotIndex] or 6) > 0 then
            for _, eq in ipairs(equipped) do
                if eq.slot == slotIndex and eq.canPlaceMore then
                    if grifConfigured and (State.isBuffFodderUnit(eq) or State.isGriffinUnit(eq)) then
                        -- Reserved for Auto Griffith
                    else
                        targetUnitInfo = eq
                        break
                    end
                end
            end
            if targetUnitInfo then break end
        end
    end
    State.NextUnitInfo = targetUnitInfo
    State.NextSlot = targetUnitInfo and targetUnitInfo.slot or nil
    if not targetUnitInfo then
        State.NextSpot = nil
        updateGhostHologram()
        return
    end
    local bestSpot = nil
    local bestScore = math.huge
    local custom = targetUnitInfo.slot and Config.UnitCustomSettings and Config.UnitCustomSettings[targetUnitInfo.slot]
    local isCEO = isCEOUnit(targetUnitInfo)
    local isFarm = isFarmUnit(targetUnitInfo)
    local desiredPct
    if custom and custom.CustomPath and custom.CustomPath > 0 then
        desiredPct = custom.CustomPath
    elseif isCEO then
        desiredPct = 95
    elseif isFarm then
        desiredPct = Config.FarmPathPercentage or 85
    else
        desiredPct = Config.PathPercentage
    end
    local customAreaPos = State.getCustomPlacementArea()
    local targetCenterPos = nil
    if customAreaPos then
        targetCenterPos = customAreaPos
    elseif State.Lanes then
        local targetLane = State.Lanes["1"] or select(2, next(State.Lanes))
        if targetLane and #targetLane >= 2 then
            local totalLength = 0
            for i = 1, #targetLane - 1 do
                totalLength = totalLength + (targetLane[i + 1] - targetLane[i]).Magnitude
            end
            local d = math.clamp(desiredPct / 100, 0, 1) * totalLength
            targetCenterPos, _ = getPointAndDirectionAtDistance(d, targetLane)
        end
    end
    -- Own farms keep the normal farm placement; everything else follows teammates.
    local playerAnchors = nil
    if Config.PlaceStickToPlayers and stickAnchors and #stickAnchors > 0 and not isFarm then
        playerAnchors = stickAnchors
    end
    local scoreSpot = function(spot)
        if playerAnchors and #playerAnchors > 0 then
            local center = playerAnchors[1]
            local dist = (spot.position - center).Magnitude
            local inCircle = (dist <= 22.0)
            if inCircle or spot.isPlayerAnchorSpot then
                return dist
            else
                return 10000 + dist
            end
        end
        if targetCenterPos then
            local dist = (spot.position - targetCenterPos).Magnitude
            local inCircle = (dist <= 18.0)
            local laneLoad = laneCounts[spot.lane] or 0
            if inCircle then
                return dist + (laneLoad * 0.05)
            else
                local pctDiff = math.abs((spot.pathPercent or Config.PathPercentage) - desiredPct)
                return 2000 + (pctDiff * 100) + dist + (laneLoad * 0.05)
            end
        end
        local laneLoad = laneCounts[spot.lane] or 0
        local pctDiff = math.abs((spot.pathPercent or Config.PathPercentage) - desiredPct)
        return (pctDiff * 1000) + (laneLoad * 100) + spot.centerDistance
    end
    for _, spot in ipairs(State.Spots) do
        if not spot.occupied and not State.FailedSpots[spot.index] then
            local typeMatches = false
            if targetUnitInfo.isHybrid then
                local uName = targetUnitInfo.name or ""
                local prefGround = (Config.HybridGround == uName or Config.HybridGround == "All Hybrid" or (type(Config.HybridGround) == "table" and table.find(Config.HybridGround, uName)))
                local prefHill = (Config.HybridHill == uName or Config.HybridHill == "All Hybrid" or (type(Config.HybridHill) == "table" and table.find(Config.HybridHill, uName)))
                if prefGround and not prefHill then
                    typeMatches = not spot.isHill
                elseif prefHill and not prefGround then
                    typeMatches = spot.isHill
                else
                    typeMatches = true
                end
            elseif targetUnitInfo.isHill then
                typeMatches = spot.isHill
            else
                typeMatches = not spot.isHill
            end
            if typeMatches then
                local score = scoreSpot(spot)
                if score < bestScore then
                    bestScore = score
                    bestSpot = spot
                end
            end
        end
    end
    if not bestSpot and targetUnitInfo and targetUnitInfo.isHybrid then
        for _, spot in ipairs(State.Spots) do
            if not spot.occupied and not State.FailedSpots[spot.index] then
                local score = scoreSpot(spot)
                if score < bestScore then
                    bestScore = score
                    bestSpot = spot
                end
            end
        end
    end
    State.NextSpot = bestSpot
    updateGhostHologram()
    if bestSpot then
        local money = getPlayerMoney()
        if money < targetUnitInfo.cost then
            State.LastPlacementTime = tick() - (Config.PlacementInterval or 0.3) + 0.8
            return
        end
        State.IsPlacingUnit = true
        State.PlacingStartTime = tick()
        State.LastPlacementTime = tick()
            local lookVector = (bestSpot.lookTarget - bestSpot.position)
            local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)
            local spawnCFrame = CFrame.new(bestSpot.position)
            if flatLook.Magnitude > 0.1 then
                spawnCFrame = CFrame.new(bestSpot.position, bestSpot.position + flatLook)
            end
            local unitUuid = targetUnitInfo.uuid
            local placedSpot = bestSpot
            local placedUnitInfo = targetUnitInfo
            local endpointsClient = getEndpointsClient()
            task.spawn(function()
                local success, res = pcall(function()
                    if endpointsClient and endpointsClient.invoke_server then
                        return endpointsClient.invoke_server("spawn_unit", unitUuid, spawnCFrame)
                    else
                        return Endpoints.spawn_unit:InvokeServer(unitUuid, spawnCFrame)
                    end
                end)
                if success and res == true then
                    placedSpot.occupied = true
                    placedUnitInfo.cur = placedUnitInfo.cur + 1
                    placedUnitInfo.canPlaceMore = (placedUnitInfo.cur < placedUnitInfo.max)
                    markSpotVisualOccupied(placedSpot.index)
                    updateGhostHologram()
                else
                    placedSpot.occupied = true
                    State.FailedSpots[placedSpot.index] = tick() + 300.0

                    local originPos = placedSpot.position
                    local candidates = {}
                    local isHybrid = placedUnitInfo.isHybrid
                    local isHill = placedUnitInfo.isHill
                    local uName = placedUnitInfo.name or ""
                    local prefGround = isHybrid and (Config.HybridGround == uName or Config.HybridGround == "All Hybrid" or (type(Config.HybridGround) == "table" and table.find(Config.HybridGround, uName)))
                    local prefHill = isHybrid and (Config.HybridHill == uName or Config.HybridHill == "All Hybrid" or (type(Config.HybridHill) == "table" and table.find(Config.HybridHill, uName)))

                    for _, cand in ipairs(State.Spots) do
                        if cand.index ~= placedSpot.index and not cand.occupied and not State.FailedSpots[cand.index] then
                            local typeMatches = false
                            if isHybrid then
                                if prefGround and not prefHill then
                                    typeMatches = not cand.isHill
                                elseif prefHill and not prefGround then
                                    typeMatches = cand.isHill
                                else
                                    typeMatches = true
                                end
                            elseif isHill then
                                typeMatches = cand.isHill
                            else
                                typeMatches = not cand.isHill
                            end
                            if typeMatches then
                                local dist = (cand.position - originPos).Magnitude
                                if dist <= 50.0 then
                                    table.insert(candidates, { spot = cand, dist = dist })
                                end
                            end
                        end
                    end
                    if #candidates == 0 and isHybrid then
                        for _, cand in ipairs(State.Spots) do
                            if cand.index ~= placedSpot.index and not cand.occupied and not State.FailedSpots[cand.index] then
                                local dist = (cand.position - originPos).Magnitude
                                if dist <= 50.0 then
                                    table.insert(candidates, { spot = cand, dist = dist })
                                end
                            end
                        end
                    end
                    table.sort(candidates, function(a, b) return a.dist < b.dist end)

                    for cIdx = 1, math.min(5, #candidates) do
                        local cand = candidates[cIdx].spot
                        local cLook = (cand.lookTarget - cand.position)
                        local cFlat = Vector3.new(cLook.X, 0, cLook.Z)
                        local candCFrame = CFrame.new(cand.position)
                        if cFlat.Magnitude > 0.1 then
                            candCFrame = CFrame.new(cand.position, cand.position + cFlat)
                        end
                        task.wait(0.12)
                        local cSuccess, cRes = pcall(function()
                            if endpointsClient and endpointsClient.invoke_server then
                                return endpointsClient.invoke_server("spawn_unit", unitUuid, candCFrame)
                            else
                                return Endpoints.spawn_unit:InvokeServer(unitUuid, candCFrame)
                            end
                        end)
                        if cSuccess and cRes == true then
                            cand.occupied = true
                            placedUnitInfo.cur = placedUnitInfo.cur + 1
                            placedUnitInfo.canPlaceMore = (placedUnitInfo.cur < placedUnitInfo.max)
                            markSpotVisualOccupied(cand.index)
                            updateGhostHologram()
                            break
                        else
                            cand.occupied = true
                            State.FailedSpots[cand.index] = tick() + 300.0
                        end
                    end
                end
                State.IsPlacingUnit = false
            end)
    end
end
local readCurrentTeam = function()
    local spawnGui = LocalPlayer.PlayerGui:FindFirstChild("spawn_units")
    local grid = spawnGui and spawnGui:FindFirstChild("Lives") and spawnGui.Lives:FindFirstChild("Frame") and spawnGui.Lives.Frame:FindFirstChild("Units")
    if not grid then return nil end
    local team = {}
    for s = 1, 6 do
        local sf = grid:FindFirstChild(tostring(s))
        local uuid = sf and sf:GetAttribute("_equipped_frame_unit_uuid")
        if uuid and uuid ~= "" then
            local nl = sf:FindFirstChild("name", true)
            table.insert(team, {slot = s, uuid = uuid, name = (nl and nl.Text ~= "" and nl.Text) or ("Slot " .. s)})
        end
    end
    return team
end
local saveTeamToPreset = function()
    local team = readCurrentTeam()
    if not team or #team == 0 then return 0 end
    Config.TeamPreset = team
    State.PresetEquipAttempts = 0
    triggerAutoSave()
    return #team
end
local teamMatchesPreset = function(team, preset)
    if #team ~= #preset then return false end
    local have = {}
    for _, u in ipairs(team) do have[u.uuid] = true end
    for _, u in ipairs(preset) do
        if not have[u.uuid] then return false end
    end
    return true
end
local invokeTeamEndpoint = function(name, ...)
    local remote = Endpoints:FindFirstChild(name)
    if not remote then return false end
    local args = {...}
    return (pcall(function()
        remote:InvokeServer(unpack(args))
    end))
end
-- Returns true while lobby automation should wait so the preset is on before joining.
local processAutoEquipPreset = function()
    if not Config.AutoEquipPreset then return false end
    local preset = Config.TeamPreset
    if type(preset) ~= "table" or #preset == 0 then return false end
    if State.EquippingPreset then return true end
    local inLobby = isLobby()
    if not inLobby then
        local data = Workspace:FindFirstChild("_DATA")
        local started = data and data:FindFirstChild("GameStarted")
        if not started or started.Value then return false end
    end
    -- Capped so a missing/sold unit can't block auto-join forever.
    local attempts = State.PresetEquipAttempts or 0
    if attempts >= 3 then return false end
    local team = readCurrentTeam()
    if not team then return false end
    if teamMatchesPreset(team, preset) then return false end
    if tick() - (State.LastPresetEquipTime or 0) < 4 then return inLobby end
    State.EquippingPreset = true
    State.PresetEquipAttempts = attempts + 1
    State.LastPresetEquipTime = tick()
    task.spawn(function()
        local wanted = {}
        for _, u in ipairs(preset) do wanted[u.uuid] = true end
        if Endpoints:FindFirstChild("unequip_all") then
            invokeTeamEndpoint("unequip_all")
            task.wait(0.3)
        else
            for _, u in ipairs(team) do
                if not wanted[u.uuid] then
                    invokeTeamEndpoint("unequip_unit", u.uuid)
                    task.wait(0.25)
                end
            end
        end
        local have = {}
        for _, u in ipairs(readCurrentTeam() or {}) do have[u.uuid] = true end
        local ordered = {}
        for _, u in ipairs(preset) do table.insert(ordered, u) end
        table.sort(ordered, function(a, b) return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0) end)
        for _, u in ipairs(ordered) do
            if not have[u.uuid] then
                invokeTeamEndpoint("equip_unit", u.uuid)
                task.wait(0.3)
            end
        end
        task.wait(0.5)
        pcall(getEquippedUnits, true)
        State.LastPresetEquipTime = tick()
        State.EquippingPreset = false
    end)
    return true
end

local processAutoUpgrade = function()
    if isLobby() or not Config.AutoUpgradeEnabled then return end
    if State.isAutoGriffithActive and State.isAutoGriffithActive() then return end
    if State.IsUpgradingUnit and (tick() - (State.UpgradingStartTime or 0)) < 3.0 then return end
    if tick() - State.LastUpgradeTime < Config.UpgradeInterval then return end
    local money = getPlayerMoney()
    if money <= 0 then return end
    local equipped = getEquippedUnits()
    local owned = getOwnedUnitsInGame()
    if #owned == 0 then return end
    if Config.AutoPlaceEnabled then
        local placeOrder = Config.UseCustomPlacementOrder and Config.PlacementOrder or {1, 2, 3, 4, 5, 6}
        local grifConfigured = State.hasAutoGriffithConfigured and State.hasAutoGriffithConfigured() and not State.isGriffinBuffCompleted()
        for _, slotIndex in ipairs(placeOrder) do
            if Config.SlotPlacement[slotIndex] ~= false and (Config.SlotLimits[slotIndex] or 6) > 0 then
                for _, eq in ipairs(equipped) do
                    if eq.slot == slotIndex and eq.canPlaceMore then
                        if not (grifConfigured and (State.isBuffFodderUnit(eq) or State.isGriffinUnit(eq))) then
                            return
                        end
                    end
                end
            end
        end
    end
    if Config.PhoenixReincarnate then
        for _, unit in ipairs(owned) do
            local stats = unit:FindFirstChild("_stats")
            if stats and stats:FindFirstChild("upgrade") and not State.PhoenixSold[unit] then
                local currentUpgrade = stats.upgrade.Value
                local maxUpgrade = stats:FindFirstChild("max_upgrade") and stats.max_upgrade.Value or 15
                local uName = unit.Name:lower()
                if uName:find("phoenix") ~= nil and currentUpgrade >= maxUpgrade then
                    State.PhoenixSold[unit] = true
                    State.LastUpgradeTime = tick()
                    pcall(function()
                        if Endpoints:FindFirstChild("sell_unit_ingame") then
                            Endpoints.sell_unit_ingame:InvokeServer(unit)
                        end
                    end)
                    return
                end
            end
        end
    end
    local upgOrder = Config.UseCustomUpgradeOrder and Config.UpgradeOrder or {1, 2, 3, 4, 5, 6}
    local priorityCandidates = {}
    for _, slotIndex in ipairs(upgOrder) do
        local slotUnits = {}
        for _, unit in ipairs(owned) do
            local slot = getUnitSlot(unit, equipped)
            if slot == slotIndex then
                local stats = unit:FindFirstChild("_stats")
                if stats and stats:FindFirstChild("upgrade") then
                    local currentUpgrade = stats.upgrade.Value
                    local maxUpgrade = stats:FindFirstChild("max_upgrade") and stats.max_upgrade.Value or 15
                    local slotCap = Config.SlotMaxUpgrades[slot] or Config.GlobalMaxUpgrades
                    local cap = math.min(slotCap, maxUpgrade)
                    if currentUpgrade < cap then
                        local cost, isMaxed = getUnitUpgradeCost(unit)
                        if not isMaxed and cost and cost > 0 then
                            table.insert(slotUnits, {
                                unit = unit,
                                current = currentUpgrade,
                                cost = cost,
                                slot = slotIndex
                            })
                        end
                    end
                end
            end
        end
        if #slotUnits > 0 then
            table.sort(slotUnits, function(a, b) return a.current > b.current end)
            table.insert(priorityCandidates, slotUnits[1])
        end
    end
    if #priorityCandidates == 0 then return end
    local chosenTarget = nil
    local topTarget = priorityCandidates[1]
    if Config.SmartCostBalancing ~= false and #priorityCandidates >= 2 then
        local nextTarget = priorityCandidates[2]
        if nextTarget.cost < topTarget.cost then
            chosenTarget = nextTarget
        else
            chosenTarget = topTarget
        end
    else
        chosenTarget = topTarget
    end
    if chosenTarget and chosenTarget.unit then
        if money >= chosenTarget.cost then
            State.IsUpgradingUnit = true
            State.UpgradingStartTime = tick()
            State.LastUpgradeTime = tick()
            local targetUnit = chosenTarget.unit
            task.spawn(function()
                pcall(function()
                    Endpoints.upgrade_unit_ingame:InvokeServer(targetUnit)
                end)
                State.IsUpgradingUnit = false
            end)
            return
        else
            State.LastUpgradeTime = tick() - (Config.UpgradeInterval or 0.3) + 1.0
            return
        end
    end
end
local isManagedByAutoBuff = function(unit)
    if not unit then return false end
    local stats = unit:FindFirstChild("_stats")
    local uId = (stats and stats:FindFirstChild("id") and tostring(stats.id.Value):lower()) or ""
    local uName = unit.Name:lower()
    if uId:find("wendy") or uName:find("wendy") then return true end
    if uId:find("erwin") or uId:find("commander") or uName:find("erwin") or uName:find("commander") then return true end
    if uId:find("leafy") or uName:find("leafy") then return true end
    return false
end
local isShadowgirlLoopManaged = function(unit, equipped)
    if not isShadowgirlUnit(unit) then return false end
    equipped = equipped or getEquippedUnits()
    local slot = getUnitSlot(unit, equipped)
    local custom = slot and Config.UnitCustomSettings and Config.UnitCustomSettings[slot]
    if custom and (custom.IdealLoop == true or custom.Ability == "Ideal Loop") then
        return true
    end
    return false
end
local processAutoAbilities = function()
    if isLobby() or not Config.AutoAbilitiesEnabled then return end
    if tick() - State.LastAbilityTime < Config.AbilityInterval then return end
    State.LastAbilityTime = tick()
    local currentWave = getCurrentWave()
    local equipped = getEquippedUnits()
    local owned = getOwnedUnitsInGame()
    local nowTick = tick()
    for _, unit in ipairs(owned) do
        local uName = (unit.Name or ""):lower()
        local uId = (unit:GetAttribute("unit_id") or ""):lower()
        if not isManagedByAutoBuff(unit) and not isShadowgirlLoopManaged(unit, equipped) and not uName:find("mahoraga") and not uId:find("mahoraga") then
            local stats = unit:FindFirstChild("_stats")
            if stats and stats:FindFirstChild("active_attack") and stats.active_attack.Value ~= "" and stats.active_attack.Value ~= "nil" then
                local cd = stats:FindFirstChild("active_attack_cooldown") and stats.active_attack_cooldown.Value or 0
                local lastCast = stats:FindFirstChild("last_active_cast") and stats.last_active_cast.Value or -100000000
                local remaining = 0
                if lastCast > 0 then
                    remaining = cd - (nowTick - lastCast)
                end
                if remaining <= 0 then
                    local slot = getUnitSlot(unit, equipped)
                    local custom = slot and Config.UnitCustomSettings and Config.UnitCustomSettings[slot]
                    local mode = (custom and custom.Ability ~= "Default" and custom.Ability) or Config.AbilityMode
                    local startWave = (custom and custom.AbilityWave) or Config.AbilityStartWave
                    if mode ~= "Disabled" and mode ~= "Never" then
                        local canCast = false
                        if mode == "Whenever Ready" or mode == "When Ready" or mode == "When ready" then
                            canCast = true
                        elseif mode == "From Wave" or mode == "From wave" then
                            canCast = (currentWave >= startWave)
                        elseif mode == "When Boss Is Near" or mode == "When boss is near" or mode == "Boss Near" or mode == "Boss near" then
                            local bosses = CollectionService:GetTagged("bosses")
                            local unitPos = unit.PrimaryPart and unit.PrimaryPart.Position
                            if unitPos then
                                for _, boss in ipairs(bosses) do
                                    local bossPos = boss.PrimaryPart and boss.PrimaryPart.Position
                                    if bossPos and (bossPos - unitPos).Magnitude <= Config.BossDetectionRange then
                                        canCast = true
                                        break
                                    end
                                end
                            end
                        end
                        if canCast then
                            State.LastAbilityTime = tick()
                            pcall(function()
                                if Endpoints:FindFirstChild("use_active_attack") then
                                    Endpoints.use_active_attack:InvokeServer(unit)
                                end
                            end)
                            return
                        end
                    end
                end
            end
        end
    end
end
local processUnitTargeting = function()
    if tick() - State.LastTargetCheckTime < 1.0 then return end
    State.LastTargetCheckTime = tick()
    local equipped = getEquippedUnits()
    local owned = getOwnedUnitsInGame()
    for _, unit in ipairs(owned) do
        local stats = unit:FindFirstChild("_stats")
        if stats and stats:FindFirstChild("priority") then
            local slot = getUnitSlot(unit, equipped)
            local custom = slot and Config.UnitCustomSettings and Config.UnitCustomSettings[slot]
            local desired = (custom and custom.Target ~= "Default" and custom.Target) or Config.GlobalTargetPriority
            if desired and desired ~= "Auto" and desired ~= "Default" then
                local cur = stats.priority.Value
                if string.lower(cur) ~= string.lower(desired) then
                    pcall(function()
                        if Endpoints:FindFirstChild("change_priority") then
                            Endpoints.change_priority:InvokeServer(unit, string.lower(desired))
                        end
                    end)
                end
            end
        end
    end
end
local qot = queue_on_teleport
    or queueonteleport
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)
    or syn_queue_on_teleport
local _teleportQueued = false
local function buildAutoLoadPayload(url)
    local fmtUrl = string.format("%q", tostring(url or "https://raw.githubusercontent.com/antihypeCM/AA/refs/heads/main/AJHUB.lua"))
    return table.concat({
        "task.spawn(function()",
        " if getgenv().AJ_HUB_BOOTING or getgenv().AJ_HUB_LOADED then return end",
        " getgenv().AJ_HUB_BOOTING = true",
        " local allow = true",
        " pcall(function()",
        "  if readfile and isfile and isfile('AJ_HUB_Config.json') then",
        "   local d = game:GetService('HttpService'):JSONDecode(readfile('AJ_HUB_Config.json'))",
        "   if d and d.Config and d.Config.AutoLoad == false then allow = false end",
        "  end",
        " end)",
        " if not allow then getgenv().AJ_HUB_BOOTING = nil return end",
        " if not game:IsLoaded() then game.Loaded:Wait() end",
        " local plrs = game:GetService('Players')",
        " local lp = plrs.LocalPlayer or plrs.PlayerAdded:Wait()",
        " local dl = tick() + 10",
        " while not lp.Character and tick() < dl do task.wait(0.15) end",
        " task.wait(0.6)",
        " if getgenv().AJ_HUB_LOADED then getgenv().AJ_HUB_BOOTING = nil return end",
        " local url = getgenv().AJ_HUB_URL or " .. fmtUrl,
        " local src = nil",
        " for i = 1, 4 do",
        "  local ok, body = pcall(function() return game:HttpGet(url) end)",
        "  if ok and type(body) == 'string' and #body > 1000 then",
        "   src = body",
        "   pcall(function()",
        "    if makefolder and isfolder and not isfolder('AJ_HUB') then makefolder('AJ_HUB') end",
        "    if writefile then writefile('AJ_HUB/autoload.lua', body) end",
        "   end)",
        "   break",
        "  end",
        "  task.wait(0.6)",
        " end",
        " if not src and readfile and isfile then",
        "  for _, p in ipairs({'AJ_HUB/autoload.lua', '123.lua'}) do",
        "   if isfile(p) then",
        "    local okR, data = pcall(readfile, p)",
        "    if okR and type(data) == 'string' and #data > 1000 then src = data break end",
        "   end",
        "  end",
        " end",
        " if src then local fn = loadstring(src) if fn then pcall(fn) end end",
        " getgenv().AJ_HUB_BOOTING = nil",
        "end)"
    })
end
local queueAutoLoad = function(force)
    if not Config.AutoLoad or not qot then return end
    if _teleportQueued and not force then return end
    _teleportQueued = true
    local targetUrl = getgenv().AJ_HUB_URL or Config.AutoLoadUrl or "https://raw.githubusercontent.com/antihypeCM/AA/refs/heads/main/AJHUB.lua"
    pcall(function()
        qot(buildAutoLoadPayload(targetUrl))
    end)
end
if Config.AutoLoad then
    queueAutoLoad(false)
end
pcall(function()
    if LocalPlayer then
        LocalPlayer.OnTeleport:Connect(function(state)
            if Config.AutoLoad and (state == nil or state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress) then
                queueAutoLoad(false)
            end
        end)
    end
end)

local syncAntiAfk = function()
    if Config.AntiPunishments or Config.AntiPunishment then
        if not State.AntiAfkConnection and VirtualUser then
            pcall(function()
                State.AntiAfkConnection = LocalPlayer.Idled:Connect(function()
                    if not VirtualUser then return end
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end)
            end)
        end
    else
        if State.AntiAfkConnection then
            pcall(function()
                State.AntiAfkConnection:Disconnect()
            end)
            State.AntiAfkConnection = nil
        end
    end
end
syncAntiAfk()
local processAntiPunishment = function()
    syncAntiAfk()
    if (Config.AntiPunishments or Config.AntiPunishment) and VirtualUser then
        if tick() - (State.LastAntiAfkTime or 0) >= 25.0 then
            State.LastAntiAfkTime = tick()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end

    if not Config.AntiPunishment or isLobby() then
        if State.AntiPunishWalking then
            State.AntiPunishWalking = false
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    hum:MoveTo(hrp.Position)
                end
            end)
        end
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return end

    local lanes = State.Lanes
    if not lanes or next(lanes) == nil then
        lanes = refreshAllLanes()
    end
    if not lanes or next(lanes) == nil then return end

    local pts = lanes["1"]
    if not pts or #pts < 2 then
        for _, lp in pairs(lanes) do
            if lp and #lp >= 2 then
                pts = lp
                break
            end
        end
    end
    if not pts or #pts < 2 then return end

    State.AntiPunishWalking = true

    if not State.AntiPunishIdx or State.AntiPunishIdx < 1 or State.AntiPunishIdx > #pts then
        local closestIdx = 1
        local closestDist = math.huge
        for i, pt in ipairs(pts) do
            local d = (hrp.Position - pt).Magnitude
            if d < closestDist then
                closestDist = d
                closestIdx = i
            end
        end
        State.AntiPunishIdx = closestIdx
        State.AntiPunishForward = (closestIdx < #pts)
        State.AntiPunishWaypointStartTime = tick()
    end

    local targetPt = pts[State.AntiPunishIdx]
    if not targetPt then return end

    local flatDist = Vector2.new(hrp.Position.X - targetPt.X, hrp.Position.Z - targetPt.Z).Magnitude
    local timeAtWaypoint = tick() - (State.AntiPunishWaypointStartTime or tick())

    if flatDist <= 6.0 or timeAtWaypoint > 5.0 then
        if flatDist > 6.0 and timeAtWaypoint > 2.0 and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end

        if State.AntiPunishForward then
            if State.AntiPunishIdx >= #pts then
                State.AntiPunishForward = false
                State.AntiPunishIdx = math.max(1, #pts - 1)
            else
                State.AntiPunishIdx = State.AntiPunishIdx + 1
            end
        else
            if State.AntiPunishIdx <= 1 then
                State.AntiPunishForward = true
                State.AntiPunishIdx = math.min(#pts, 2)
            else
                State.AntiPunishIdx = State.AntiPunishIdx - 1
            end
        end
        State.AntiPunishWaypointStartTime = tick()
        targetPt = pts[State.AntiPunishIdx]
    end

    if tick() - (State.AntiPunishLastMoveTime or 0) >= 0.4 then
        State.AntiPunishLastMoveTime = tick()
        pcall(function()
            hum:MoveTo(targetPt)
        end)
    end
end
local processAutoSkip = function()
    if not Config.AutoWaveSkip then return end
    if game.PlaceId == 8304191830 or not workspace:FindFirstChild("_DATA") then return end
    if tick() - State.LastSkipTime < 1.0 then return end
    State.LastSkipTime = tick()
    pcall(function()
        if Endpoints:FindFirstChild("vote_wave_skip") then
            Endpoints.vote_wave_skip:InvokeServer()
        end
    end)
end
local processAutoStart = function()
    if not Config.AutoStart then return end
    if game.PlaceId == 8304191830 then return end
    local voteData = workspace:FindFirstChild("_DATA")
    if not voteData then return end
    if tick() - (State.LastStartVoteTime or 0) < 1.0 then return end
    local gameStarted = false
    if voteData and voteData:FindFirstChild("GameStarted") then
        gameStarted = voteData.GameStarted.Value
    end
    if not gameStarted then
        State.LastStartVoteTime = tick()
        pcall(function()
            if Endpoints:FindFirstChild("vote_start") then
                Endpoints.vote_start:InvokeServer()
            end
            if Endpoints:FindFirstChild("request_start_game") then
                Endpoints.request_start_game:InvokeServer()
            end
            local voteGui = LocalPlayer.PlayerGui:FindFirstChild("VoteStart")
            if voteGui and voteGui.Enabled then
                local yesBtn = voteGui:FindFirstChild("Holder") and voteGui.Holder:FindFirstChild("ButtonHolder") and voteGui.Holder.ButtonHolder:FindFirstChild("Yes")
                if yesBtn and firesignal then
                    firesignal(yesBtn.Activated)
                end
            end
        end)
    end
end
local isMatchFinished = function()
    if game.PlaceId == 8304191830 then return false end
    local d = workspace:FindFirstChild("_DATA")
    if d and d:FindFirstChild("GameFinished") and d.GameFinished.Value == true then
        return true
    end
    local r = LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
    if r and r.Enabled then
        local holder = r:FindFirstChild("Holder")
        local finished = r:FindFirstChild("Finished")
        if (holder and holder.Visible) or (finished and finished.Visible) then
            return true
        end
        for _, ch in ipairs(r:GetChildren()) do
            if ch:IsA("GuiObject") and ch.Visible then
                return true
            end
        end
    end
    return false
end
local formatCommas = function(amount)
    local formatted = tostring(math.floor(math.abs(tonumber(amount) or 0)))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end
local parseMatchRewards = function()
    local rewards = {}
    local hasSecret = false
    local seen = {}
    local seenIndex = {}

    local normalizeRewardKey = function(entry)
        local k = tostring(entry or "")
            :gsub("%[ Total:[^%]]*%]", "")
            :gsub("%(%s*Tier%s*[%w_]+%s*%)", "")
            :gsub(",", "")
            :gsub("%+", "")
            :gsub("[%c%s]+", " ")
            :lower()
            :match("^%s*(.-)%s*$")
        return k
    end

    local addReward = function(entry, isSecret)
        if not entry or #entry == 0 then return end
        local norm = normalizeRewardKey(entry)
        if not norm or #norm == 0 then return end
        if isSecret then
            hasSecret = true
        end
        if seen[norm] then
            local idx = seenIndex[norm]
            if idx and #entry > #(rewards[idx] or "") then
                rewards[idx] = entry
            end
            return
        end
        seen[norm] = true
        table.insert(rewards, entry)
        seenIndex[norm] = #rewards
    end

    local isRaritySecret = function(tbl, idStr, nameStr)
        if type(tbl) == "table" then
            local r = tostring(tbl.rarity or tbl.Rarity or ""):lower()
            if r:find("secret") then return true end
            if tbl.is_secret == true or tbl.secret == true then return true end
        end
        if idStr and tostring(idStr):lower():find("secret") then return true end
        if nameStr and tostring(nameStr):lower():find("secret") then return true end
        return false
    end

    local formatResourceName = function(rName)
        local cleanRName = tostring(rName)
        if cleanRName == "SummerPearls" or cleanRName:lower() == "summer_pearls" then
            return "Summer Pearls"
        elseif cleanRName == "Candies" or cleanRName:lower() == "candies" then
            return "Candies"
        elseif cleanRName == "Gems" or cleanRName:lower() == "gems" then
            return "Gems"
        elseif cleanRName == "Gold" or cleanRName:lower() == "gold" then
            return "Gold"
        elseif cleanRName == "GemsLegacy" then
            return "Legacy Gems"
        elseif cleanRName == "AprilCoins" then
            return "April Coins"
        elseif cleanRName == "HolidayStars" then
            return "Holiday Stars"
        end
        return cleanRName:gsub("^_+", ""):gsub("([a-z])([A-Z])", "%1 %2"):gsub("_", " ")
    end

    local ItemsData = nil
    pcall(function()
        ItemsData = require(game:GetService("ReplicatedStorage").src.Data.Items)
    end)
    local UnitsData = getUnitsData()

    local Loader = nil
    pcall(function()
        Loader = require(game:GetService("ReplicatedStorage").src.Loader)
    end)
    local guiService = Loader and Loader.load_client_service and Loader.load_client_service(nil, "GUIService")
    local rUI = guiService and guiService.results_ui
    local UnitCollSvc = getUnitCollectionServiceClient()
    local invSvc = Loader and Loader.load_client_service and Loader.load_client_service(nil, "ItemInventoryServiceClient")
    local s = State.LastMatchSettings or (rUI and rUI.settings)

    local resolveItemTotalInInv = function(itemId)
        local totalInInv = 0
        pcall(function()
            local sInv = invSvc and invSvc.session and invSvc.session.inventory
            if sInv and sInv.item_uuid_cache then
                for _, it in pairs(sInv.item_uuid_cache) do
                    if type(it) == "table" and (it.item_id == itemId or it._item_id == itemId) then
                        totalInInv = totalInInv + 1
                    end
                end
            end
            if totalInInv == 0 and sInv and sInv.inventory_profile_data and sInv.inventory_profile_data.normal_items and sInv.inventory_profile_data.normal_items[itemId] then
                totalInInv = tonumber(sInv.inventory_profile_data.normal_items[itemId]) or 0
            elseif totalInInv == 0 and sInv and sInv.normal_items and sInv.normal_items[itemId] then
                totalInInv = tonumber(sInv.normal_items[itemId]) or 0
            end
        end)
        return totalInInv
    end

    local appendItemEntry = function(itemId, amount, tier, itemObj)
        if not itemId and not (type(itemObj) == "table" and itemObj._mock_resource) then return end
        if itemId == "_mock_resource_item" or (type(itemObj) == "table" and itemObj._mock_resource) then
            local resName = (type(itemObj) == "table" and itemObj._mock_resource) or itemId
            addReward("+" .. formatCommas(amount or 1) .. " " .. formatResourceName(resName))
            return
        end
        local iData = (ItemsData and itemId and ItemsData[itemId]) or nil
        local displayName = (iData and (iData.name or iData.title)) or tostring(itemId)
        if tier == nil and type(itemObj) == "table" then
            local ud = itemObj._unique_item_data
            if type(ud) == "table" then
                tier = ud.portal_depth or ud.tier or (type(ud._unique_portal_data) == "table" and (ud._unique_portal_data.portal_depth or ud._unique_portal_data.tier))
            end
        end
        if tier == nil and iData and iData.tier then
            tier = iData.tier
        end
        local isSecretItem = isRaritySecret(iData, itemId, displayName)
        local amtNum = tonumber(amount) or 1
        local entry = "+" .. tostring(amtNum) .. " " .. displayName
        if tier ~= nil then
            local totalInInv = resolveItemTotalInInv(itemId)
            local totalStr = totalInInv > 0 and string.format(" [ Total: %d ]", totalInInv) or ""
            entry = entry .. string.format("\n(Tier %s)%s", tostring(tier), totalStr)
        elseif amtNum > 1 then
            local totalInInv = resolveItemTotalInInv(itemId)
            local totalStr = totalInInv > 0 and string.format(" [ Total: %d ]", totalInInv) or ""
            entry = entry .. totalStr
        else
            local totalInInv = resolveItemTotalInInv(itemId)
            if totalInInv > 0 and iData and (iData.item_group == "Portals" or isSecretItem) then
                entry = entry .. string.format(" [ Total: %d ]", totalInInv)
            end
        end
        addReward(entry, isSecretItem)
    end

    local appendUnitEntry = function(uObj)
        local uUuid = nil
        local uId = nil
        local isShiny = false
        if type(uObj) == "string" then
            uUuid = uObj
        elseif type(uObj) == "table" then
            uUuid = uObj.uuid
            uId = uObj.unit_id or uObj.id
            isShiny = uObj.shiny == true
        end
        if uUuid and UnitCollSvc and UnitCollSvc.session and UnitCollSvc.session.collection and UnitCollSvc.session.collection.get_unit_by_uuid then
            local okU, liveUnit = pcall(function()
                return UnitCollSvc.session.collection:get_unit_by_uuid(uUuid)
            end)
            if okU and type(liveUnit) == "table" then
                uId = uId or liveUnit.unit_id or liveUnit.id
                if liveUnit.shiny ~= nil then
                    isShiny = liveUnit.shiny == true
                end
            end
        end
        if not uId and uUuid and UnitCollSvc and UnitCollSvc.get_equipped_unit_by_uuid then
            local okEq, eqUnit = pcall(UnitCollSvc.get_equipped_unit_by_uuid, uUuid)
            if okEq and type(eqUnit) == "table" then
                uId = eqUnit.unit_id or eqUnit.id
                if eqUnit.shiny ~= nil then
                    isShiny = eqUnit.shiny == true
                end
            end
        end
        if not uId and uUuid then
            if UnitsData and UnitsData[uUuid] then
                uId = uUuid
            end
        end
        local uData = (UnitsData and uId and UnitsData[uId]) or nil
        if not uData and uId and UnitsData then
            local stripped = tostring(uId):match("^([^:]+)")
            if stripped and UnitsData[stripped] then
                uData = UnitsData[stripped]
            end
        end
        local uName = (uData and uData.name) or uId or uUuid or "Unit"
        local isSecretUnit = isRaritySecret(uData, uId, uName)
        local entry = "+1 " .. tostring(uName)
        if isShiny then
            entry = entry .. " (Shiny)"
        end
        addReward(entry .. " [Unit]", isSecretUnit)
    end

    local processItemCollection = function(tbl)
        if type(tbl) ~= "table" then return end
        for k, itemObj in pairs(tbl) do
            if type(itemObj) == "number" and type(k) == "string" then
                appendItemEntry(k, itemObj, nil, nil)
            elseif type(itemObj) == "string" then
                appendItemEntry(itemObj, 1, nil, nil)
            elseif type(itemObj) == "table" then
                local itemId = itemObj.item_id or itemObj._item_id or itemObj.id or itemObj.name
                local amount = itemObj.amount or itemObj.count or 1
                local tier = itemObj.tier or itemObj.item_tier
                appendItemEntry(itemId, amount, tier, itemObj)
            end
        end
    end

    if s and type(s) == "table" then
        if s.xp_reward and tonumber(s.xp_reward) and tonumber(s.xp_reward) > 0 then
            addReward("+" .. formatCommas(s.xp_reward) .. " XP")
        end
        if s.resource_reward and type(s.resource_reward) == "table" then
            for rName, rAmt in pairs(s.resource_reward) do
                local amt = tonumber(rAmt) or 0
                if amt > 0 then
                    addReward("+" .. formatCommas(amt) .. " " .. formatResourceName(rName))
                end
            end
        end
        if s.gem_reward and tonumber(s.gem_reward) and tonumber(s.gem_reward) > 0 then
            addReward("+" .. formatCommas(s.gem_reward) .. " Gems")
        end
        if s.gold_reward and tonumber(s.gold_reward) and tonumber(s.gold_reward) > 0 then
            addReward("+" .. formatCommas(s.gold_reward) .. " Gold")
        end
        if s.trophy_reward and tonumber(s.trophy_reward) and tonumber(s.trophy_reward) > 0 then
            addReward("+" .. formatCommas(s.trophy_reward) .. " Trophies")
        end
        if s.first_completion_gems and tonumber(s.first_completion_gems) and tonumber(s.first_completion_gems) > 0 then
            addReward("+" .. formatCommas(s.first_completion_gems) .. " Gems (First Clear)")
        end
        if s.first_completion_trophies and tonumber(s.first_completion_trophies) and tonumber(s.first_completion_trophies) > 0 then
            addReward("+" .. formatCommas(s.first_completion_trophies) .. " Trophies (First Clear)")
        end

        processItemCollection(s.new_items)
        if type(s.new_units) == "table" then
            for _, uObj in pairs(s.new_units) do
                appendUnitEntry(uObj)
            end
        end
    end

    processItemCollection(State.LastDroppedItems)
    if type(State.LastDroppedUnits) == "table" then
        for _, uObj in pairs(State.LastDroppedUnits) do
            appendUnitEntry(uObj)
        end
    end

    if State.MatchSessionDrops then
        if State.MatchSessionDrops.hasSecret then
            hasSecret = true
        end
        processItemCollection(State.MatchSessionDrops.items)
        if type(State.MatchSessionDrops.normalItems) == "table" then
            for itemId, amt in pairs(State.MatchSessionDrops.normalItems) do
                appendItemEntry(itemId, amt, nil, nil)
            end
        end
        if type(State.MatchSessionDrops.units) == "table" then
            for _, uObj in ipairs(State.MatchSessionDrops.units) do
                appendUnitEntry(uObj)
            end
        end
        if type(State.MatchSessionDrops.dropMessages) == "table" then
            for _, dm in ipairs(State.MatchSessionDrops.dropMessages) do
                if dm.resource then
                    addReward("+" .. formatCommas(dm.amount or 1) .. " " .. formatResourceName(dm.resource))
                elseif dm.itemId then
                    if ItemsData and ItemsData[dm.itemId] then
                        appendItemEntry(dm.itemId, dm.amount or 1, nil, nil)
                    elseif dm.extra and dm.extra.resource then
                        addReward("+" .. formatCommas(dm.amount or 1) .. " " .. formatResourceName(dm.extra.resource))
                    elseif dm.extra and dm.extra.override_name_text then
                        addReward("+" .. tostring(dm.amount or 1) .. " " .. tostring(dm.extra.override_name_text), tostring(dm.extra.override_name_text):lower():find("secret") ~= nil)
                    end
                elseif dm.extra and dm.extra.text then
                    local txt = tostring(dm.extra.text)
                    addReward(txt, txt:lower():find("secret") ~= nil)
                end
            end
        end
    end

    local resultsUI = LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
    if resultsUI then
        local lr = resultsUI:FindFirstChild("LevelRewards", true)
        local scroll = lr and lr:FindFirstChild("ScrollingFrame", true)
        if scroll then
            for _, frame in ipairs(scroll:GetChildren()) do
                if frame:IsA("GuiObject") and frame.Visible then
                    local fName = frame.Name
                    local amtLbl = frame:FindFirstChild("Amount", true)
                    local amtText = amtLbl and amtLbl.Text
                    if amtText and #amtText > 0 and amtText ~= "9999" and amtText ~= "+9999" and amtText ~= "+9999 XP" then
                        if fName == "GoldReward" then
                            addReward(amtText .. " Gold")
                        elseif fName == "GemReward" then
                            addReward(amtText .. " Gems")
                        elseif fName == "XPReward" then
                            addReward(amtText .. (amtText:find("XP") and "" or " XP"))
                        elseif fName == "TrophyReward" then
                            addReward(amtText .. " Trophies")
                        elseif fName == "ResourceReward" and not (s and s.resource_reward and next(s.resource_reward) ~= nil) then
                            addReward(amtText .. " Event Currency")
                        elseif fName ~= "UIListLayout" and fName ~= "Configuration" and fName ~= "ResourceReward" then
                            local clean = fName:gsub("([a-z])([A-Z])", "%1 %2"):gsub("_", " ")
                            addReward(amtText .. " " .. clean)
                        end
                    end
                end
            end
        end

        for _, desc in ipairs(resultsUI:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Visible and desc.Text and #desc.Text > 0 then
                local t = desc.Text:lower()
                if t:find("secret") and desc.Text ~= "9999" then
                    hasSecret = true
                end
            end
        end
    end

    return rewards, hasSecret
end
local getCleanUnitDisplayName = function(u, stats, eqFallback)
    local rawName = u and u.Name or (stats and stats:FindFirstChild("name") and stats.name.Value) or (eqFallback and eqFallback.unitId) or ""
    local unitUuid = (stats and stats:FindFirstChild("uuid") and stats.uuid.Value) or (eqFallback and eqFallback.uuid)
    local unitId = (stats and stats:FindFirstChild("id") and stats.id.Value) or (eqFallback and eqFallback.unitId)
    local rawBase = (unitId or rawName):match("^([^:]+)") or (unitId or rawName)
    local rawModifier = (unitId or rawName):match(":(.+)$")
    if not rawModifier and u and u.Name and u.Name:find(":") then
        rawModifier = u.Name:match(":(.+)$")
    end
    if not rawModifier and eqFallback and eqFallback.unitId and eqFallback.unitId:find(":") then
        rawModifier = eqFallback.unitId:match(":(.+)$")
    end
    local cleanName = nil
    local traitName = nil
    local equipped = getEquippedUnits()
    if unitUuid then
        for _, eq in ipairs(equipped) do
            if eq.uuid == unitUuid then
                cleanName = eq.name
                break
            end
        end
    end
    if not cleanName and rawBase then
        for _, eq in ipairs(equipped) do
            if eq.unitId and (eq.unitId == rawBase or eq.unitId:match("^([^:]+)") == rawBase) then
                cleanName = eq.name
                break
            end
        end
    end
    if not cleanName and unitUuid then
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local spawnGui = pg and pg:FindFirstChild("spawn_units")
        if spawnGui then
            for i = 1, 6 do
                local slotFrame = spawnGui:FindFirstChild(tostring(i), true)
                if slotFrame and slotFrame:GetAttribute("_equipped_frame_unit_uuid") == unitUuid then
                    local nLbl = slotFrame:FindFirstChild("name", true)
                    if nLbl and nLbl.Text and #nLbl.Text > 0 then
                        cleanName = nLbl.Text
                        break
                    end
                end
            end
        end
    end
    local UnitsData = getUnitsData()
    if not cleanName and UnitsData then
        if unitId and UnitsData[unitId] and UnitsData[unitId].name then
            cleanName = UnitsData[unitId].name
        elseif rawBase and UnitsData[rawBase] and UnitsData[rawBase].name then
            cleanName = UnitsData[rawBase].name
        else
            local strippedBase = rawBase:gsub("_summer.*$", ""):gsub("_halloween.*$", ""):gsub("_christmas.*$", ""):gsub("_winter.*$", ""):gsub("_skin.*$", ""):gsub("_shiny.*$", ""):gsub("_evolved.*$", "")
            if UnitsData[strippedBase] and UnitsData[strippedBase].name then
                cleanName = UnitsData[strippedBase].name
            end
        end
    end
    if not cleanName and eqFallback and eqFallback.name then
        cleanName = eqFallback.name
    end
    local UnitCollectionServiceClient = getUnitCollectionServiceClient()
    if UnitCollectionServiceClient and unitUuid then
        local success, uData = pcall(function()
            return UnitCollectionServiceClient.get_equipped_unit_by_uuid(unitUuid)
        end)
        if success and uData and uData.traits and #uData.traits > 0 then
            local t = uData.traits[1]
            local tr = type(t) == "table" and (t.trait or t.name) or tostring(t)
            if tr and #tr > 0 and tr:lower() ~= "none" then
                traitName = tr:sub(1,1):upper() .. tr:sub(2):lower()
            end
        end
    end
    if not traitName and rawModifier and #rawModifier > 0 then
        traitName = rawModifier:sub(1,1):upper() .. rawModifier:sub(2):lower()
    end
    if not cleanName or cleanName == "" or cleanName:find("^Slot ") then
        local stripped = rawBase:gsub("_", " ")
        cleanName = stripped:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    end
    if traitName and #traitName > 0 and not cleanName:find("%(" .. traitName .. "%)") then
        return cleanName .. " (" .. traitName .. ")"
    end
    return cleanName
end

local getUnitsMatchSummary = function()
    local unitGroups = {}
    local owned = getOwnedUnitsInGame()
    for _, u in ipairs(owned) do
        local stats = u:FindFirstChild("_stats")
        local uName = getCleanUnitDisplayName(u, stats, nil)
        local kills = (stats and stats:FindFirstChild("kills") and stats.kills.Value)
            or (stats and stats:FindFirstChild("kill_count") and stats.kill_count.Value)
            or (stats and stats:FindFirstChild("total_kills") and stats.total_kills.Value)
            or 0
        local curUpg = stats and stats:FindFirstChild("upgrade") and stats.upgrade.Value or 0
        local maxUpg = stats and stats:FindFirstChild("max_upgrade") and stats.max_upgrade.Value or 0
        if not unitGroups[uName] then
            unitGroups[uName] = { count = 0, kills = 0, curUpg = curUpg, maxUpg = maxUpg }
        end
        unitGroups[uName].count = unitGroups[uName].count + 1
        unitGroups[uName].kills = unitGroups[uName].kills + kills
        unitGroups[uName].curUpg = math.max(unitGroups[uName].curUpg, curUpg)
        unitGroups[uName].maxUpg = math.max(unitGroups[uName].maxUpg, maxUpg)
    end
    local lines = {}
    for name, data in pairs(unitGroups) do
        table.insert(lines, string.format("[ %d ] %s = %s \226\154\148\239\184\143 - [Upg %d/%d]", data.count, name, formatCommas(data.kills), data.curUpg, data.maxUpg))
    end
    if #lines == 0 then
        local equipped = getEquippedUnits()
        for _, eq in ipairs(equipped) do
            local dName = getCleanUnitDisplayName(nil, nil, eq)
            table.insert(lines, string.format("[ %d ] %s = 0 \226\154\148\239\184\143 - [Upg 0/%d]", eq.cur or 0, dName, eq.max or 0))
        end
    end
    if #lines == 0 then
        return "None"
    end
    return table.concat(lines, "\n")
end
local sendMatchWebhook = function(isTest)
    local url = Config.WebhookUrl
    if not url or #url < 10 then
        if isTest and library and library.notifications then
            library.notifications:create_notification({
                name = "AJ HUB | Webhook",
                info = "Please enter a valid Webhook URL!"
            })
        end
        return
    end
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if not req then return end
    local resultsUI = LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
    local Loader = nil
    pcall(function()
        Loader = require(game:GetService("ReplicatedStorage").src.Loader)
    end)
    local guiSvc = Loader and Loader.load_client_service and Loader.load_client_service(nil, "GUIService")
    local matchSettings = State.LastMatchSettings or (guiSvc and guiSvc.results_ui and guiSvc.results_ui.settings)
    local isVictory = false
    if isTest then
        isVictory = true
    else
        local foundVictory = false
        local foundDefeat = false

        -- 1. Check server-authoritative data in LastMatchSettings / results_ui.settings
        local s = matchSettings
        if s and type(s) == "table" then
            if s.win == false or s.won == false or s.victory == false or s.defeat == true or s.failed == true then
                foundDefeat = true
            elseif s.win == true or s.won == true or s.victory == true or s.success == true then
                foundVictory = true
            end
        end

        -- 2. Check ResultsUI Title text label (ResultsUI.Holder.Title)
        if resultsUI and resultsUI.Enabled then
            local holder = resultsUI:FindFirstChild("Holder")
            local titleLbl = holder and holder:FindFirstChild("Title")
            if titleLbl and titleLbl:IsA("TextLabel") and titleLbl.Text and #titleLbl.Text > 0 then
                local t = titleLbl.Text:upper()
                if t:find("DEFEAT") or t:find("GAME OVER") or t:find("FAILED") or t:find("LOST") then
                    foundDefeat = true
                    foundVictory = false
                elseif t:find("VICTORY") or t:find("STAGE CLEAR") or t:find("COMPLETE") or t:find("CLEARED") then
                    foundVictory = true
                end
            end

            -- 3. Check visible TextLabels in ResultsUI (only visible TextLabels, never descendant instance names)
            if not foundDefeat and not foundVictory then
                for _, desc in ipairs(resultsUI:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc.Visible and desc.Text and #desc.Text > 0 then
                        local txt = desc.Text:upper()
                        if txt == "DEFEAT" or txt:find("GAME OVER") or txt:find("DEFEATED") or txt == "FAILED" then
                            foundDefeat = true
                            break
                        elseif txt == "VICTORY" or txt:find("STAGE CLEAR") or txt:find("LEVEL COMPLETE") then
                            foundVictory = true
                        end
                    end
                end
            end
        end

        if foundDefeat then
            isVictory = false
        elseif foundVictory then
            isVictory = true
        else
            isVictory = false
        end
    end
    local color = isVictory and 3066993 or 15158332
    local resultTitle = isVictory and "\240\159\143\134 Victory" or "\240\159\146\128 Defeat"
    local lvl, xp, gems, gold, pearls, rerolls = 0, 0, 0, 0, 0, 0
    local pStats = LocalPlayer:FindFirstChild("_stats")
    local inv = Loader and Loader.load_client_service and Loader.load_client_service(nil, "ItemInventoryServiceClient")
    local d = inv and inv.session and inv.session.profile_data

    gems = (pStats and pStats:FindFirstChild("gem_amount") and pStats.gem_amount.Value)
        or (d and d.gem_amount)
        or (pStats and pStats:FindFirstChild("gem") and pStats.gem.Value)
        or (pStats and pStats:FindFirstChild("gems") and pStats.gems.Value)
        or 0
    gold = (pStats and pStats:FindFirstChild("gold_amount") and pStats.gold_amount.Value)
        or (d and d.gold_amount)
        or (pStats and pStats:FindFirstChild("gold") and pStats.gold.Value)
        or 0
    pearls = (pStats and pStats:FindFirstChild("_resourceSummerPearls") and pStats._resourceSummerPearls.Value)
        or (d and d.resources and (d.resources.SummerPearls or d.resources.summer_pearls))
        or (pStats and pStats:FindFirstChild("summer_pearls") and pStats.summer_pearls.Value)
        or 0
    rerolls = (d and d.trait_reroll_tokens)
        or (pStats and pStats:FindFirstChild("reroll_tokens") and pStats.reroll_tokens.Value)
        or 0
    xp = (pStats and pStats:FindFirstChild("player_xp") and pStats.player_xp.Value)
        or (d and d.player_xp)
        or (pStats and pStats:FindFirstChild("xp") and pStats.xp.Value)
        or (pStats and pStats:FindFirstChild("Exp") and pStats.Exp.Value)
        or 0

    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local lvlLbl = pg and pg:FindFirstChild("spawn_units")
        and pg.spawn_units:FindFirstChild("Lives")
        and pg.spawn_units.Lives:FindFirstChild("Main")
        and pg.spawn_units.Lives.Main:FindFirstChild("Desc")
        and pg.spawn_units.Lives.Main.Desc:FindFirstChild("Level")
    if lvlLbl and lvlLbl.Text then
        lvl = tonumber(lvlLbl.Text:match("Level%s*(%d+)")) or lvl
    end
    if lvl == 0 and pg and pg:FindFirstChild("PartyUI") then
        for _, desc in ipairs(pg.PartyUI:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Name == "Level" and tonumber(desc.Text) then
                lvl = tonumber(desc.Text)
                break
            end
        end
    end
    if lvl == 0 and pStats and pStats:FindFirstChild("Level") then
        lvl = pStats.Level.Value
    end
    if lvl == 0 and Loader and Loader.load_core_service then
        pcall(function()
            local lvlService = Loader.load_core_service(nil, "LevelServiceCore")
            if lvlService and lvlService.calculate_level and xp > 0 then
                lvl = lvlService.calculate_level(nil, xp) or lvl
            end
        end)
    end
    if lvl == 0 then
        lvl = 378
    end

    local matchStats = (type(matchSettings) == "table" and type(matchSettings.stats) == "table") and matchSettings.stats or nil
    local durationSec = (matchStats and tonumber(matchStats.time_taken)) and math.max(0, math.ceil(tonumber(matchStats.time_taken)))
        or math.max(0, math.floor(tick() - (State.MatchStartTime or tick())))
    local durationStr = string.format("%02d:%02d:%02d", math.floor(durationSec / 3600), math.floor((durationSec % 3600) / 60), durationSec % 60)
    local waveNum = getCurrentWave()
    if (not waveNum or waveNum == 0) and matchStats and tonumber(matchStats.waves_completed) then
        waveNum = tonumber(matchStats.waves_completed)
    end
    local mapName = "Otherworldy Plane Summer Hunt - Hard"
    local mapCfg = Workspace:FindFirstChild("_MAP_CONFIG")
    if mapCfg and mapCfg:FindFirstChild("MapName") then
        local diff = mapCfg:FindFirstChild("Difficulty") and (" - " .. mapCfg.Difficulty.Value) or ""
        mapName = mapCfg.MapName.Value .. diff
    elseif type(matchSettings) == "table" and type(matchSettings.title) == "string" and #matchSettings.title > 0 then
        mapName = matchSettings.title
    elseif State.CurrentMatchLevel then
        mapName = tostring(State.CurrentMatchLevel)
    end
    local capStr = ""
    pcall(function()
        local unitCount = 0
        local unitCap = 500
        local unitsService = Loader and Loader.load_client_service and Loader.load_client_service(nil, "UnitInventoryServiceClient")
        local s = unitsService and unitsService.session
        if s and s.collection then
            for _ in pairs(s.collection) do unitCount = unitCount + 1 end
        end
        if s and s.collection_profile_data and s.collection_profile_data.capacity then
            unitCap = s.collection_profile_data.capacity
        end
        if unitCount > 0 then
            capStr = string.format(" [%d/%d]", unitCount, unitCap)
        end
    end)
    local rewardsList, hasSecret = parseMatchRewards()
    if isTest then
        gems = 1395
        gold = 68009
        rerolls = 31
        pearls = 170525
        lvl = 106
        capStr = " [478/500]"
        rewardsList = {"+1 Explosion Mage's Portal\n(Tier 0) [ Total: 1 ]", "+13708 Summer Pearls"}
        hasSecret = true
        mapName = "Navy Bay - Summer [Hard]"
        waveNum = 50
        durationStr = "00:21:29"
        isVictory = true
    end
    local rewardsText = #rewardsList > 0 and table.concat(rewardsList, "\n") or "None"
    if #rewardsText > 1000 then
        rewardsText = rewardsText:sub(1, 990) .. "\n..."
    end
    if not hasSecret and rewardsText:lower():find("secret") then
        hasSecret = true
    end
    local embedColor = isVictory and 5763719 or 15548997
    local shouldPing = (hasSecret == true and Config.WebhookPingSecret ~= false)
    local payload = {
        content = shouldPing and "@everyone" or nil,
        allowed_mentions = shouldPing and {
            parse = {"everyone"}
        } or nil,
        embeds = {
            {
                title = "Anime Adventures",
                color = embedColor,
                description = string.format("User : ||%s||\nLevel : %s", LocalPlayer.Name, tostring(lvl)),
                thumbnail = {
                    url = "https://cdn.discordapp.com/attachments/1509934485288911011/1568306230647066634/image.png?ex=6af34aff&is=6af1f97f&hm=96107dbd0c30f4e57f4382bddb26071042029a86a6b9943a3e43d56a5c1175e4&"
                },
                fields = {
                    {
                        name = "Player Stats",
                        value = string.format("\240\159\146\142 %s\n\240\159\170\153 %s\n\240\159\140\184 %s", formatCommas(gems), formatCommas(gold), formatCommas(pearls)),
                        inline = false
                    },
                    {
                        name = "Rewards",
                        value = rewardsText,
                        inline = false
                    },
                    {
                        name = "Match Result",
                        value = string.format("%s - Wave %d\n%s", durationStr, waveNum, mapName),
                        inline = false
                    },
                    {
                        name = isVictory and "\226\128\162 VICTORY" or "\226\128\162 DEFEAT",
                        value = "\226\128\139",
                        inline = false
                    }
                },
                footer = {
                    text = "https://discord.gg/jtr4YAy4G9 (" .. os.date("%H:%M:%S") .. ")"
                }
            }
        }
    }
    local bodyJson = game:GetService("HttpService"):JSONEncode(payload)
    local okPost, resp = pcall(function()
        return req({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = bodyJson
        })
    end)
    if okPost and type(resp) == "table" and tonumber(resp.StatusCode) == 429 then
        local retrySec = 1.5
        pcall(function()
            if type(resp.Body) == "string" then
                local decoded = game:GetService("HttpService"):JSONDecode(resp.Body)
                if type(decoded) == "table" and tonumber(decoded.retry_after) then
                    retrySec = math.clamp(tonumber(decoded.retry_after) + 0.15, 0.5, 4.0)
                end
            end
        end)
        task.wait(retrySec)
        pcall(function()
            req({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = bodyJson
            })
        end)
    end
    if isTest and library and library.notifications then
        library.notifications:create_notification({
            name = "AJ HUB | Webhook",
            info = "Test webhook sent successfully!"
        })
    end
end
getgenv().AJ_HUB_SEND_WEBHOOK = sendMatchWebhook

local processMatchAutomation = function()
    if not isMatchFinished() then
        if State._clearDropsOnNextMatch then
            State.LastMatchSettings = nil
            State.LastDroppedItems = nil
            State.LastDroppedUnits = nil
            State._clearDropsOnNextMatch = false
            resetMatchSessionDrops()
        end
        State.WebhookSentForCurrentMatch = false
        State.WebhookInProgress = false
        return
    end
    local resultsUI = LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
    if Config.WebhookEnabled and Config.WebhookUrl and #Config.WebhookUrl > 10 and not State.WebhookSentForCurrentMatch and not State.WebhookInProgress then
        State.WebhookInProgress = true
        task.spawn(function()
            local t0 = tick()
            while tick() - t0 < 8.0 do
                resultsUI = LocalPlayer.PlayerGui:FindFirstChild("ResultsUI")
                if resultsUI and resultsUI.Enabled then
                    break
                end
                task.wait(0.2)
            end
            local t1 = tick()
            while tick() - t1 < 2.5 do
                local guiSvcLive = nil
                pcall(function()
                    local L = require(game:GetService("ReplicatedStorage").src.Loader)
                    guiSvcLive = L and L.load_client_service and L.load_client_service(nil, "GUIService")
                end)
                local hasSettings = State.LastMatchSettings ~= nil or (guiSvcLive and guiSvcLive.results_ui and guiSvcLive.results_ui.settings ~= nil)
                if hasSettings then
                    break
                end
                task.wait(0.15)
            end
            task.wait(0.6)
            sendMatchWebhook(false)
            State.WebhookSentForCurrentMatch = true
            State._clearDropsOnNextMatch = true
            task.wait(0.4)
            if resultsUI and resultsUI:FindFirstChild("Holder") and resultsUI.Holder.Visible then
                local nextBtn = resultsUI.Holder:FindFirstChild("Buttons") and resultsUI.Holder.Buttons:FindFirstChild("Next")
                if nextBtn and firesignal then
                    firesignal(nextBtn.Activated)
                end
            end
            State.WebhookInProgress = false
        end)
    end
    if State.WebhookInProgress then return end
    if tick() - (State.LastMatchActionTime or 0) < 1.5 then return end
    State.LastMatchActionTime = tick()
    pcall(function()
        if resultsUI and resultsUI:FindFirstChild("Holder") and resultsUI.Holder.Visible then
            local nextBtn = resultsUI.Holder:FindFirstChild("Buttons") and resultsUI.Holder.Buttons:FindFirstChild("Next")
            if nextBtn and firesignal then
                firesignal(nextBtn.Activated)
            end
        end
        if Config.AutoLeave then
            if Endpoints:FindFirstChild("teleport_back_to_lobby") then
                Endpoints.teleport_back_to_lobby:InvokeServer()
            end
            return
        end
        if Config.AutoNextStory then
            if Endpoints:FindFirstChild("set_game_finished_vote") then
                Endpoints.set_game_finished_vote:InvokeServer("next_story")
            end
            if resultsUI and resultsUI:FindFirstChild("Finished") and resultsUI.Finished:FindFirstChild("NextLevel") and firesignal then
                firesignal(resultsUI.Finished.NextLevel.Activated)
            end
            return
        end
        if Config.AutoNextRoom then
            if Endpoints:FindFirstChild("request_start_infinite_tower_from_game") then
                Endpoints.request_start_infinite_tower_from_game:InvokeServer()
            end
            if Endpoints:FindFirstChild("set_game_finished_vote") then
                Endpoints.set_game_finished_vote:InvokeServer("replay")
            end
            if resultsUI and resultsUI:FindFirstChild("Finished") and resultsUI.Finished:FindFirstChild("NextRetry") and firesignal then
                firesignal(resultsUI.Finished.NextRetry.Activated)
            end
            return
        end
        if Config.AutoNextPortal then
            if Endpoints:FindFirstChild("set_game_finished_vote") then
                Endpoints.set_game_finished_vote:InvokeServer("replay")
            end
            if resultsUI and resultsUI:FindFirstChild("Finished") and resultsUI.Finished:FindFirstChild("NextRetry") and firesignal then
                firesignal(resultsUI.Finished.NextRetry.Activated)
            end
            return
        end
        if Config.AutoReplay then
            if Endpoints:FindFirstChild("set_game_finished_vote") then
                Endpoints.set_game_finished_vote:InvokeServer("replay")
            end
            if resultsUI and resultsUI:FindFirstChild("Finished") and resultsUI.Finished:FindFirstChild("NextRetry") and firesignal then
                firesignal(resultsUI.Finished.NextRetry.Activated)
            end
            return
        end
    end)
end

local StoryWorldMap = {

    ["Planet Greenie"]                 = "namek",
    ["Walled City"]                    = "aot",
    ["Snowy Town"]                     = "demonslayer",
    ["Demon Slayer"]                   = "demonslayer",
    ["Sand Village"]                   = "naruto",
    ["Hidden Sand Village"]            = "naruto",
    ["Navy Bay"]                       = "marineford",
    ["Fiend City"]                     = "tokyoghoul",
    ["Ghoul City"]                     = "tokyoghoul",
    ["Spirit World"]                   = "hueco",
    ["Hollow World"]                   = "hueco",
    ["Ant Kingdom"]                    = "hxhant",
    ["Magic Town"]                     = "magnolia",
    ["Haunted Academy"]                = "jjk",
    ["Cursed Academy"]                 = "jjk",
    ["Magic Hills"]                    = "clover",
    ["Space Center"]                   = "jojo",
    ["Cape Canaveral"]                 = "jojo",
    ["Alien Spaceship"]                = "opm",
    ["Fabled Kingdom"]                 = "7ds",
    ["Ruined City"]                    = "mha",
    ["Hero City"]                      = "mha",
    ["Puppet Island"]                  = "dressrosa",
    ["Virtual Dungeon"]                = "sao",
    ["Virtual Reality"]                = "sao",
    ["Snowy Kingdom"]                  = "berserk",
    ["Eclipse"]                        = "berserk",
    ["Dungeon Throne"]                 = "overlord",
    ["Mountain Temple"]                = "fate",
    ["Fuyuki City"]                    = "fate",
    ["Rain Village"]                   = "amegakure",
    ["Shibuya District"]               = "shibuya",
    ["Mitakihara City"]                = "madoka",
}
local LegendWorldMap = {
    ["Magic Hills (Elf Invasion)"]     = "clover_legend",
    ["Spirit Invasion"]                = "bleach_legend",
    ["Space Center"]                   = "jojo_legend",
    ["Fabled Kingdom (Generals)"]      = "7ds_legend",
    ["Ruined City (Midnight)"]         = "mha_legend",
    ["Virtual Dungeon (Bosses)"]       = "sao_legend",
    ["Dungeon Throne"]                 = "overlord_legend",
    ["Rain Village"]                   = "amegakure_legend",
}
local RaidWorldMap = {
    ["Current Raid"]                   = "current_raid",
    ["Nightmare Train"]                = "demonslayer_raid_1",
    ["Walled City"]                    = "aot_raid_1",
    ["Sand Village"]                   = "naruto_raid_1",
    ["Future City"]                    = "west_city_raid",
    ["Future City (Tyrant's Invasion)"]= "west_city_frieza",
    ["Cursed Festival"]                = "entertainment_district",
    ["Sacred Planet"]                  = "kai_planet",
    ["Strange Town"]                   = "morioh",
    ["Storm Hideout"]                  = "uchiha",
    ["Ant Kingdom (Midnight)"]         = "hxh_feitan",
    ["Ruined City (The Menace)"]       = "mha_stain",
}
local WorldIdMap = setmetatable({}, {
    __index = function(_, k)
        return StoryWorldMap[k] or LegendWorldMap[k] or RaidWorldMap[k]
    end
})
syncWithXTHub = function()
    local xt = getgenv().XT_AnimeAdventures
    local lobby = xt and xt.Lobby
    if not lobby then return end
    pcall(function()
        lobby.AutoJoin = Config.AutoJoinStory
        lobby.World = WorldIdMap[Config.StoryWorld] or Config.StoryWorld:lower()
        lobby.Act = tonumber(string.match(Config.StoryAct, "%d+")) or (Config.StoryAct == "Infinite" and "infinite" or 1)
        lobby.Difficulty = (Config.StoryAct == "Infinite") and "Hard" or Config.StoryDifficulty
        lobby.FriendsOnly = Config.StoryFriendsOnly
        lobby.LastAct = Config.JoinLastAct
        lobby.AutoLegend = Config.AutoJoinLegend
        lobby.LegendWorld = WorldIdMap[Config.LegendStage] or "clover_legend"
        lobby.LegendAct = tonumber(string.match(Config.LegendAct, "%d+")) or 1
        lobby.AutoRaid = Config.AutoJoinRaid
        lobby.RaidWorld = Config.RaidWorld
        lobby.RaidAct = tonumber(string.match(Config.RaidAct, "%d+")) or 1
        lobby.AutoMansion = Config.AutoJoinMansion
        lobby.MansionRoom = tonumber(Config.MansionRoom) or 1
        lobby.MansionDifficulty = Config.MansionDifficulty
        lobby.MansionLast = Config.JoinLastMansionRoom
        lobby.AutoSummer = Config.AutoJoinSummer
        if type(Config.SummerSkipMaps) == "table" then
            lobby.SummerSkipMaps = Config.SummerSkipMaps
        end
        if type(Config.SummerSkipWeather) == "table" then
            lobby.SummerSkipWeather = Config.SummerSkipWeather
        end
        lobby.AutoChallenge = Config.AutoJoinChallenge
        lobby.AutoDaily = Config.AutoJoinDailyChallenge
    end)
end
local leaveCurrentLobby = function()
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        local EndpointsClient = getEndpointsClient()
        for _, folder in ipairs({
            workspace:FindFirstChild("_PORTALS"),
            workspace:FindFirstChild("_LOBBIES"),
            workspace:FindFirstChild("_CHALLENGES"),
            workspace:FindFirstChild("_RAID"),
            workspace:FindFirstChild("_EVENT_CHALLENGES"),
            workspace:FindFirstChild("_SUMMER"),
            workspace:FindFirstChild("_EVENT_AREA")
        }) do
            if folder then
                for _, room in ipairs(folder:GetDescendants()) do
                    if room:FindFirstChild("Owner") and room.Owner.Value == lp then
                        if EndpointsClient and EndpointsClient.invoke_server then
                            pcall(function() EndpointsClient.invoke_server("request_leave_lobby", room.Name) end)
                        elseif Endpoints:FindFirstChild("request_leave_lobby") then
                            Endpoints.request_leave_lobby:InvokeServer(room.Name)
                        end
                    end
                end
            end
        end
        local loader = require(game:GetService("ReplicatedStorage").src.Loader)
        local ls = loader.load_client_service(nil, "LobbyServiceClient")
        if ls and ls.cancel_selections then
            ls.cancel_selections()
        end
    end)
end
local function solveCaptchaWindow(cw)
    if not cw or not cw.Parent then return end
    task.spawn(function()
        local captchaLabel = cw:WaitForChild("Captcha", 3)
        local typeBox = cw:WaitForChild("TypeBox", 3)
        local buttonHolder = cw:WaitForChild("ButtonHolder", 3)
        local yesBtn = buttonHolder and buttonHolder:WaitForChild("Yes", 3)
        if not (captchaLabel and typeBox and yesBtn) then return end
        local code = ""
        for i = 1, 40 do
            code = tostring(captchaLabel.Text):gsub("%s+", "")
            if #code > 0 then break end
            task.wait(0.03)
        end
        if #code == 0 then return end
        typeBox.Text = code
        task.wait(0.04)
        if typeof(getconnections) == "function" then
            for _, conn in ipairs(getconnections(yesBtn.Activated)) do
                pcall(function() conn:Fire() end)
            end
            for _, conn in ipairs(getconnections(yesBtn.MouseButton1Click)) do
                pcall(function() conn:Fire() end)
            end
        end
        if typeof(firesignal) == "function" then
            pcall(function() firesignal(yesBtn.Activated) end)
            pcall(function() firesignal(yesBtn.MouseButton1Click) end)
        end
    end)
end
local function setupAutoMatchmakingCaptcha()
    task.spawn(function()
        pcall(function()
            local loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local nwUI = loader.load_client_service(nil, "GUIService").notification_windows_ui
            if nwUI then
                nwUI._last_matchmaking_captcha_success = tick() + 999999
                if not nwUI._original_show_captcha then
                    nwUI._original_show_captcha = nwUI._show_matchmaking_captcha
                    nwUI._show_matchmaking_captcha = function(self, cb)
                        self.HAS_MATCHMAKING_PROMPT = false
                        self._last_matchmaking_captcha_success = tick() + 999999
                        if cb then
                            task.spawn(cb)
                        end
                    end
                end
            end
        end)
    end)
    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
        if not pg then return end
        local nw = pg:WaitForChild("NotificationWindows", 10)
        local popups = nw and nw:WaitForChild("Popups", 10)
        if not popups then return end
        local function handlePopup(child)
            if not child or not child.Parent then return end
            if child.Name == "CaptchaWindow" then
                solveCaptchaWindow(child)
            elseif child.Name == "MatchmakingPrompt" then
                local anyActive = Config.AutoFindMatchStory or
                    Config.AutoFindMatchLegend or
                    Config.AutoFindMatchRaid or
                    Config.AutoFindMatchMansion or
                    Config.AutoFindMatchChallenge or
                    Config.AutoFindMatchDailyChallenge or
                    Config.AutoFindMatchSummer or
                    (Config.AutoJoinArtifact and Config.ArtifactJoinMode == "Find Match")
                if anyActive then
                    task.spawn(function()
                        task.wait(0.04)
                        pcall(function()
                            local buttons = child:FindFirstChild("Main") and child.Main:FindFirstChild("Buttons")
                            local mmBtn = buttons and buttons:FindFirstChild("Matchmaking")
                            if mmBtn then
                                if typeof(getconnections) == "function" then
                                    for _, conn in ipairs(getconnections(mmBtn.Activated)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                    for _, conn in ipairs(getconnections(mmBtn.MouseButton1Click)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                end
                                if typeof(firesignal) == "function" then
                                    firesignal(mmBtn.Activated)
                                    pcall(function() firesignal(mmBtn.MouseButton1Click) end)
                                end
                            end
                        end)
                    end)
                elseif Config.AutoJoinSummer then
                    task.spawn(function()
                        task.wait(0.04)
                        pcall(function()
                            local buttons = child:FindFirstChild("Main") and child.Main:FindFirstChild("Buttons")
                            local soloBtn = buttons and buttons:FindFirstChild("PlaySolo")
                            if soloBtn then
                                if typeof(getconnections) == "function" then
                                    for _, conn in ipairs(getconnections(soloBtn.Activated)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                    for _, conn in ipairs(getconnections(soloBtn.MouseButton1Click)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                end
                                if typeof(firesignal) == "function" then
                                    firesignal(soloBtn.Activated)
                                    pcall(function() firesignal(soloBtn.MouseButton1Click) end)
                                end
                            end
                        end)
                    end)
                end
            elseif child.Name:find("Party") or child.Name:find("Invite") then
                if Config.AutoPartyEnabled and Config.PartyAutoAccept then
                    task.spawn(function()
                        task.wait(0.05)
                        pcall(function()
                            local acceptBtn = child:FindFirstChild("Accept", true)
                                or child:FindFirstChild("AcceptButton", true)
                                or child:FindFirstChild("Yes", true)
                                or child:FindFirstChild("Confirm", true)
                                or child:FindFirstChild("Join", true)
                            if acceptBtn then
                                if typeof(getconnections) == "function" then
                                    for _, conn in ipairs(getconnections(acceptBtn.Activated)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                    for _, conn in ipairs(getconnections(acceptBtn.MouseButton1Click)) do
                                        pcall(function() conn:Fire() end)
                                    end
                                end
                                if typeof(firesignal) == "function" then
                                    pcall(function() firesignal(acceptBtn.Activated) end)
                                    pcall(function() firesignal(acceptBtn.MouseButton1Click) end)
                                end
                            end
                        end)
                    end)
                end
            end
        end
        popups.ChildAdded:Connect(handlePopup)
        for _, child in ipairs(popups:GetChildren()) do
            handlePopup(child)
        end
    end)
end
setupAutoMatchmakingCaptcha()
local isMatchmakingActive = function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local mmUI = pg and pg:FindFirstChild("MatchmakingUI")
    local isUIActive = (mmUI and mmUI.Enabled and mmUI:FindFirstChild("Frame") and mmUI.Frame.Visible) == true
    if State.MatchmakingActive and (tick() - (State.LastMatchmakingAttempt or 0) > 30.0) then
        State.MatchmakingActive = false
    end
    if State.MatchFoundTime and (tick() - State.MatchFoundTime > 35.0) then
        State.MatchFound = false
        State.MatchFoundTime = nil
    end
    return isUIActive or State.MatchmakingActive == true
end
task.spawn(function()
    pcall(function()
        local s2c = game:GetService("ReplicatedStorage"):WaitForChild("endpoints", 10)
            and game:GetService("ReplicatedStorage").endpoints:WaitForChild("server_to_client", 10)
        if not s2c then return end
        local mmStarted = s2c:WaitForChild("matchmaking_started", 10)
        if mmStarted then
            mmStarted.OnClientEvent:Connect(function(lvl)
                State.MatchmakingActive = true
                State.MatchFound = false
                State.MatchFoundTime = nil
                State.CurrentMatchLevel = lvl
            end)
        end
        local mmEnded = s2c:WaitForChild("matchmaking_ended", 10)
        if mmEnded then
            mmEnded.OnClientEvent:Connect(function(wasFound)
                State.MatchmakingActive = false
                if wasFound then
                    State.MatchFound = true
                    State.MatchFoundTime = tick()
                end
            end)
        end
        local setTele = s2c:WaitForChild("set_teleport_location", 10)
        if setTele then
            setTele.OnClientEvent:Connect(function()
                State.MatchFound = true
                State.MatchFoundTime = tick()
            end)
        end
    end)
end)
local cancelMatchmaking = function()
    if State.MatchFound or (State.MatchFoundTime and (tick() - State.MatchFoundTime < 35)) then
        return
    end
    State.MatchmakingActive = false
    pcall(function()
        local EndpointsClient = getEndpointsClient()
        if EndpointsClient and EndpointsClient.invoke_server then
            pcall(function() EndpointsClient.invoke_server("leave_matchmaking") end)
        end
        if Endpoints:FindFirstChild("leave_matchmaking") then
            Endpoints.leave_matchmaking:InvokeServer()
        end
        local loader = require(game:GetService("ReplicatedStorage").src.Loader)
        local guiService = loader.load_client_service(nil, "GUIService")
        if guiService and guiService.matchmaking_ui then
            guiService.matchmaking_ui:hide()
        end
    end)
end
local checkCancelMatchmaking = function()
    local anyActive = Config.AutoFindMatchStory or
        Config.AutoFindMatchLegend or
        Config.AutoFindMatchRaid or
        Config.AutoFindMatchMansion or
        Config.AutoFindMatchChallenge or
        Config.AutoFindMatchDailyChallenge or
        Config.AutoFindMatchSummer or
        (Config.AutoJoinArtifact and Config.ArtifactJoinMode == "Find Match")
    if not anyActive and isMatchmakingActive() then
        cancelMatchmaking()
    end
end

-- ==============================================================================
-- Auto Party Engine (Derived from autoparty.lua.disabled & GUI controls)
-- ==============================================================================
local PARTY_SYNC_FILE = "AJ_HUB_Party.json"

local function saveSharedPartyInfo(mainUser, altUsers)
    if not writefile then return end
    pcall(function()
        local current = loadSharedPartyInfo() or {}
        local m = (mainUser and #tostring(mainUser):gsub("%s+", "") > 0) and tostring(mainUser):gsub("%s+", "") or (current.Main and #current.Main > 0 and current.Main) or ""
        local altMap = {}
        if current.Alts and #current.Alts > 0 then
            for u in string.gmatch(current.Alts, "[^,;%s]+") do
                altMap[u:lower()] = u
            end
        end
        if altUsers and #tostring(altUsers):gsub("%s+", "") > 0 then
            for u in string.gmatch(tostring(altUsers), "[^,;%s]+") do
                altMap[u:lower()] = u
            end
        end
        local altList = {}
        for _, u in pairs(altMap) do
            table.insert(altList, u)
        end
        table.sort(altList)
        local a = table.concat(altList, ", ")
        local data = {
            Main = m,
            Alts = a
        }
        writefile(PARTY_SYNC_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadSharedPartyInfo()
    if not readfile or not isfile then return nil end
    local info = nil
    pcall(function()
        if isfile(PARTY_SYNC_FILE) then
            local raw = readfile(PARTY_SYNC_FILE)
            if raw and #raw > 2 then
                local data = HttpService:JSONDecode(raw)
                if type(data) == "table" then
                    info = data
                end
            end
        end
    end)
    return info
end

local party_invite_remote = nil
local party_respond_remote = nil
local party_invite_received_remote = nil

pcall(function()
    local ep = ReplicatedStorage:WaitForChild("endpoints", 30)
    if ep then
        local c2s = ep:WaitForChild("client_to_server", 30)
        local s2c = ep:WaitForChild("server_to_client", 30)
        if c2s then
            party_invite_remote = c2s:WaitForChild("party_invite", 30)
            party_respond_remote = c2s:WaitForChild("party_respond_invite", 30)
        end
        if s2c then
            party_invite_received_remote = s2c:WaitForChild("party_invite_received", 30)
        end
    end
end)

local function wait_character(player)
    if not player then return nil end
    local char = player.Character or player.CharacterAdded:Wait()
    pcall(function()
        char:WaitForChild("HumanoidRootPart", 60)
        char:WaitForChild("Humanoid", 60)
    end)
    return char
end

local function doPartyInvite(targetPlayer)
    if not targetPlayer then return end
    pcall(function()
        if party_invite_remote then
            party_invite_remote:InvokeServer(targetPlayer)
        elseif Endpoints and Endpoints:FindFirstChild("party_invite") then
            Endpoints.party_invite:InvokeServer(targetPlayer)
        elseif ReplicatedStorage:FindFirstChild("endpoints") and ReplicatedStorage.endpoints:FindFirstChild("client_to_server") and ReplicatedStorage.endpoints.client_to_server:FindFirstChild("party_invite") then
            ReplicatedStorage.endpoints.client_to_server.party_invite:InvokeServer(targetPlayer)
        end
    end)
end

local function doPartyRespond(targetPlayer, accept)
    if not targetPlayer then return end
    pcall(function()
        if party_respond_remote then
            party_respond_remote:InvokeServer(targetPlayer, accept ~= false)
        elseif Endpoints and Endpoints:FindFirstChild("party_respond_invite") then
            Endpoints.party_respond_invite:InvokeServer(targetPlayer, accept ~= false)
        elseif ReplicatedStorage:FindFirstChild("endpoints") and ReplicatedStorage.endpoints:FindFirstChild("client_to_server") and ReplicatedStorage.endpoints.client_to_server:FindFirstChild("party_respond_invite") then
            ReplicatedStorage.endpoints.client_to_server.party_respond_invite:InvokeServer(targetPlayer, accept ~= false)
        end
    end)
end

local function isMatchingPlayer(player, identifier)
    if not player or not identifier then return false end
    if type(identifier) == "number" then
        return player.UserId == identifier
    end
    local target = string.lower(tostring(identifier)):gsub("%s+", "")
    if #target == 0 then return false end
    if string.lower(player.Name) == target then return true end
    if player.DisplayName and string.lower(player.DisplayName) == target then return true end
    return false
end

local function isPlayerInList(player, list)
    if not player or not list then return false end
    for _, id in ipairs(list) do
        if isMatchingPlayer(player, id) then
            return true
        end
    end
    return false
end

local function getConfiguredAlts()
    local list = {}
    local seen = {}
    local function addAlt(name)
        if not name then return end
        local u = tostring(name):gsub("%s+", "")
        if #u > 0 and not seen[u:lower()] then
            seen[u:lower()] = true
            table.insert(list, u)
        end
    end

    local raw = Config.PartyAltUsers or ""
    for user in string.gmatch(raw, "[^,;%s]+") do
        addAlt(user)
    end
    local shared = loadSharedPartyInfo()
    if shared and shared.Alts and #shared.Alts > 0 then
        for user in string.gmatch(shared.Alts, "[^,;%s]+") do
            addAlt(user)
        end
    end
    return list
end

local function getConfiguredMain()
    local m = Config.PartyMainUser or ""
    m = m:gsub("%s+", "")
    if #m == 0 then
        local shared = loadSharedPartyInfo()
        if shared and shared.Main and #shared.Main > 0 then
            m = shared.Main:gsub("%s+", "")
        end
    end
    return m
end

local function isConfiguredPartyMember(name)
    if not name or #name == 0 then return false end
    local clean = tostring(name):lower():gsub("%s+", "")
    if clean == LocalPlayer.Name:lower() then return true end
    local mainName = getConfiguredMain():lower()
    if #mainName > 0 and clean == mainName then return true end
    for _, alt in ipairs(getConfiguredAlts()) do
        if clean == tostring(alt):lower():gsub("%s+", "") then return true end
    end
    return false
end

local function getPartyRole()
    local mainUser = getConfiguredMain()
    if #mainUser > 0 and isMatchingPlayer(LocalPlayer, mainUser) then
        return "Main"
    end
    local alts = getConfiguredAlts()
    if #alts > 0 and isPlayerInList(LocalPlayer, alts) then
        return "Alt"
    end
    if Config.PartyMainUser and #Config.PartyMainUser > 0 and isMatchingPlayer(LocalPlayer, Config.PartyMainUser) then
        return "Main"
    end
    for user in string.gmatch(Config.PartyAltUsers or "", "[^,;%s]+") do
        if isMatchingPlayer(LocalPlayer, user) then
            return "Alt"
        end
    end
    return "Solo"
end

local function isPartyReady()
    if not Config.PartyWaitForMembers then
        return true, "Gate disabled"
    end
    local role = getPartyRole()
    local myPartyId = LocalPlayer:GetAttribute("PartyId")
    
    local requiredUsers = {}
    if role == "Main" then
        requiredUsers = getConfiguredAlts()
        if #requiredUsers == 0 then
            return true, "No alts configured"
        end
    elseif role == "Alt" then
        local mainName = getConfiguredMain()
        if #mainName > 0 then
            table.insert(requiredUsers, mainName)
        else
            return true, "No main configured"
        end
    else
        return false, "Set Main/Alt Username"
    end
    
    local missingInServer = {}
    local missingInParty = {}
    
    for _, targetName in ipairs(requiredUsers) do
        local foundPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if isMatchingPlayer(p, targetName) then
                foundPlayer = p
                break
            end
        end
        if not foundPlayer then
            table.insert(missingInServer, tostring(targetName))
        else
            local pPartyId = foundPlayer:GetAttribute("PartyId")
            if not myPartyId or not pPartyId or myPartyId ~= pPartyId then
                table.insert(missingInParty, foundPlayer.Name)
            end
        end
    end
    
    if #missingInServer > 0 then
        return false, "Waiting for server: " .. table.concat(missingInServer, ", ")
    end
    if #missingInParty > 0 then
        return false, "Waiting for party: " .. table.concat(missingInParty, ", ")
    end
    return true, "Party Ready"
end

local function inviteAllAlts()
    local alts = getConfiguredAlts()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isPlayerInList(p, alts) then
            doPartyInvite(p)
        end
    end
end

local function acceptMainInvite()
    local mainName = getConfiguredMain()
    for _, p in ipairs(Players:GetPlayers()) do
        if isMatchingPlayer(p, mainName) then
            doPartyRespond(p, true)
            break
        end
    end
end

local function leaveParty()
    pcall(function()
        for _, name in ipairs({"party_leave", "leave_party", "party_disband", "disband_party"}) do
            if Endpoints and Endpoints:FindFirstChild(name) then
                pcall(function() Endpoints[name]:InvokeServer() end)
                return
            end
        end
    end)
end

local function waitForRoomMembers(room)
    if not Config.PartyWaitForMembers or not room then return end
    local roomPlayers = room:FindFirstChild("Players")
    if not roomPlayers then return end
    local alts = getConfiguredAlts()
    if #alts == 0 then return end
    local startWait = tick()
    while (tick() - startWait < 5.0) do
        local allPresent = true
        for _, altName in ipairs(alts) do
            local foundInRoom = false
            for _, ch in ipairs(roomPlayers:GetChildren()) do
                if isMatchingPlayer(ch, altName) or (ch:IsA("ObjectValue") and ch.Value and isMatchingPlayer(ch.Value, altName)) then
                    foundInRoom = true
                    break
                end
            end
            if not foundInRoom then
                local inServer = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if isMatchingPlayer(p, altName) then
                        inServer = true
                        break
                    end
                end
                if inServer then
                    allPresent = false
                    break
                end
            end
        end
        if allPresent then break end
        task.wait(0.25)
    end
end

task.spawn(function()
    pcall(function()
        local ep = ReplicatedStorage:WaitForChild("endpoints", 30)
        local s2c = ep and ep:WaitForChild("server_to_client", 30)
        local pir = s2c and s2c:WaitForChild("party_invite_received", 30)
        if pir then
            pir.OnClientEvent:Connect(function(sender)
                if not Config.AutoPartyEnabled or not Config.PartyAutoAccept then return end
                if not sender then return end
                local role = getPartyRole()
                if role == "Alt" then
                    local mainName = getConfiguredMain()
                    if #mainName == 0 or isMatchingPlayer(sender, mainName) then
                        doPartyRespond(sender, true)
                        if #mainName == 0 then
                            Config.PartyMainUser = sender.Name
                            saveSharedPartyInfo(sender.Name, LocalPlayer.Name)
                            triggerAutoSave()
                        end
                    end
                end
            end)
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(function()
            if not Config.AutoPartyEnabled then return end
            wait_character(LocalPlayer)
            local role = getPartyRole()
            local myPartyId = LocalPlayer:GetAttribute("PartyId")
            
            -- Sync our identity to shared party pool
            if role == "Main" then
                saveSharedPartyInfo(LocalPlayer.Name, Config.PartyAltUsers)
            elseif role == "Alt" then
                saveSharedPartyInfo(Config.PartyMainUser, LocalPlayer.Name)
            end
            
            -- Alt Auto-Accept (listener backup + polling)
            if role == "Alt" and Config.PartyAutoAccept then
                if not myPartyId then
                    local mainName = getConfiguredMain()
                    if #mainName > 0 then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if isMatchingPlayer(p, mainName) then
                                doPartyRespond(p, true)
                                break
                            end
                        end
                    end
                end
            end
            
            -- Main Auto-Invite (polls alts & invites)
            if role == "Main" and Config.PartyAutoInvite then
                local alts = getConfiguredAlts()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and isPlayerInList(p, alts) then
                        local altPartyId = p:GetAttribute("PartyId")
                        local alreadyTogether = (myPartyId ~= nil and altPartyId ~= nil and myPartyId == altPartyId)
                        if not alreadyTogether then
                            if not p.Character or p.Character:FindFirstChild("HumanoidRootPart") then
                                doPartyInvite(p)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local startMatchmaking = function(levelId)
    if not levelId or State.LobbyJoining then return end
    if isMatchmakingActive() or State.MatchFound then return end
    if State.MatchFoundTime and (tick() - State.MatchFoundTime < 35) then return end
    if tick() - (State.LastMatchmakingAttempt or 0) < 6.0 then return end
    if Config.PartyWaitForMembers then
        local ready, reason = isPartyReady()
        if not ready then
            State.PartyWaitReason = reason
            return
        end
    end
    State.LastMatchmakingAttempt = tick()
    State.MatchmakingActive = true
    State.MatchFound = false
    State.CurrentMatchLevel = levelId
    pcall(function()
        leaveCurrentLobby()
        task.wait(0.15)
        local loader = require(game:GetService("ReplicatedStorage").src.Loader)
        local nwUI = loader.load_client_service(nil, "GUIService").notification_windows_ui
        local guiService = loader.load_client_service(nil, "GUIService")
        if nwUI then
            nwUI.HAS_MATCHMAKING_PROMPT = false
            nwUI._last_matchmaking_captcha_success = tick() + 999999
        end
        local EndpointsClient = getEndpointsClient()
        if EndpointsClient and EndpointsClient.invoke_server then
            pcall(function() EndpointsClient.invoke_server("request_matchmaking", levelId) end)
        end
        if Endpoints:FindFirstChild("request_matchmaking") then
            pcall(function() Endpoints.request_matchmaking:InvokeServer(levelId) end)
        end
        if guiService and guiService.matchmaking_ui then
            guiService.matchmaking_ui:show(levelId)
        end
    end)
end
local processLobbyAutomation = function()
    if not isLobby() or State.LobbyJoining then return end
    if isMatchmakingActive() or State.MatchFound then return end
    if State.MatchFoundTime and (tick() - State.MatchFoundTime < 35) then return end
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("TeleportingLock") and lp.TeleportingLock.Value > 0 then return end
    if tick() - (State.LastLobbyCheck or 0) < 1.0 then return end
    State.LastLobbyCheck = tick()
    syncWithXTHub()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if Config.PartyWaitForMembers then
        local ready, reason = isPartyReady()
        if not ready then
            State.PartyWaitReason = reason
            return
        end
        State.PartyWaitReason = nil
    end
    local function findEmptyRoom(container)
        if not container then return nil end
        for _, room in ipairs(container:GetChildren()) do
            local owner = room:FindFirstChild("Owner")
            local active = room:FindFirstChild("Active")
            local locked = room:FindFirstChild("Locked")
            local teleporting = room:FindFirstChild("Teleporting")
            local playersFolder = room:FindFirstChild("Players")
            local isOwnerEmpty = (not owner or owner.Value == nil or owner.Value == LocalPlayer)
            local isNotActive = (not active or active.Value == false)
            local isNotLocked = (not locked or locked.Value == false or (owner and owner.Value == LocalPlayer))
            local isNotTeleporting = (not teleporting or teleporting.Value == false)
            local hasStrangers = false
            if playersFolder then
                for _, p in ipairs(playersFolder:GetChildren()) do
                    if p.Name ~= LocalPlayer.Name and not isConfiguredPartyMember(p.Name) then
                        hasStrangers = true
                        break
                    end
                end
            end
            if isOwnerEmpty and isNotActive and isNotLocked and isNotTeleporting and not hasStrangers then
                return room
            end
        end
        return nil
    end
    if Config.AutoClaimArtifactRewards and Endpoints:FindFirstChild("claim_first_clear_rewards") then
        pcall(function() Endpoints.claim_first_clear_rewards:InvokeServer("artifact") end)
    end
    if (Config.AutoJoinSummer or Config.AutoFindMatchSummer) and not State.LobbyJoining then
        local skipCurrent = false
        pcall(function()
            local xt = getgenv().XT_AnimeAdventures
            if xt and xt.Lobby and xt.Lobby.SummerNow then
                local nowData = xt.Lobby.SummerNow()
                if nowData and typeof(nowData) == "table" then
                    local curMap = nowData.Map or nowData.map
                    local curWeather = nowData.Weather or nowData.weather
                    if curMap and Config.SummerSkipMaps and (Config.SummerSkipMaps[curMap] or table.find(Config.SummerSkipMaps, curMap)) then
                        skipCurrent = true
                    end
                    if curWeather and Config.SummerSkipWeather and (Config.SummerSkipWeather[curWeather] or table.find(Config.SummerSkipWeather, curWeather)) then
                        skipCurrent = true
                    end
                end
            end
        end)
        if skipCurrent then
            if isMatchmakingActive() then
                cancelMatchmaking()
            end
        else
            if Config.AutoFindMatchSummer then
                startMatchmaking("summer2_event")
                return
            end
            if Config.AutoJoinSummer then
                if isMatchmakingActive() then
                    cancelMatchmaking()
                end
                local function getRoomTargetPart(room)
                    if not room then return nil end
                    return room.PrimaryPart
                        or room:FindFirstChild("primary")
                        or room:FindFirstChild("Door")
                        or room:FindFirstChild("Out")
                        or room:FindFirstChild("ShinyPortalPart")
                        or room:FindFirstChild("NeonPlatform")
                        or room:FindFirstChildWhichIsA("BasePart")
                end
                local function findSummerHuntRoom()
                    local containers = {}
                    local ec = Workspace:FindFirstChild("_EVENT_CHALLENGES")
                    if ec then
                        local ecLobbies = ec:FindFirstChild("Lobbies")
                        if ecLobbies then table.insert(containers, ecLobbies) end
                        table.insert(containers, ec)
                    end
                    local lobbiesFolder = Workspace:FindFirstChild("_LOBBIES")
                    if lobbiesFolder then
                        for _, subName in ipairs({"Event", "Summer", "SummerHunt", "Summer2"}) do
                            local sub = lobbiesFolder:FindFirstChild(subName)
                            if sub then table.insert(containers, sub) end
                        end
                    end
                    local evArea = Workspace:FindFirstChild("_EVENT_AREA")
                    if evArea then
                        local evLobbies = evArea:FindFirstChild("Lobbies")
                        if evLobbies then table.insert(containers, evLobbies) end
                        table.insert(containers, evArea)
                    end
                    local smFolder = Workspace:FindFirstChild("_SUMMER")
                    if smFolder then
                        local smLobbies = smFolder:FindFirstChild("Lobbies")
                        if smLobbies then table.insert(containers, smLobbies) end
                        table.insert(containers, smFolder)
                    end
                    for _, container in ipairs(containers) do
                        for _, room in ipairs(container:GetChildren()) do
                            if room:IsA("Model") then
                                local targetPart = getRoomTargetPart(room)
                                if targetPart then
                                    local lvlVal = room:FindFirstChild("Level")
                                    local isSummer = (room.Name:lower():find("event") or room.Name:lower():find("summer") or (lvlVal and tostring(lvlVal.Value):lower():find("summer")))
                                    if isSummer then
                                        local owner = room:FindFirstChild("Owner")
                                        local active = room:FindFirstChild("Active")
                                        local locked = room:FindFirstChild("Locked")
                                        local teleporting = room:FindFirstChild("Teleporting")
                                        local playersFolder = room:FindFirstChild("Players")
                                        local isOwnerEmpty = (not owner or owner.Value == nil or owner.Value == LocalPlayer)
                                        local isNotActive = (not active or active.Value == false)
                                        local isNotLocked = (not locked or locked.Value == false or (owner and owner.Value == LocalPlayer))
                                        local isNotTeleporting = (not teleporting or teleporting.Value == false)
                                        local hasStrangers = false
                                        if playersFolder then
                                            for _, p in ipairs(playersFolder:GetChildren()) do
                                                if p.Name ~= LocalPlayer.Name then
                                                    hasStrangers = true
                                                    break
                                                end
                                            end
                                        end
                                        if isOwnerEmpty and isNotActive and isNotLocked and isNotTeleporting and not hasStrangers then
                                            local mapName = ""
                                            local weatherName = ""
                                            pcall(function()
                                                local ml = room:FindFirstChild("MapName", true)
                                                if ml and ml:IsA("TextLabel") then
                                                    mapName = ml.Text
                                                end
                                                local wv = room:FindFirstChild("Weather")
                                                if wv and wv:IsA("StringValue") then
                                                    weatherName = wv.Value
                                                end
                                                local dl = room:FindFirstChild("Difficulty", true)
                                                if dl and dl:IsA("TextLabel") and weatherName == "" then
                                                    weatherName = dl.Text
                                                end
                                            end)
                                            local skipM = false
                                            if type(Config.SummerSkipMaps) == "table" and #Config.SummerSkipMaps > 0 and mapName ~= "" then
                                                for _, sm in ipairs(Config.SummerSkipMaps) do
                                                    if mapName:lower():find(sm:lower()) or sm:lower():find(mapName:lower()) then
                                                        skipM = true
                                                        break
                                                    end
                                                end
                                            end
                                            local skipW = false
                                            if type(Config.SummerSkipWeather) == "table" and #Config.SummerSkipWeather > 0 and weatherName ~= "" then
                                                local weatherAliases = {
                                                    ["underwater"] = "flooded",
                                                    ["flooded"] = "flooded",
                                                    ["blizzard"] = "blizzard",
                                                    ["clear"] = "clear",
                                                    ["inferno"] = "inferno",
                                                    ["magical"] = "magical"
                                                }
                                                local normW = weatherAliases[weatherName:lower()] or weatherName:lower()
                                                for _, sw in ipairs(Config.SummerSkipWeather) do
                                                    local normSw = weatherAliases[sw:lower()] or sw:lower()
                                                    if normW:find(normSw) or normSw:find(normW) then
                                                        skipW = true
                                                        break
                                                    end
                                                end
                                            end
                                            if not skipM and not skipW then
                                                return room, targetPart
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return nil, nil
                end
                local room, targetPart = findSummerHuntRoom()
                if room and targetPart then
                    State.LobbyJoining = true
                    task.spawn(function()
                        if (hrp.Position - targetPart.Position).Magnitude > 12 then
                            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.35)
                        end
                        pcall(function()
                            local EndpointsClient = getEndpointsClient()
                            if EndpointsClient and EndpointsClient.invoke_server then
                                EndpointsClient.invoke_server("request_join_lobby", room.Name)
                            elseif Endpoints:FindFirstChild("request_join_lobby") then
                                Endpoints.request_join_lobby:InvokeServer(room.Name)
                            end
                            task.wait(0.3)
                            waitForRoomMembers(room)
                            if EndpointsClient and EndpointsClient.invoke_server then
                                EndpointsClient.invoke_server("request_start_game", room.Name)
                            elseif Endpoints:FindFirstChild("request_start_game") then
                                Endpoints.request_start_game:InvokeServer(room.Name)
                            end
                        end)
                        task.wait(2.5)
                        State.LobbyJoining = false
                    end)
                    return
                end
            end
        end
    end
    if Config.AutoJoinStory or Config.AutoFindMatchStory or Config.JoinLastAct then
        local targetWorld = StoryWorldMap[Config.StoryWorld] or "namek"
        local targetDiff = Config.StoryDifficulty or "Normal"
        local friendsOnly = (Config.StoryFriendsOnly == true)
        local storyLevelId
        if Config.StoryAct == "Infinite" then
            storyLevelId = targetWorld .. "_infinite"
            targetDiff = "Hard"
        elseif Config.JoinLastAct then
            storyLevelId = targetWorld .. "_level_6"
            targetDiff = Config.StoryDifficulty or "Normal"
        else
            local actNum = tonumber(string.match(Config.StoryAct or "1", "%d+")) or 1
            storyLevelId = targetWorld .. "_level_" .. tostring(actNum)
        end
        if Config.AutoFindMatchStory then
            startMatchmaking(storyLevelId)
            return
        end
        local lobbiesFolder = Workspace:FindFirstChild("_LOBBIES")
        local storyFolder = lobbiesFolder and lobbiesFolder:FindFirstChild("Story")
        local room = findEmptyRoom(storyFolder)
        if room and room:FindFirstChild("primary") then
            State.LobbyJoining = true
            task.spawn(function()
                if (hrp.Position - room.primary.Position).Magnitude > 12 then
                    hrp.CFrame = room.primary.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.35)
                end
                pcall(function()
                    if Endpoints:FindFirstChild("request_join_lobby") then
                        Endpoints.request_join_lobby:InvokeServer(room.Name)
                    end
                    task.wait(0.25)
                    local lockSuccess = false
                    if Endpoints:FindFirstChild("request_lock_level") then
                        local res = Endpoints.request_lock_level:InvokeServer(room.Name, storyLevelId, friendsOnly, targetDiff)
                        if res == true or res == "success" then
                            lockSuccess = true
                        elseif type(res) == "table" then
                            if res.lock == true or res.success == true then
                                lockSuccess = true
                            elseif res.lock ~= false and not res.messages and not res.error then
                                lockSuccess = true
                            end
                        end
                        if not lockSuccess and room and room:FindFirstChild("Level") and room.Level.Value == storyLevelId then
                            lockSuccess = true
                        end
                    end
                    if lockSuccess then
                        if Config.WorldSkip and Config.StoryAct ~= "Infinite" and Endpoints:FindFirstChild("lobby_world_skip") then
                            task.wait(0.2)
                            Endpoints.lobby_world_skip:InvokeServer(room.Name)
                        end
                        task.wait(0.35)
                        waitForRoomMembers(room)
                        if Endpoints:FindFirstChild("request_start_game") then
                            Endpoints.request_start_game:InvokeServer(room.Name)
                        end
                    else
                        if Endpoints:FindFirstChild("request_leave_lobby") then
                            Endpoints.request_leave_lobby:InvokeServer(room.Name)
                        end
                    end
                end)
                task.wait(2.0)
                State.LobbyJoining = false
            end)
            return
        end
    end
    if Config.AutoJoinDailyChallenge or Config.AutoFindMatchDailyChallenge then
        if Config.AutoFindMatchDailyChallenge then
            startMatchmaking("__DAILY_CHALLENGE")
            return
        end
        local challengesFolder = Workspace:FindFirstChild("_CHALLENGES")
        local dailyFolder = challengesFolder and challengesFolder:FindFirstChild("DailyChallenge")
        local room = findEmptyRoom(dailyFolder)
        if room and room:FindFirstChild("primary") then
            State.LobbyJoining = true
            task.spawn(function()
                if (hrp.Position - room.primary.Position).Magnitude > 12 then
                    hrp.CFrame = room.primary.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.4)
                end
                pcall(function()
                    if Endpoints:FindFirstChild("request_join_lobby") then
                        Endpoints.request_join_lobby:InvokeServer(room.Name)
                    end
                    task.wait(0.3)
                    waitForRoomMembers(room)
                    if Endpoints:FindFirstChild("request_start_game") then
                        Endpoints.request_start_game:InvokeServer(room.Name)
                    end
                end)
                task.wait(2.5)
                State.LobbyJoining = false
            end)
            return
        end
    end
    if Config.AutoJoinChallenge or Config.AutoFindMatchChallenge then
        if Config.AutoFindMatchChallenge then
            startMatchmaking("__NORMAL_CHALLENGE")
            return
        end
        local challengesFolder = Workspace:FindFirstChild("_CHALLENGES")
        local normFolder = challengesFolder and challengesFolder:FindFirstChild("Challenges")
        local room = findEmptyRoom(normFolder)
        if room and room:FindFirstChild("primary") then
            State.LobbyJoining = true
            task.spawn(function()
                if (hrp.Position - room.primary.Position).Magnitude > 12 then
                    hrp.CFrame = room.primary.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.4)
                end
                pcall(function()
                    if Endpoints:FindFirstChild("request_join_lobby") then
                        Endpoints.request_join_lobby:InvokeServer(room.Name)
                    end
                    task.wait(0.3)
                    waitForRoomMembers(room)
                    if Endpoints:FindFirstChild("request_start_game") then
                        Endpoints.request_start_game:InvokeServer(room.Name)
                    end
                end)
                task.wait(2.5)
                State.LobbyJoining = false
            end)
            return
        end
    end
    if Config.AutoJoinRaid or Config.AutoFindMatchRaid then
        local targetRaid = WorldIdMap[Config.RaidWorld] or "current_raid"
        if targetRaid == "current_raid" then
            pcall(function()
                local activeRaid = Workspace:FindFirstChild("_RAID") and Workspace._RAID:FindFirstChild("_DATA") and Workspace._RAID._DATA:FindFirstChild("current_raid")
                if activeRaid and activeRaid.Value ~= "" then
                    targetRaid = activeRaid.Value
                else
                    targetRaid = "demonslayer_raid_1"
                end
            end)
        end
        local actNum = tonumber(string.match(Config.RaidAct, "%d+")) or 1
        local multiActRaids = {
            ["west_city_frieza"] = true,
            ["entertainment_district"] = true,
            ["kai_planet"] = true,
            ["morioh"] = true,
            ["uchiha"] = true
        }
        local raidLevelId = targetRaid
        if multiActRaids[targetRaid] then
            raidLevelId = targetRaid .. "_level_" .. tostring(actNum)
        end
        if Config.AutoFindMatchRaid then
            startMatchmaking(raidLevelId)
            return
        end
        local raidFolder = Workspace:FindFirstChild("_RAID") and Workspace._RAID:FindFirstChild("Raid")
        local room = findEmptyRoom(raidFolder)
        if room and room:FindFirstChild("primary") then
            State.LobbyJoining = true
            task.spawn(function()
                if (hrp.Position - room.primary.Position).Magnitude > 12 then
                    hrp.CFrame = room.primary.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.4)
                end
                pcall(function()
                    if Endpoints:FindFirstChild("request_join_lobby") then
                        Endpoints.request_join_lobby:InvokeServer(room.Name)
                    end
                    task.wait(0.3)
                    local lockSuccess = false
                    if Endpoints:FindFirstChild("request_lock_level") then
                        local res = Endpoints.request_lock_level:InvokeServer(room.Name, raidLevelId, false, "Normal")
                        lockSuccess = (res == true or res == "success" or (room and room:FindFirstChild("Level") and room.Level.Value == storyLevelId))
                    end
                    if lockSuccess then
                        task.wait(0.25)
                        waitForRoomMembers(room)
                        if Endpoints:FindFirstChild("request_start_game") then
                            Endpoints.request_start_game:InvokeServer(room.Name)
                        end
                    else
                        if Endpoints:FindFirstChild("request_leave_lobby") then
                            Endpoints.request_leave_lobby:InvokeServer(room.Name)
                        end
                    end
                end)
                task.wait(2.5)
                State.LobbyJoining = false
            end)
            return
        end
    end
    if Config.AutoJoinMansion or Config.AutoFindMatchMansion then
        local rNum = Config.JoinLastMansionRoom and 100 or (tonumber(Config.MansionRoom) or 1)
        rNum = math.clamp(rNum, 1, 100)
        local diff = Config.MansionDifficulty or "Hard"
        if Config.AutoFindMatchMansion then
            startMatchmaking("__INFINITE_TOWER:" .. tostring(rNum) .. ":" .. tostring(diff))
            return
        end
        if Endpoints:FindFirstChild("request_start_infinite_tower") then
            pcall(function()
                Endpoints.request_start_infinite_tower:InvokeServer(rNum, diff)
            end)
            return
        end
    end
    if Config.AutoJoinArtifact and Config.ArtifactJoinMode == "Find Match" then
        local artifactLevel = "artifact_usopp_ts"
        pcall(function()
            local loader = require(game:GetService("ReplicatedStorage").src.Loader)
            local levels = loader.load_data(script, "Levels")
            if levels and levels["artifact_tengen_2"] and (levels["artifact_tengen_2"]._MATCHMAKING or levels["artifact_tengen_2"].Matchmaking) then
                artifactLevel = "artifact_tengen_2"
            end
        end)
        startMatchmaking(artifactLevel)
        return
    end
    if Config.AutoJoinLegend or Config.AutoFindMatchLegend then
        local legendWorld = LegendWorldMap[Config.LegendStage] or "clover_legend"
        local actNum = tonumber(string.match(Config.LegendAct or "1", "%d+")) or 1
        local legendLevelId = legendWorld .. "_" .. tostring(actNum)
        if Config.AutoFindMatchLegend then
            startMatchmaking(legendLevelId)
            return
        end
        local lobbiesFolder = Workspace:FindFirstChild("_LOBBIES")
        local storyFolder = lobbiesFolder and lobbiesFolder:FindFirstChild("Story")
        local room = findEmptyRoom(storyFolder)
        if room and room:FindFirstChild("primary") then
            State.LobbyJoining = true
            task.spawn(function()
                if (hrp.Position - room.primary.Position).Magnitude > 12 then
                    hrp.CFrame = room.primary.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.35)
                end
                pcall(function()
                    if Endpoints:FindFirstChild("request_join_lobby") then
                        Endpoints.request_join_lobby:InvokeServer(room.Name)
                    end
                    task.wait(0.25)
                    local lockSuccess = false
                    if Endpoints:FindFirstChild("request_lock_level") then
                        local res = Endpoints.request_lock_level:InvokeServer(room.Name, legendLevelId, false, "Normal")
                        lockSuccess = (res == true or res == "success")
                    end
                    if lockSuccess then
                        task.wait(0.25)
                        waitForRoomMembers(room)
                        if Endpoints:FindFirstChild("request_start_game") then
                            Endpoints.request_start_game:InvokeServer(room.Name)
                        end
                    else
                        if Endpoints:FindFirstChild("request_leave_lobby") then
                            Endpoints.request_leave_lobby:InvokeServer(room.Name)
                        end
                    end
                end)
                task.wait(2.0)
                State.LobbyJoining = false
            end)
            return
        end
    end
end
local processEventLobbyAutomation = function()
    if not isLobby() then return end
    local now = tick()
    if Config.AutoClaimMapBoard and (now - (State.LastMapBoardCheck or 0) > 4.0) then
        State.LastMapBoardCheck = now
        pcall(function()
            if Endpoints:FindFirstChild("claim_summer2_map_board_lines") then
                Endpoints.claim_summer2_map_board_lines:InvokeServer()
            end
            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
            if pgui and pgui:FindFirstChild("SummerHuntMaps") and pgui.SummerHuntMaps.Main:FindFirstChild("Claim") then
                if pgui.SummerHuntMaps.Main.Claim.Visible then
                    firesignal(pgui.SummerHuntMaps.Main.Claim.Activated)
                    pcall(function() firesignal(pgui.SummerHuntMaps.Main.Claim.MouseButton1Click) end)
                end
            end
        end)
    end
    if Config.AutoEventQuests and (now - (State.LastEventQuestCheck or 0) > 4.0) then
        State.LastEventQuestCheck = now
        pcall(function()
            if Endpoints:FindFirstChild("accept_npc_quest") then
                Endpoints.accept_npc_quest:InvokeServer("weather_girl")
                Endpoints.accept_npc_quest:InvokeServer("water_goddess")
                Endpoints.accept_npc_quest:InvokeServer("summer_event")
            end
            if Endpoints:FindFirstChild("redeem_quest") then
                Endpoints.redeem_quest:InvokeServer("summer_event_1")
                Endpoints.redeem_quest:InvokeServer("summer_event_2")
            end
            if Endpoints:FindFirstChild("claim_battlepass_rewards") then
                Endpoints.claim_battlepass_rewards:InvokeServer()
            end
        end)
    end
    if Config.AutoBuyMerchant and (now - (State.LastMerchantCheck or 0) > 5.0) then
        State.LastMerchantCheck = now
        pcall(function()
            local shopData = nil
            if Endpoints:FindFirstChild("request_current_bsd_shop") then
                shopData = Endpoints.request_current_bsd_shop:InvokeServer()
            end
            if shopData and typeof(shopData) == "table" then
                local pearls = 999999
                local gems = 999999
                pcall(function()
                    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                    if pgui and pgui:FindFirstChild("BSDShop") then
                        local curLbl = pgui.BSDShop.Window:FindFirstChild("LesserGrails") or pgui.BSDShop.Window:FindFirstChild("Amount")
                        if curLbl and curLbl.Text then
                            pearls = tonumber(curLbl.Text:match("%d+")) or pearls
                        end
                    end
                end)
                for itemId, itemInfo in pairs(shopData) do
                    local itemName = itemInfo.Name or itemInfo.item_id or tostring(itemId)
                    local cost = itemInfo.Cost or itemInfo.price or 0
                    local costType = itemInfo.Currency or "Pearls"
                    local wantsItem = false
                    if Config.MerchantItem == "All" or (Config.MerchantItems and table.find(Config.MerchantItems, "All")) then
                        wantsItem = true
                    elseif Config.MerchantItem == itemName or (Config.MerchantItems and table.find(Config.MerchantItems, itemName)) then
                        wantsItem = true
                    end
                    if wantsItem then
                        if costType == "Gems" and (gems - cost) >= (Config.KeepGems or 0) then
                            if Endpoints:FindFirstChild("buy_travelling_merchant_item") then
                                Endpoints.buy_travelling_merchant_item:InvokeServer(itemId)
                            elseif Endpoints:FindFirstChild("buy_bsd_shop_item") then
                                Endpoints.buy_bsd_shop_item:InvokeServer(itemId)
                            end
                        elseif costType ~= "Gems" and (pearls - cost) >= (Config.KeepSummerPearls or 0) then
                            if Endpoints:FindFirstChild("buy_travelling_merchant_item") then
                                Endpoints.buy_travelling_merchant_item:InvokeServer(itemId)
                            elseif Endpoints:FindFirstChild("buy_bsd_shop_item") then
                                Endpoints.buy_bsd_shop_item:InvokeServer(itemId)
                            end
                        end
                    end
                end
            end
        end)
    end
end
local isRoguelikeChoiceActive = function()
    local rogue = Workspace:FindFirstChild("_DATA") and Workspace._DATA:FindFirstChild("Roguelike")
    if rogue and rogue:FindFirstChild("WaitingForRoguelikeChoice") and rogue.WaitingForRoguelikeChoice.Value == true then
        return true
    end
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local cardGui = pgui and pgui:FindFirstChild("CardSelectRoguelike")
    if cardGui and cardGui.Enabled == true then
        return true
    end
    return false
end
local pickBestRoguelikeCard = function()
    if not Config.AutoPickCards and not Config.BestForEventCurrency then return end
    if not isRoguelikeChoiceActive() then return end
    local now = tick()
    if State.LastVotedRoundChoice and (now - (State.LastVotedRoundTime or 0) < 3.5) then
        return
    end
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local cardGui = pgui and pgui:FindFirstChild("CardSelectRoguelike")
    local pageUI = cardGui and cardGui:FindFirstChild("main") and cardGui.main:FindFirstChild("pick") and cardGui.main.pick:FindFirstChild("inner") and cardGui.main.pick.inner:FindFirstChild("PageUI")
    if not pageUI then return end
    local candidates = {}
    local anyWithoutResist = false
    for idx, cardFrame in ipairs(pageUI:GetChildren()) do
        if cardFrame:IsA("GuiObject") and cardFrame.Name ~= "UIListLayout" and cardFrame.Name ~= "Configuration" then
            local cardText = ""
            for _, lbl in ipairs(cardFrame:GetDescendants()) do
                if lbl:IsA("TextLabel") and lbl.Text and #lbl.Text > 0 then
                    cardText = cardText .. " " .. lbl.Text
                end
            end
            local textLower = cardText:lower()
            local pearlBonus = 0
            local m = cardText:match("%+(%d+)%%%s*Summer") or cardText:match("(%d+)%%%s*Summer") or cardText:match("(%d+)%%%s*Pearls") or cardText:match("%+(%d+)%%%s*Reward")
            if m then
                pearlBonus = tonumber(m) or 0
            end
            local hasPhysResist = string.find(textLower, "physical resist") ~= nil
            local hasMagicResist = string.find(textLower, "magic resist") ~= nil
            local hasResist = hasPhysResist or hasMagicResist
            if not hasResist then
                anyWithoutResist = true
            end
            local takeScore = 0
            local matchedTakeNames = {}
            local cardPatterns = {
                ["attack"] = "attack",
                ["attack damage"] = "attack",
                ["range"] = "range",
                ["cooldown"] = "cooldown",
                ["crit chance"] = "crit",
                ["phys crit chance"] = "phys crit",
                ["magic crit chance"] = "magic crit",
                ["phys damage"] = "phys damage",
                ["magic damage"] = "magic damage",
                ["boss damage"] = "boss damage",
                ["damage vs flying"] = "flying",
                ["summer pearls"] = "pearl",
                ["money (\194\165)"] = "\194\165",
                ["money"] = "\194\165",
                ["secret drop rate"] = "secret",
                ["secret drop"] = "secret",
                ["star golem chance"] = "golem",
                ["blessings"] = "blessing"
            }
            local takeList = Config.TakeCardsPriority or {}
            State.TakenCardsCount = State.TakenCardsCount or {}
            for i, entry in ipairs(takeList) do
                local entryName = type(entry) == "table" and entry.name or tostring(entry)
                local limit = type(entry) == "table" and (tonumber(entry.limit) or 0) or 0
                local pat = cardPatterns[entryName:lower()] or entryName:lower()
                if string.find(textLower, pat) then
                    table.insert(matchedTakeNames, entryName)
                    local curCount = State.TakenCardsCount[entryName] or 0
                    if limit > 0 and curCount >= limit then
                        takeScore = math.max(takeScore, 10)
                    else
                        local rankScore = 1000 - i * 50
                        if rankScore > takeScore then
                            takeScore = rankScore
                        end
                    end
                end
            end
            local avoidPenalty = 0
            local matchedAvoidNames = {}
            local avoidPatterns = {
                ["physical resist"] = "physical resist",
                ["magic resist"] = "magic resist",
                ["enemy health"] = "health",
                ["enemy speed"] = "enemy speed",
                ["enemy regen"] = "regen",
                ["enemy shield"] = "shield",
                ["explosive deaths"] = "explosive",
                ["burst enemy speed"] = "burst",
                ["new paths"] = "new path",
                ["placement/upgrade cost"] = "cost",
                ["enemy flying chance"] = "flying chance",
                ["flyers soaring"] = "soaring",
                ["enemy passives"] = "passive",
                ["lightning strikes"] = "lightning",
                ["curses"] = "curse"
            }
            local avoidList = Config.AvoidCardsPriority or {}
            State.AvoidedCardsCount = State.AvoidedCardsCount or {}
            for i, entry in ipairs(avoidList) do
                local entryName = type(entry) == "table" and entry.name or tostring(entry)
                local limit = type(entry) == "table" and (tonumber(entry.limit) or 0) or 0
                local pat = avoidPatterns[entryName:lower()] or entryName:lower()
                if string.find(textLower, pat) then
                    table.insert(matchedAvoidNames, entryName)
                    local curAvoid = State.AvoidedCardsCount[entryName] or 0
                    if limit == 0 or curAvoid < limit then
                        avoidPenalty = avoidPenalty + (5000 - i * 100)
                    end
                end
            end
            table.insert(candidates, {
                frame = cardFrame,
                key = cardFrame.Name,
                index = idx,
                pearlBonus = pearlBonus,
                hasResist = hasResist,
                takeScore = takeScore,
                avoidPenalty = avoidPenalty,
                hasAvoidTrait = (avoidPenalty > 0),
                netScore = takeScore - avoidPenalty,
                matchedTakes = matchedTakeNames,
                matchedAvoids = matchedAvoidNames
            })
        end
    end
    if #candidates == 0 then return end
    local anyCleanOption = false
    for _, c in ipairs(candidates) do
        if not c.hasResist and not c.hasAvoidTrait then
            anyCleanOption = true
            break
        end
    end
    local best = nil
    if Config.BestForEventCurrency then
        table.sort(candidates, function(a, b)
            if anyCleanOption then
                local aBad = a.hasResist or a.hasAvoidTrait
                local bBad = b.hasResist or b.hasAvoidTrait
                if aBad and not bBad then return false end
                if not aBad and bBad then return true end
            elseif anyWithoutResist then
                if a.hasResist and not b.hasResist then return false end
                if not a.hasResist and b.hasResist then return true end
            end
            if a.pearlBonus ~= b.pearlBonus then
                return a.pearlBonus > b.pearlBonus
            end
            return a.netScore > b.netScore
        end)
        best = candidates[1]
    else
        table.sort(candidates, function(a, b)
            if anyCleanOption then
                local aBad = a.hasResist or a.hasAvoidTrait
                local bBad = b.hasResist or b.hasAvoidTrait
                if aBad and not bBad then return false end
                if not aBad and bBad then return true end
            end
            return a.netScore > b.netScore
        end)
        best = candidates[1]
    end
    if best and best.frame then
        local targetFrame = best.frame
        local cardKey = tostring(best.key or best.index or "1")
        State.LastVotedRoundChoice = cardKey
        State.LastVotedRoundTime = tick()
        if best.matchedTakes then
            for _, tName in ipairs(best.matchedTakes) do
                State.TakenCardsCount[tName] = (State.TakenCardsCount[tName] or 0) + 1
            end
        end
        if best.matchedAvoids then
            for _, aName in ipairs(best.matchedAvoids) do
                State.AvoidedCardsCount[aName] = (State.AvoidedCardsCount[aName] or 0) + 1
            end
        end
        pcall(function()
            local Loader = require(game.ReplicatedStorage.src.Loader)
            local GUIService = Loader.load_client_service(nil, "GUIService")
            if GUIService and GUIService.roguelike_select_ui then
                GUIService.roguelike_select_ui:_vote(cardKey)
            end
        end)
        pcall(function()
            local Loader = require(game.ReplicatedStorage.src.Loader)
            local EndpointsClient = Loader.load_client_service(nil, "EndpointsClient")
            if EndpointsClient and EndpointsClient.invoke_server then
                EndpointsClient.invoke_server("select_roguelike_option", cardKey)
            end
        end)
        pcall(function()
            if Endpoints and Endpoints:FindFirstChild("select_roguelike_option") then
                Endpoints.select_roguelike_option:InvokeServer(cardKey)
            end
        end)
        pcall(function()
            if Endpoints and Endpoints:FindFirstChild("select_roguelike_option") and tonumber(cardKey) then
                Endpoints.select_roguelike_option:InvokeServer(tonumber(cardKey))
            end
        end)
        local clickBtn = targetFrame:IsA("GuiButton") and targetFrame or targetFrame:FindFirstChildWhichIsA("GuiButton", true)
        if clickBtn then
            pcall(function() firesignal(clickBtn.Activated) end)
            pcall(function() firesignal(clickBtn.MouseButton1Click) end)
        end
        local selBtn = cardGui.main:FindFirstChild("Bottom") and cardGui.main.Bottom:FindFirstChild("Select")
        if selBtn then
            pcall(function() firesignal(selBtn.Activated) end)
            pcall(function() firesignal(selBtn.MouseButton1Click) end)
        end
        pcall(function()
            cardGui.Enabled = false
            local Loader = require(game.ReplicatedStorage.src.Loader)
            local GUIService = Loader.load_client_service(nil, "GUIService")
            if GUIService and GUIService.roguelike_select_ui then
                GUIService.roguelike_select_ui:hide()
            end
        end)
    end
end
local processEventMatchAutomation = function()
    if isLobby() then
        State.MatchStartTime = nil
        State.TakenCardsCount = nil
        State.AvoidedCardsCount = nil
        return
    end
    if not State.MatchStartTime then
        State.MatchStartTime = tick()
        State.TakenCardsCount = {}
        State.AvoidedCardsCount = {}
    end
    local now = tick()
    if Config.SummerLeaveLowLevel and (now - (State.LastLowLevelCheck or 0) > 3.0) then
        State.LastLowLevelCheck = now
        local lowCount = 0
        local thresh = Config.SummerLowLevelUnder or 10
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local lvl = 999
                pcall(function()
                    if p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Level") then
                        lvl = p.leaderstats.Level.Value
                    elseif p:FindFirstChild("_level") then
                        lvl = p._level.Value
                    end
                end)
                if lvl < thresh then
                    lowCount = lowCount + 1
                end
            end
        end
        if lowCount >= (Config.SummerLeaveWhenFound or 1) then
            pcall(function()
                TeleportService:Teleport(8304191830)
            end)
            return
        end
    end
    if Config.SummerLeaveFewPlayers and (now - State.MatchStartTime > 20) and (now - (State.LastFewPlayersCheck or 0) > 3.0) then
        State.LastFewPlayersCheck = now
        local totalPlayers = #Players:GetPlayers()
        if totalPlayers < (Config.SummerLeaveUnder or 5) then
            pcall(function()
                TeleportService:Teleport(8304191830)
            end)
            return
        end
    end
    if (Config.AutoPickCards or Config.BestForEventCurrency) and (now - (State.LastCardCheck or 0) > 0.3) then
        State.LastCardCheck = now
        if isRoguelikeChoiceActive() then
            pcall(pickBestRoguelikeCard)
        else
            State.LastVotedRoundChoice = nil
        end
    end
    if Config.AutoClaimMapBoard and (now - (State.LastMapBoardCheck or 0) > 5.0) then
        State.LastMapBoardCheck = now
        pcall(function()
            if Endpoints:FindFirstChild("claim_summer2_map_board_lines") then
                Endpoints.claim_summer2_map_board_lines:InvokeServer()
            end
        end)
    end
end
local buffLastCastSuccess = {}
local buffLastAttempt = {}
local buffRunning = true
getgenv().AJ_HUB_BUFF_STOP = function()
    buffRunning = false
end
local function getBuffCooldownDebuffPercent()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return 0 end
    local maxDebuff = 0
    local function parseText(str)
        if not str or str == "" then return end
        local n1 = string.match(str, "([%+%-]?%d+%.?%d*)%%%s*[Cc][Oo][Oo][Ll][Dd][Oo][Ww][Nn]")
        if n1 then
            local v = tonumber(n1)
            if v and v > maxDebuff then maxDebuff = v end
        end
        local n2 = string.match(str, "[Cc][Oo][Oo][Ll][Dd][Oo][Ww][Nn][%s%w]*:%s*([%+%-]?%d+%.?%d*)%%")
        if n2 then
            local v = tonumber(n2)
            if v and v > maxDebuff then maxDebuff = v end
        end
        local n3 = string.match(str, "[Cc][Oo][Oo][Ll][Dd][Oo][Ww][Nn][%s%w]*%s+([%+%-]?%d+%.?%d*)%%")
        if n3 then
            local v = tonumber(n3)
            if v and v > maxDebuff then maxDebuff = v end
        end
        local n4 = string.match(str, "([%+%-]?%d+%.?%d*)%%%s*[Cc][Dd]")
        if n4 then
            local v = tonumber(n4)
            if v and v > maxDebuff then maxDebuff = v end
        end
    end
    local gli = pg:FindFirstChild("GameLevelInfo")
    if gli then
        for _, desc in ipairs(gli:GetDescendants()) do
            if desc:IsA("TextLabel") then
                parseText(desc.Text)
            end
        end
    end
    if maxDebuff == 0 then
        local containers = {
            pg:FindFirstChild("GameLevel"),
            pg:FindFirstChild("LevelInfo"),
            pg:FindFirstChild("spawn_units"),
        }
        for _, c in ipairs(containers) do
            if c then
                for _, desc in ipairs(c:GetDescendants()) do
                    if desc:IsA("TextLabel") then
                        parseText(desc.Text)
                    end
                end
                if maxDebuff > 0 then break end
            end
        end
    end
    return maxDebuff
end
local function isMyBuffUnit(unit)
    if not unit or not unit.Parent then return false end
    local lp = LocalPlayer
    if not lp then return false end
    local tag = "player_units:" .. tostring(lp.UserId)
    if CollectionService:HasTag(unit, tag) then
        return true
    end
    local stats = unit:FindFirstChild("_stats")
    if stats then
        local pVal = stats:FindFirstChild("player")
        if pVal and pVal.Value then
            if pVal.Value == lp then return true end
            if typeof(pVal.Value) == "Instance" and pVal.Value:IsA("Player") and pVal.Value.Name == lp.Name then return true end
            if typeof(pVal.Value) == "string" and pVal.Value == lp.Name then return true end
        end
    end
    local owner = unit:GetAttribute("owner") or unit:GetAttribute("player") or unit:GetAttribute("owner_id")
    if owner and (owner == lp.UserId or owner == lp.Name) then
        return true
    end
    return false
end
local function getPlacedBuffUnits(unitKey)
    local results = {}
    local unitsFolder = Workspace:FindFirstChild("_UNITS")
    if not unitsFolder then
        return results
    end
    for _, unit in ipairs(unitsFolder:GetChildren()) do
        local stats = unit:FindFirstChild("_stats")
        if stats and stats:FindFirstChild("id") and string.find(string.lower(stats.id.Value), string.lower(unitKey)) then
            if isMyBuffUnit(unit) then
                table.insert(results, unit)
            end
        end
    end
    table.sort(results, function(a, b)
        local idA = a:GetAttribute("_SPAWN_UNIT_UUID") or 0
        local idB = b:GetAttribute("_SPAWN_UNIT_UUID") or 0
        if idA ~= idB then
            return idA < idB
        end
        return tostring(a) < tostring(b)
    end)
    return results
end
local function getBuffUnitEffectiveCooldown(unit)
    if not unit or not unit.Parent or not unit:FindFirstChild("_stats") then
        return 63.62
    end
    local stats = unit._stats
    local baseCd = stats:FindFirstChild("active_attack_cooldown") and stats.active_attack_cooldown.Value or 63.62
    local debuff = getBuffCooldownDebuffPercent()
    local mult = 1 + (math.max(debuff, 0) / 100)
    return math.max(baseCd, baseCd * mult)
end
local function getBuffUnitCooldownRemaining(unit)
    if not unit or not unit.Parent or not unit:FindFirstChild("_stats") then
        return 9999, false, 63.62
    end
    local stats = unit._stats
    local effectiveCd = getBuffUnitEffectiveCooldown(unit)
    local nowTick = tick()
    local lastLocal = buffLastCastSuccess[unit] or 0
    local remLocal = 0
    if lastLocal > 0 then
        remLocal = effectiveCd - (nowTick - lastLocal)
    end
    local lastStat = stats:FindFirstChild("last_active_cast") and stats.last_active_cast.Value or -100000000
    local remStat = 0
    if lastStat > 0 then
        remStat = effectiveCd - (nowTick - lastStat)
    end
    local remaining = math.max(remLocal, remStat)
    local isReady = remaining <= 0.05
    return math.max(remaining, 0), isReady, effectiveCd
end
local function canBuffUnitCast(unit)
    if not unit or not unit.Parent then return false, "no_unit" end
    local stats = unit:FindFirstChild("_stats")
    if not stats then return false, "no_stats" end
    local stunned = stats:FindFirstChild("unit_stunned") and stats.unit_stunned.Value or 0
    if stunned > 0 then return false, "stunned" end
    local frozen = stats:FindFirstChild("frozen") and stats.frozen.Value or false
    if frozen then return false, "frozen" end
    local using = stats:FindFirstChild("active_queued_or_using") and stats.active_queued_or_using.Value or false
    if using then return false, "using" end
    local rem, ready = getBuffUnitCooldownRemaining(unit)
    if not ready and rem > 0.1 then
        return false, "cooldown"
    end
    local lastTry = buffLastAttempt[unit] or 0
    if (tick() - lastTry) < 0.6 then
        return false, "throttled"
    end
    return true, "ready"
end
local function callBuffActiveAttack(unit)
    if not unit or not unit.Parent or not unit:FindFirstChild("_stats") then
        return false
    end
    buffLastAttempt[unit] = tick()
    local success = false
    local EndpointsClient = getEndpointsClient()
    if EndpointsClient and EndpointsClient.invoke_server then
        local ok, res = pcall(function()
            return EndpointsClient.invoke_server("use_active_attack", unit)
        end)
        if ok and (res == true or (res ~= false and res ~= nil and type(res) ~= "string")) then
            success = true
        end
    end
    if not success then
        if Endpoints:FindFirstChild("use_active_attack") then
            local ok, res = pcall(function()
                return Endpoints.use_active_attack:InvokeServer(unit)
            end)
            if ok and (res == true or (res ~= false and res ~= nil and type(res) ~= "string")) then
                success = true
            end
        end
    end
    if success then
        buffLastCastSuccess[unit] = tick()
    end
    return success
end
local function calculateBuffOffset(unit)
    local stats = unit and unit:FindFirstChild("_stats")
    local effectiveCd = getBuffUnitEffectiveCooldown(unit)
    local debuff = getBuffCooldownDebuffPercent()
    local baseSpa = stats and stats:FindFirstChild("attack_cooldown") and stats.attack_cooldown.Value or 15
    local spa = baseSpa * (1 + (math.max(debuff, 0) / 100))
    local sDigit = math.floor(spa % 10)
    local offset = (sDigit >= 3 and sDigit <= 8) and sDigit or 4
    if effectiveCd > 60 and (effectiveCd - 60 + 1) > offset then
        offset = effectiveCd - 60 + 1
    end
    return offset
end
local function waitBuffUntilReady(unit, maxWaitSec)
    local deadline = tick() + (maxWaitSec or 120)
    while buffRunning and tick() < deadline do
        if isLobby() then return false end
        if not unit or not unit.Parent then return false end
        local ok, reason = canBuffUnitCast(unit)
        if ok then
            return true
        end
        local rem = getBuffUnitCooldownRemaining(unit)
        task.wait(math.clamp(rem, 0.2, 0.6))
    end
    return false
end
local function castBuffSafely(unit, maxWaitSec)
    if not waitBuffUntilReady(unit, maxWaitSec) then
        return false
    end
    local deadline = tick() + 4
    while buffRunning and tick() < deadline do
        if isLobby() then return false end
        if not unit or not unit.Parent then return false end
        local ok = canBuffUnitCast(unit)
        if ok then
            if callBuffActiveAttack(unit) then
                return true
            end
        end
        task.wait(0.6)
    end
    return false
end
local startBuffMonitor = function(groupKey, isEnabledFn)
    task.spawn(function()
        local sessionThread
        local function stopSession()
            if sessionThread then
                pcall(task.cancel, sessionThread)
                sessionThread = nil
            end
        end
        while buffRunning do
            if isLobby() or not isEnabledFn() then
                stopSession()
                task.wait(1)
            else
                local units = getPlacedBuffUnits(groupKey)
                if #units < 4 then
                    stopSession()
                    task.wait(1)
                else
                    if not sessionThread or coroutine.status(sessionThread) == "dead" then
                        sessionThread = task.spawn(function()
                            while buffRunning do
                                if isLobby() or not isEnabledFn() then return end
                                local curUnits = getPlacedBuffUnits(groupKey)
                                if #curUnits < 4 then return end
                                local u1, u2, u3, u4 = curUnits[1], curUnits[2], curUnits[3], curUnits[4]
                                local _, ok1 = getBuffUnitCooldownRemaining(u1)
                                local _, ok2 = getBuffUnitCooldownRemaining(u2)
                                local _, ok3 = getBuffUnitCooldownRemaining(u3)
                                local _, ok4 = getBuffUnitCooldownRemaining(u4)
                                if ok1 and ok2 and ok3 and ok4 then
                                    break
                                end
                                task.wait(0.5)
                            end
                            while buffRunning do
                                if isLobby() or not isEnabledFn() then return end
                                local curUnits = getPlacedBuffUnits(groupKey)
                                if #curUnits < 4 then return end
                                local u1, u2, u3, u4 = curUnits[1], curUnits[2], curUnits[3], curUnits[4]
                                local offset = calculateBuffOffset(u1)
                                castBuffSafely(u1, 90)
                                local t1 = tick()
                                local waitU2 = math.max((t1 + offset) - tick(), 0)
                                if waitU2 > 0 then task.wait(waitU2) end
                                if not buffRunning or isLobby() or not isEnabledFn() then return end
                                castBuffSafely(u2, 20)
                                local t2 = tick()
                                local waitU3 = math.max((t1 + 30) - tick(), 0)
                                if waitU3 > 0 then task.wait(waitU3) end
                                if not buffRunning or isLobby() or not isEnabledFn() then return end
                                castBuffSafely(u3, 20)
                                local t3 = tick()
                                local waitU4 = math.max((t2 + 30) - tick(), 0)
                                if waitU4 > 0 then task.wait(waitU4) end
                                if not buffRunning or isLobby() or not isEnabledFn() then return end
                                castBuffSafely(u4, 20)
                                local t4 = tick()
                                local waitCycle = math.max((t3 + 30) - tick(), 0)
                                if waitCycle > 0 then
                                    task.wait(waitCycle)
                                end
                            end
                        end)
                    else
                        local curUnits = getPlacedBuffUnits(groupKey)
                        if #curUnits < 4 then
                            stopSession()
                        end
                        task.wait(0.5)
                    end
                end
            end
        end
        stopSession()
    end)
end
startBuffMonitor("wendy", function() return Config.AutoBuffWendy end)
startBuffMonitor("erwin", function() return Config.AutoBuffCommander end)
local shadowgirlLoopRunning = true
local shadowgirlLastCastTime = {}
local function getPlacedShadowgirls()
    local results = {}
    local unitsFolder = Workspace:FindFirstChild("_UNITS")
    if not unitsFolder then return results end
    for _, unit in ipairs(unitsFolder:GetChildren()) do
        if isShadowgirlUnit(unit) and isMyBuffUnit(unit) then
            local stats = unit:FindFirstChild("_stats")
            local activeAtk = stats and stats:FindFirstChild("active_attack") and stats.active_attack.Value
            if activeAtk and activeAtk ~= "" and activeAtk ~= "nil" then
                table.insert(results, unit)
            end
        end
    end
    table.sort(results, function(a, b)
        local idA = a:GetAttribute("_SPAWN_UNIT_UUID") or 0
        local idB = b:GetAttribute("_SPAWN_UNIT_UUID") or 0
        if idA ~= idB then
            return idA < idB
        end
        return tostring(a) < tostring(b)
    end)
    return results
end
local function getHomuraTimestopDuration(unit)
    if not unit or not unit.Parent then return 5.0 end
    local stats = unit:FindFirstChild("_stats")
    local upg = stats and stats:FindFirstChild("upgrade") and stats.upgrade.Value or 0
    return (upg >= 7) and 5.0 or 4.0
end
local function getHomuraRemainingCooldown(unit)
    if not unit or not unit.Parent then return 9999 end
    local stats = unit:FindFirstChild("_stats")
    if not stats then return 9999 end
    local cd = stats:FindFirstChild("active_attack_cooldown") and stats.active_attack_cooldown.Value or 15
    local debuff = getBuffCooldownDebuffPercent and getBuffCooldownDebuffPercent() or 0
    local effectiveCd = math.max(cd, cd * (1 + (math.max(debuff, 0) / 100)))
    local lastCast = stats:FindFirstChild("last_active_cast") and stats.last_active_cast.Value or -100000000
    local localLast = shadowgirlLastCastTime[unit] or 0
    local effectiveLast = math.max(lastCast, localLast)
    local nowTick = tick()
    if effectiveLast > 0 then
        return math.max(0, effectiveCd - (nowTick - effectiveLast))
    end
    return 0
end
local function canHomuraCast(unit)
    if not unit or not unit.Parent then return false, "no_unit" end
    local stats = unit:FindFirstChild("_stats")
    if not stats then return false, "no_stats" end
    local activeAtk = stats:FindFirstChild("active_attack") and stats.active_attack.Value
    if not activeAtk or activeAtk == "" or activeAtk == "nil" then return false, "no_active" end
    local stunned = stats:FindFirstChild("unit_stunned") and stats.unit_stunned.Value or 0
    if stunned > 0 then return false, "stunned" end
    local frozen = stats:FindFirstChild("frozen") and stats.frozen.Value or false
    if frozen then return false, "frozen" end
    local using = stats:FindFirstChild("active_queued_or_using") and stats.active_queued_or_using.Value or false
    if using then return false, "using" end
    local rem = getHomuraRemainingCooldown(unit)
    if rem > 0.08 then
        return false, "cooldown"
    end
    return true, "ready"
end
local function callHomuraActiveAttack(unit)
    if not unit or not unit.Parent or not unit:FindFirstChild("_stats") then return false end
    local success = false
    local EndpointsClient = getEndpointsClient and getEndpointsClient()
    if EndpointsClient and EndpointsClient.invoke_server then
        local ok, res = pcall(function()
            return EndpointsClient.invoke_server("use_active_attack", unit)
        end)
        if ok and (res == true or (res ~= false and res ~= nil and type(res) ~= "string")) then
            success = true
        end
    end
    if not success and Endpoints:FindFirstChild("use_active_attack") then
        local ok, res = pcall(function()
            return Endpoints.use_active_attack:InvokeServer(unit)
        end)
        if ok and (res == true or (res ~= false and res ~= nil and type(res) ~= "string")) then
            success = true
        end
    end
    if success then
        shadowgirlLastCastTime[unit] = tick()
    end
    return success
end
local function isShadowgirlIdealLoopEnabled()
    if not Config.UnitCustomSettings then return false end
    local equipped = getEquippedUnits(false)
    for _, eq in ipairs(equipped) do
        if isShadowgirlUnit(eq) then
            local custom = Config.UnitCustomSettings[eq.slot]
            if custom and (custom.IdealLoop == true or custom.Ability == "Ideal Loop") then
                return true
            end
        end
    end
    for s = 1, 6 do
        local custom = Config.UnitCustomSettings[s]
        if custom and (custom.IdealLoop == true or custom.Ability == "Ideal Loop") then
            return true
        end
    end
    return false
end
local function startShadowgirlLoop()
    task.spawn(function()
        while shadowgirlLoopRunning do
            if isLobby() or not isShadowgirlIdealLoopEnabled() then
                task.wait(0.5)
            else
                local units = getPlacedShadowgirls()
                if #units == 0 then
                    task.wait(0.4)
                else
                    local now = tick()
                    local activeTimestopEnd = 0
                    for _, u in ipairs(units) do
                        local stats = u:FindFirstChild("_stats")
                        local lastCast = stats and stats:FindFirstChild("last_active_cast") and stats.last_active_cast.Value or 0
                        local localLast = shadowgirlLastCastTime[u] or 0
                        local effectiveLast = math.max(lastCast, localLast)
                        if effectiveLast > 0 then
                            local dur = getHomuraTimestopDuration(u)
                            local endTime = effectiveLast + dur
                            if endTime > activeTimestopEnd then
                                activeTimestopEnd = endTime
                            end
                        end
                    end
                    local timeRemaining = activeTimestopEnd - now
                    if timeRemaining > 0.08 then
                        task.wait(math.clamp(timeRemaining - 0.08, 0.03, 0.8))
                    else
                        local candidate = nil
                        local candidateLastCast = math.huge
                        for _, u in ipairs(units) do
                            if canHomuraCast(u) then
                                local stats = u._stats
                                local lastCast = stats:FindFirstChild("last_active_cast") and stats.last_active_cast.Value or -100000000
                                local localLast = shadowgirlLastCastTime[u] or 0
                                local effectiveLast = math.max(lastCast, localLast)
                                if effectiveLast < candidateLastCast then
                                    candidate = u
                                    candidateLastCast = effectiveLast
                                end
                            end
                        end
                        if candidate then
                            local ok = callHomuraActiveAttack(candidate)
                            if ok then
                                task.wait(0.2)
                            else
                                task.wait(0.1)
                            end
                        else
                            local minCdWait = 9999
                            for _, u in ipairs(units) do
                                local rem = getHomuraRemainingCooldown(u)
                                if rem < minCdWait then
                                    minCdWait = rem
                                end
                            end
                            task.wait(math.clamp(minCdWait, 0.05, 0.4))
                        end
                    end
                end
            end
        end
    end)
end
startShadowgirlLoop()
if getgenv().AJ_HUB_HEARTBEAT then
    pcall(function() getgenv().AJ_HUB_HEARTBEAT:Disconnect() end)
    getgenv().AJ_HUB_HEARTBEAT = nil
end
local _lastTickTime = 0
getgenv().AJ_HUB_HEARTBEAT = RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - _lastTickTime < 0.08 then return end
    _lastTickTime = now
    if isLobby() then
        local folder = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
        if folder then folder:Destroy() end
        local ghostFolder = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
        if ghostFolder then ghostFolder:Destroy() end
        local markerFolder = Camera:FindFirstChild("_AJ_HUB_PlacementMarker") or Workspace:FindFirstChild("_AJ_HUB_PlacementMarker")
        if markerFolder then markerFolder:Destroy() end
        local hover = Camera:FindFirstChild("_AJ_HUB_HoverMarker")
        if hover then hover:Destroy() end
        State.CurrentMapKey = nil
        State.CurrentMapName = nil
        State.CurrentMapData = nil
        State.AntiPunishIdx = nil
        State.AntiPunishWalking = false
        State.PlayerAnchors = nil
        State.StickClusterCenter = nil
        State.GriffinBuffCompleted = false
        if State.PickingPlacementArea then
            State.PickingPlacementArea = false
            if State.PlacementPickConn then
                State.PlacementPickConn:Disconnect()
                State.PlacementPickConn = nil
            end
        end
        processAntiPunishment()
        if processAutoEquipPreset() then return end
        processLobbyAutomation()
        processEventLobbyAutomation()
        return
    end
    processAutoEquipPreset()
    if State.processAutoGriffith then State.processAutoGriffith() end
    processAutoPlace()
    processAutoUpgrade()
    processAutoAbilities()
    processUnitTargeting()
    processAntiPunishment()
    processAutoSkip()
    processAutoStart()
    processMatchAutomation()
    processEventMatchAutomation()
end)
task.spawn(function()
    task.wait(0.5)
    if not isLobby() then
        computeCompactGrid()
        if Config.ShowPlaceArea then
            renderVisualGrid()
        end
    end
end)
local function applyAJGradient(inst, rot)
    if not inst then return end
    local g = inst:FindFirstChild("AJGradient") or Instance.new("UIGradient")
    g.Name = "AJGradient"
    g.Color = ColorSequence.new(Color3.fromRGB(183, 176, 205), Color3.fromRGB(213, 199, 183))
    g.Rotation = rot or 0
    g.Parent = inst
    return g
end
local function showDiscordPrompt(window)
    if Config.DontShowDiscordPrompt then
        return
    end
    local coreGui = nil
    pcall(function()
        coreGui = game:GetService("CoreGui")
    end)
    local safeParent = getSafeGuiParent()
    local prevPrompt = (safeParent and safeParent:FindFirstChild("AJ_HUB_DiscordPrompt"))
        or (coreGui and coreGui:FindFirstChild("AJ_HUB_DiscordPrompt"))
    if prevPrompt then
        prevPrompt:Destroy()
    end
    local isPromptOpen = true
    if window and window.toggle_menu then
        window.toggle_menu(false)
    end
    if library and library.items then
        library.items.Enabled = false
    end
    local origToggleMenu = window and window.toggle_menu
    if origToggleMenu then
        window.toggle_menu = function(bool)
            if isPromptOpen then
                return
            end
            return origToggleMenu(bool)
        end
    end
    local function setMainWindowVisible(v)
        pcall(function()
            if library and library.other then
                library.other.Enabled = false
            end
            if library and library.items then
                library.items.Enabled = v
                for _, d in ipairs(library.items:GetChildren()) do
                    if d:IsA("Frame") and (d.Size.X.Offset >= 400 or d:FindFirstChild("AJMobileScale")) then
                        d.Visible = v
                    end
                end
            end
        end)
        pcall(function()
            local roots = {}
            if coreGui then table.insert(roots, coreGui) end
            if safeParent and safeParent ~= coreGui then table.insert(roots, safeParent) end
            for _, root in ipairs(roots) do
                for _, g in ipairs(root:GetChildren()) do
                    if g:IsA("ScreenGui") and g.Name == "AJ_HUB_SCREEN_GUI" then
                        g.Enabled = v
                        for _, d in ipairs(g:GetChildren()) do
                            if d:IsA("Frame") and (d.Size.X.Offset >= 400 or d:FindFirstChild("AJMobileScale")) then
                                d.Visible = v
                            end
                        end
                    elseif g:IsA("ScreenGui") and g.Name == "AJ_HUB_OTHER_GUI" then
                        g.Enabled = false
                    end
                end
            end
        end)
    end
    setMainWindowVisible(false)
    task.spawn(function()
        while isPromptOpen do
            setMainWindowVisible(false)
            task.wait(0.08)
        end
    end)
    local discordUrl = "https://discord.gg/jtr4YAy4G9"
    local dontShowAgain = false
    local function copyDiscord()
        pcall(function()
            if setclipboard then
                setclipboard(discordUrl)
            elseif toclipboard then
                toclipboard(discordUrl)
            end
        end)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AJ HUB | Discord",
                Text = "Discord link copied to clipboard!",
                Duration = 4
            })
        end)
        if not UserInputService.TouchEnabled then
            pcall(function()
                local req = request or http_request or (syn and syn.request)
                if req then
                    req({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                        Body = game:GetService("HttpService"):JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = {code = "jtr4YAy4G9"},
                            nonce = game:GetService("HttpService"):GenerateGUID(false)
                        })
                    })
                end
            end)
        end
    end
    copyDiscord()
    local gui = Instance.new("ScreenGui")
    gui.Name = "AJ_HUB_DiscordPrompt"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if safeParent then
            gui.Parent = safeParent
        elseif syn and syn.protect_gui and coreGui then
            syn.protect_gui(gui)
            gui.Parent = coreGui
        elseif coreGui then
            gui.Parent = coreGui
        end
    end)
    if not gui.Parent and safeParent then gui.Parent = safeParent end

    local overlay = Instance.new("Frame")
    overlay.Position = UDim2.new(0, 0, 0, -60)
    overlay.Size = UDim2.new(1, 0, 1, 120)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.Parent = gui

    local vp = getViewportSize()
    local promptW = math.min(420, math.max(280, vp.X - 32))
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, promptW, 0, 245)
    container.Position = UDim2.new(0.5, -math.floor(promptW * 0.5), 0.5, -122)
    container.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    container.BorderSizePixel = 0
    container.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(183, 176, 205)
    stroke.Transparency = 0.35
    stroke.Parent = container

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.new(0, 20, 0, 16)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "AJ HUB"
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = container

    local titleGrad = Instance.new("UIGradient")
    titleGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(183, 176, 205)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(213, 199, 183))
    }
    titleGrad.Parent = title

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, -40, 0, 36)
    subTitle.Position = UDim2.new(0, 20, 0, 46)
    subTitle.BackgroundTransparency = 1
    subTitle.Font = Enum.Font.GothamMedium
    subTitle.Text = "Join our official Discord for updates, configs & support!\nLink has been copied to your clipboard."
    subTitle.TextSize = 13
    subTitle.TextColor3 = Color3.fromRGB(180, 180, 195)
    subTitle.TextWrapped = true
    subTitle.TextXAlignment = Enum.TextXAlignment.Center
    subTitle.Parent = container

    local linkBox = Instance.new("Frame")
    linkBox.Size = UDim2.new(1, -40, 0, 32)
    linkBox.Position = UDim2.new(0, 20, 0, 90)
    linkBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    linkBox.BorderSizePixel = 0
    linkBox.Parent = container

    local linkCorner = Instance.new("UICorner")
    linkCorner.CornerRadius = UDim.new(0, 6)
    linkCorner.Parent = linkBox

    local linkLabel = Instance.new("TextLabel")
    linkLabel.Size = UDim2.new(1, -16, 1, 0)
    linkLabel.Position = UDim2.new(0, 8, 0, 0)
    linkLabel.BackgroundTransparency = 1
    linkLabel.Font = Enum.Font.Code
    linkLabel.Text = discordUrl
    linkLabel.TextSize = 13
    linkLabel.TextColor3 = Color3.fromRGB(183, 176, 205)
    linkLabel.TextXAlignment = Enum.TextXAlignment.Center
    linkLabel.Parent = linkBox

    local checkRow = Instance.new("Frame")
    checkRow.Size = UDim2.new(1, -40, 0, 22)
    checkRow.Position = UDim2.new(0, 20, 0, 132)
    checkRow.BackgroundTransparency = 1
    checkRow.Parent = container

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0, 18, 0, 18)
    checkBtn.Position = UDim2.new(0, 2, 0, 2)
    checkBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    checkBtn.BorderSizePixel = 0
    checkBtn.Text = ""
    checkBtn.AutoButtonColor = false
    checkBtn.Parent = checkRow

    local cbCorner = Instance.new("UICorner")
    cbCorner.CornerRadius = UDim.new(0, 4)
    cbCorner.Parent = checkBtn

    local cbStroke = Instance.new("UIStroke")
    cbStroke.Thickness = 1
    cbStroke.Color = Color3.fromRGB(183, 176, 205)
    cbStroke.Transparency = 0.4
    cbStroke.Parent = checkBtn

    local cbIcon = Instance.new("TextLabel")
    cbIcon.Size = UDim2.new(1, 0, 1, 0)
    cbIcon.BackgroundTransparency = 1
    cbIcon.Font = Enum.Font.GothamBold
    cbIcon.Text = "X"
    cbIcon.TextSize = 13
    cbIcon.TextColor3 = Color3.fromRGB(183, 176, 205)
    cbIcon.Visible = false
    cbIcon.Parent = checkBtn

    local checkLabel = Instance.new("TextButton")
    checkLabel.Size = UDim2.new(1, -28, 1, 0)
    checkLabel.Position = UDim2.new(0, 28, 0, 0)
    checkLabel.BackgroundTransparency = 1
    checkLabel.Font = Enum.Font.Gotham
    checkLabel.Text = "Don't show this again"
    checkLabel.TextSize = 12
    checkLabel.TextColor3 = Color3.fromRGB(175, 175, 190)
    checkLabel.TextXAlignment = Enum.TextXAlignment.Left
    checkLabel.Parent = checkRow

    local function toggleCheck()
        dontShowAgain = not dontShowAgain
        cbIcon.Visible = dontShowAgain
        if dontShowAgain then
            checkBtn.BackgroundColor3 = Color3.fromRGB(40, 36, 50)
        else
            checkBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        end
    end
    checkBtn.MouseButton1Click:Connect(toggleCheck)
    checkLabel.MouseButton1Click:Connect(toggleCheck)

    local btnJoin = Instance.new("TextButton")
    btnJoin.Size = UDim2.new(0.5, -25, 0, 34)
    btnJoin.Position = UDim2.new(0, 20, 0, 168)
    btnJoin.BackgroundColor3 = Color3.fromRGB(183, 176, 205)
    btnJoin.Font = Enum.Font.GothamBold
    btnJoin.Text = "Join Discord"
    btnJoin.TextSize = 13
    btnJoin.TextColor3 = Color3.fromRGB(15, 15, 20)
    btnJoin.AutoButtonColor = true
    btnJoin.Parent = container

    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = btnJoin

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(183, 176, 205)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(213, 199, 183))
    }
    btnGrad.Parent = btnJoin

    local btnClose = Instance.new("TextButton")
    btnClose.Size = UDim2.new(0.5, -25, 0, 34)
    btnClose.Position = UDim2.new(0.5, 5, 0, 168)
    btnClose.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    btnClose.Font = Enum.Font.GothamBold
    btnClose.Text = "Continue"
    btnClose.TextSize = 13
    btnClose.TextColor3 = Color3.fromRGB(200, 200, 215)
    btnClose.AutoButtonColor = true
    btnClose.Parent = container

    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btnClose

    local function dismiss()
        isPromptOpen = false
        if dontShowAgain then
            Config.DontShowDiscordPrompt = true
            saveConfigToFile()
            triggerAutoSave()
        end
        game:GetService("TweenService"):Create(overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        local tw = game:GetService("TweenService"):Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -210, 0.5, -75), BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function()
            gui:Destroy()
            task.wait(0.05)
            if origToggleMenu and window then
                window.toggle_menu = origToggleMenu
            end
            if window and window.toggle_menu then
                window.toggle_menu(true)
            end
            if library and library.items then
                library.items.Enabled = true
            end
            setMainWindowVisible(true)
        end)
    end

    btnJoin.MouseButton1Click:Connect(function()
        copyDiscord()
        btnJoin.Text = "Copied!"
        task.delay(0.9, function()
            dismiss()
        end)
    end)

    btnClose.MouseButton1Click:Connect(function()
        dismiss()
    end)
end
local window = library:window({
    name = "AJ HUB",
    suffix = "",
    gameInfo = "Anime Adventures",
    size = UDim2.new(0, 760, 0, 560),
})
State.HubWindow = window
pcall(function()
    if library and library.items then
        library.items.Name = "AJ_HUB_SCREEN_GUI"
        library.items:SetAttribute("AJ_HUB", true)
    end
    if library and library.other then
        library.other.Name = "AJ_HUB_OTHER_GUI"
        library.other:SetAttribute("AJ_HUB", true)
    end
    getgenv().AJ_HUB_LIBRARY = library
    getgenv().AJ_HUB_CLEANUP = function()
        pcall(function()
            if library and library._mobileToggleGui then
                pcall(function() library._mobileToggleGui:Destroy() end)
                library._mobileToggleGui = nil
            end
            if library and library.unload_menu then
                library:unload_menu()
            else
                if library and library.items then library.items:Destroy() end
                if library and library.other then library.other:Destroy() end
            end
        end)
    end
    getgenv().AJ_HUB_LOADED = true
end)
showDiscordPrompt(window)
pcall(function()
    local parentGui = getSafeGuiParent()
    if not parentGui then return end
    local oldBtnGui = parentGui:FindFirstChild("AJ_HUB_MobileToggle")
    if oldBtnGui then oldBtnGui:Destroy() end
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "AJ_HUB_MobileToggle"
    toggleGui.ResetOnSpawn = false
    toggleGui.IgnoreGuiInset = true
    pcall(function()
        toggleGui.ScreenInsets = Enum.ScreenInsets.None
    end)
    toggleGui.DisplayOrder = 999990
    toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    toggleGui:SetAttribute("AJ_HUB", true)
    toggleGui.Parent = parentGui
    library._mobileToggleGui = toggleGui

    local btnSize = UserInputService.TouchEnabled and 48 or 44
    local pill = Instance.new("TextButton")
    pill.Name = "ToggleButton"
    pill.Size = UDim2.new(0, btnSize, 0, btnSize)
    pill.Position = UDim2.new(0, 145, 0, 10)
    pill.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    pill.BackgroundTransparency = 0.08
    pill.BorderSizePixel = 0
    pill.Text = "AJ"
    pill.Font = Enum.Font.GothamBold
    pill.TextSize = 14
    pill.TextColor3 = Color3.fromRGB(255, 255, 255)
    pill.AutoButtonColor = true
    pill.ClipsDescendants = true
    pill.Parent = toggleGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = pill

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.4
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = pill

    applyAJGradient(stroke, 45)

    local iconImg = Instance.new("ImageLabel")
    iconImg.Name = "Icon"
    iconImg.Size = UDim2.new(1, -6, 1, -6)
    iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
    iconImg.BackgroundTransparency = 1
    iconImg.ScaleType = Enum.ScaleType.Fit
    iconImg.Visible = false
    iconImg.Parent = pill

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = iconImg

    local TOGGLE_ICON_URL = "https://cdn.discordapp.com/attachments/1509934485288911011/1568306230647066634/image.png?ex=6af5453f&is=6af3f3bf&hm=028654e7a3f0337a9978c4be46ea090df1c53b15a3662b70648408926f068bf1&"
    local TOGGLE_ICON_PATH = "AJ_HUB/toggle_icon.png"
    local getAssetFn = getcustomasset or getsynasset
    local function applyIconFromDisk()
        if not getAssetFn or not isfile or not isfile(TOGGLE_ICON_PATH) then return false end
        local okAsset, assetId = pcall(getAssetFn, TOGGLE_ICON_PATH)
        if okAsset and type(assetId) == "string" and #assetId > 0 then
            iconImg.Image = assetId
            iconImg.Visible = true
            pill.Text = ""
            return true
        end
        return false
    end
    if not applyIconFromDisk() then
        task.spawn(function()
            local okGet, body = pcall(function()
                return game:HttpGet(TOGGLE_ICON_URL)
            end)
            if okGet and type(body) == "string" and #body > 100 and writefile then
                pcall(function()
                    if makefolder and isfolder and not isfolder("AJ_HUB") then
                        makefolder("AJ_HUB")
                    end
                    writefile(TOGGLE_ICON_PATH, body)
                end)
                if iconImg and iconImg.Parent then
                    applyIconFromDisk()
                end
            end
        end)
    end

    local dragging = false
    local moved = false
    local activeInput = nil
    local startPos = pill.Position
    local startMouse = Vector3.new()
    pill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            moved = false
            activeInput = input
            startMouse = input.Position
            startPos = pill.Position
        end
    end)
    library:connection(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if activeInput and activeInput.UserInputType == Enum.UserInputType.Touch then
            if input ~= activeInput and input.UserInputType ~= Enum.UserInputType.Touch then return end
        elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end
        local dx = input.Position.X - startMouse.X
        local dy = input.Position.Y - startMouse.Y
        if (dx * dx + dy * dy) > 64 then
            moved = true
        end
        if moved then
            local vp = getViewportSize()
            local nx = math.clamp(pill.Parent and (startPos.X.Scale * vp.X + startPos.X.Offset + dx) or 14, 4, math.max(4, vp.X - btnSize - 4))
            local ny = math.clamp(pill.Parent and (startPos.Y.Scale * vp.Y + startPos.Y.Offset + dy) or 100, 36, math.max(36, vp.Y - btnSize - 4))
            pill.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
    library:connection(UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input == activeInput or input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local wasTap = not moved
            dragging = false
            activeInput = nil
            if wasTap and window and window.toggle_menu then
                local nextState = not (library and library.items and library.items.Enabled)
                window.toggle_menu(nextState)
            end
        end
    end)
end)
task.spawn(function()
    for _ = 1, 15 do
        task.wait(0.2)
        updateSidebarIcons()
    end
end)
pcall(function()
    if library and library.update_theme then
        local accentCol = (Config.MenuAccent and Color3.fromRGB(Config.MenuAccent.R, Config.MenuAccent.G, Config.MenuAccent.B)) or Color3.fromRGB(183, 176, 205)
        library:update_theme("accent", accentCol)
    end
end)
pcall(function()
    if library and library.items then
        for _, d in ipairs(library.items:GetDescendants()) do
            if d:IsA("TextLabel") then
                if d.Text:find("32 days left") then
                    d.Visible = false
                    d.Text = ""
                elseif d.Text:find("Counter%-Strike") or d.Text:find("Milenium") then
                    d.Text = "AJ HUB"
                elseif d.Text:find("Automation") then
                    d.Text = d.Text:gsub("%s*Automation%s*", "")
                end
                if d.Text:find("AJ HUB") then
                    d.TextColor3 = Color3.fromRGB(255, 255, 255)
                    applyAJGradient(d, 0)
                end
            end
        end
    end
end)
window:seperator({name = "Modules"})
local story_tab, modes_tab = window:tab({
    name = "Main",
    icon = "rbxassetid://7072718631",
    tabs = {"Story & Stages", "Raids & Challenges"}
})
do
    local col1 = story_tab:column({size = 1})
    local col2 = story_tab:column({size = 1})
    local sec_story = col1:section({name = "Story", icon = "rbxassetid://7072706263", default = true, size = 0.63})
    sec_story:dropdown({
        name = "World",
        items = {
            "Planet Greenie", "Walled City", "Snowy Town", "Sand Village",
            "Navy Bay", "Fiend City", "Spirit World", "Ant Kingdom",
            "Magic Town", "Haunted Academy", "Magic Hills", "Space Center",
            "Alien Spaceship", "Fabled Kingdom", "Ruined City", "Puppet Island",
            "Virtual Dungeon", "Snowy Kingdom", "Dungeon Throne", "Mountain Temple",
            "Rain Village", "Shibuya District"
        },
        default = Config.StoryWorld,
        width = 160,
        callback = function(val)
            Config.StoryWorld = val
            syncWithXTHub()
        end
    })
    sec_story:dropdown({
        name = "Act",
        items = {"Act 1", "Act 2", "Act 3", "Act 4", "Act 5", "Act 6", "Infinite"},
        default = Config.StoryAct,
        width = 160,
        callback = function(val)
            Config.StoryAct = val
            syncWithXTHub()
        end
    })
    sec_story:dropdown({
        name = "Difficulty",
        items = {"Normal", "Hard"},
        default = Config.StoryDifficulty,
        width = 160,
        callback = function(val)
            Config.StoryDifficulty = val
            syncWithXTHub()
        end
    })
    sec_story:toggle({
        name = "Friends Only",
        type = "toggle",
        default = Config.StoryFriendsOnly,
        callback = function(val)
            Config.StoryFriendsOnly = val
            syncWithXTHub()
        end
    })
    sec_story:toggle({
        name = "Auto Join",
        type = "toggle",
        default = Config.AutoJoinStory,
        callback = function(val)
            setExclusiveAutoJoin("AutoJoinStory", val)
        end
    })
    sec_story:toggle({
        name = "Auto Find Match",
        type = "toggle",
        default = Config.AutoFindMatchStory,
        callback = function(val)
            setExclusiveAutoJoin("AutoFindMatchStory", val)
            if not val then checkCancelMatchmaking() end
        end
    })
    local sec_last = col1:section({name = "Join Last Act", icon = "rbxassetid://7072719750", default = true, size = 0.37})
    sec_last:toggle({
        name = "Join Last Act",
        type = "toggle",
        default = Config.JoinLastAct,
        callback = function(val)
            setExclusiveAutoJoin("JoinLastAct", val)
        end
    })
    sec_last:toggle({
        name = "World Skip",
        type = "toggle",
        default = Config.WorldSkip,
        callback = function(val)
            Config.WorldSkip = val
            syncWithXTHub()
        end
    })
    local sec_legend = col2:section({name = "Legend Stage", icon = "rbxassetid://7072716549", default = true, size = 0.48})
    sec_legend:dropdown({
        name = "Stage",
        items = {
            "Magic Hills (Elf Invasion)",
            "Spirit Invasion",
            "Space Center",
            "Fabled Kingdom (Generals)",
            "Ruined City (Midnight)",
            "Virtual Dungeon (Bosses)",
            "Dungeon Throne",
            "Rain Village"
        },
        default = Config.LegendStage,
        width = 160,
        callback = function(val)
            Config.LegendStage = val
            syncWithXTHub()
        end
    })
    sec_legend:dropdown({
        name = "Act",
        items = {"Act 1", "Act 2", "Act 3"},
        default = Config.LegendAct,
        width = 160,
        callback = function(val)
            Config.LegendAct = val
            syncWithXTHub()
        end
    })
    sec_legend:toggle({
        name = "Auto Join Legend",
        type = "toggle",
        default = Config.AutoJoinLegend,
        callback = function(val)
            Config.AutoJoinLegend = val
            syncWithXTHub()
        end
    })
    sec_legend:toggle({
        name = "Auto Find Match",
        type = "toggle",
        default = Config.AutoFindMatchLegend,
        callback = function(val)
            Config.AutoFindMatchLegend = val
            syncWithXTHub()
            if not val then checkCancelMatchmaking() end
        end
    })
    local sec_mansion = col2:section({name = "Infinity Mansion", icon = "rbxassetid://7072706318", default = true, size = 0.52})
    sec_mansion:slider({
        name = "Room",
        min = 1,
        max = 150,
        interval = 1,
        default = Config.MansionRoom,
        callback = function(val)
            Config.MansionRoom = val
            syncWithXTHub()
        end
    })
    sec_mansion:dropdown({
        name = "Difficulty",
        items = {"Hard", "Normal"},
        default = Config.MansionDifficulty,
        width = 160,
        callback = function(val)
            Config.MansionDifficulty = val
            syncWithXTHub()
        end
    })
    sec_mansion:toggle({
        name = "Auto Join Infinity Mansion",
        type = "toggle",
        default = Config.AutoJoinMansion,
        callback = function(val)
            Config.AutoJoinMansion = val
            syncWithXTHub()
        end
    })
    sec_mansion:toggle({
        name = "Join Last Room",
        type = "toggle",
        default = Config.JoinLastMansionRoom,
        callback = function(val)
            Config.JoinLastMansionRoom = val
            syncWithXTHub()
        end
    })
    sec_mansion:toggle({
        name = "Auto Find Match",
        type = "toggle",
        default = Config.AutoFindMatchMansion,
        callback = function(val)
            Config.AutoFindMatchMansion = val
            syncWithXTHub()
            if not val then checkCancelMatchmaking() end
        end
    })
end
do
    local col1 = modes_tab:column({size = 1})
    local col2 = modes_tab:column({size = 1})
    local sec_raid = col1:section({name = "Raid", icon = "rbxassetid://7072723337", default = true, size = 0.52})
    sec_raid:dropdown({
        name = "Raid",
        items = {
            "Current Raid",
            "Nightmare Train",
            "Walled City",
            "Sand Village",
            "Future City",
            "Future City (Tyrant's Invasion)",
            "Cursed Festival",
            "Sacred Planet",
            "Strange Town",
            "Storm Hideout",
            "Ant Kingdom (Midnight)",
            "Ruined City (The Menace)"
        },
        default = Config.RaidWorld,
        width = 160,
        callback = function(val)
            Config.RaidWorld = val
            syncWithXTHub()
        end
    })
    sec_raid:dropdown({
        name = "Act",
        items = {"Act 1", "Act 2", "Act 3", "Act 4", "Act 5"},
        default = Config.RaidAct,
        width = 160,
        callback = function(val)
            Config.RaidAct = val
            syncWithXTHub()
        end
    })
    sec_raid:toggle({
        name = "Auto Join Raid",
        type = "toggle",
        default = Config.AutoJoinRaid,
        callback = function(val)
            Config.AutoJoinRaid = val
            syncWithXTHub()
        end
    })
    sec_raid:toggle({
        name = "Auto Find Match",
        type = "toggle",
        default = Config.AutoFindMatchRaid,
        callback = function(val)
            Config.AutoFindMatchRaid = val
            syncWithXTHub()
            if not val then checkCancelMatchmaking() end
        end
    })
    local sec_artifact = col1:section({name = "Artifact Stage", icon = "rbxassetid://7072723006", default = true, size = 0.48})
    sec_artifact:dropdown({
        name = "Join With",
        items = {"Find Match", "Own Room"},
        default = Config.ArtifactJoinMode,
        width = 160,
        callback = function(val)
            Config.ArtifactJoinMode = val
            syncWithXTHub()
        end
    })
    sec_artifact:toggle({
        name = "Auto Join Artifact Stage",
        type = "toggle",
        default = Config.AutoJoinArtifact,
        callback = function(val)
            Config.AutoJoinArtifact = val
            syncWithXTHub()
            if not val then checkCancelMatchmaking() end
        end
    })
    sec_artifact:toggle({
        name = "Auto Claim Clear Rewards",
        type = "toggle",
        default = Config.AutoClaimArtifactRewards,
        callback = function(val)
            Config.AutoClaimArtifactRewards = val
            syncWithXTHub()
        end
    })
    local sec_chal = col2:section({name = "Challenge", icon = "rbxassetid://7072705696", default = true, size = 1.0})
    sec_chal:dropdown({
        name = "Rewards",
        items = {"All / Any", "Gems", "Star Remnants", "Trait Rerolls", "Stat Rerolls", "Gold"},
        default = Config.ChallengeRewardFilter,
        width = 160,
        callback = function(val)
            Config.ChallengeRewardFilter = val
            syncWithXTHub()
        end
    })
    sec_chal:toggle({
        name = "Auto Join Challenge",
        type = "toggle",
        default = Config.AutoJoinChallenge,
        callback = function(val)
            setExclusiveAutoJoin("AutoJoinChallenge", val)
        end
    })
    sec_chal:toggle({
        name = "Auto Find Match Challenge",
        type = "toggle",
        default = Config.AutoFindMatchChallenge,
        callback = function(val)
            setExclusiveAutoJoin("AutoFindMatchChallenge", val)
            if not val then checkCancelMatchmaking() end
        end
    })
    sec_chal:toggle({
        name = "Auto Join Daily Challenge",
        type = "toggle",
        default = Config.AutoJoinDailyChallenge,
        callback = function(val)
            setExclusiveAutoJoin("AutoJoinDailyChallenge", val)
        end
    })
    sec_chal:toggle({
        name = "Auto Find Match Daily Challenge",
        type = "toggle",
        default = Config.AutoFindMatchDailyChallenge,
        callback = function(val)
            setExclusiveAutoJoin("AutoFindMatchDailyChallenge", val)
            if not val then checkCancelMatchmaking() end
        end
    })
end
local auto_play_tab, unit_settings_tab, party_tab = window:tab({
    name = "Auto Play",
    tabs = {"Auto Play", "Unit Settings", "Party"}
})
getgenv().AJ_HUB_UNIT_SETTINGS_TAB = unit_settings_tab
local cardUpdateRegistry = {}
getgenv().AJ_HUB_UPDATE_CARDS = function()
    for _, fn in pairs(cardUpdateRegistry) do
        pcall(fn)
    end
end
do
    local col1 = auto_play_tab:column({size = 1})
    local sec1 = col1:section({name = "Placement & Upgrades", icon = "rbxassetid://7072715317", default = true, size = 1})
    sec1:toggle({
        name = "Auto Place Units",
        type = "toggle",
        default = Config.AutoPlaceEnabled,
        callback = function(val)
            Config.AutoPlaceEnabled = val
            if val then
                computeCompactGrid()
                renderVisualGrid()
            end
        end
    })
    sec1:slider({
        name = "Auto Place Path",
        min = 0,
        max = 100,
        interval = 1,
        default = Config.PathPercentage,
        suffix = "%",
        callback = function(val)
            Config.PathPercentage = val
            computeCompactGrid()
            renderVisualGrid()
            for _, fn in pairs(cardUpdateRegistry) do
                pcall(fn)
            end
        end
    })
    sec1:toggle({
        name = "Place Anywhere",
        type = "toggle",
        default = Config.PlaceAnywhere,
        callback = function(val)
            Config.PlaceAnywhere = val
            computeCompactGrid()
            renderVisualGrid()
        end
    })
    sec1:toggle({
        name = "Custom Placement Area",
        type = "toggle",
        default = (Config.UseCustomPlacementArea ~= false),
        callback = function(val)
            Config.UseCustomPlacementArea = val
            State.updatePlacementMarker()
            computeCompactGrid()
            renderVisualGrid()
        end
    })
    sec1:toggle({
        name = "Place Unit Stick To Players",
        type = "toggle",
        default = Config.PlaceStickToPlayers,
        callback = function(val)
            Config.PlaceStickToPlayers = val
            State.PlayerAnchors = nil
        State.StickClusterCenter = nil
        State.GriffinBuffCompleted = false
        end
    })
    sec1:button({
        name = "Set Placement Area (Click Map)",
        callback = function()
            State.startPickingPlacementArea()
        end
    })
    sec1:button({
        name = "Clear Placement Area (Current Map)",
        callback = function()
            State.clearPlacementArea()
        end
    })
    sec1:toggle({
        name = "Auto Upgrade Units",
        type = "toggle",
        default = Config.AutoUpgradeEnabled,
        callback = function(val)
            Config.AutoUpgradeEnabled = val
        end
    })
    sec1:toggle({
        name = "Smart Cost Balancing",
        type = "toggle",
        default = (Config.SmartCostBalancing ~= false),
        callback = function(val)
            Config.SmartCostBalancing = val
        end
    })
    sec1:toggle({
        name = "Auto Use Abilities",
        type = "toggle",
        default = Config.AutoAbilitiesEnabled,
        callback = function(val)
            Config.AutoAbilitiesEnabled = val
        end
    })
    sec1:toggle({
        name = "Show Placement Grid",
        type = "toggle",
        default = Config.ShowPlaceArea,
        callback = function(val)
            Config.ShowPlaceArea = val
            if not isLobby() then
                renderVisualGrid()
            else
                local folder = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
                if folder then folder:Destroy() end
            end
        end
    })
    sec1:toggle({
        name = "Show Next Placement",
        type = "toggle",
        default = Config.ShowNextPlacement,
        callback = function(val)
            Config.ShowNextPlacement = val
            if not isLobby() then
                updateGhostHologram()
            else
                local ghostFolder = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
                if ghostFolder then ghostFolder:Destroy() end
            end
        end
    })
    local col2 = auto_play_tab:column({size = 1})
    local sec_match = col2:section({name = "MATCH", icon = "rbxassetid://7072720722", default = true, size = 0.68})
    sec_match:toggle({
        name = "Auto Start",
        type = "toggle",
        default = Config.AutoStart,
        callback = function(val)
            Config.AutoStart = val
        end
    })
    sec_match:toggle({
        name = "Auto Skip Wave",
        type = "toggle",
        default = Config.AutoWaveSkip,
        callback = function(val)
            Config.AutoWaveSkip = val
        end
    })
    sec_match:toggle({
        name = "Anti Punishment",
        type = "toggle",
        default = Config.AntiPunishment,
        callback = function(val)
            Config.AntiPunishment = val
            if not val then
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp then
                        hum:MoveTo(hrp.Position)
                    end
                end)
            end
        end
    })
    sec_match:toggle({
        name = "Auto Replay",
        type = "toggle",
        default = Config.AutoReplay,
        callback = function(val)
            Config.AutoReplay = val
        end
    })
    sec_match:toggle({
        name = "Auto Next Story",
        type = "toggle",
        default = Config.AutoNextStory,
        callback = function(val)
            Config.AutoNextStory = val
        end
    })
    sec_match:toggle({
        name = "Auto Next Room",
        type = "toggle",
        default = Config.AutoNextRoom,
        callback = function(val)
            Config.AutoNextRoom = val
        end
    })
    sec_match:toggle({
        name = "Auto Next Portal",
        type = "toggle",
        default = Config.AutoNextPortal,
        callback = function(val)
            Config.AutoNextPortal = val
        end
    })
    sec_match:toggle({
        name = "Auto Leave",
        type = "toggle",
        default = Config.AutoLeave,
        callback = function(val)
            Config.AutoLeave = val
        end
    })
    local sec_buffs = col2:section({name = "Buffs", icon = "rbxassetid://7072721855", default = true, size = 0.32})
    sec_buffs:toggle({
        name = "Auto Buff Wendy",
        type = "toggle",
        default = Config.AutoBuffWendy,
        callback = function(val)
            Config.AutoBuffWendy = val
        end
    })
    sec_buffs:toggle({
        name = "Auto Buff Commander",
        type = "toggle",
        default = Config.AutoBuffCommander,
        callback = function(val)
            Config.AutoBuffCommander = val
        end
    })
end
do
    Config.PlacementOrder = Config.PlacementOrder or {1, 2, 3, 4, 5, 6}
    Config.UpgradeOrder = Config.UpgradeOrder or {1, 2, 3, 4, 5, 6}
    Config.UseCustomPlacementOrder = true
    Config.UseCustomUpgradeOrder = true
    local col = unit_settings_tab:column({size = 1})
    local sec = col:section({name = "Equipped Units", icon = "rbxassetid://7072988037", default = true, size = 1})
    local cardsContainer = sec.items["elements"]
    local function createUnitPortrait(slotNumber)
        local spawnGui = LocalPlayer.PlayerGui:FindFirstChild("spawn_units")
        if not spawnGui or not spawnGui:FindFirstChild("Lives") or not spawnGui.Lives:FindFirstChild("Frame") then return nil end
        local unitsGrid = spawnGui.Lives.Frame:FindFirstChild("Units")
        if not unitsGrid then return nil end
        local slotFrame = unitsGrid:FindFirstChild(tostring(slotNumber))
        if not slotFrame then return nil end
        local wm = slotFrame:FindFirstChildWhichIsA("WorldModel", true)
        local srcModel = wm and wm:FindFirstChildWhichIsA("Model")
        if not srcModel then return nil end
        local vp = Instance.new("ViewportFrame")
        vp.Size = UDim2.new(1, 0, 1, 0)
        vp.BackgroundTransparency = 1
        vp.BorderSizePixel = 0
        vp.Active = false
        local world = Instance.new("WorldModel", vp)
        local cloned = srcModel:Clone()
        cloned.Parent = world
        local cam = Instance.new("Camera", vp)
        cam.FieldOfView = 36
        local head = cloned:FindFirstChild("Head") or cloned:FindFirstChild("fakehead") or cloned.PrimaryPart
        if head then
            local look = head.CFrame.LookVector
            local camPos = head.Position + (look * 2.3) + Vector3.new(0, 0.15, 0)
            cam.CFrame = CFrame.new(camPos, head.Position)
        else
            cam.CFrame = CFrame.new(Vector3.new(0, 0.25, 2.4), Vector3.new(0, 0, 0))
        end
        vp.CurrentCamera = cam
        return vp
    end
    local equipped = getEquippedUnits()
    local unitNames = {}
    for i = 1, 6 do
        unitNames[i] = "Slot " .. i
    end
    for _, eq in ipairs(equipped) do
        if eq.slot and eq.name then
            unitNames[eq.slot] = eq.name
        end
    end
    table.clear(cardUpdateRegistry)
    local lastCardUnitKey = {}
    local activeDropdownClose = nil
    local function closeActiveDropdown()
        if activeDropdownClose then
            local fn = activeDropdownClose
            activeDropdownClose = nil
            pcall(fn)
        end
    end
    pcall(function()
        if cardsContainer and cardsContainer:IsA("ScrollingFrame") then
            cardsContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(closeActiveDropdown)
        end
    end)
    local function setPlacementPriority(slot, targetP)
        local currentP = table.find(Config.PlacementOrder, slot) or slot
        if currentP == targetP then return end
        local otherSlot = Config.PlacementOrder[targetP]
        Config.PlacementOrder[targetP] = slot
        Config.PlacementOrder[currentP] = otherSlot
        Config.UseCustomPlacementOrder = true
        for _, fn in pairs(cardUpdateRegistry) do
            fn()
        end
        triggerAutoSave()
    end
    getgenv().AJ_HUB_SET_PLACE_PRIORITY = setPlacementPriority
    local function setUpgradePriority(slot, targetP)
        local currentP = table.find(Config.UpgradeOrder, slot) or slot
        if currentP == targetP then return end
        local otherSlot = Config.UpgradeOrder[targetP]
        Config.UpgradeOrder[targetP] = slot
        Config.UpgradeOrder[currentP] = otherSlot
        Config.UseCustomUpgradeOrder = true
        for _, fn in pairs(cardUpdateRegistry) do
            fn()
        end
        triggerAutoSave()
    end
    getgenv().AJ_HUB_SET_UPG_PRIORITY = setUpgradePriority
    local function buildUnitCard(slot)
        local slotData = Config.UnitCustomSettings[slot] or {}
        local unitName = unitNames[slot] or ("Slot " .. slot)
        local card = Instance.new("Frame")
        card.Name = "UnitCard_" .. slot
        card.Size = UDim2.new(1, 0, 0, 52)
        card.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        card.ClipsDescendants = true
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(42, 42, 50)
        cardStroke.Thickness = 1
        card.LayoutOrder = table.find(Config.PlacementOrder, slot) or slot
        card.Parent = cardsContainer
        local headerBtn = Instance.new("TextButton")
        headerBtn.Name = "Header"
        headerBtn.Size = UDim2.new(1, 0, 0, 52)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""
        headerBtn.ZIndex = 25
        headerBtn.Active = true
        headerBtn.Parent = card
        local portFrame = Instance.new("Frame")
        portFrame.Size = UDim2.new(0, 40, 0, 40)
        portFrame.Position = UDim2.new(0, 8, 0.5, -20)
        portFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        portFrame.Active = false
        Instance.new("UICorner", portFrame).CornerRadius = UDim.new(0, 7)
        local portStroke = Instance.new("UIStroke", portFrame)
        portStroke.Color = Color3.fromRGB(50, 50, 62)
        portFrame.Parent = headerBtn
        local fallbackLbl = Instance.new("TextLabel")
        fallbackLbl.Size = UDim2.new(1, 0, 1, 0)
        fallbackLbl.BackgroundTransparency = 1
        fallbackLbl.Font = Enum.Font.GothamBold
        fallbackLbl.TextSize = 13
        fallbackLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
        fallbackLbl.Text = tostring(slot)
        fallbackLbl.Active = false
        fallbackLbl.Parent = portFrame
        pcall(function()
            local vp = createUnitPortrait(slot)
            if vp then
                vp.Active = false
                fallbackLbl.Visible = false
                vp.Parent = portFrame
            end
        end)
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(0, 220, 0, 18)
        nameLbl.Position = UDim2.new(0, 56, 0, 8)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 13
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.Text = unitName
        nameLbl.Active = false
        nameLbl.Parent = headerBtn
        local chips = Instance.new("Frame")
        chips.Size = UDim2.new(1, -90, 0, 18)
        chips.Position = UDim2.new(0, 56, 0, 28)
        chips.BackgroundTransparency = 1
        chips.Active = false
        local chipLayout = Instance.new("UIListLayout", chips)
        chipLayout.FillDirection = Enum.FillDirection.Horizontal
        chipLayout.Padding = UDim.new(0, 5)
        chips.Parent = headerBtn
        local function makeChip(initialText, color, textColor, strokeColor)
            local chip = Instance.new("Frame")
            chip.BackgroundColor3 = color or Color3.fromRGB(36, 36, 44)
            chip.Size = UDim2.new(0, 0, 1, 0)
            chip.AutomaticSize = Enum.AutomaticSize.X
            chip.Active = false
            Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 4)
            if strokeColor then
                local st = Instance.new("UIStroke", chip)
                st.Color = strokeColor
                st.Thickness = 1
            end
            local pad = Instance.new("UIPadding", chip)
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            local txt = Instance.new("TextLabel", chip)
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 10
            txt.TextColor3 = textColor or Color3.fromRGB(220, 220, 230)
            txt.Text = initialText
            txt.Active = false
            chip.Parent = chips
            return txt, chip
        end
        local initialPlaceP = table.find(Config.PlacementOrder, slot) or slot
        local initialUpgP = table.find(Config.UpgradeOrder, slot) or slot
        local initialLimit = Config.SlotLimits[slot] or 6
        local initialCap = Config.SlotMaxUpgrades[slot] or 10
        local placeChip, placeChipFrame = makeChip("Place #" .. initialPlaceP, Color3.fromRGB(183, 176, 205), Color3.fromRGB(18, 18, 24))
        applyAJGradient(placeChipFrame, 45)
        local upgOrderChip, upgChipFrame = makeChip("Upg #" .. initialUpgP, Color3.fromRGB(36, 36, 44), Color3.fromRGB(213, 199, 183), Color3.fromRGB(183, 176, 205))
        local limitChip = makeChip((initialLimit == 0 and "Skip" or (initialLimit > 5 and "Max" or (initialLimit .. " Max"))), Color3.fromRGB(34, 34, 42), (initialLimit == 0 and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(220, 220, 230)))
        local upgCapChip = makeChip((initialCap > 12 and "Max" or ("Upgrade " .. initialCap)), Color3.fromRGB(34, 34, 42), Color3.fromRGB(220, 220, 230))
        local idealLoopChip, idealLoopChipFrame = makeChip("Ideal Loop", Color3.fromRGB(48, 36, 68), Color3.fromRGB(213, 199, 240), Color3.fromRGB(183, 176, 205))
        idealLoopChipFrame.Visible = false
        local griffinChip, griffinChipFrame = makeChip("Auto Griffith", Color3.fromRGB(68, 36, 48), Color3.fromRGB(240, 199, 213), Color3.fromRGB(205, 176, 183))
        griffinChipFrame.Visible = false
        local chevron = Instance.new("TextLabel")
        chevron.Size = UDim2.new(0, 16, 0, 16)
        chevron.Position = UDim2.new(1, -22, 0.5, -8)
        chevron.BackgroundTransparency = 1
        chevron.Font = Enum.Font.SourceSansBold
        chevron.TextSize = 14
        chevron.TextColor3 = Color3.fromRGB(170, 170, 185)
        chevron.Text = "\226\150\188"
        chevron.Active = false
        chevron.Parent = headerBtn
        local body = Instance.new("Frame")
        body.Name = "Body"
        body.Size = UDim2.new(1, 0, 0, 330)
        body.Position = UDim2.new(0, 0, 0, 52)
        body.BackgroundTransparency = 1
        body.Parent = card
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -16, 0, 1)
        line.Position = UDim2.new(0, 8, 0, 0)
        line.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        line.BorderSizePixel = 0
        line.Parent = body
        local bodyLayout = Instance.new("UIListLayout", body)
        bodyLayout.Padding = UDim.new(0, 6)
        bodyLayout.FillDirection = Enum.FillDirection.Vertical
        local bodyPad = Instance.new("UIPadding", body)
        bodyPad.PaddingTop = UDim.new(0, 8)
        bodyPad.PaddingLeft = UDim.new(0, 8)
        bodyPad.PaddingRight = UDim.new(0, 8)
        local function makePriorityStepper(labelText, initialP, isPlacement, onPick)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundTransparency = 1
            row.Parent = body
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 130, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = labelText
            lbl.Parent = row
            local ctrl = Instance.new("Frame")
            ctrl.Size = UDim2.new(0, 180, 1, 0)
            ctrl.Position = UDim2.new(0, 135, 0, 0)
            ctrl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            Instance.new("UICorner", ctrl).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", ctrl)
            stroke.Color = Color3.fromRGB(44, 44, 56)
            stroke.Thickness = 1
            ctrl.Parent = row
            local btnMinus = Instance.new("TextButton")
            btnMinus.Size = UDim2.new(0, 24, 1, 0)
            btnMinus.Position = UDim2.new(0, 0, 0, 0)
            btnMinus.BackgroundTransparency = 1
            btnMinus.Font = Enum.Font.GothamBold
            btnMinus.TextSize = 11
            btnMinus.Text = "\226\151\132"
            btnMinus.Parent = ctrl
            local btnPlus = Instance.new("TextButton")
            btnPlus.Size = UDim2.new(0, 24, 1, 0)
            btnPlus.Position = UDim2.new(1, -24, 0, 0)
            btnPlus.BackgroundTransparency = 1
            btnPlus.Font = Enum.Font.GothamBold
            btnPlus.TextSize = 11
            btnPlus.Text = "\226\150\186"
            btnPlus.Parent = ctrl
            local valBtn = Instance.new("TextButton")
            valBtn.Size = UDim2.new(1, -48, 1, 0)
            valBtn.Position = UDim2.new(0, 24, 0, 0)
            valBtn.BackgroundTransparency = 1
            valBtn.Font = Enum.Font.GothamBold
            valBtn.TextSize = 11
            valBtn.TextColor3 = Color3.fromRGB(183, 176, 205)
            valBtn.Parent = ctrl
            local currentP = initialP
            local function refresh(p)
                currentP = math.clamp(p, 1, 6)
                valBtn.Text = tostring(currentP)
                btnMinus.TextColor3 = (currentP > 1) and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(75, 75, 85)
                btnPlus.TextColor3 = (currentP < 6) and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(75, 75, 85)
            end
            refresh(initialP)
            btnMinus.MouseButton1Click:Connect(function()
                if currentP > 1 then
                    onPick(currentP - 1)
                end
            end)
            btnPlus.MouseButton1Click:Connect(function()
                if currentP < 6 then
                    onPick(currentP + 1)
                end
            end)
            valBtn.MouseButton1Click:Connect(function()
                local screenGui = library and library.items
                if not screenGui then return end
                closeActiveDropdown()
                local backdrop = Instance.new("TextButton")
                backdrop.Size = UDim2.new(1, 0, 1, 0)
                backdrop.BackgroundTransparency = 1
                backdrop.Text = ""
                backdrop.ZIndex = 499
                backdrop.Parent = screenGui
                local menu = Instance.new("Frame")
                local absPos = ctrl.AbsolutePosition
                local absSize = ctrl.AbsoluteSize
                menu.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 3)
                menu.Size = UDim2.fromOffset(absSize.X, 6 * 24 + 6)
                menu.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                menu.ZIndex = 500
                Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 5)
                local menuStroke = Instance.new("UIStroke", menu)
                menuStroke.Color = Color3.fromRGB(183, 176, 205)
                menuStroke.Thickness = 1
                menu.Parent = screenGui
                local mLayout = Instance.new("UIListLayout", menu)
                mLayout.Padding = UDim.new(0, 2)
                local mPad = Instance.new("UIPadding", menu)
                mPad.PaddingTop = UDim.new(0, 3)
                mPad.PaddingBottom = UDim.new(0, 3)
                mPad.PaddingLeft = UDim.new(0, 3)
                mPad.PaddingRight = UDim.new(0, 3)
                local function cleanup()
                    if menu and menu.Parent then menu:Destroy() end
                    if backdrop and backdrop.Parent then backdrop:Destroy() end
                    if activeDropdownClose == cleanup then
                        activeDropdownClose = nil
                    end
                end
                activeDropdownClose = cleanup
                backdrop.MouseButton1Click:Connect(cleanup)
                for i = 1, 6 do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 22)
                    itemBtn.ZIndex = 501
                    local isSel = (i == currentP)
                    itemBtn.BackgroundColor3 = isSel and Color3.fromRGB(38, 38, 48) or Color3.fromRGB(22, 22, 28)
                    itemBtn.Font = Enum.Font.GothamMedium
                    itemBtn.TextSize = 11
                    itemBtn.TextColor3 = isSel and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(210, 210, 220)
                    itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    itemBtn.Text = (isSel and "  \226\151\143  " or "      ") .. tostring(i)
                    Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
                    itemBtn.Parent = menu
                    itemBtn.MouseEnter:Connect(function()
                        itemBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 56)
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        itemBtn.BackgroundColor3 = (i == currentP) and Color3.fromRGB(38, 38, 48) or Color3.fromRGB(22, 22, 28)
                    end)
                    itemBtn.MouseButton1Click:Connect(function()
                        cleanup()
                        onPick(i)
                    end)
                end
            end)
            return refresh
        end
        local function makeStepper(labelText, initialVal, minVal, maxVal, onChange, formatFunc, step)
            step = step or 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundTransparency = 1
            row.Parent = body
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 130, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = labelText
            lbl.Parent = row
            local ctrl = Instance.new("Frame")
            ctrl.Size = UDim2.new(0, 180, 1, 0)
            ctrl.Position = UDim2.new(0, 135, 0, 0)
            ctrl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            Instance.new("UICorner", ctrl).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", ctrl)
            stroke.Color = Color3.fromRGB(44, 44, 56)
            stroke.Thickness = 1
            ctrl.Parent = row
            local btnMinus = Instance.new("TextButton")
            btnMinus.Size = UDim2.new(0, 24, 1, 0)
            btnMinus.Position = UDim2.new(0, 0, 0, 0)
            btnMinus.BackgroundTransparency = 1
            btnMinus.Font = Enum.Font.GothamBold
            btnMinus.TextSize = 13
            btnMinus.TextColor3 = Color3.fromRGB(183, 176, 205)
            btnMinus.Text = "-"
            btnMinus.Parent = ctrl
            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(1, -48, 1, 0)
            valLbl.Position = UDim2.new(0, 24, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 11
            valLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
            valLbl.Text = formatFunc and formatFunc(initialVal) or tostring(initialVal)
            valLbl.Parent = ctrl
            local btnPlus = Instance.new("TextButton")
            btnPlus.Size = UDim2.new(0, 24, 1, 0)
            btnPlus.Position = UDim2.new(1, -24, 0, 0)
            btnPlus.BackgroundTransparency = 1
            btnPlus.Font = Enum.Font.GothamBold
            btnPlus.TextSize = 13
            btnPlus.TextColor3 = Color3.fromRGB(183, 176, 205)
            btnPlus.Text = "+"
            btnPlus.Parent = ctrl
            local current = initialVal
            local function update(newVal)
                current = math.clamp(newVal, minVal, maxVal)
                valLbl.Text = formatFunc and formatFunc(current) or tostring(current)
                onChange(current)
                triggerAutoSave()
            end
            btnMinus.MouseButton1Click:Connect(function() update(current - step) end)
            btnPlus.MouseButton1Click:Connect(function() update(current + step) end)
            return {
                refresh = function()
                    valLbl.Text = formatFunc and formatFunc(current) or tostring(current)
                end,
                getValue = function() return current end,
                setValue = function(v) update(v) end
            }
        end
        local function makeSlider(labelText, initialVal, minVal, maxVal, onChange, formatFunc)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundTransparency = 1
            row.Parent = body
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 130, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = labelText
            lbl.Parent = row
            local ctrl = Instance.new("TextButton")
            ctrl.Size = UDim2.new(0, 180, 1, 0)
            ctrl.Position = UDim2.new(0, 135, 0, 0)
            ctrl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            ctrl.Text = ""
            ctrl.AutoButtonColor = false
            ctrl.Active = true
            Instance.new("UICorner", ctrl).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", ctrl)
            stroke.Color = Color3.fromRGB(44, 44, 56)
            stroke.Thickness = 1
            ctrl.Parent = row
            local track = Instance.new("Frame")
            track.Name = "Track"
            track.Size = UDim2.new(1, -54, 0, 4)
            track.Position = UDim2.new(0, 8, 0.5, -2)
            track.BackgroundColor3 = Color3.fromRGB(44, 44, 56)
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
            track.Parent = ctrl
            local current = math.clamp(initialVal or minVal, minVal, maxVal)
            local initialFrac = (current - minVal) / math.max(1, maxVal - minVal)
            local fill = Instance.new("Frame")
            fill.Name = "Fill"
            fill.Size = UDim2.new(initialFrac, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(183, 176, 205)
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            fill.Parent = track
            local knob = Instance.new("Frame")
            knob.Name = "Knob"
            knob.Size = UDim2.new(0, 10, 0, 10)
            knob.Position = UDim2.new(initialFrac, -5, 0.5, -5)
            knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            knob.Parent = track
            local valLbl = Instance.new("TextLabel")
            valLbl.Name = "ValLbl"
            valLbl.Size = UDim2.new(0, 42, 1, 0)
            valLbl.Position = UDim2.new(1, -44, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 10
            valLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
            valLbl.Text = formatFunc and formatFunc(current) or tostring(current)
            valLbl.Parent = ctrl
            local dragging = false
            local lastSaveTick = 0
            local lockedScrolls = nil
            local function applyAtX(posX)
                local absX = track.AbsolutePosition.X
                local absW = track.AbsoluteSize.X
                if absW <= 0 then return end
                local frac = math.clamp((posX - absX) / absW, 0, 1)
                local val = math.floor(minVal + (maxVal - minVal) * frac + 0.5)
                val = math.clamp(val, minVal, maxVal)
                current = val
                fill.Size = UDim2.new(frac, 0, 1, 0)
                knob.Position = UDim2.new(frac, -5, 0.5, -5)
                valLbl.Text = formatFunc and formatFunc(val) or tostring(val)
                onChange(val)
                if tick() - lastSaveTick >= 0.35 then
                    lastSaveTick = tick()
                    triggerAutoSave()
                end
            end
            local function startDrag(posX)
                dragging = true
                library._sliderDragging = true
                if library._dragStateMap then
                    for _, s in pairs(library._dragStateMap) do
                        s.dragging = false
                        s.dragInput = nil
                    end
                end
                lockedScrolls = collectAncestorScrollFrames(track)
                applyAtX(posX)
            end
            local function endDrag()
                if dragging then
                    dragging = false
                    library._sliderDragging = false
                    restoreAncestorScrollFrames(lockedScrolls)
                    lockedScrolls = nil
                    triggerAutoSave()
                end
            end
            local function handleInputBegan(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    startDrag(input.Position.X)
                end
            end
            ctrl.InputBegan:Connect(handleInputBegan)
            track.InputBegan:Connect(handleInputBegan)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    applyAtX(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    endDrag()
                end
            end)
            return {
                row = row,
                refresh = function()
                    local frac = (current - minVal) / math.max(1, maxVal - minVal)
                    fill.Size = UDim2.new(frac, 0, 1, 0)
                    knob.Position = UDim2.new(frac, -5, 0.5, -5)
                    valLbl.Text = formatFunc and formatFunc(current) or tostring(current)
                end,
                getValue = function() return current end,
                setValue = function(v)
                    current = math.clamp(v, minVal, maxVal)
                    local frac = (current - minVal) / math.max(1, maxVal - minVal)
                    fill.Size = UDim2.new(frac, 0, 1, 0)
                    knob.Position = UDim2.new(frac, -5, 0.5, -5)
                    valLbl.Text = formatFunc and formatFunc(current) or tostring(current)
                    onChange(current)
                    triggerAutoSave()
                end
            }
        end
        local function makeDropdown(labelText, options, defaultVal, onSelect)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundTransparency = 1
            row.Parent = body
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 130, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = labelText
            lbl.Parent = row
            local ctrl = Instance.new("Frame")
            ctrl.Size = UDim2.new(0, 180, 1, 0)
            ctrl.Position = UDim2.new(0, 135, 0, 0)
            ctrl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            Instance.new("UICorner", ctrl).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", ctrl)
            stroke.Color = Color3.fromRGB(44, 44, 56)
            stroke.Thickness = 1
            ctrl.Parent = row
            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.new(1, 0, 1, 0)
            dropBtn.BackgroundTransparency = 1
            dropBtn.AutoButtonColor = false
            dropBtn.Text = ""
            dropBtn.Parent = ctrl
            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(1, -26, 1, 0)
            valLbl.Position = UDim2.new(0, 8, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 11
            valLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
            valLbl.TextXAlignment = Enum.TextXAlignment.Left
            valLbl.TextTruncate = Enum.TextTruncate.AtEnd
            valLbl.Text = defaultVal
            valLbl.Parent = dropBtn
            local arrowLbl = Instance.new("TextLabel")
            arrowLbl.Size = UDim2.new(0, 18, 1, 0)
            arrowLbl.Position = UDim2.new(1, -20, 0, 0)
            arrowLbl.BackgroundTransparency = 1
            arrowLbl.Font = Enum.Font.GothamBold
            arrowLbl.TextSize = 10
            arrowLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
            arrowLbl.Text = "\226\150\188"
            arrowLbl.Parent = dropBtn
            local currentVal = defaultVal
            dropBtn.MouseButton1Click:Connect(function()
                local screenGui = library and library.items
                if not screenGui then return end
                closeActiveDropdown()
                local backdrop = Instance.new("TextButton")
                backdrop.Size = UDim2.new(1, 0, 1, 0)
                backdrop.BackgroundTransparency = 1
                backdrop.Text = ""
                backdrop.ZIndex = 499
                backdrop.Parent = screenGui
                local menu = Instance.new("Frame")
                local absPos = ctrl.AbsolutePosition
                local absSize = ctrl.AbsoluteSize
                menu.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 3)
                menu.Size = UDim2.fromOffset(absSize.X, #options * 24 + 6)
                menu.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                menu.ZIndex = 500
                Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 5)
                local menuStroke = Instance.new("UIStroke", menu)
                menuStroke.Color = Color3.fromRGB(183, 176, 205)
                menuStroke.Thickness = 1
                menu.Parent = screenGui
                local mLayout = Instance.new("UIListLayout", menu)
                mLayout.Padding = UDim.new(0, 2)
                local mPad = Instance.new("UIPadding", menu)
                mPad.PaddingTop = UDim.new(0, 3)
                mPad.PaddingBottom = UDim.new(0, 3)
                mPad.PaddingLeft = UDim.new(0, 3)
                mPad.PaddingRight = UDim.new(0, 3)
                local function cleanup()
                    if menu and menu.Parent then menu:Destroy() end
                    if backdrop and backdrop.Parent then backdrop:Destroy() end
                    if activeDropdownClose == cleanup then
                        activeDropdownClose = nil
                    end
                end
                activeDropdownClose = cleanup
                backdrop.MouseButton1Click:Connect(cleanup)
                for _, opt in ipairs(options) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 22)
                    itemBtn.ZIndex = 501
                    local isSel = (opt == currentVal)
                    itemBtn.BackgroundColor3 = isSel and Color3.fromRGB(38, 38, 48) or Color3.fromRGB(22, 22, 28)
                    itemBtn.Font = Enum.Font.GothamMedium
                    itemBtn.TextSize = 11
                    itemBtn.TextColor3 = isSel and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(210, 210, 220)
                    itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    itemBtn.Text = (isSel and "  \226\151\143  " or "      ") .. opt
                    Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)
                    itemBtn.Parent = menu
                    itemBtn.MouseEnter:Connect(function()
                        itemBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 56)
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        itemBtn.BackgroundColor3 = (opt == currentVal) and Color3.fromRGB(38, 38, 48) or Color3.fromRGB(22, 22, 28)
                    end)
                    itemBtn.MouseButton1Click:Connect(function()
                        currentVal = opt
                        valLbl.Text = opt
                        cleanup()
                        onSelect(opt)
                        triggerAutoSave()
                    end)
                end
            end)
            return {
                set = function(opt)
                    currentVal = opt
                    valLbl.Text = opt
                end,
                setOptions = function(newOpts)
                    options = newOpts
                end,
                get = function() return currentVal end,
                row = row
            }
        end
        local refreshPlaceBtns = makePriorityStepper("Place Order", initialPlaceP, true, function(targetP)
            setPlacementPriority(slot, targetP)
        end)
        local refreshUpgBtns = makePriorityStepper("Upgrade Order", initialUpgP, false, function(targetP)
            setUpgradePriority(slot, targetP)
        end)
        makeStepper("Place Limit", Config.SlotLimits[slot] or 6, 0, 6, function(v)
            Config.SlotLimits[slot] = (v > 5) and 6 or v
            Config.SlotPlacement[slot] = (v > 0)
            if Config.UnitCustomSettings[slot] then Config.UnitCustomSettings[slot].Amount = (v > 5) and 6 or v end
            limitChip.Text = (v == 0) and "Skip" or (v > 5 and "Max" or (v .. " Max"))
            limitChip.TextColor3 = (v == 0) and Color3.fromRGB(239, 68, 68) or Color3.fromRGB(220, 220, 230)
            renderVisualGrid()
        end, function(v)
            if v == 0 then return "Skip" end
            if v > 5 then return "Max" end
            return tostring(v)
        end)
        local rawCap = Config.SlotMaxUpgrades[slot] or 10
        local stepperCap = (rawCap >= 15) and 13 or math.min(rawCap, 13)
        makeStepper("Max Upgrade", stepperCap, 0, 13, function(v)
            local effectiveCap = (v >= 13) and 15 or v
            Config.SlotMaxUpgrades[slot] = effectiveCap
            if Config.UnitCustomSettings[slot] then Config.UnitCustomSettings[slot].MaxUpgrade = effectiveCap end
            upgCapChip.Text = (v >= 13) and "Max" or ("Upgrade " .. v)
        end, function(v)
            if v >= 13 then return "Max" end
            return tostring(v)
        end)
        local function checkIsCEO()
            local eqUnits = getEquippedUnits()
            for _, eq in ipairs(eqUnits) do
                if eq.slot == slot and isCEOUnit(eq) then
                    return true
                end
            end
            local uName = unitNames and unitNames[slot]
            if uName and isCEOUnit({ name = uName, id = uName }) then
                return true
            end
            return false
        end
        local function checkIsFarm()
            local eqUnits = getEquippedUnits()
            for _, eq in ipairs(eqUnits) do
                if eq.slot == slot and isFarmUnit(eq) then
                    return true
                end
            end
            local uName = unitNames and unitNames[slot]
            if uName and isFarmUnit({ name = uName, id = uName }) then
                return true
            end
            return false
        end
        local pathStepper = makeStepper("Path Position", slotData.CustomPath or 0, 0, 100, function(v)
            if Config.UnitCustomSettings[slot] then Config.UnitCustomSettings[slot].CustomPath = v end
            computeCompactGrid()
            renderVisualGrid()
        end, function(v)
            if v == 0 then
                if checkIsCEO() then
                    return "Auto (95% C.E.O)"
                elseif checkIsFarm() then
                    return "Auto (" .. (Config.FarmPathPercentage or 85) .. "% Farm)"
                else
                    return "Auto (" .. Config.PathPercentage .. "%)"
                end
            end
            return v .. "%"
        end, 5)
        local curTarget = slotData.Target or "Auto"
        if curTarget == "Default" then curTarget = "Auto" end
        makeDropdown("Target Priority", {"Auto", "First", "Last", "Strongest"}, curTarget, function(t)
            if Config.UnitCustomSettings[slot] then Config.UnitCustomSettings[slot].Target = t end
        end)
        local function checkIsShadowgirl()
            local eqUnits = getEquippedUnits()
            for _, eq in ipairs(eqUnits) do
                if eq.slot == slot and isShadowgirlUnit(eq) then
                    return true
                end
            end
            local uName = unitNames and unitNames[slot]
            if uName and isShadowgirlUnit({ name = uName, id = uName }) then
                return true
            end
            return false
        end
        local isInitialSG = checkIsShadowgirl()
        local curAbility = slotData.Ability or "Whenever Ready"
        if curAbility == "Default" or curAbility == "Ready" then
            curAbility = isInitialSG and "Ideal Loop" or "Whenever Ready"
        end
        local abilityOptions = isInitialSG and {"Ideal Loop", "Whenever Ready", "When Boss Is Near", "From Wave", "Disabled"} or {"Whenever Ready", "When Boss Is Near", "From Wave", "Disabled"}
        local abilityDropdown
        local setIdealLoopState
        abilityDropdown = makeDropdown("Auto Ability", abilityOptions, curAbility, function(a)
            if Config.UnitCustomSettings[slot] then
                Config.UnitCustomSettings[slot].Ability = a
                Config.UnitCustomSettings[slot].IdealLoop = (a == "Ideal Loop")
            end
            if setIdealLoopState then
                setIdealLoopState(a == "Ideal Loop", true)
            end
        end)
        local idealLoopRow = Instance.new("Frame")
        idealLoopRow.Name = "IdealLoopRow"
        idealLoopRow.Size = UDim2.new(1, 0, 0, 24)
        idealLoopRow.BackgroundTransparency = 1
        idealLoopRow.Visible = isInitialSG
        idealLoopRow.Parent = body
        local idealLbl = Instance.new("TextLabel")
        idealLbl.Size = UDim2.new(0, 130, 1, 0)
        idealLbl.BackgroundTransparency = 1
        idealLbl.Font = Enum.Font.GothamBold
        idealLbl.TextSize = 11
        idealLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        idealLbl.TextXAlignment = Enum.TextXAlignment.Left
        idealLbl.Text = "Ideal Loop"
        idealLbl.Parent = idealLoopRow
        local isIdeal = (slotData.IdealLoop == true or curAbility == "Ideal Loop")
        if isInitialSG and slotData.IdealLoop == nil and (slotData.Ability == nil or slotData.Ability == "Ideal Loop" or slotData.Ability == "Default") then
            isIdeal = true
            slotData.IdealLoop = true
            slotData.Ability = "Ideal Loop"
            if Config.UnitCustomSettings[slot] then
                Config.UnitCustomSettings[slot].IdealLoop = true
                Config.UnitCustomSettings[slot].Ability = "Ideal Loop"
            end
        end
        local idealToggleBtn = Instance.new("TextButton")
        idealToggleBtn.Size = UDim2.new(0, 44, 0, 22)
        idealToggleBtn.Position = UDim2.new(0, 135, 0, 1)
        idealToggleBtn.BackgroundColor3 = isIdeal and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(28, 28, 36)
        Instance.new("UICorner", idealToggleBtn).CornerRadius = UDim.new(1, 0)
        local idealStroke = Instance.new("UIStroke", idealToggleBtn)
        idealStroke.Color = isIdeal and Color3.fromRGB(213, 199, 183) or Color3.fromRGB(44, 44, 56)
        idealStroke.Thickness = 1
        idealToggleBtn.Text = ""
        idealToggleBtn.Parent = idealLoopRow
        local idealKnob = Instance.new("Frame")
        idealKnob.Size = UDim2.new(0, 16, 0, 16)
        idealKnob.Position = isIdeal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        idealKnob.BackgroundColor3 = isIdeal and Color3.fromRGB(18, 18, 24) or Color3.fromRGB(120, 120, 135)
        Instance.new("UICorner", idealKnob).CornerRadius = UDim.new(1, 0)
        idealKnob.Parent = idealToggleBtn
        setIdealLoopState = function(val, skipDropdownSync)
            isIdeal = val
            if Config.UnitCustomSettings[slot] then
                Config.UnitCustomSettings[slot].IdealLoop = val
                if val then
                    Config.UnitCustomSettings[slot].Ability = "Ideal Loop"
                elseif Config.UnitCustomSettings[slot].Ability == "Ideal Loop" then
                    Config.UnitCustomSettings[slot].Ability = "Whenever Ready"
                end
            end
            if idealLoopChipFrame then
                idealLoopChipFrame.Visible = checkIsShadowgirl() and isIdeal
            end
            TweenService:Create(idealKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = isIdeal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = isIdeal and Color3.fromRGB(18, 18, 24) or Color3.fromRGB(120, 120, 135)
            }):Play()
            TweenService:Create(idealToggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = isIdeal and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(28, 28, 36)
            }):Play()
            idealStroke.Color = isIdeal and Color3.fromRGB(213, 199, 183) or Color3.fromRGB(44, 44, 56)
            if not skipDropdownSync and abilityDropdown and abilityDropdown.set then
                abilityDropdown.set(isIdeal and "Ideal Loop" or "Whenever Ready")
            end
            triggerAutoSave()
        end
        idealToggleBtn.MouseButton1Click:Connect(function()
            setIdealLoopState(not isIdeal)
        end)
        local function checkIsGriffin()
            local eqUnits = getEquippedUnits()
            for _, eq in ipairs(eqUnits) do
                if eq.slot == slot and State.isGriffinUnit(eq) then
                    return true
                end
            end
            local uName = unitNames and unitNames[slot]
            if uName and State.isGriffinUnit({ name = uName, id = uName }) then
                return true
            end
            return false
        end
        local isInitialGrif = checkIsGriffin()
        local autoGriffithRow = Instance.new("Frame")
        autoGriffithRow.Name = "AutoGriffithRow"
        autoGriffithRow.Size = UDim2.new(1, 0, 0, 24)
        autoGriffithRow.BackgroundTransparency = 1
        autoGriffithRow.Visible = isInitialGrif
        autoGriffithRow.Parent = body
        local grifLbl = Instance.new("TextLabel")
        grifLbl.Size = UDim2.new(0, 130, 1, 0)
        grifLbl.BackgroundTransparency = 1
        grifLbl.Font = Enum.Font.GothamBold
        grifLbl.TextSize = 11
        grifLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        grifLbl.TextXAlignment = Enum.TextXAlignment.Left
        grifLbl.Text = "Auto Griffith"
        grifLbl.Parent = autoGriffithRow
        local isAutoGrif = (slotData.AutoGriffith == true)
        local grifToggleBtn = Instance.new("TextButton")
        grifToggleBtn.Size = UDim2.new(0, 44, 0, 22)
        grifToggleBtn.Position = UDim2.new(0, 135, 0, 1)
        grifToggleBtn.BackgroundColor3 = isAutoGrif and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(28, 28, 36)
        Instance.new("UICorner", grifToggleBtn).CornerRadius = UDim.new(1, 0)
        local grifStroke = Instance.new("UIStroke", grifToggleBtn)
        grifStroke.Color = isAutoGrif and Color3.fromRGB(213, 199, 183) or Color3.fromRGB(44, 44, 56)
        grifStroke.Thickness = 1
        grifToggleBtn.Text = ""
        grifToggleBtn.Parent = autoGriffithRow
        local grifKnob = Instance.new("Frame")
        grifKnob.Size = UDim2.new(0, 16, 0, 16)
        grifKnob.Position = isAutoGrif and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        grifKnob.BackgroundColor3 = isAutoGrif and Color3.fromRGB(18, 18, 24) or Color3.fromRGB(120, 120, 135)
        Instance.new("UICorner", grifKnob).CornerRadius = UDim.new(1, 0)
        grifKnob.Parent = grifToggleBtn
        local griffithWaveSlider = makeSlider("Griffith Wave", slotData.AutoGriffithWave or 1, 1, 100, function(v)
            if Config.UnitCustomSettings[slot] then
                Config.UnitCustomSettings[slot].AutoGriffithWave = v
            end
        end, function(v)
            return "Wave " .. v
        end)
        local allBodyChildren = body:GetChildren()
        local griffithWaveRow = allBodyChildren[#allBodyChildren]
        griffithWaveRow.Name = "AutoGriffithWaveRow"
        griffithWaveRow.Visible = isInitialGrif and isAutoGrif
        local function setAutoGriffithState(val)
            isAutoGrif = val
            if Config.UnitCustomSettings[slot] then
                Config.UnitCustomSettings[slot].AutoGriffith = val
            end
            if griffinChipFrame then
                griffinChipFrame.Visible = checkIsGriffin() and isAutoGrif
            end
            if griffithWaveRow then
                griffithWaveRow.Visible = checkIsGriffin() and isAutoGrif
            end
            if expanded then
                local targetH = isAutoGrif and 380 or 315
                pcall(function()
                    TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, targetH)
                    }):Play()
                end)
                task.delay(0.2, function()
                    if card and card.Parent and expanded then
                        card.Size = UDim2.new(1, 0, 0, targetH)
                    end
                end)
            end
            TweenService:Create(grifKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = isAutoGrif and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = isAutoGrif and Color3.fromRGB(18, 18, 24) or Color3.fromRGB(120, 120, 135)
            }):Play()
            TweenService:Create(grifToggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = isAutoGrif and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(28, 28, 36)
            }):Play()
            grifStroke.Color = isAutoGrif and Color3.fromRGB(213, 199, 183) or Color3.fromRGB(44, 44, 56)
            triggerAutoSave()
        end
        grifToggleBtn.MouseButton1Click:Connect(function()
            setAutoGriffithState(not isAutoGrif)
        end)
        cardUpdateRegistry[slot] = function()
            local pP = table.find(Config.PlacementOrder, slot) or slot
            local uP = table.find(Config.UpgradeOrder, slot) or slot
            card.LayoutOrder = pP
            placeChip.Text = "Place #" .. pP
            upgOrderChip.Text = "Upg #" .. uP
            refreshPlaceBtns(pP)
            refreshUpgBtns(uP)
            if pathStepper and pathStepper.refresh then
                pathStepper.refresh()
            end
            local isSG = checkIsShadowgirl()
            idealLoopRow.Visible = isSG
            if isSG then
                if abilityDropdown and abilityDropdown.setOptions then
                    abilityDropdown.setOptions({"Ideal Loop", "Whenever Ready", "When Boss Is Near", "From Wave", "Disabled"})
                end
            else
                if abilityDropdown and abilityDropdown.setOptions then
                    abilityDropdown.setOptions({"Whenever Ready", "When Boss Is Near", "From Wave", "Disabled"})
                end
            end
            local slotConf = Config.UnitCustomSettings and Config.UnitCustomSettings[slot]
            local hasIdeal = (slotConf and (slotConf.IdealLoop == true or slotConf.Ability == "Ideal Loop"))
            if idealLoopChipFrame then
                idealLoopChipFrame.Visible = isSG and hasIdeal
            end
            local isGrif = checkIsGriffin()
            autoGriffithRow.Visible = isGrif
            local hasGrif = (slotConf and slotConf.AutoGriffith == true)
            if griffithWaveRow then
                griffithWaveRow.Visible = isGrif and hasGrif
            end
            if griffinChipFrame then
                griffinChipFrame.Visible = isGrif and hasGrif
            end
            pcall(function()
                local equipped = cachedEq or getEquippedUnits(false)
                local curEq = nil
                for _, eq in ipairs(equipped) do
                    if eq.slot == slot then
                        curEq = eq
                        break
                    end
                end
                local targetName = curEq and curEq.name or ("Empty (Slot " .. slot .. ")")
                if nameLbl and nameLbl.Text ~= targetName then
                    nameLbl.Text = targetName
                end
                local curUnitKey = curEq and (curEq.uuid or curEq.name) or ("empty_" .. slot)
                local existingVp = portFrame and portFrame:FindFirstChildWhichIsA("ViewportFrame")
                if lastCardUnitKey[slot] ~= curUnitKey or not existingVp then
                    lastCardUnitKey[slot] = curUnitKey
                    if portFrame then
                        for _, ch in ipairs(portFrame:GetChildren()) do
                            if ch:IsA("ViewportFrame") then
                                ch:Destroy()
                            end
                        end
                        local vp = createUnitPortrait(slot)
                        if vp then
                            vp.Active = false
                            fallbackLbl.Visible = false
                            vp.Parent = portFrame
                        else
                            fallbackLbl.Visible = true
                            fallbackLbl.Text = tostring(slot)
                        end
                    end
                end
            end)
        end
        local expanded = false
        local lastToggleTick = 0
        local function toggleExpand()
            if tick() - lastToggleTick < 0.2 then return end
            lastToggleTick = tick()
            closeActiveDropdown()
            expanded = not expanded
            local isSG = checkIsShadowgirl()
            local isGrif = checkIsGriffin()
            local slotConf = Config.UnitCustomSettings and Config.UnitCustomSettings[slot]
            local hasGrif = (slotConf and slotConf.AutoGriffith == true)
            local baseH = 282
            if isGrif then
                baseH = hasGrif and 380 or 315
            elseif isSG then
                baseH = 315
            end
            local targetHeight = expanded and baseH or 52
            chevron.Text = expanded and "\226\150\178" or "\226\150\188"
            chevron.TextColor3 = expanded and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(170, 170, 185)
            cardStroke.Color = expanded and Color3.fromRGB(183, 176, 205) or Color3.fromRGB(42, 42, 50)
            pcall(function()
                TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, targetHeight)
                }):Play()
            end)
            task.delay(0.22, function()
                if card and card.Parent then
                    card.Size = UDim2.new(1, 0, 0, targetHeight)
                end
            end)
        end
        getgenv().AJ_EXPAND_REGISTRY = getgenv().AJ_EXPAND_REGISTRY or {}
        getgenv().AJ_EXPAND_REGISTRY[slot] = toggleExpand
        headerBtn.Activated:Connect(toggleExpand)
        headerBtn.MouseButton1Click:Connect(toggleExpand)
    end
    for slot = 1, 6 do
        buildUnitCard(slot)
    end
end
local refreshAllEquippedCards = function()
    local eq = getEquippedUnits(false)
    for s = 1, 6 do
        if cardUpdateRegistry[s] then
            pcall(cardUpdateRegistry[s], eq)
        end
    end
end
getgenv().AJ_HUB_REFRESH_ROSTER = refreshAllEquippedCards
local function hookSpawnUnitsGrid()
    pcall(function()
        local pgui = LocalPlayer:WaitForChild("PlayerGui", 10)
        if not pgui then return end
        local spawnGui = pgui:WaitForChild("spawn_units", 10)
        if not spawnGui then return end
        local frame = spawnGui:WaitForChild("Lives", 10) and spawnGui.Lives:WaitForChild("Frame", 10)
        local unitsGrid = frame and frame:WaitForChild("Units", 10)
        if not unitsGrid then return end
        for slotIndex = 1, 6 do
            local slotFrame = unitsGrid:WaitForChild(tostring(slotIndex), 5)
            if slotFrame then
                slotFrame:GetAttributeChangedSignal("_equipped_frame_unit_uuid"):Connect(function()
                    task.wait(0.1)
                    refreshAllEquippedCards()
                end)
            end
        end
    end)
end
task.spawn(hookSpawnUnitsGrid)
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "spawn_units" then
        task.wait(0.5)
        hookSpawnUnitsGrid()
        refreshAllEquippedCards()
    end
end)
task.spawn(function()
    local lastRosterHash = ""
    while true do
        task.wait(0.75)
        pcall(function()
            local spawnGui = LocalPlayer.PlayerGui:FindFirstChild("spawn_units")
            local grid = spawnGui and spawnGui:FindFirstChild("Lives") and spawnGui.Lives:FindFirstChild("Frame") and spawnGui.Lives.Frame:FindFirstChild("Units")
            if grid then
                local h = ""
                for s = 1, 6 do
                    local sf = grid:FindFirstChild(tostring(s))
                    local uuid = sf and sf:GetAttribute("_equipped_frame_unit_uuid") or "nil"
                    local nl = sf and sf:FindFirstChild("name", true)
                    local nm = nl and nl.Text or "none"
                    h = h .. s .. ":" .. uuid .. ":" .. nm .. ";"
                end
                if h ~= lastRosterHash then
                    lastRosterHash = h
                    refreshAllEquippedCards()
                end
            end
        end)
    end
end)
do
    local col1 = party_tab:column({size = 1})
    local sec_party_cfg = col1:section({name = "Auto Party Settings", icon = "rbxassetid://7072716507", default = true, size = 0.58})
    local toggleAutoParty = sec_party_cfg:toggle({
        name = "Auto Party Enabled",
        type = "toggle",
        default = Config.AutoPartyEnabled,
        callback = function(val)
            Config.AutoPartyEnabled = val
            local role = getPartyRole()
            if val then
                if role == "Main" then
                    Config.PartyAutoInvite = true
                    if toggleAutoInvite and toggleAutoInvite.set then pcall(function() toggleAutoInvite.set(true) end) end
                elseif role == "Alt" then
                    Config.PartyAutoAccept = true
                    if toggleAutoAccept and toggleAutoAccept.set then pcall(function() toggleAutoAccept.set(true) end) end
                end
            end
            triggerAutoSave()
        end
    })
    local toggleAutoInvite = sec_party_cfg:toggle({
        name = "Auto Invite Alts",
        type = "toggle",
        default = Config.PartyAutoInvite,
        callback = function(val)
            Config.PartyAutoInvite = val
            if val then
                Config.AutoPartyEnabled = true
                if toggleAutoParty and toggleAutoParty.set then pcall(function() toggleAutoParty.set(true) end) end
            end
            triggerAutoSave()
        end
    })
    local toggleWaitParty = sec_party_cfg:toggle({
        name = "Wait For Party (Auto Join)",
        type = "toggle",
        default = Config.PartyWaitForMembers,
        callback = function(val)
            Config.PartyWaitForMembers = val
            triggerAutoSave()
        end
    })
    local toggleAutoAccept = sec_party_cfg:toggle({
        name = "Auto Accept Invites",
        type = "toggle",
        default = Config.PartyAutoAccept,
        callback = function(val)
            Config.PartyAutoAccept = val
            if val then
                Config.AutoPartyEnabled = true
                if toggleAutoParty and toggleAutoParty.set then pcall(function() toggleAutoParty.set(true) end) end
            end
            triggerAutoSave()
        end
    })

    local sec_actions = col1:section({name = "Party Actions", icon = "rbxassetid://7072720722", default = true, size = 0.42})
    local btnInviteAlts = sec_actions:button({
        name = "Invite All Alts",
        callback = function()
            pcall(inviteAllAlts)
        end
    })
    local btnAcceptMain = sec_actions:button({
        name = "Accept From Main",
        callback = function()
            pcall(acceptMainInvite)
        end
    })
    local btnLeaveParty = sec_actions:button({
        name = "Leave Party",
        callback = function()
            pcall(leaveParty)
        end
    })

    local function setElementVisible(elem, visible)
        if not elem then return end
        pcall(function()
            if elem.items then
                if elem.items["toggle"] then
                    elem.items["toggle"].Visible = visible
                end
                if elem.items["button_element"] then
                    elem.items["button_element"].Visible = visible
                end
            end
        end)
    end

    local function updateRoleVisibility()
        local role = getPartyRole()
        local isMain = (role == "Main")
        local isAlt = (role == "Alt")

        setElementVisible(toggleAutoInvite, isMain)
        setElementVisible(toggleWaitParty, isMain)
        setElementVisible(btnInviteAlts, isMain)

        setElementVisible(toggleAutoAccept, isAlt)
        setElementVisible(btnAcceptMain, isAlt)
    end

    local col2 = party_tab:column({size = 1})
    local sec_users = col2:section({name = "Party Usernames", icon = "rbxassetid://7072718631", default = true, size = 0.5})
    local defaultMain = (Config.PartyMainUser and #Config.PartyMainUser:gsub("%s+", "") > 0) and Config.PartyMainUser or ""
    local defaultAlts = (Config.PartyAltUsers and #Config.PartyAltUsers:gsub("%s+", "") > 0) and Config.PartyAltUsers or ""

    sec_users:textbox({
        name = "Main Username:",
        flag = "party_main_user",
        default = defaultMain,
        callback = function(val)
            Config.PartyMainUser = val
            saveSharedPartyInfo(Config.PartyMainUser, Config.PartyAltUsers)
            triggerAutoSave()
            updateRoleVisibility()
        end
    })
    sec_users:textbox({
        name = "Alt Usernames (comma-separated):",
        flag = "party_alt_users",
        default = defaultAlts,
        callback = function(val)
            Config.PartyAltUsers = val
            saveSharedPartyInfo(Config.PartyMainUser, Config.PartyAltUsers)
            triggerAutoSave()
            updateRoleVisibility()
        end
    })

    saveSharedPartyInfo(Config.PartyMainUser, Config.PartyAltUsers)

    local sec_status = col2:section({name = "Party Status & Monitor", icon = "rbxassetid://7072977617", default = true, size = 0.5})
    local lblRole = sec_status:label({name = "Role: Detecting..."})
    local lblPartyId = sec_status:label({name = "Party ID: None"})
    local lblMembers = sec_status:label({name = "Party Size: 1"})
    local lblGate = sec_status:label({name = "Auto Join Gate: Checking..."})

    updateRoleVisibility()

    task.spawn(function()
        while task.wait(1.5) do
            pcall(function()
                updateRoleVisibility()
                local role = getPartyRole()
                local myPartyId = LocalPlayer:GetAttribute("PartyId")
                local partyCount = 0
                if myPartyId then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p:GetAttribute("PartyId") == myPartyId then
                            partyCount = partyCount + 1
                        end
                    end
                else
                    partyCount = 1
                end

                local ready, reason = isPartyReady()

                if lblRole and lblRole.items and lblRole.items["name"] then
                    local roleText = (role == "Main" and "Role: Main (Leader)")
                        or (role == "Alt" and "Role: Alt (Follower)")
                        or "Role: None (Enter Username)"
                    lblRole.items["name"].Text = roleText
                end
                if lblPartyId and lblPartyId.items and lblPartyId.items["name"] then
                    lblPartyId.items["name"].Text = "Party ID: " .. (myPartyId and tostring(myPartyId) or "None")
                end
                if lblMembers and lblMembers.items and lblMembers.items["name"] then
                    lblMembers.items["name"].Text = string.format("Party Members: %d", partyCount)
                end
                if lblGate and lblGate.items and lblGate.items["name"] then
                    lblGate.items["name"].Text = "Gate: " .. (ready and "Ready" or tostring(reason))
                end
            end)
        end
    end)
end
pcall(function()
    local origInit = library.init_config
    library.init_config = function(self, win)
        win:seperator({name = "Settings"})
        local main = win:tab({name = "Configs", icon = "rbxassetid://7072987508", tabs = {"Main"}})
        local column = main:column({})
        local currentProfile = (State and State.CurrentProfile) or "Default"
        local config_holder = nil

        local sec_cloud = column:section({name = "Cloud Configs", size = 0.5, default = true, icon = "rbxassetid://7072718631"})
        local cloudCodeInput = ""
        sec_cloud:textbox({
            name = "Cloud Code:",
            flag = "cloud_cfg_code_input",
            placeholder = "e.g. AJ-ERTJN",
            default = "",
            callback = function(val)
                cloudCodeInput = val
            end
        })
        local lblCloudStatus = sec_cloud:label({
            name = "Status: Ready"
        })
        sec_cloud:button({
            name = "Load Config",
            callback = function()
                local code = library.flags and library.flags["cloud_cfg_code_input"]
                if not code or #code == 0 then
                    code = cloudCodeInput
                end
                if not code or #code == 0 then
                    pcall(function()
                        if getclipboard then
                            local c = getclipboard()
                            if c and (#c >= 4) and (c:find("AJ-") or c:find("dpaste") or c:find("pastes%.dev")) then
                                code = c
                            end
                        end
                    end)
                end
                if not code or #code == 0 then
                    if library.notifications and library.notifications.create_notification then
                        library.notifications:create_notification({
                            name = "AJ HUB | Cloud",
                            info = "Please enter or paste a Cloud Code first!"
                        })
                    end
                    return
                end

                if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                    lblCloudStatus.items["name"].Text = "Status: Downloading..."
                end

                task.spawn(function()
                    local ok, countOrErr, loadedProf = loadConfigFromCloud(code)
                    if ok then
                        if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                            lblCloudStatus.items["name"].Text = string.format("Loaded: %s (%s)", tostring(code), os.date("%H:%M:%S"))
                        end
                        if config_holder and config_holder.refresh_options then
                            pcall(function()
                                config_holder:refresh_options(listAccountProfiles())
                            end)
                        end
                        if library.notifications and library.notifications.create_notification then
                            library.notifications:create_notification({
                                name = "AJ HUB | Cloud",
                                info = string.format("Cloud Config [%s] loaded! (%s fields)", tostring(code), tostring(countOrErr))
                            })
                        end
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "AJ HUB | Cloud Config",
                                Text = string.format("Config [%s] loaded successfully!", tostring(code)),
                                Duration = 4
                            })
                        end)
                    else
                        if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                            lblCloudStatus.items["name"].Text = "Error: Invalid or not found"
                        end
                        if library.notifications and library.notifications.create_notification then
                            library.notifications:create_notification({
                                name = "AJ HUB | Cloud",
                                info = string.format("Failed to load: %s", tostring(countOrErr or "Unknown error"))
                            })
                        end
                    end
                end)
            end
        })
        sec_cloud:button({
            name = "Share Config",
            callback = function()
                if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                    lblCloudStatus.items["name"].Text = "Status: Uploading..."
                end
                task.spawn(function()
                    local nameText = library.flags and library.flags["config_name_text"]
                    local targetProf = (nameText and #nameText > 0) and nameText or currentProfile or "Default"
                    local ok, codeOrErr = saveConfigToCloud(targetProf)
                    if ok and codeOrErr then
                        pcall(function()
                            if library.config_flags and library.config_flags["cloud_cfg_code_input"] then
                                library.config_flags["cloud_cfg_code_input"](codeOrErr)
                            end
                            cloudCodeInput = codeOrErr
                        end)
                        if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                            lblCloudStatus.items["name"].Text = "Code: " .. tostring(codeOrErr) .. " (Copied!)"
                        end
                        if library.notifications and library.notifications.create_notification then
                            library.notifications:create_notification({
                                name = "AJ HUB | Cloud",
                                info = string.format("Cloud Code [%s] copied to clipboard!", tostring(codeOrErr))
                            })
                        end
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "AJ HUB | Cloud Config",
                                Text = string.format("Code %s copied to clipboard!", tostring(codeOrErr)),
                                Duration = 5
                            })
                        end)
                    else
                        if lblCloudStatus and lblCloudStatus.items and lblCloudStatus.items["name"] then
                            lblCloudStatus.items["name"].Text = "Error: Upload failed"
                        end
                        if library.notifications and library.notifications.create_notification then
                            library.notifications:create_notification({
                                name = "AJ HUB | Cloud",
                                info = "Failed to upload config to cloud!"
                            })
                        end
                    end
                end)
            end
        })
        local sec_webhook = column:section({name = "Discord Webhook", size = 0.5, default = true, icon = "rbxassetid://7072718362"})
        sec_webhook:toggle({
            name = "Send Match Webhook",
            type = "toggle",
            default = Config.WebhookEnabled,
            callback = function(val)
                Config.WebhookEnabled = val
                triggerAutoSave()
            end
        })
        sec_webhook:textbox({
            name = "Webhook URL:",
            flag = "webhook_url_input",
            default = Config.WebhookUrl or "",
            callback = function(val)
                Config.WebhookUrl = val
                triggerAutoSave()
            end
        })
        sec_webhook:toggle({
            name = "Ping @everyone on Secret",
            type = "toggle",
            default = Config.WebhookPingSecret,
            callback = function(val)
                Config.WebhookPingSecret = val
                triggerAutoSave()
            end
        })
        sec_webhook:button({
            name = "Send Test Webhook",
            callback = function()
                sendMatchWebhook(true)
            end
        })
        local column2 = main:column({})
        local section2 = column2:section({name = "Settings", side = "right", size = 1, default = true, icon = "rbxassetid://129380150574313"})
        local userId, cleanName, rawName = getAccountInfo()
        section2:textbox({name = "Config name:", flag = "config_name_text"})
        section2:button({
            name = "Save to Disk",
            callback = function()
                local nameText = library.flags and library.flags["config_name_text"]
                local targetProfile = (nameText and #nameText > 0) and nameText or currentProfile or "Default"
                saveConfigToFile(targetProfile)
                pcall(function()
                    if config_holder and config_holder.refresh_options then
                        config_holder:refresh_options(listAccountProfiles())
                    end
                end)
                if library.notifications and library.notifications.create_notification then
                    library.notifications:create_notification({
                        name = "AJ HUB",
                        info = string.format("Config [%s] saved for %s!", targetProfile, cleanName)
                    })
                end
            end
        })
        section2:button({
            name = "Reload from Disk",
            callback = function()
                local nameText = library.flags and library.flags["config_name_text"]
                local targetProfile = (nameText and #nameText > 0) and nameText or currentProfile or "Default"
                loadConfigFromFile(targetProfile)
                if getgenv().AJ_HUB_UPDATE_CARDS then
                    getgenv().AJ_HUB_UPDATE_CARDS()
                end
                if library.notifications and library.notifications.create_notification then
                    library.notifications:create_notification({
                        name = "AJ HUB",
                        info = string.format("Config [%s] loaded for %s!", targetProfile, cleanName)
                    })
                end
            end
        })
        section2:button({
            name = "Join Discord (Copy Link)",
            callback = function()
                pcall(function()
                    if setclipboard then
                        setclipboard("https://discord.gg/jtr4YAy4G9")
                    elseif toclipboard then
                        toclipboard("https://discord.gg/jtr4YAy4G9")
                    end
                end)
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "AJ HUB | Discord",
                        Text = "Discord link copied to clipboard!",
                        Duration = 4
                    })
                end)
                if library.notifications and library.notifications.create_notification then
                    library.notifications:create_notification({
                        name = "AJ HUB",
                        info = "Discord link copied to clipboard!"
                    })
                end
            end
        })
        local savedAccent = (Config.MenuAccent and Color3.fromRGB(Config.MenuAccent.R, Config.MenuAccent.G, Config.MenuAccent.B)) or Color3.fromRGB(183, 176, 205)
        section2:colorpicker({
            name = "Menu Accent",
            flag = "menu_accent",
            color = savedAccent,
            callback = function(color, alpha)
                library:update_theme("accent", color)
                Config.MenuAccent = {
                    R = math.floor(color.R * 255),
                    G = math.floor(color.G * 255),
                    B = math.floor(color.B * 255),
                    Hex = color:ToHex()
                }
                saveConfigToFile()
            end
        })
        local savedKey = nil
        if Config.MenuBind and Config.MenuBind.key and Config.MenuBind.key ~= "NONE" then
            pcall(function()
                savedKey = library:convert_enum(Config.MenuBind.key)
            end)
        end
        section2:keybind({
            name = "Menu Bind",
            flag = "menu_bind",
            key = savedKey,
            mode = (Config.MenuBind and Config.MenuBind.mode) or "Toggle",
            default = true,
            callback = function(bool)
                win.toggle_menu(bool)
            end
        })
        section2:toggle({
            name = "Anti-AFK",
            type = "toggle",
            default = Config.AntiPunishments,
            callback = function(val)
                Config.AntiPunishments = val
                syncAntiAfk()
                saveConfigToFile()
            end
        })
        section2:toggle({
            name = "Auto Load",
            type = "toggle",
            default = Config.AutoLoad,
            callback = function(val)
                Config.AutoLoad = val
                if val and queueAutoLoad then
                    queueAutoLoad(true)
                end
                saveConfigToFile()
            end
        })
        section2:toggle({
            name = "Prompt Discord on Startup",
            type = "toggle",
            default = not Config.DontShowDiscordPrompt,
            callback = function(val)
                Config.DontShowDiscordPrompt = not val
                saveConfigToFile()
            end
        })
        section2:button({
            name = "Unload Script",
            callback = function()
                pcall(saveConfigToFile, nil, true)
                if getgenv().AJ_HUB_AUTOSAVE_THREAD then
                    pcall(task.cancel, getgenv().AJ_HUB_AUTOSAVE_THREAD)
                    getgenv().AJ_HUB_AUTOSAVE_THREAD = nil
                end
                if getgenv().AJ_HUB_AUTOSUMMON_THREAD then
                    pcall(task.cancel, getgenv().AJ_HUB_AUTOSUMMON_THREAD)
                    getgenv().AJ_HUB_AUTOSUMMON_THREAD = nil
                end
                if getgenv().AJ_HUB_HEARTBEAT then
                    pcall(function() getgenv().AJ_HUB_HEARTBEAT:Disconnect() end)
                    getgenv().AJ_HUB_HEARTBEAT = nil
                end
                if getgenv().AJ_HUB_BUFF_STOP then pcall(getgenv().AJ_HUB_BUFF_STOP) end
                if getgenv().AA_BUFF_STOP then pcall(getgenv().AA_BUFF_STOP) end
                if _G.AA_BUFF_STOP then pcall(_G.AA_BUFF_STOP) end
                if State and State.AntiAfkConnection then
                    pcall(function() State.AntiAfkConnection:Disconnect() end)
                    State.AntiAfkConnection = nil
                end
                pcall(function()
                    local v = Camera:FindFirstChild("_AJ_HUB_VisualGrid") or Workspace:FindFirstChild("_AJ_HUB_VisualGrid")
                    if v then v:Destroy() end
                    local g = Camera:FindFirstChild("_AJ_HUB_GhostPreview") or Workspace:FindFirstChild("_AJ_HUB_GhostPreview")
                    if g then g:Destroy() end
                end)
                getgenv().AJ_HUB_LOADED = nil
                getgenv().AJ_HUB_BOOTING = nil
                if getgenv().AJ_HUB_CLEANUP then
                    pcall(getgenv().AJ_HUB_CLEANUP)
                    getgenv().AJ_HUB_CLEANUP = nil
                end
                getgenv().AJ_HUB_LIBRARY = nil
            end
        })
    end
end)
local summer_tab, cards_tab = window:tab({
    name = "Event",
    icon = "rbxassetid://7072723105",
    tabs = {"Summer Hunt & Party", "Cards & Merchant"}
})
local function initEventTabs()
    local SummerMapList = {
        "Adventurer Town", "Alien Spaceship (Underwater)", "Ant Kingdom (Summer)",
        "Assassin Park", "Cursed Festival", "Dungeon Throne", "Fabled Kingdom (Summer)",
        "Fiend City", "Future City", "Haunted Academy (Summer)", "Haunted Mansion",
        "Hellish City", "Magic Hills", "Magic Town", "Mountain Temple", "Navy Bay",
        "Nightmare Train", "Otherwordly Plane", "Planet Greenie (Summer)", "Puppet Island (Summer)",
        "Rain Village", "Ruined City", "Sacred Planet", "Sand Village", "Shibuya District",
        "Sky Aircraft", "Sky Island", "Snowy Kingdom", "Snowy Town", "Space Center",
        "Spirit Town", "Spirit World", "Storm Hideout", "Strange Town", "Virtual Dungeon",
        "Walled City (Summer)"
    }
    local SummerWeatherList = {
        "Blizzard", "Clear", "Flooded", "Inferno", "Magical",
        "Rainy", "Sandstorm", "Starfall", "Stormy", "Windy"
    }
    local MerchantItemList = {
        "All", "Lesser Grails", "Star Fruit", "Star Fruit (Rainbow)",
        "Summon Ticket", "Trait Reroll Token", "Dungeon Key", "Stat Reroll", "Super Stat Reroll"
    }
        local TakeCardsList = {
        "Attack",
        "Range",
        "Cooldown",
        "Secret Drop",
        "Star Golem Chance",
        "Blessings",
        "Summer Pearls",
        "Boss Damage",
        "Phys Damage",
        "Magic Damage",
        "Crit Chance",
        "Damage vs Flying",
        "Money (\194\165)"
    }
    local AvoidCardsList = {
        "Physical Resist",
        "Magic Resist",
        "Enemy Health",
        "Enemy Speed",
        "Enemy Regen",
        "Enemy Shield",
        "Explosive Deaths",
        "Burst Enemy Speed",
        "New Paths",
        "Placement/Upgrade Cost",
        "Enemy Flying Chance",
        "Flyers Soaring",
        "Enemy Passives",
        "Lightning Strikes",
        "Curses"
    }
    local col1 = summer_tab:column({size = 1})
    local col2 = summer_tab:column({size = 1})
    local sec_summer = col1:section({name = "Summer Hunt", icon = "rbxassetid://7072723105", default = true, size = 1})
    sec_summer:toggle({
        name = "Auto Find Match",
        default = Config.AutoFindMatchSummer,
        callback = function(val)
            setExclusiveAutoJoin("AutoFindMatchSummer", val)
            if not val then checkCancelMatchmaking() end
        end
    })
    sec_summer:toggle({
        name = "Auto Join Summer Hunt",
        default = Config.AutoJoinSummer,
        callback = function(val)
            setExclusiveAutoJoin("AutoJoinSummer", val)
            if val and isMatchmakingActive() then
                cancelMatchmaking()
            end
        end
    })
    sec_summer:dropdown({
        name = "Skip Maps",
        width = 100,
        multi = true,
        items = SummerMapList,
        default = (type(Config.SummerSkipMaps) == "table" and Config.SummerSkipMaps) or {},
        callback = function(val)
            local arr = (type(val) == "table") and val or (val and {val} or {})
            Config.SummerSkipMaps = arr
        end
    })
    sec_summer:dropdown({
        name = "Skip Weather",
        width = 100,
        multi = true,
        items = SummerWeatherList,
        default = (type(Config.SummerSkipWeather) == "table" and Config.SummerSkipWeather) or {},
        callback = function(val)
            local arr = (type(val) == "table") and val or (val and {val} or {})
            Config.SummerSkipWeather = arr
        end
    })
    sec_summer:toggle({
        name = "Auto Claim Map Board",
        default = Config.AutoClaimMapBoard,
        callback = function(val)
            Config.AutoClaimMapBoard = val
        end
    })
    sec_summer:toggle({
        name = "Auto Event Quests",
        default = Config.AutoEventQuests,
        callback = function(val)
            Config.AutoEventQuests = val
        end
    })
    local sec_party = col2:section({name = "Event Party Filters", icon = "rbxassetid://7072716507", default = true, size = 0.55})
    sec_party:toggle({
        name = "Leave On Low Level",
        default = Config.SummerLeaveLowLevel,
        callback = function(val)
            Config.SummerLeaveLowLevel = val
        end
    })
    sec_party:slider({
        name = "Min Player Level",
        min = 1,
        max = 250,
        interval = 1,
        default = Config.SummerLowLevelUnder or 10,
        callback = function(val)
            Config.SummerLowLevelUnder = val
        end
    })
    sec_party:dropdown({
        name = "Trigger Count",
        width = 95,
        items = {"1 player", "2 players", "3 players", "4 players", "5 players"},
        default = (Config.SummerLeaveWhenFound or 1) .. " player" .. ((Config.SummerLeaveWhenFound or 1) == 1 and "" or "s"),
        callback = function(val)
            Config.SummerLeaveWhenFound = tonumber(string.match(val, "%d+")) or 1
        end
    })
    sec_party:toggle({
        name = "Leave On Few Players",
        default = Config.SummerLeaveFewPlayers,
        callback = function(val)
            Config.SummerLeaveFewPlayers = val
        end
    })
    sec_party:dropdown({
        name = "Min Players",
        width = 95,
        items = {"2 players", "3 players", "4 players", "5 players", "6 players"},
        default = (Config.SummerLeaveUnder or 5) .. " players",
        callback = function(val)
            Config.SummerLeaveUnder = tonumber(string.match(val, "%d+")) or 5
        end
    })
    local sec_monitor = col2:section({name = "Party & Match Status", icon = "rbxassetid://7072977617", default = true, size = 0.45})
    local monStatus = sec_monitor:label({name = "Status: In Match"})
    local monPlayers = sec_monitor:label({name = "Team Size: 1 Players"})
    local monLowest = sec_monitor:label({name = "Lowest Level: Safe"})
    sec_monitor:button({
        name = "Leave Match / Lobby",
        callback = function()
            pcall(function()
                if isLobby() then
                    leaveCurrentLobby()
                else
                    TeleportService:Teleport(8304191830)
                end
            end)
        end
    })
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                local inLob = isLobby()
                local players = Players:GetPlayers()
                local pCount = #players
                local lowest = 9999
                for _, p in ipairs(players) do
                    local lvl = 999
                    if p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Level") then
                        lvl = p.leaderstats.Level.Value
                    elseif p:FindFirstChild("_level") then
                        lvl = p._level.Value
                    end
                    if lvl < lowest then lowest = lvl end
                end
                if monStatus and monStatus.items and monStatus.items["name"] then
                    monStatus.items["name"].Text = inLob and "Status: In Lobby" or "Status: In Match"
                end
                if monPlayers and monPlayers.items and monPlayers.items["name"] then
                    monPlayers.items["name"].Text = string.format("Team Size: %d Players", pCount)
                end
                if monLowest and monLowest.items and monLowest.items["name"] then
                    local isDanger = (lowest < (Config.SummerLowLevelUnder or 10))
                    monLowest.items["name"].Text = string.format("Lowest Level: %d %s", lowest == 9999 and 0 or lowest, isDanger and "[DANGER]" or "[SAFE]")
                end
            end)
        end
    end)
    local col_c1 = cards_tab:column({size = 1})
    local col_c2 = cards_tab:column({size = 1})
    local sec_cards = col_c1:section({name = "Cards (Roguelike / Summer)", icon = "rbxassetid://7072718011", default = true, size = 1})
    sec_cards:toggle({
        name = "Auto Pick Cards",
        default = Config.AutoPickCards,
        callback = function(val)
            Config.AutoPickCards = val
        end
    })
    sec_cards:toggle({
        name = "Best For Event Currency",
        default = (Config.BestForEventCurrency ~= false),
        callback = function(val)
            Config.BestForEventCurrency = val
        end
    })
    local function buildPriorityListUI(parentFrame, titleText, cfgKey, getSyncDrop, onListChanged)
        local container = Instance.new("Frame")
        container.Name = titleText:gsub("%s+", "") .. "Container"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 0, 0)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.Parent = parentFrame

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Padding = UDim.new(0, 6)
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Parent = container

        local header = Instance.new("Frame")
        header.Name = "Header"
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 16)
        header.LayoutOrder = 1
        header.Parent = container

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Name = "Title"
        titleLbl.BackgroundTransparency = 1
        titleLbl.Position = UDim2.new(0, 0, 0, 0)
        titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
        titleLbl.Font = Enum.Font.GothamMedium
        titleLbl.Text = titleText
        titleLbl.TextColor3 = Color3.fromRGB(180, 180, 195)
        titleLbl.TextSize = 13
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = header

        local limitLbl = Instance.new("TextLabel")
        limitLbl.Name = "LimitHeader"
        limitLbl.BackgroundTransparency = 1
        limitLbl.Position = UDim2.new(1, -120, 0, 0)
        limitLbl.Size = UDim2.new(0, 68, 1, 0)
        limitLbl.Font = Enum.Font.GothamMedium
        limitLbl.Text = "Limit"
        limitLbl.TextColor3 = Color3.fromRGB(130, 130, 145)
        limitLbl.TextSize = 12
        limitLbl.TextXAlignment = Enum.TextXAlignment.Center
        limitLbl.Parent = header

        local rowsFrame = Instance.new("Frame")
        rowsFrame.Name = "Rows"
        rowsFrame.BackgroundTransparency = 1
        rowsFrame.Size = UDim2.new(1, 0, 0, 0)
        rowsFrame.AutomaticSize = Enum.AutomaticSize.Y
        rowsFrame.LayoutOrder = 2
        rowsFrame.Parent = container

        local rowsLayout = Instance.new("UIListLayout")
        rowsLayout.Padding = UDim.new(0, 6)
        rowsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rowsLayout.Parent = rowsFrame

        local function refreshRows()
            for _, ch in ipairs(rowsFrame:GetChildren()) do
                if ch:IsA("GuiObject") and ch.Name ~= "UIListLayout" then
                    ch:Destroy()
                end
            end
            local listData = Config[cfgKey] or {}
            for i, item in ipairs(listData) do
                local row = Instance.new("TextButton")
                row.Name = "Row_" .. tostring(i)
                row.AutoButtonColor = false
                row.Text = ""
                row.Size = UDim2.new(1, 0, 0, 32)
                row.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                row.BorderSizePixel = 0
                row.LayoutOrder = i
                row.Parent = rowsFrame

                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 6)
                rowCorner.Parent = row

                local rowStroke = Instance.new("UIStroke")
                rowStroke.Color = Color3.fromRGB(40, 40, 52)
                rowStroke.Thickness = 1
                rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                rowStroke.Parent = row

                local badge = Instance.new("Frame")
                badge.Name = "Badge"
                badge.BackgroundColor3 = Color3.fromRGB(36, 32, 54)
                badge.BorderSizePixel = 0
                badge.Position = UDim2.new(0, 6, 0.5, -11)
                badge.Size = UDim2.new(0, 22, 0, 22)
                badge.Parent = row

                local badgeCorner = Instance.new("UICorner")
                badgeCorner.CornerRadius = UDim.new(0, 4)
                badgeCorner.Parent = badge

                local badgeLbl = Instance.new("TextLabel")
                badgeLbl.BackgroundTransparency = 1
                badgeLbl.Size = UDim2.new(1, 0, 1, 0)
                badgeLbl.Font = Enum.Font.GothamBold
                badgeLbl.Text = tostring(i)
                badgeLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
                badgeLbl.TextSize = 12
                badgeLbl.Parent = badge

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "ItemName"
                nameLbl.BackgroundTransparency = 1
                nameLbl.Position = UDim2.new(0, 35, 0, 0)
                nameLbl.Size = UDim2.new(1, -165, 1, 0)
                nameLbl.Font = Enum.Font.GothamMedium
                nameLbl.Text = tostring(item.name or "Card")
                nameLbl.TextColor3 = Color3.fromRGB(230, 230, 242)
                nameLbl.TextSize = 13
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                nameLbl.Parent = row

                local stepper = Instance.new("Frame")
                stepper.Name = "Stepper"
                stepper.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                stepper.BorderSizePixel = 0
                stepper.Position = UDim2.new(1, -120, 0.5, -11)
                stepper.Size = UDim2.new(0, 68, 0, 22)
                stepper.Parent = row

                local stepperCorner = Instance.new("UICorner")
                stepperCorner.CornerRadius = UDim.new(0, 4)
                stepperCorner.Parent = stepper

                local stepperStroke = Instance.new("UIStroke")
                stepperStroke.Color = Color3.fromRGB(34, 34, 44)
                stepperStroke.Thickness = 1
                stepperStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                stepperStroke.Parent = stepper

                local btnMinus = Instance.new("TextButton")
                btnMinus.Name = "Minus"
                btnMinus.BackgroundTransparency = 1
                btnMinus.Position = UDim2.new(0, 0, 0, 0)
                btnMinus.Size = UDim2.new(0, 20, 1, 0)
                btnMinus.Font = Enum.Font.GothamBold
                btnMinus.Text = "-"
                btnMinus.TextColor3 = Color3.fromRGB(130, 130, 150)
                btnMinus.TextSize = 14
                btnMinus.Parent = stepper

                local valLbl = Instance.new("TextLabel")
                valLbl.Name = "Value"
                valLbl.BackgroundTransparency = 1
                valLbl.Position = UDim2.new(0, 20, 0, 0)
                valLbl.Size = UDim2.new(1, -40, 1, 0)
                valLbl.Font = Enum.Font.GothamBold
                valLbl.Text = (item.limit == 0 and "\226\136\158" or tostring(item.limit or 0))
                valLbl.TextColor3 = Color3.fromRGB(183, 176, 205)
                valLbl.TextSize = 13
                valLbl.Parent = stepper

                local btnPlus = Instance.new("TextButton")
                btnPlus.Name = "Plus"
                btnPlus.BackgroundTransparency = 1
                btnPlus.Position = UDim2.new(1, -20, 0, 0)
                btnPlus.Size = UDim2.new(0, 20, 1, 0)
                btnPlus.Font = Enum.Font.GothamBold
                btnPlus.Text = "+"
                btnPlus.TextColor3 = Color3.fromRGB(130, 130, 150)
                btnPlus.TextSize = 14
                btnPlus.Parent = stepper

                local arrows = Instance.new("Frame")
                arrows.Name = "Arrows"
                arrows.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                arrows.BorderSizePixel = 0
                arrows.Position = UDim2.new(1, -46, 0.5, -11)
                arrows.Size = UDim2.new(0, 42, 0, 22)
                arrows.Parent = row

                local arrowsCorner = Instance.new("UICorner")
                arrowsCorner.CornerRadius = UDim.new(0, 4)
                arrowsCorner.Parent = arrows

                local arrowsStroke = Instance.new("UIStroke")
                arrowsStroke.Color = Color3.fromRGB(34, 34, 44)
                arrowsStroke.Thickness = 1
                arrowsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                arrowsStroke.Parent = arrows

                local btnUp = Instance.new("TextButton")
                btnUp.Name = "Up"
                btnUp.BackgroundTransparency = 1
                btnUp.Position = UDim2.new(0, 0, 0, 0)
                btnUp.Size = UDim2.new(0.5, -1, 1, 0)
                btnUp.Font = Enum.Font.GothamBold
                btnUp.Text = "\226\150\178"
                btnUp.TextColor3 = Color3.fromRGB(140, 140, 160)
                btnUp.TextSize = 9
                btnUp.Parent = arrows

                local arrowDiv = Instance.new("Frame")
                arrowDiv.BorderSizePixel = 0
                arrowDiv.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
                arrowDiv.Position = UDim2.new(0.5, 0, 0, 2)
                arrowDiv.Size = UDim2.new(0, 1, 1, -4)
                arrowDiv.Parent = arrows

                local btnDown = Instance.new("TextButton")
                btnDown.Name = "Down"
                btnDown.BackgroundTransparency = 1
                btnDown.Position = UDim2.new(0.5, 1, 0, 0)
                btnDown.Size = UDim2.new(0.5, -1, 1, 0)
                btnDown.Font = Enum.Font.GothamBold
                btnDown.Text = "\226\150\188"
                btnDown.TextColor3 = Color3.fromRGB(140, 140, 160)
                btnDown.TextSize = 9
                btnDown.Parent = arrows

                local idx = i
                btnMinus.MouseButton1Click:Connect(function()
                    if item.limit == 0 then
                        item.limit = 15
                    elseif item.limit == 1 then
                        item.limit = 0
                    elseif item.limit > 15 then
                        item.limit = 15
                    else
                        item.limit = item.limit - 1
                    end
                    valLbl.Text = (item.limit == 0 and "\226\136\158" or tostring(item.limit))
                    if onListChanged then onListChanged() end
                end)

                btnPlus.MouseButton1Click:Connect(function()
                    if item.limit == 0 then
                        item.limit = 1
                    elseif item.limit >= 15 then
                        item.limit = 0
                    else
                        item.limit = item.limit + 1
                    end
                    valLbl.Text = (item.limit == 0 and "\226\136\158" or tostring(item.limit))
                    if onListChanged then onListChanged() end
                end)

                btnUp.MouseButton1Click:Connect(function()
                    if idx > 1 then
                        local temp = Config[cfgKey][idx]
                        Config[cfgKey][idx] = Config[cfgKey][idx - 1]
                        Config[cfgKey][idx - 1] = temp
                        refreshRows()
                        if onListChanged then onListChanged() end
                    end
                end)

                btnDown.MouseButton1Click:Connect(function()
                    if idx < #Config[cfgKey] then
                        local temp = Config[cfgKey][idx]
                        Config[cfgKey][idx] = Config[cfgKey][idx + 1]
                        Config[cfgKey][idx + 1] = temp
                        refreshRows()
                        if onListChanged then onListChanged() end
                    end
                end)

                row.MouseButton2Click:Connect(function()
                    table.remove(Config[cfgKey], idx)
                    refreshRows()
                    if onListChanged then onListChanged() end
                    local syncDrop = getSyncDrop and getSyncDrop()
                    if syncDrop and syncDrop.set and syncDrop.multi_items then
                        local newSelected = {}
                        for _, it in ipairs(Config[cfgKey]) do
                            table.insert(newSelected, it.name)
                        end
                        syncDrop.multi_items = newSelected
                        syncDrop.set(newSelected)
                    end
                end)
            end
        end

        refreshRows()

        return {
            container = container,
            refresh = refreshRows
        }
    end

    local parentElements = sec_cards.items and sec_cards.items["elements"]

    local initialTake = {}
    if type(Config.TakeCardsPriority) == "table" and #Config.TakeCardsPriority > 0 then
        for _, it in ipairs(Config.TakeCardsPriority) do
            local n = type(it) == "table" and it.name or tostring(it)
            table.insert(initialTake, n)
        end
    elseif type(Config.TakeCards) == "table" and #Config.TakeCards > 0 then
        initialTake = Config.TakeCards
        Config.TakeCardsPriority = {}
        for _, n in ipairs(initialTake) do
            table.insert(Config.TakeCardsPriority, { name = n, limit = (n:lower() == "attack" and 8 or 5) })
        end
    else
        initialTake = {"Attack"}
        Config.TakeCardsPriority = { { name = "Attack", limit = 8 } }
    end

    local takeDrop
    takeDrop = sec_cards:dropdown({
        name = "Take Cards With",
        width = 115,
        multi = true,
        items = TakeCardsList,
        default = initialTake,
        callback = function(val)
            local selectedArr = (type(val) == "table") and val or (val and {val} or {})
            Config.TakeCards = selectedArr
            local selectedLookup = {}
            for _, s in ipairs(selectedArr) do
                if s and s ~= "" and s ~= "None" then
                    selectedLookup[s:lower()] = true
                end
            end
            local existingPriority = Config.TakeCardsPriority or {}
            local updatedPriority = {}
            local alreadyIncluded = {}
            for _, item in ipairs(existingPriority) do
                local itemName = type(item) == "table" and item.name or tostring(item)
                if selectedLookup[itemName:lower()] then
                    table.insert(updatedPriority, item)
                    alreadyIncluded[itemName:lower()] = true
                end
            end
            for _, selName in ipairs(selectedArr) do
                if selName and selName ~= "" and selName ~= "None" then
                    if not alreadyIncluded[selName:lower()] then
                        local defLimit = (selName:lower() == "attack" and 8 or 5)
                        table.insert(updatedPriority, { name = selName, limit = defLimit })
                        alreadyIncluded[selName:lower()] = true
                    end
                end
            end
            Config.TakeCardsPriority = updatedPriority
            if State.TakePriorityUI and State.TakePriorityUI.refresh then
                State.TakePriorityUI.refresh()
            end
            triggerAutoSave()
        end
    })

    State.TakePriorityUI = buildPriorityListUI(parentElements, "Take Priority", "TakeCardsPriority", function()
        return takeDrop
    end, function()
        triggerAutoSave()
    end)

    local initialAvoid = {}
    if type(Config.AvoidCardsPriority) == "table" and #Config.AvoidCardsPriority > 0 then
        for _, it in ipairs(Config.AvoidCardsPriority) do
            local n = type(it) == "table" and it.name or tostring(it)
            table.insert(initialAvoid, n)
        end
    elseif type(Config.AvoidCards) == "table" and #Config.AvoidCards > 0 then
        initialAvoid = Config.AvoidCards
        Config.AvoidCardsPriority = {}
        for _, n in ipairs(initialAvoid) do
            table.insert(Config.AvoidCardsPriority, { name = n, limit = 0 })
        end
    else
        initialAvoid = {"Enemy Regen"}
        Config.AvoidCardsPriority = { { name = "Enemy Regen", limit = 0 } }
    end

    local avoidDrop
    avoidDrop = sec_cards:dropdown({
        name = "Avoid Cards With",
        width = 115,
        multi = true,
        items = AvoidCardsList,
        default = initialAvoid,
        callback = function(val)
            local selectedArr = (type(val) == "table") and val or (val and {val} or {})
            Config.AvoidCards = selectedArr
            local selectedLookup = {}
            for _, s in ipairs(selectedArr) do
                if s and s ~= "" and s ~= "None" then
                    selectedLookup[s:lower()] = true
                end
            end
            local existingPriority = Config.AvoidCardsPriority or {}
            local updatedPriority = {}
            local alreadyIncluded = {}
            for _, item in ipairs(existingPriority) do
                local itemName = type(item) == "table" and item.name or tostring(item)
                if selectedLookup[itemName:lower()] then
                    table.insert(updatedPriority, item)
                    alreadyIncluded[itemName:lower()] = true
                end
            end
            for _, selName in ipairs(selectedArr) do
                if selName and selName ~= "" and selName ~= "None" then
                    if not alreadyIncluded[selName:lower()] then
                        table.insert(updatedPriority, { name = selName, limit = 0 })
                        alreadyIncluded[selName:lower()] = true
                    end
                end
            end
            Config.AvoidCardsPriority = updatedPriority
            if State.AvoidPriorityUI and State.AvoidPriorityUI.refresh then
                State.AvoidPriorityUI.refresh()
            end
            triggerAutoSave()
        end
    })

    State.AvoidPriorityUI = buildPriorityListUI(parentElements, "Avoid Priority", "AvoidCardsPriority", function()
        return avoidDrop
    end, function()
        triggerAutoSave()
    end)
    local eventBonusLabel = sec_cards:label({
        name = "Event Currency Bonus: x1.00 (+0%)"
    })
    task.spawn(function()
        while task.wait(3) do
            pcall(function()
                local mult = "x1.00 (+0%)"
                local xt = getgenv().XT_AnimeAdventures
                if xt and xt.UI and xt.UI.Values and xt.UI.Values["EventCurrencyBonus"] then
                    mult = tostring(xt.UI.Values["EventCurrencyBonus"])
                else
                    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                    local infoReward = pgui and pgui:FindFirstChild("GameLevelInfo") and pgui.GameLevelInfo:FindFirstChild("List_rg") and pgui.GameLevelInfo.List_rg:FindFirstChild("inner") and pgui.GameLevelInfo.List_rg.inner:FindFirstChild("scroll") and pgui.GameLevelInfo.List_rg.inner.scroll:FindFirstChild("Buffs") and pgui.GameLevelInfo.List_rg.inner.scroll.Buffs:FindFirstChild("InfoReward")
                    if infoReward and infoReward.Text and #infoReward.Text > 0 then
                        mult = infoReward.Text:gsub("^.-:%s*", "")
                    elseif pgui and pgui:FindFirstChild("Waves") and pgui.Waves:FindFirstChild("Main") then
                        for _, desc in ipairs(pgui.Waves.Main:GetDescendants()) do
                            if desc:IsA("TextLabel") and desc.Text and desc.Text:find("x%d+%.%d+") then
                                mult = desc.Text
                                break
                            end
                        end
                    end
                end
                if eventBonusLabel and eventBonusLabel.items and eventBonusLabel.items["name"] then
                    eventBonusLabel.items["name"].Text = "Event Currency Bonus: " .. mult
                end
            end)
        end
    end)
    local sec_merchant = col_c2:section({name = "Traveling Merchant", icon = "rbxassetid://7072721904", default = true, size = 0.58})
    sec_merchant:toggle({
        name = "Auto Buy Traveling Merchant",
        default = Config.AutoBuyMerchant,
        callback = function(val)
            Config.AutoBuyMerchant = val
        end
    })
    sec_merchant:dropdown({
        name = "Items To Buy",
        width = 105,
        items = MerchantItemList,
        default = Config.MerchantItem or "All",
        callback = function(val)
            Config.MerchantItem = val
            Config.MerchantItems = {val}
        end
    })
    sec_merchant:slider({
        name = "Keep Summer Pearls",
        min = 0,
        max = 50000,
        interval = 100,
        default = Config.KeepSummerPearls or 0,
        callback = function(val)
            Config.KeepSummerPearls = val
        end
    })
    sec_merchant:slider({
        name = "Keep Gems",
        min = 0,
        max = 100000,
        interval = 500,
        default = Config.KeepGems or 0,
        callback = function(val)
            Config.KeepGems = val
        end
    })
    local sec_hybrid = col_c2:section({name = "Hybrid Units", icon = "rbxassetid://7072721188", default = true, size = 0.42})
    local hybridList = {"None", "All Hybrid"}
    pcall(function()
        local eq = getEquippedUnits()
        for _, u in ipairs(eq) do
            if u.isHybrid and not table.find(hybridList, u.name) then
                table.insert(hybridList, u.name)
            end
        end
    end)
    sec_hybrid:dropdown({
        name = "On Ground",
        width = 105,
        items = hybridList,
        default = Config.HybridGround or "None",
        callback = function(val)
            Config.HybridGround = val
            computeCompactGrid()
            renderVisualGrid()
        end
    })
    sec_hybrid:dropdown({
        name = "On Hill",
        width = 105,
        items = hybridList,
        default = Config.HybridHill or "None",
        callback = function(val)
            Config.HybridHill = val
            computeCompactGrid()
            renderVisualGrid()
        end
    })
end
initEventTabs()

local function initAutoSummonTab()
    local summon_tab = window:tab({
        name = "Auto-Summon",
        icon = "rbxassetid://7072718840",
        tabs = {"Auto-Summon"}
    })

    local col1 = summon_tab:column({size = 1})
    local col2 = summon_tab:column({size = 1})

    local sec_settings = col1:section({name = "Summon Settings", icon = "rbxassetid://7072718840", default = true, size = 1})
    local sec_status = col2:section({name = "Status & Info", icon = "rbxassetid://7072718266", default = true, size = 0.42})
    local sec_autosell = col2:section({name = "Auto Sell (Auto-Summon Only)", icon = "rbxassetid://7072719338", default = true, size = 0.58})

    local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
    local ItemsData = Loader.load_data(nil, "Items")
    local SkinsData = Loader.load_data(nil, "Skins")
    local UnitsData = Loader.load_data(nil, "Units")
    local SummonService = Loader.load_client_service(nil, "SummonServiceClient")

    local function getAvailableBanners()
        local bannerList = {}
        local seen = {}
        pcall(function()
            local BannersData = Loader.load_data(nil, "Banners")
            if BannersData then
                for k, v in pairs(BannersData) do
                    if v and v.active ~= false and not seen[k] then
                        seen[k] = true
                        table.insert(bannerList, tostring(k))
                    end
                end
            end
        end)
        table.sort(bannerList)
        if #bannerList == 0 then
            bannerList = {"Summer2026", "EventClover", "Legacy"}
        end
        return bannerList
    end

    local function getRollCode(sType)
        if sType == "1x" or sType == "1" or sType == "gems" then
            return "gems"
        elseif sType == "Ticket (1x)" or sType == "Ticket" or sType == "ticket" then
            return "ticket"
        else
            return "gems10"
        end
    end

    local function isRaritySelected(rarityList, targetRarity)
        if not targetRarity then return false end
        if type(rarityList) == "string" then
            return string.lower(rarityList) == string.lower(targetRarity)
        end
        if type(rarityList) ~= "table" then return false end
        local lowerTarget = string.lower(tostring(targetRarity))
        for k, v in pairs(rarityList) do
            if v == true and string.lower(tostring(k)) == lowerTarget then
                return true
            elseif type(v) == "string" and string.lower(v) == lowerTarget then
                return true
            end
        end
        return false
    end

    local function checkCanAfford(bannerId, rollCode)
        local pulls = (rollCode == "gems10" and 10 or 1)
        local lp = Players.LocalPlayer
        local stats = lp and lp:FindFirstChild("_stats")
        if not stats then return false, "No Player Stats" end

        if rollCode == "ticket" then
            local count = 0
            pcall(function()
                if SummonService and SummonService.session and SummonService.session.inventory then
                    count = SummonService.session.inventory:get_number_of_owned_item("summon_ticket") or 0
                end
            end)
            if count >= pulls then
                return true
            else
                return false, "No Summon Tickets"
            end
        end

        local bData = nil
        pcall(function()
            local BannersData = Loader.load_data(nil, "Banners")
            bData = BannersData and BannersData[bannerId]
        end)

        if not bData then
            return false, "Unknown Banner (" .. tostring(bannerId) .. ")"
        end

        if bData.resource_cost then
            local rId = bData.resource_cost.id
            local need = bData.resource_cost.amount * pulls
            local curObj = stats:FindFirstChild("_resource" .. rId)
            local curVal = curObj and curObj.Value or 0
            if rId == "SummerPearls" and Config.KeepSummerPearls and Config.KeepSummerPearls > 0 then
                if (curVal - need) < Config.KeepSummerPearls then
                    return false, "Pearls Reserve Limit (" .. curVal .. "/" .. Config.KeepSummerPearls .. ")"
                end
            end
            if curVal >= need then
                return true
            else
                return false, "Need " .. need .. " " .. rId .. " (Have: " .. curVal .. ")"
            end
        elseif bData.id == "Legacy" then
            local need = 50 * pulls
            local curObj = stats:FindFirstChild("_resourceGemsLegacy")
            local curVal = curObj and curObj.Value or 0
            if curVal >= need then
                return true
            else
                return false, "Need " .. need .. " Legacy Gems (Have: " .. curVal .. ")"
            end
        else
            local costPerPull = bData.gem_cost or 50
            local need = costPerPull * pulls
            local curObj = stats:FindFirstChild("gem_amount")
            local curVal = curObj and curObj.Value or 0
            if Config.KeepGems and Config.KeepGems > 0 then
                if (curVal - need) < Config.KeepGems then
                    return false, "Gems Reserve Limit (" .. curVal .. "/" .. Config.KeepGems .. ")"
                end
            end
            if curVal >= need then
                return true
            else
                return false, "Need " .. need .. " Gems (Have: " .. curVal .. ")"
            end
        end
    end

    local banners = getAvailableBanners()
    local initialBanner = Config.AutoSummonBanner
    if not initialBanner or not table.find(banners, initialBanner) then
        initialBanner = table.find(banners, "Summer2026") and "Summer2026" or banners[1]
        Config.AutoSummonBanner = initialBanner
    end

    local _summonPullCount = 0
    local _unitsSoldTotal = 0
    local _skinsSoldTotal = 0
    local _isAutoSummonRollActive = false
    local _lastAutoSummonTime = 0
    local _alreadyProcessedUuids = {}

    local lbl_status
    local lbl_banner
    local lbl_total
    local lbl_currency
    local lbl_sold

    local function updateCurrencyLabel()
        if not lbl_currency or not lbl_currency.items or not lbl_currency.items["name"] then return end
        pcall(function()
            local lp = Players.LocalPlayer
            local stats = lp and lp:FindFirstChild("_stats")
            if not stats then
                lbl_currency.items["name"].Text = "Currency: No Stats"
                return
            end
            local gems = stats.gem_amount and stats.gem_amount.Value or 0
            local pearls = stats:FindFirstChild("_resourceSummerPearls") and stats._resourceSummerPearls.Value or 0
            local legacy = stats:FindFirstChild("_resourceGemsLegacy") and stats._resourceGemsLegacy.Value or 0
            lbl_currency.items["name"].Text = string.format("Gems: %s | Pearls: %s | Legacy: %s", tostring(gems), tostring(pearls), tostring(legacy))
        end)
    end

    local function updateSoldLabel()
        if not lbl_sold or not lbl_sold.items or not lbl_sold.items["name"] then return end
        lbl_sold.items["name"].Text = string.format("Auto-Sold: %d units, %d skins", _unitsSoldTotal, _skinsSoldTotal)
    end

    local function processAutoSummonSell(itemsList, unitsList)
        local now = tick()
        local isRecentAutoRoll = _isAutoSummonRollActive or ((now - (_lastAutoSummonTime or 0)) < 3.0)
        if not isRecentAutoRoll then
            return
        end
        _isAutoSummonRollActive = false
        _lastAutoSummonTime = 0

        task.spawn(function()
            if (not unitsList or #unitsList == 0) and (itemsList and #itemsList > 0 and type(itemsList[1]) == "string") then
                unitsList = itemsList
                itemsList = nil
            end

            local unitsToSell = {}
            local skinsToSell = {}

            -- Filter Units dropped from this auto-summon ONLY
            if Config.AutoSummonSellUnits and unitsList and type(unitsList) == "table" and #unitsList > 0 then
                local sellRarities = Config.AutoSummonSellUnitRarities or {"Rare", "Epic"}
                local keepShiny = (Config.AutoSummonKeepShiny ~= false)

                for _, uItem in ipairs(unitsList) do
                    local uUuid = type(uItem) == "table" and uItem.uuid or uItem
                    if uUuid and type(uUuid) == "string" and not _alreadyProcessedUuids[uUuid] then
                        local uObj = SummonService.session and SummonService.session.collection and SummonService.session.collection:get_unit_by_uuid(uUuid)
                        if not uObj and type(uItem) == "table" and uItem.unit_id then
                            uObj = uItem
                        end
                        if not uObj then
                            for _ = 1, 6 do
                                task.wait(0.05)
                                uObj = SummonService.session and SummonService.session.collection and SummonService.session.collection:get_unit_by_uuid(uUuid)
                                if uObj then break end
                            end
                        end
                        if uObj and uObj.unit_id then
                            _alreadyProcessedUuids[uUuid] = true
                            local isShiny = (uObj.shiny == true)
                            if not (keepShiny and isShiny) then
                                local uData = UnitsData[uObj.unit_id]
                                local rarity = uData and uData.rarity
                                if rarity and isRaritySelected(sellRarities, rarity) then
                                    table.insert(unitsToSell, uUuid)
                                end
                            end
                        end
                    end
                end
            end

            -- Filter Skins dropped from this auto-summon ONLY
            if Config.AutoSummonSellSkins and itemsList and type(itemsList) == "table" and #itemsList > 0 then
                local sellSkinRarities = Config.AutoSummonSellSkinRarities or {"Rare", "Epic"}
                local keepShiny = (Config.AutoSummonKeepShiny ~= false)

                for _, it in ipairs(itemsList) do
                    if type(it) == "table" and it.item_id and it.uuid and not _alreadyProcessedUuids[it.uuid] then
                        local itData = ItemsData[it.item_id]
                        local skinId = itData and itData.usage and itData.usage.skin_id
                        if skinId then
                            _alreadyProcessedUuids[it.uuid] = true
                            local skinData = SkinsData[skinId]
                            local rarity = skinData and (skinData._skin_rarity or skinData.rarity) or (itData and itData.rarity)
                            local isShiny = (it._unique_item_data and it._unique_item_data.shiny == true) or (it.shiny == true)
                            if not (keepShiny and isShiny) then
                                if rarity and isRaritySelected(sellSkinRarities, rarity) then
                                    table.insert(skinsToSell, it.uuid)
                                end
                            end
                        end
                    end
                end
            end

            if #unitsToSell > 0 then
                local ok = pcall(function()
                    Endpoints.autosell_hatched_units:InvokeServer(unitsToSell)
                end)
                if ok then
                    _unitsSoldTotal = _unitsSoldTotal + #unitsToSell
                    updateSoldLabel()
                end
            end

            if #skinsToSell > 0 then
                local ok = pcall(function()
                    Endpoints.delete_unique_items:InvokeServer(skinsToSell)
                end)
                if ok then
                    _skinsSoldTotal = _skinsSoldTotal + #skinsToSell
                    updateSoldLabel()
                end
            end
        end)
    end

    getgenv()._AJ_HUB_AUTOSUMMON_ON_REWARDS = function(itemsList, unitsList)
        processAutoSummonSell(itemsList, unitsList)
    end

    sec_settings:toggle({
        name = "Enable Auto-Summon",
        default = Config.AutoSummonEnabled or false,
        callback = function(val)
            Config.AutoSummonEnabled = val
            triggerAutoSave()
            if not val and lbl_status and lbl_status.items and lbl_status.items["name"] then
                lbl_status.items["name"].Text = "Status: Disabled"
            end
        end
    })

    sec_settings:dropdown({
        name = "Select Banner",
        items = banners,
        default = initialBanner,
        width = 135,
        callback = function(val)
            Config.AutoSummonBanner = val
            triggerAutoSave()
            if lbl_banner and lbl_banner.items and lbl_banner.items["name"] then
                lbl_banner.items["name"].Text = "Banner: " .. tostring(val) .. " (" .. tostring(Config.AutoSummonType or "10x") .. ")"
            end
        end
    })

    sec_settings:dropdown({
        name = "Summon Type",
        items = {"10x", "1x", "Ticket (1x)"},
        default = Config.AutoSummonType or "10x",
        width = 120,
        callback = function(val)
            Config.AutoSummonType = val
            triggerAutoSave()
            if lbl_banner and lbl_banner.items and lbl_banner.items["name"] then
                lbl_banner.items["name"].Text = "Banner: " .. tostring(Config.AutoSummonBanner or "Summer2026") .. " (" .. tostring(val) .. ")"
            end
        end
    })

    sec_settings:toggle({
        name = "Skip Animation (Fast)",
        default = Config.AutoSummonSkipAnim ~= false,
        callback = function(val)
            Config.AutoSummonSkipAnim = val
            triggerAutoSave()
        end
    })

    sec_settings:slider({
        name = "Summon Delay (s)",
        min = 0.1,
        max = 3.0,
        interval = 0.1,
        default = Config.AutoSummonDelay or 0.5,
        callback = function(val)
            Config.AutoSummonDelay = val
            triggerAutoSave()
        end
    })

    lbl_status = sec_status:label({
        name = "Status: " .. (Config.AutoSummonEnabled and "Active" or "Idle")
    })

    lbl_banner = sec_status:label({
        name = "Banner: " .. tostring(Config.AutoSummonBanner or "Summer2026") .. " (" .. tostring(Config.AutoSummonType or "10x") .. ")"
    })

    lbl_total = sec_status:label({
        name = "Total Pulls: 0"
    })

    lbl_currency = sec_status:label({
        name = "Currency: Checking..."
    })
    updateCurrencyLabel()

    sec_status:button({
        name = "Summon Once (Test)",
        callback = function()
            if not isLobby() then
                if lbl_status and lbl_status.items and lbl_status.items["name"] then
                    lbl_status.items["name"].Text = "Status: Cannot summon in match!"
                end
                return
            end
            local banner = Config.AutoSummonBanner or "Summer2026"
            local rollCode = getRollCode(Config.AutoSummonType)
            local canAfford, reason = checkCanAfford(banner, rollCode)
            if not canAfford then
                if lbl_status and lbl_status.items and lbl_status.items["name"] then
                    lbl_status.items["name"].Text = "Status: " .. tostring(reason or "Cannot afford")
                end
                return
            end
            task.spawn(function()
                if lbl_status and lbl_status.items and lbl_status.items["name"] then
                    lbl_status.items["name"].Text = "Status: Testing Summon..."
                end
                _isAutoSummonRollActive = true
                _lastAutoSummonTime = tick()
                local ok, err = pcall(function()
                    Endpoints.buy_from_banner:InvokeServer(banner, rollCode)
                end)
                task.delay(1.0, function()
                    _isAutoSummonRollActive = false
                end)

                if ok then
                    local pullsAdded = (rollCode == "gems10" and 10 or 1)
                    _summonPullCount = _summonPullCount + pullsAdded
                    if lbl_total and lbl_total.items and lbl_total.items["name"] then
                        lbl_total.items["name"].Text = "Total Pulls: " .. tostring(_summonPullCount)
                    end
                    if lbl_status and lbl_status.items and lbl_status.items["name"] then
                        lbl_status.items["name"].Text = "Status: Test Pulled " .. tostring(pullsAdded) .. "x (" .. tostring(banner) .. ")"
                    end
                else
                    if lbl_status and lbl_status.items and lbl_status.items["name"] then
                        lbl_status.items["name"].Text = "Status: Error: " .. tostring(err)
                    end
                end
                updateCurrencyLabel()
            end)
        end
    })

    sec_status:button({
        name = "Reset Pull Counter",
        callback = function()
            _summonPullCount = 0
            _unitsSoldTotal = 0
            _skinsSoldTotal = 0
            if lbl_total and lbl_total.items and lbl_total.items["name"] then
                lbl_total.items["name"].Text = "Total Pulls: 0"
            end
            updateSoldLabel()
        end
    })

    -- Auto-Sell Controls in sec_autosell
    sec_autosell:toggle({
        name = "Auto Sell Units",
        default = Config.AutoSummonSellUnits or false,
        callback = function(val)
            Config.AutoSummonSellUnits = val
            triggerAutoSave()
        end
    })

    sec_autosell:dropdown({
        name = "Sell Unit Rarities",
        multi = true,
        width = 125,
        items = {"Rare", "Epic", "Legendary", "Mythic", "Secret"},
        default = Config.AutoSummonSellUnitRarities or {"Rare", "Epic"},
        callback = function(val)
            Config.AutoSummonSellUnitRarities = (type(val) == "table" and val or {val})
            triggerAutoSave()
        end
    })

    sec_autosell:toggle({
        name = "Auto Sell Skins",
        default = Config.AutoSummonSellSkins or false,
        callback = function(val)
            Config.AutoSummonSellSkins = val
            triggerAutoSave()
        end
    })

    sec_autosell:dropdown({
        name = "Sell Skin Rarities",
        multi = true,
        width = 125,
        items = {"Rare", "Epic", "Legendary", "Mythic", "Secret"},
        default = Config.AutoSummonSellSkinRarities or {"Rare", "Epic"},
        callback = function(val)
            Config.AutoSummonSellSkinRarities = (type(val) == "table" and val or {val})
            triggerAutoSave()
        end
    })

    sec_autosell:toggle({
        name = "Keep Shiny (Units & Skins)",
        default = Config.AutoSummonKeepShiny ~= false,
        callback = function(val)
            Config.AutoSummonKeepShiny = val
            triggerAutoSave()
        end
    })

    lbl_sold = sec_autosell:label({
        name = "Auto-Sold: 0 units, 0 skins"
    })
    updateSoldLabel()

    if getgenv().AJ_HUB_AUTOSUMMON_THREAD then
        pcall(task.cancel, getgenv().AJ_HUB_AUTOSUMMON_THREAD)
        getgenv().AJ_HUB_AUTOSUMMON_THREAD = nil
    end

    getgenv().AJ_HUB_AUTOSUMMON_THREAD = task.spawn(function()
        while true do
            task.wait(0.2)
            if Config.AutoSummonEnabled then
                if not isLobby() then
                    if lbl_status and lbl_status.items and lbl_status.items["name"] then
                        lbl_status.items["name"].Text = "Status: Paused (In Match)"
                    end
                    task.wait(2)
                else
                    local banner = Config.AutoSummonBanner or "Summer2026"
                    local rollCode = getRollCode(Config.AutoSummonType)
                    local canAfford, reason = checkCanAfford(banner, rollCode)

                    updateCurrencyLabel()
                    if lbl_banner and lbl_banner.items and lbl_banner.items["name"] then
                        lbl_banner.items["name"].Text = "Banner: " .. tostring(banner) .. " (" .. tostring(Config.AutoSummonType or "10x") .. ")"
                    end

                    if not canAfford then
                        if lbl_status and lbl_status.items and lbl_status.items["name"] then
                            lbl_status.items["name"].Text = "Status: " .. tostring(reason or "Insufficient Currency")
                        end
                        task.wait(2.5)
                    else
                        if lbl_status and lbl_status.items and lbl_status.items["name"] then
                            lbl_status.items["name"].Text = "Status: Summoning..."
                        end

                        _isAutoSummonRollActive = true
                        _lastAutoSummonTime = tick()
                        local ok, err = pcall(function()
                            Endpoints.buy_from_banner:InvokeServer(banner, rollCode)
                        end)
                        task.delay(1.0, function()
                            _isAutoSummonRollActive = false
                        end)

                        if ok then
                            local pullsAdded = (rollCode == "gems10" and 10 or 1)
                            _summonPullCount = _summonPullCount + pullsAdded
                            if lbl_total and lbl_total.items and lbl_total.items["name"] then
                                lbl_total.items["name"].Text = "Total Pulls: " .. tostring(_summonPullCount)
                            end
                            if lbl_status and lbl_status.items and lbl_status.items["name"] then
                                lbl_status.items["name"].Text = "Status: Pulled " .. tostring(pullsAdded) .. "x (" .. tostring(banner) .. ")"
                            end
                        else
                            if lbl_status and lbl_status.items and lbl_status.items["name"] then
                                lbl_status.items["name"].Text = "Status: Error: " .. tostring(err)
                            end
                        end

                        updateCurrencyLabel()
                        local delayTime = math.max(0.1, tonumber(Config.AutoSummonDelay) or 0.5)
                        task.wait(delayTime)
                    end
                end
            else
                if lbl_status and lbl_status.items and lbl_status.items["name"] then
                    local curText = lbl_status.items["name"].Text
                    if curText:find("Summoning") or curText:find("Pulled") then
                        lbl_status.items["name"].Text = "Status: Idle"
                    end
                end
                task.wait(0.5)
            end
        end
    end)
end
initAutoSummonTab()

library:init_config(window)
State.UIInitialized = true
pcall(function()
    if Config.MenuBind and Config.MenuBind.key and Config.MenuBind.key ~= "NONE" then
        local setFn = library.config_flags and library.config_flags["menu_bind"]
        if setFn then
            local kEnum = library:convert_enum(Config.MenuBind.key)
            setFn({
                mode = Config.MenuBind.mode or "Toggle",
                key = kEnum or Config.MenuBind.key,
                active = Config.MenuBind.active ~= false
            })
        end
    end
end)
if getgenv().AJ_HUB_AUTOSAVE_THREAD then
    pcall(task.cancel, getgenv().AJ_HUB_AUTOSAVE_THREAD)
    getgenv().AJ_HUB_AUTOSAVE_THREAD = nil
end
getgenv().AJ_HUB_AUTOSAVE_THREAD = task.spawn(function()
    while true do
        task.wait(30)
        saveConfigToFile()
    end
end)
