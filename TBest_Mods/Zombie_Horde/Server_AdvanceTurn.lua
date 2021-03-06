function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	standing = game.ServerGame.LatestTurnStanding;
	CurrentIndex=1;
	Order66={};
	ZombieID = Mod.Settings.ZombieID;
	--ignore unimportent orders TODO
	if (Mod.Settings.RandomZombie ==true) then
		--ZombieID = FindZombieID(game);
		ZombieID = 69603; --tempFix for ongoing game.
	end
--Mod.Settings.NumTurns instead of hardcoded turn limit
	if (game.Game.NumberOfTurns > 10 or Mod.Settings.ZombieWin == false) then --can the zombie win? turn limit on win?
		if (playersAlive() == 2) then --update to count teams, not players? 
			for _,territory in pairs(standing.Territories) do 
				if (territory.OwnerPlayerID == ZombieID) then
					terrMod = WL.TerritoryModification.Create(territory.ID);
					terrMod.SetOwnerOpt=WL.PlayerID.Neutral;
					Order66[CurrentIndex]=terrMod;
					CurrentIndex=CurrentIndex+1;
--the order66 is a modefication from https://github.com/dabo123148/WarlightMod/blob/master/Pestilence/Server_AdvanceTurn.lua
				end
			end
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); --the order don't get carried out, if Zombie is killed
		addNewOrder(WL.GameOrderEvent.Create(WL.PlayerID.Neutral,"Cure Found and zombies are now harmless",nil,Order66));
		end
	end
end

function Server_AdvanceTurn_End(game, addNewOrder)
	standing = game.ServerGame.LatestTurnStanding;
	newExtraDeploy = Mod.Settings.ExtraArmies;
	if (playersAlive() > 2) then --update to count teams, not players	
		for _,territory in pairs(standing.Territories) do 	
			if (territory.OwnerPlayerID == ZombieID) then
				if (newExtraDeploy + territory.NumArmies.NumArmies < newExtraDeploy *10) then
					if (newExtraDeploy < 0) then newExtraDeploy = 0 end;	
					if (newExtraDeploy > 1000) then newExtraDeploy = 1000 end;	
--make this only add one event, that is "All Zombie territories deployex X armies. ?TODO
					addNewOrder(WL.GameOrderDeploy.Create(ZombieID, newExtraDeploy, territory.ID,nil,GameOrderDeploy));
				end
			end
		end
	end
end

function FindZombieID(game)
	local playersSet = {}
	for _,territory in pairs(game.ServerGame.TurnZeroStanding.Territories)do	
		if (not territory.IsNeutral) then
			playersSet[territory.OwnerPlayerID] = true
		end
	end
	local playersTable = {}
	local n = 0;
	for key, _ in pairs(playersSet) do
		playersTable[n] = key
		n = n + 1;
	end	
	winnerKey =0;
	gameNummber = game.Game.ID - 13523000; --if not, gets timeout issues
	for i=1,(gameNummber) do
		winnerKey = winnerKey +1;
		if (winnerKey >= n ) then
			winnerKey =0;
		end
	end
	return playersTable[winnerKey];
end

function playersAlive()
	local playersSet = {}
	for _, territory in pairs(standing.Territories) do
		if (not territory.IsNeutral) then
			playersSet[territory.OwnerPlayerID] = true
		end
	end
	local playersTable = {}
	local n = 0;
	for key, _ in pairs(playersSet) do
		playersTable[n] = key
		n = n + 1;
	end	
	return n;
end
