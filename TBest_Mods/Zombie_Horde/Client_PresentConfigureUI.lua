--TODO remove Slider from ZombieID

function Client_PresentConfigureUI(rootParent)
	local initialValue1 = Mod.Settings.ExtraArmies;
	local initialZombieID = Mod.Settings.ZombieID;
	
	if initialValue1 == nil then initialValue1 = 5; end
    	if initialZombieID == nil then initialZombieID = 69603; end

    local horz1 = UI.CreateHorizontalLayoutGroup(rootParent);
	UI.CreateLabel(horz1).SetText('Extra Armies for Zombie in EACH territory per Turn:');
    numberInputField1 = UI.CreateNumberInputField(horz1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(10)
		.SetValue(initialValue1);

    local horz2 = UI.CreateHorizontalLayoutGroup(rootParent);	
	UI.CreateLabel(horz2).SetText('The PlayerID of the Zombie:');
    zombieInputField = UI.CreateNumberInputField(horz2)
		.SetValue(initialZombieID);

end
