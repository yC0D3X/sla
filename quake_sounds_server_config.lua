-- Author: __Vector__

quakeSounds = {};


local bodyPartIDs = {
	["torso"]=3,
	["ass"]=4,
	["left arm"]=5,
	["right arm"]=6,
	["left leg"]=7,
	["right leg"]=8,
	["head"]=9
};


local function __loadConfig ()

	local function __loadQuakeSoundConfig (node)
		local attrs = xmlNodeGetAttributes (node);

		if attrs ["name"] == nil then
			outputDebugString ("Name not specified for a Quake Sound",1);
			return;
		end;
		if attrs ["kills"] == nil then
			outputDebugString ("Undefined number of kills for \"" .. attrs ["name"] .. "\" Quake Sound",1);
			return;
		end;

		-- default values.
		if attrs ["scope"] == nil then
			attrs ["scope"] = "all";
		end;
		if attrs ["killer"] == nil then
			attrs ["killer"] = "player";
		end;

		if attrs ["weapon"] ~= nil then
			attrs ["weapon"] = getWeaponIDFromName (attrs ["weapon"]);
			if not attrs ["weapon"] then
				attrs ["weapon"] = nil;
			end;
		end;

		if attrs ["bodypart"] ~= nil then
			attrs ["bodypart"] = bodyPartIDs [string.lower (attrs ["bodypart"])];
		end;

		quakeSounds [attrs ["name"]] = {
			["scope"] = attrs ["scope"],
			["killer"] = attrs ["killer"],
			["kills"] = tonumber (attrs ["kills"]),
			["bodypart"] = attrs ["bodypart"],
			["weapon"] = attrs ["weapon"]
		};
	end;

	local config = xmlLoadFile ("quake_sounds_config.xml");
	if not config then
		outputServerLog ("Cannot open quake_sounds_config.xml file");
		return;
	end;
	local children = xmlNodeGetChildren (config);

	for i,j in ipairs (children) do
		__loadQuakeSoundConfig (j);
	end;

	xmlUnloadFile (config);
end;


__loadConfig ();

