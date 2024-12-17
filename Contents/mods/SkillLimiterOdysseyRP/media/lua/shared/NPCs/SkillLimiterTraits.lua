local function SkillLimiterTraitsInit()

	local TR_SprintingXP = TraitFactory.addTrait("TR_SprintingXP", getText("UI_trait_tr_sprintingxp"), 0, getText("UI_trait_tr_sprintingxpdesc"), true);
	local TR_LightfootedXP = TraitFactory.addTrait("TR_LightfootedXP", getText("UI_trait_tr_lightfootedxp"), 0, getText("UI_trait_tr_lightfootedxpdesc"), true);
	local TR_NimbleXP = TraitFactory.addTrait("TR_NimbleXP", getText("UI_trait_tr_nimblexp"), 0, getText("UI_trait_tr_nimblexpdesc"), true);
	local TR_SneakingXP = TraitFactory.addTrait("TR_SneakingXP", getText("UI_trait_tr_sneakingxp"), 0, getText("UI_trait_tr_sneakingxpdesc"), true);
	local TR_AxeXP = TraitFactory.addTrait("TR_AxeXP", getText("UI_trait_tr_axexp"), 0, getText("UI_trait_tr_axexpdesc"), true);
	local TR_LongBluntXP = TraitFactory.addTrait("TR_LongBluntXP", getText("UI_trait_tr_longbluntxp"), 0, getText("UI_trait_tr_longbluntxpdesc"), true);
	local TR_ShortBluntXP = TraitFactory.addTrait("TR_ShortBluntXP", getText("UI_trait_tr_shortbluntxp"), 0, getText("UI_trait_tr_shortbluntxpdesc"), true);
	local TR_LongBladeXP = TraitFactory.addTrait("TR_LongBladeXP", getText("UI_trait_tr_longbladexp"), 0, getText("UI_trait_tr_longbladexpdesc"), true);
	local TR_ShortBladeXP = TraitFactory.addTrait("TR_ShortBladeXP", getText("UI_trait_tr_shortbladexp"), 0, getText("UI_trait_tr_shortbladexpdesc"), true);
	local TR_SpearXP = TraitFactory.addTrait("TR_SpearXP", getText("UI_trait_tr_spearxp"), 0, getText("UI_trait_tr_spearxpdesc"), true);
	local TR_MaintenanceXP = TraitFactory.addTrait("TR_MaintenanceXP", getText("UI_trait_tr_maintenancexp"), 0, getText("UI_trait_tr_maintenancexpdesc"), true);
	local TR_CarpentryXP = TraitFactory.addTrait("TR_CarpentryXP", getText("UI_trait_tr_carpentryxp"), 0, getText("UI_trait_tr_carpentryxpdesc"), true);
	local TR_CookingXP = TraitFactory.addTrait("TR_CookingXP", getText("UI_trait_tr_cookingxp"), 0, getText("UI_trait_tr_cookingxpdesc"), true);
	local TR_FarmingXP = TraitFactory.addTrait("TR_FarmingXP", getText("UI_trait_tr_farmingxp"), 0, getText("UI_trait_tr_farmingxpdesc"), true);
	local TR_FirstAidXP = TraitFactory.addTrait("TR_FirstAidXP", getText("UI_trait_tr_firstaidxp"), 0, getText("UI_trait_tr_firstaidxpdesc"), true);
	local TR_ElectricalXP = TraitFactory.addTrait("TR_ElectricalXP", getText("UI_trait_tr_electricalxp"), 0, getText("UI_trait_tr_electricalxpdesc"), true);
	local TR_MetalWorkingXP = TraitFactory.addTrait("TR_MetalWorkingXP", getText("UI_trait_tr_metalworkingxp"), 0, getText("UI_trait_tr_metalworkingxpdesc"), true);
	local TR_TailoringXP = TraitFactory.addTrait("TR_TailoringXP", getText("UI_trait_tr_tailoringxp"), 0, getText("UI_trait_tr_tailoringxpdesc"), true);
	local TR_AimingXP = TraitFactory.addTrait("TR_AimingXP", getText("UI_trait_tr_aimingxp"), 0, getText("UI_trait_tr_aimingxpdesc"), true);
	local TR_ReloadingXP = TraitFactory.addTrait("TR_ReloadingXP", getText("UI_trait_tr_reloadingxp"), 0, getText("UI_trait_tr_reloadingxpdesc"), true);
	local TR_FishingXP = TraitFactory.addTrait("TR_FishingXP", getText("UI_trait_tr_fishingxp"), 0, getText("UI_trait_tr_fishingxpdesc"), true);
	local TR_TrappingXP = TraitFactory.addTrait("TR_TrappingXP", getText("UI_trait_tr_trappingxp"), 0, getText("UI_trait_tr_trappingxpdesc"), true);
	local TR_ForagingXP = TraitFactory.addTrait("TR_ForagingXP", getText("UI_trait_tr_foragingxp"), 0, getText("UI_trait_tr_foragingxpdesc"), true);
	local TR_MechanicXP = TraitFactory.addTrait("TR_MechanicXP", getText("UI_trait_tr_mechanicxp"), 0, getText("UI_trait_tr_Mechanicxpdesc"), true);
end

Events.OnGameBoot.Add(SkillLimiterTraitsInit);

