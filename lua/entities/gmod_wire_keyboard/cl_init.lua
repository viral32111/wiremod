include('shared.lua')
include("remap.lua") -- For stools/keyboard.lua's layout selector

net.Receive("wire_keyboard_blockinput", function(netlen)
	if net.ReadBit() ~= 0 then
		hook.Add("PlayerBindPress", "wire_keyboard_blockinput", function(ply, bind, pressed)
			-- return true for all keys except the mouse, to block keyboard actions while typing
			if bind == "+attack" then return nil end
			if bind == "+attack2" then return nil end

			return true
		end)
	else
		hook.Remove("PlayerBindPress", "wire_keyboard_blockinput")
	end
end)

local panel

local function hideMessage()
	if not panel then return end

	panel:Remove()
	panel = nil
end

local function leaveKeyboard()

end

net.Receive("wire_keyboard_activatemessage", function(netlen)
	local on = net.ReadBit() ~= 0

	hideMessage()

	if not on then return end

	local pod = net.ReadBit() ~= 0

	local leaveKey = LocalPlayer():GetInfoNum("wire_keyboard_leavekey", KEY_LALT)
	local leaveKeyName = string.upper(input.GetKeyName(leaveKey))

	local text
	if pod then
		text = "This pod is linked to a Wire Keyboard - press " .. leaveKeyName .. " to leave."
	else
		text = "Wire Keyboard turned on - press " .. leaveKeyName .. " to leave."
	end

	panel = vgui.Create("DFrame")
	panel:SetPos(100, 100)
	panel:SetSize(300, 200)
	panel:SetTitle("Wire Keyboard")
	panel:SetDraggable(true)
	panel:DockPadding(10, 10, 10, 10)

	local label = vgui.Create("DLabel", panel)
	label:SetText(text)
	label:Dock(FILL)

	local hideButton = vgui.Create("DButton", panel)
	hideButton:Dock(BOTTOM)
	hideButton:SetText("Hide this message")
	function hideButton:DoClick()
		chat.AddText("Hide Button was clicked!")
		hideMessage()
	end

	local leaveButton = vgui.Create("DButton", panel)
	leaveButton:Dock(BOTTOM)
	leaveButton:SetText("Leave keyboard")
	function leaveButton:DoClick()
		chat.AddText("Leave Button was clicked!")
		leaveKeyboard()
	end

	panel:SetMouseInputEnabled(true)
	--panel:SetKeyboardInputEnabled(true)
	--panel:MakePopup()
end)


--[[
Mode 1:
- "dont show again"
- alt to interact

Mode 2:
- old functionality if checkbox checked
- checkbox reachable via control panel


TODO:
- Add "Don't show again" checkbox to dialog
- Capture leavekey on client side
]]
