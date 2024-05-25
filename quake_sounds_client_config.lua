-- Author: __Vector__

quakeSounds = {};
messageConfig = {};


local function __loadConfig ()
	local function __loadQuakeSoundConfig (node)
		local attrs = xmlNodeGetAttributes (node);
		local name = attrs ["name"];
		local sound = attrs ["sound"];
		local message = attrs ["message"];
		local kills = attrs ["kills"];

		if name == nil then
			outputDebugString ("Name not speicified for a Quake Sound", 2);
			return;
		end;
		if sound == nil then
			outputDebugString ("Path not speificied for \"" .. name .. "\" Quake Sound", 2);
			return;
		end;
		if message == nil then
			outputDebugString ("Message not specified for \"" .. name .. "\" Quake Sound", 2);
			return;
		end;

		if kills == nil then
			outputDebugString("Undefined Number of kills for the Quake Sound", 2);
			return;
		end;

		-- add new quake sound.
		quakeSounds [name] = {
			["sound"]=sound,
			["message"]=message,
			["killdelay"]=tonumber(attrs["killdelay"]),
			["kills"]=tonumber (kills)
		};
	end;


	local config = xmlLoadFile ("quake_sounds_config.xml");
	if not config then
		outputDebugString ("Cannot open quake_sounds_config.xml file", 1);
		return;
	end;

	local attrs = xmlNodeGetAttributes (config);

	if attrs ["messagexpos"] == nil then
		outputDebugString ("Undefined value for Quake Position Messages (x-position)", 2);
		return;
	end;

	if attrs ["messageypos"] == nil then
		outputDebugString ("Undefined value for Quake Position Messages (y-position)", 2);
		return;
	end;

	if attrs ["messagetimefade"] == nil then
		outputDebugString ("Undefined value for Quake Message Time Fade", 2);
		return;
	end;
	if tonumber(attrs ["messagetimefade"]) == 0.0 then
		outputDebugString ("Quake Message Time Fade must be non zero", 2);
		return;
	end;

	if attrs ["messagevelocity"] == nil then
		outputDebugString ("Undefined Quake Message Velocity", 2);
		return;
	end;

	messageConfig.x = tonumber (attrs ["messagexpos"]);
	messageConfig.y = tonumber (attrs ["messageypos"]);
	messageConfig.fadevelocity = 1000.0 / tonumber (attrs ["messagetimefade"]);
	messageConfig.velocity = tonumber (attrs ["messagevelocity"]);

	if attrs ["messagefont"] == nil then
		messageConfig.font = "default";
	else
		messageConfig.font = attrs ["messagefont"];
	end;

	if attrs ["messagefontscale"] == nil then
		messageConfig.scale = 1.0;
	else
		messageConfig.scale = tonumber (attrs ["messagefontscale"]);
	end;


	local children = xmlNodeGetChildren (config);

	for i,j in ipairs (children) do
		if xmlNodeGetName (j) == "quake_sound" then
			__loadQuakeSoundConfig (j);
		end;
	end;


	xmlUnloadFile (config);
end;

__loadConfig ();




