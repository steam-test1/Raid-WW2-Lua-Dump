DLCManager = DLCManager or class()
DLCManager.PLATFORM_CLASS_MAP = {}

function DLCManager:new(...)
	local platform = SystemInfo:platform()

	return (self.PLATFORM_CLASS_MAP[platform:key()] or GenericDLCManager):new(...)
end

GenericDLCManager = GenericDLCManager or class()

function GenericDLCManager:init()
	self._debug_on = Application:production_build()

	self:_set_dlc_save_table()
end

function GenericDLCManager:_set_dlc_save_table()
	if not Global.dlc_save then
		Global.dlc_save = {
			packages = {},
		}
	end
end

function GenericDLCManager:setup()
	self:_create_achievement_locked_content_table()
end

function GenericDLCManager:_create_achievement_locked_content_table()
	self._achievement_locked_content = {}
	self._dlc_locked_content = {}

	for name, dlc in pairs(tweak_data.dlc.descriptions) do
		local content = dlc.content

		if content then
			local loot_drops = content.loot_drops

			if loot_drops then
				for _, loot_drop in ipairs(loot_drops) do
					if loot_drop.type_items then
						if dlc.achievement_id then
							self._achievement_locked_content[loot_drop.type_items] = self._achievement_locked_content[loot_drop.type_items] or {}
							self._achievement_locked_content[loot_drop.type_items][loot_drop.item_entry] = name
						else
							self._dlc_locked_content[loot_drop.type_items] = self._dlc_locked_content[loot_drop.type_items] or {}
							self._dlc_locked_content[loot_drop.type_items][loot_drop.item_entry] = name
						end
					end
				end
			end
		end
	end
end

function GenericDLCManager:achievement_locked_content()
	return self._achievement_locked_content
end

function GenericDLCManager:on_tweak_data_reloaded()
	self:setup()
end

function GenericDLCManager:init_finalize()
	managers.savefile:add_load_sequence_done_callback_handler(callback(self, self, "_load_done"))
end

function GenericDLCManager:chk_content_updated()
	return
end

function GenericDLCManager:give_dlc_and_verify_blackmarket()
	self:give_dlc_package()

	if managers.blackmarket then
		managers.blackmarket:verify_dlc_items()
	else
		Application:error("[GenericDLCManager] _load_done(): BlackMarketManager not yet initialized!")
	end
end

function GenericDLCManager:_load_done(...)
	self:give_dlc_and_verify_blackmarket()
end

function GenericDLCManager:give_dlc_package()
	for package_id, data in pairs(tweak_data.dlc.descriptions) do
		if self:is_dlc_unlocked(package_id) then
			local identifier = UpgradesManager.AQUIRE_STRINGS[5] .. tostring(package_id)

			for _, upgrade in ipairs(data.content.upgrades or {}) do
				if not managers.upgrades:aquired(upgrade, identifier) then
					managers.upgrades:aquire_default(upgrade, identifier)
				end
			end
		else
			local identifier = UpgradesManager.AQUIRE_STRINGS[5] .. tostring(package_id)

			for _, upgrade in ipairs(data.content.upgrades or {}) do
				if managers.upgrades:aquired(upgrade, identifier) then
					managers.upgrades:unaquire(upgrade, identifier)
				end
			end
		end
	end
end

function GenericDLCManager:list_dlc_package(dlcs)
	local t = {}

	for package_id, data in pairs(tweak_data.dlc.descriptions) do
		if not dlcs or dlcs[package_id] or table.contains(dlcs, package_id) then
			for _, loot_drop in ipairs(data.content.loot_drops or {}) do
				t.items = t.items or {}

				if #loot_drop > 0 then
					-- block empty
				else
					local global_value = loot_drop.global_value or data.content.loot_global_value or package_id
					local category = loot_drop.type_items
					local entry = loot_drop.item_entry
					local amount = loot_drop.amount

					table.insert(t.items, {
						global_value,
						category,
						entry,
						amount,
					})
				end
			end

			for _, upgrade in ipairs(data.content.upgrades or {}) do
				t.upgrades = t.upgrades or {}

				table.insert(t.upgrades, upgrade)
			end
		end
	end

	return t
end

function GenericDLCManager:save(data)
	data.dlc_save = Global.dlc_save
end

function GenericDLCManager:load(data)
	if data.dlc_save and data.dlc_save.packages then
		Global.dlc_save = data.dlc_save
	end
end

function GenericDLCManager:on_reset_profile()
	Global.dlc_save = nil

	self:_set_dlc_save_table()
	self:give_dlc_package()
end

function GenericDLCManager:on_achievement_award_loot()
	Application:debug("GenericDLCManager:on_achievement_award_loot()")
	self:give_dlc_package()
end

function GenericDLCManager:on_signin_complete()
	return
end

function GenericDLCManager:are_all_dlcs_unlocked(list_of_dlcs)
	for _, dlc in ipairs(list_of_dlcs) do
		if not self:is_dlc_unlocked(dlc) then
			return false
		end
	end

	return true
end

function GenericDLCManager:is_any_dlc_unlocked(list_of_dlcs)
	for _, dlc in ipairs(list_of_dlcs) do
		if self:is_dlc_unlocked(dlc) then
			return true
		end
	end

	return false
end

function GenericDLCManager:is_dlc_unlocked(dlc)
	return tweak_data.dlc.descriptions[dlc] and tweak_data.dlc.descriptions[dlc].free or self:has_dlc(dlc)
end

function GenericDLCManager:has_dlc(dlc)
	local dlc_description = tweak_data.dlc.descriptions[dlc]

	if dlc_description and dlc_description.dlc then
		if self[dlc_description.dlc] then
			return self[dlc_description.dlc](self, dlc_description)
		else
			Application:error("Didn't have dlc has function for", dlc, "has_dlc()", dlc_description.dlc)
			Application:stack_dump()
		end
	end

	local dlc_data = Global.dlc_manager.all_dlc_data[dlc]

	if not dlc_data then
		Application:error("Didn't have dlc data for", dlc)

		return false
	end

	return dlc_data.verified
end

function GenericDLCManager:has_full_game()
	return Global.dlc_manager.all_dlc_data.full_game.verified
end

function GenericDLCManager:is_trial()
	return not self:has_full_game()
end

function GenericDLCManager:dlcs_string()
	local s = ""

	s = s .. (self:is_dlc_unlocked("preorder") and "preorder " or "")

	return s
end

function GenericDLCManager:has_corrupt_data()
	return self._has_corrupt_data
end

function GenericDLCManager:has_all_dlcs()
	return true
end

function GenericDLCManager:has_preorder()
	return Global.dlc_manager.all_dlc_data.preorder and Global.dlc_manager.all_dlc_data.preorder.verified
end

function GenericDLCManager:has_achievement(data)
	local achievement = managers.achievment and data and data.achievement_id and managers.achievment:get_info(data.achievement_id)

	return achievement and achievement.awarded or false
end

PS4DLCManager = PS4DLCManager or class(GenericDLCManager)
DLCManager.PLATFORM_CLASS_MAP[Idstring("PS4"):key()] = PS4DLCManager
PS4DLCManager.SERVICE_ID = "EP4040-BLES01902_00"

function PS4DLCManager:init()
	PS4DLCManager.super.init(self)

	if not Global.dlc_manager then
		Global.dlc_manager = {}
		Global.dlc_manager.all_dlc_data = {
			full_game = {
				verified = true,
			},
			preorder = {
				verified = false,
			},
		}

		self:_verify_dlcs()
	end
end

function PS4DLCManager:_verify_dlcs()
	for dlc_name, dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
		if dlc_data.is_default or dlc_data.verified == true then
			dlc_data.verified = true
		else
			dlc_data.verified = PS4:has_entitlement(dlc_data.product_id)
		end
	end
end

function PS4DLCManager:_init_NPCommerce()
	local result = NPCommerce:init()

	print("init result", result)

	if not result then
		MenuManager:show_np_commerce_init_fail()
		NPCommerce:destroy()

		return
	end

	local result = NPCommerce:open(callback(self, self, "cb_NPCommerce"))

	print("open result", result)

	if result < 0 then
		MenuManager:show_np_commerce_init_fail()
		NPCommerce:destroy()

		return
	end

	return true
end

function PS4DLCManager:buy_full_game()
	print("[PS4DLCManager:buy_full_game]")

	if self._activity then
		return
	end

	if not self:_init_NPCommerce() then
		return
	end

	managers.menu:show_waiting_NPCommerce_open()

	self._request = {
		product = "full_game",
		type = "buy_product",
	}
	self._activity = {
		type = "open",
	}
end

function PS4DLCManager:buy_product(product_name)
	print("[PS4DLCManager:buy_product]", product_name)

	if self._activity then
		return
	end

	if not self:_init_NPCommerce() then
		return
	end

	managers.menu:show_waiting_NPCommerce_open()

	self._request = {
		product = product_name,
		type = "buy_product",
	}
	self._activity = {
		type = "open",
	}
end

function PS4DLCManager:cb_NPCommerce(result, info)
	print("[PS4DLCManager:cb_NPCommerce]", result, info)

	for i, k in pairs(info) do
		print(i, k)
	end

	self._NPCommerce_cb_results = self._NPCommerce_cb_results or {}

	print("self._activity", self._activity and inspect(self._activity))
	table.insert(self._NPCommerce_cb_results, {
		result,
		info,
	})

	if not self._activity then
		return
	elseif self._activity.type == "open" then
		if info.category_error or info.category_done == false then
			self._activity = nil

			managers.system_menu:close("waiting_for_NPCommerce_open")
			self:_close_NPCommerce()
		else
			managers.system_menu:close("waiting_for_NPCommerce_open")

			local product_id = Global.dlc_manager.all_dlc_data[self._request.product].product_id

			print("starting storebrowse", product_id)

			local ret = NPCommerce:storebrowse("product", product_id, true)

			if not ret then
				self._activity = nil

				managers.menu:show_NPCommerce_checkout_fail()
				self:_close_NPCommerce()
			end

			self._activity = {
				type = "browse",
			}
		end
	elseif self._activity.type == "browse" then
		if info.browse_succes then
			self._activity = nil

			managers.menu:show_NPCommerce_browse_success()
			self:_close_NPCommerce()
		elseif info.browse_back then
			self._activity = nil

			self:_close_NPCommerce()
		elseif info.category_error then
			self._activity = nil

			managers.menu:show_NPCommerce_browse_fail()
			self:_close_NPCommerce()
		end
	elseif self._activity.type == "checkout" then
		if info.checkout_error then
			self._activity = nil

			managers.menu:show_NPCommerce_checkout_fail()
			self:_close_NPCommerce()
		elseif info.checkout_cancel then
			self._activity = nil

			self:_close_NPCommerce()
		elseif info.checkout_success then
			self._activity = nil

			self:_close_NPCommerce()
		end
	end

	print("/[PS4DLCManager:cb_NPCommerce]")
end

function PS4DLCManager:_close_NPCommerce()
	print("[PS4DLCManager:_close_NPCommerce]")
	NPCommerce:destroy()
end

function PS4DLCManager:cb_confirm_purchase_yes(sku_data)
	NPCommerce:checkout(sku_data.skuid)
end

function PS4DLCManager:cb_confirm_purchase_no()
	self._activity = nil

	self:_close_NPCommerce()
end

XB1DLCManager = XB1DLCManager or class(GenericDLCManager)
DLCManager.PLATFORM_CLASS_MAP[Idstring("XB1"):key()] = XB1DLCManager

function XB1DLCManager:init()
	XB1DLCManager.super.init(self)

	if not Global.dlc_manager then
		Global.dlc_manager = {}
		Global.dlc_manager.all_dlc_data = {
			full_game = {
				index = 0,
				is_default = true,
				verified = true,
			},
			preorder = {
				index = 1,
				is_default = false,
				product_id = "123456",
			},
		}

		self:_verify_dlcs()
	end
end

function XB1DLCManager:_verify_dlcs()
	local dlc_content_updated = false
	local old_verified

	for dlc_name, dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
		old_verified = dlc_data.verified or false

		if dlc_data.is_default then
			dlc_data.verified = true
		else
			dlc_data.verified = XboxLive:check_dlc(dlc_data.product_id)
		end

		dlc_content_updated = dlc_content_updated or old_verified ~= dlc_data.verified
	end

	return dlc_content_updated
end

function XB1DLCManager:chk_content_updated()
	print("[XB1DLCManager:chk_content_updated]")

	if not managers.blackmarket:currently_customizing_mask() and self:_verify_dlcs() then
		print("[XB1DLCManager:chk_content_updated] content updated")

		if managers.experience and managers.upgrades then
			for level = 1, managers.experience:current_level() do
				managers.upgrades:aquire_from_level_tree(level, true)
				managers.upgrades:verify_level_tree(level, true)
			end
		end

		self:give_dlc_and_verify_blackmarket()
	end
end

function XB1DLCManager:on_signin_complete()
	self:chk_content_updated()
end

WINDLCManager = WINDLCManager or class(GenericDLCManager)
DLCManager.PLATFORM_CLASS_MAP[Idstring("WIN32"):key()] = WINDLCManager

function WINDLCManager:init()
	WINDLCManager.super.init(self)

	if not Global.dlc_manager then
		Global.dlc_manager = {}
		Global.dlc_manager.all_dlc_data = {
			full_game = {
				app_id = tostring(self:get_app_id()),
				external = true,
				no_install = true,
				verified = true,
			},
			official_soundtrack = {
				app_id = "720860",
				no_install = true,
			},
			preorder = {
				app_id = "707070",
				no_install = true,
			},
			raid_community = {
				no_install = true,
				source_id = "103582791460014708",
			},
			special_edition = {
				app_id = "707080",
				no_install = true,
			},
		}

		self:_verify_dlcs()
	end
end

function WINDLCManager:get_app_id()
	return 414740
end

function WINDLCManager:_check_dlc_data(dlc_data)
	if IS_STEAM then
		if dlc_data.app_id then
			if dlc_data.no_install then
				if Steam:is_product_owned(dlc_data.app_id) then
					return true
				end
			elseif Steam:is_product_installed(dlc_data.app_id) then
				return true
			end
		elseif dlc_data.source_id and Steam:is_user_in_source(Steam:userid(), dlc_data.source_id) then
			return true
		end
	end
end

function WINDLCManager:_verify_dlcs()
	for dlc_name, dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
		if not dlc_data.verified and self:_check_dlc_data(dlc_data) then
			dlc_data.verified = true
		end
	end
end

function WINDLCManager:chk_content_updated()
	for dlc_name, dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
		if not dlc_data.verified and self:_check_dlc_data(dlc_data) then
			managers.menu:show_dlc_require_restart()

			break
		end
	end
end
