-- Author: __Vector__

local numKills = {};
local totalKills = 0;


local function __playQuakeSound (sound, killer, death)
	if quakeSounds[sound].scope == "all" then
		triggerClientEvent (getRootElement (), "onQuakeSoundPlay", getRootElement (),
			sound, killer, death);
	elseif quakeSounds[sound].scope == "player" then
		triggerClientEvent (killer, "onQuakeSoundPlay", getRootElement (),
			sound, killer, death);
	end;
end;


local function __onPlayerKill (killer, death, weapon, bodypart)
	if not killer then return; end;

	if getElementType (killer) ~= "player" then
		if getElementType (killer) == "vehicle" then
			local driver = getVehicleOccupant (killer);
			if not driver then return; end;
			killer = driver;
		else
			return;
		end;
	end;

	totalKills = totalKills + 1;
	numKills [killer] = numKills [killer] + 1;


	for i,j in pairs (quakeSounds) do
		if j.killdelay == nil then
			if j.kills == 0 then
				if ((j.bodypart == nil) or (j.bodypart == bodypart)) and
					((j.weapon == nil) or (j.weapon == weapon)) then
					__playQuakeSound (i, killer, death);
				end;
			else
				if j.killer == "player" then
					if j.kills == numKills [killer] then
						__playQuakeSound (i, killer, death);
					end;
				elseif j.killer == "all" then
					if totalKills == j.kills then
						__playQuakeSound (i, killer, death);
					end;
				end;
			end;
		end;
	end;
end;


addEvent ("onQuakeSoundPlay", true);
addEventHandler ("onQuakeSoundPlay", getRootElement (),
	function (sound, killer, death)
		__playQuakeSound (sound, killer, death);
	end);


addEventHandler ("onPlayerWasted", getRootElement (),
	function (amno, killer, weapon, bodypart)

		__onPlayerKill (killer, source, weapon, bodypart);
		numKills [source] = 0;
	end);

addEventHandler ("onPedWasted", getRootElement (),
	function (amno, killer, weapon, bodypart)

		__onPlayerKill (killer, source, weapon, bodypart);
	end);



addEventHandler ("onPlayerJoin", getRootElement (),
	function ()
		numKills [source] = 0;
	end);

addEventHandler ("onPlayerQuit", getRootElement (),
	function ()
		numKills [source] = nil;
	end);

function QuakeSoundsInitRound ()
	totalKills = 0;
	for i,j in pairs (numKills) do
		numKills [i] = 0;
	end;
end;

addEventHandler ("onResourceStart", getResourceRootElement (getThisResource ()),
	function ()
		totalKills = 0;
		local players = getElementsByType ("player", getRootElement ());
		for i,j in ipairs (players) do
			numKills [j] = 0;
		end;
	end);
