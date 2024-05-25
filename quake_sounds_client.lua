-- Author: __Vector__

local messages = {};

local function __addNewMessage (message)
	messages [#messages+1] = {
		["text"] = message,
		["fade"] = 1.0,
		["height"] = 0.0
	};
end;

local function __deleteMessage (index)
	table.remove (messages, index);
end;


local function __displayMessage (h, message, alpha)
	local width, height = guiGetScreenSize ();
	local absoluteX, absoluteY = messageConfig.x * width, messageConfig.y * height;
	absoluteY = absoluteY + h;
	local fontwidth = dxGetTextWidth (message, messageConfig.scale, messageConfig.font);
	local fontheight = dxGetFontHeight (messageConfig.scale, messageConfig.font);

	dxDrawText (message, absoluteX, absoluteY, absoluteX+fontwidth, absoluteY+fontheight,
			tocolor (255,255,255,alpha), messageConfig.scale, messageConfig.font,
			"left", "top", false, false, false, true);
end;


addEvent ("onQuakeSoundPlay", true);
addEventHandler ("onQuakeSoundPlay", getRootElement (),
	function (sound, killer, death)
		-- play sound.
		playSound (quakeSounds [sound].sound, false);

		-- add a new message.
		local message;

		if getElementType (death) == "ped" then
			message = string.format (quakeSounds [sound].message, getPlayerName (killer) .. "#FFFFFF", "ped");
		elseif getElementType (death) == "player" then
			message = string.format (quakeSounds [sound].message, getPlayerName (killer) .. "#FFFFFF", getPlayerName (death));
		else
			message = string.format (quakeSounds [sound].message, getPlayerName (killer) .. "#FFFFFF", "element");
		end;

		__addNewMessage (message);
		-- outputChatBox (message, 255, 255, 255, true);
	end);



addEventHandler ("onClientRender", getRootElement (),
	function ()
		for i,j in ipairs (messages) do
			__displayMessage (j.height, j.text, math.floor(j.fade*255));
		end;
	end);



addEventHandler ("onClientPreRender", getRootElement (),
	function (dt)
		dt = 0.001 * dt;
		for i,j in ipairs (messages) do
			j.fade = j.fade - messageConfig.fadevelocity * dt;
			j.height = j.height - messageConfig.velocity * dt;

			if j.fade <= 0.0 then
				__deleteMessage (i);
			end;
		end;
	end);




local __timer;
local numKills;

local function __onPlayerKill (death)
	if isTimer (__timer) then
		numKills = numKills + 1;

		for i,j in pairs (quakeSounds) do
			if (j.killdelay ~= nil) and (numKills == j.kills) then
				-- play a quake sound !!
				triggerServerEvent ("onQuakeSoundPlay", getRootElement (), i, getLocalPlayer (), death);
			end;
		end;
	else
		numKills = 1;
		local killdelay=0;
		for i,j in pairs (quakeSounds) do
			if (j.killdelay ~= nil) and (j.killdelay > killdelay) then
				killdelay = j.killdelay;
			end;
		end;


		if killdelay > 0 then
			__timer = setTimer (function () numKills = 1; end, killdelay, 1);
		end;
	end;
end;



addEventHandler ("onClientPedWasted", getRootElement (),
	function (killer, weapon, bodypart)
		if killer == getLocalPlayer () then __onPlayerKill (source); end;
	end);

addEventHandler ("onClientPlayerWasted", getRootElement (),
	function (killer, weapon, bodypart)
		if killer == getLocalPlayer () then __onPlayerKill (source); end;
	end);
