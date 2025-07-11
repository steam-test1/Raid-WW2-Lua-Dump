InstigatorRuleUnitElement = InstigatorRuleUnitElement or class(MissionElement)
InstigatorRuleUnitElement.SAVE_UNIT_POSITION = false
InstigatorRuleUnitElement.SAVE_UNIT_ROTATION = false

function InstigatorRuleUnitElement:init(unit)
	InstigatorRuleUnitElement.super.init(self, unit)

	self._hed.instigator = "none"
	self._hed.rules = {}
	self._hed.invert = false

	table.insert(self._save_values, "instigator")
	table.insert(self._save_values, "rules")
	table.insert(self._save_values, "invert")
end

function InstigatorRuleUnitElement:_rule_updated(category, value)
	self._hed.rules[self._hed.instigator] = self._hed.rules[self._hed.instigator] or {}
	self._hed.rules[self._hed.instigator][category] = #value > 0 and value or nil
end

function InstigatorRuleUnitElement:_instigator_changed(params)
	self:_update_rules_panel()
end

function InstigatorRuleUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()

	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer

	local instigator_params = {
		ctrlr_proportions = 2,
		name = "Instigator:",
		name_proportions = 1,
		options = managers.mission:area_instigator_categories(),
		panel = panel,
		sizer = panel_sizer,
		sorted = false,
		tooltip = "Select an instigator type for the area",
		value = self._hed.instigator,
	}
	local instigator = CoreEWS.combobox(instigator_params)

	instigator:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {
		ctrlr = instigator,
		value = "instigator",
	})
	instigator:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_instigator_changed"), {
		ctrlr = instigator,
	})
	self:_build_value_checkbox(panel, panel_sizer, "invert", "Check this to have the rule inverted, i.e. exclude one unit from triggering the connected element", "Invert rule")

	self._rules_panel = EWS:Panel(panel, "rules_panel", "TAB_TRAVERSAL")
	self._rules_panel_sizer = EWS:BoxSizer("VERTICAL")

	self._rules_panel:set_sizer(self._rules_panel_sizer)
	self._rules_panel:destroy_children()
	panel_sizer:add(self._rules_panel, 1, 1, "EXPAND")
	self:_update_rules_panel()
end

function InstigatorRuleUnitElement:_update_rules_panel(panel, panel_sizer)
	panel = self._rules_panel
	panel_sizer = self._rules_panel_sizer

	self._rules_panel:destroy_children()

	local instigator = self._hed.instigator

	if instigator == "player" then
		local states_params = {
			name = "Player states:",
			options = managers.player:player_states(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select player state rules",
			updated_callback = callback(self, self, "_rule_updated", "states"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].states,
		}
		local states = CoreEws.list_selector(states_params)
		local carry_ids_params = {
			name = "Carry ids:",
			options = tweak_data.carry:get_carry_ids(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select player carry ids rules",
			updated_callback = callback(self, self, "_rule_updated", "carry_ids"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].carry_ids,
		}
		local states = CoreEws.list_selector(carry_ids_params)
		local options = {}

		for name, _ in pairs(tweak_data.equipments.specials) do
			table.insert(options, name)
		end

		local mission_equipment_params = {
			name = "Mission equipment:",
			options = options,
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select player mission equipment rules",
			updated_callback = callback(self, self, "_rule_updated", "mission_equipment"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].mission_equipment,
		}
		local states = CoreEws.list_selector(mission_equipment_params)
	elseif instigator == "enemies" then
		local carry_ids_params = {
			name = "Enemy name:",
			options = managers.enemy:enemy_units(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select enemy names rules",
			updated_callback = callback(self, self, "_rule_updated", "enemy_names"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].enemy_names,
		}
		local states = CoreEws.list_selector(carry_ids_params)
		local pickups_params = {
			name = "Pickup:",
			options = PickupUnitElement.get_options(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select a pickup rule",
			updated_callback = callback(self, self, "_rule_updated", "pickup"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].pickup,
		}
		local pickup = CoreEws.list_selector(pickups_params)
	elseif instigator == "civilians" then
		local civilian_names_params = {
			name = "Civilian name:",
			options = SpawnCivilianUnitElement._options,
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select civilian names rules",
			updated_callback = callback(self, self, "_rule_updated", "civilian_names"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].civilian_names,
		}
		local states = CoreEws.list_selector(civilian_names_params)
		local pickups_params = {
			name = "Pickup:",
			options = PickupUnitElement.get_options(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select a pickup rule",
			updated_callback = callback(self, self, "_rule_updated", "pickup"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].pickup,
		}
		local pickup = CoreEws.list_selector(pickups_params)
	elseif instigator == "loot" then
		local params = {
			name = "Carry ids:",
			options = tweak_data.carry:get_carry_ids(),
			panel = panel,
			sizer = panel_sizer,
			tooltip = "Select a loot carry id rule",
			updated_callback = callback(self, self, "_rule_updated", "carry_ids"),
			value = self._hed.rules[instigator] and self._hed.rules[instigator].carry_ids,
		}
		local list = CoreEws.list_selector(params)
	end

	self._rules_panel:layout()
	self._panel:layout()
	managers.editor:layer("Mission"):do_layout()
end
