MenuNodeStatsGui = MenuNodeStatsGui or class(MenuNodeGui)

function MenuNodeStatsGui:init(node, layer, parameters)
	MenuNodeStatsGui.super.init(self, node, layer, parameters)

	self._stats_items = {}

	self:_setup_stats(node)
end

function MenuNodeStatsGui:_setup_panels(node)
	MenuNodeStatsGui.super._setup_panels(self, node)

	local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
end

function MenuNodeStatsGui:_setup_stats(node)
	self:_add_stats({
		type = "text",
		data = managers.experience:total_cash_string(),
		topic = managers.localization:text("menu_stats_money"),
	})
	self:_add_stats({
		type = "progress",
		data = managers.experience:current_level() / managers.experience:level_cap(),
		text = "" .. managers.experience:current_level() .. "/" .. managers.experience:level_cap(),
		topic = managers.localization:text("menu_stats_level_progress"),
	})
	self:_add_stats({
		type = "text",
		data = managers.statistics:time_played() .. " " .. managers.localization:text("menu_stats_time"),
		topic = managers.localization:text("menu_stats_time_played"),
	})
	self:_add_stats({
		type = "text",
		data = string.upper(managers.statistics:favourite_level()),
		topic = managers.localization:text("menu_stats_favourite_campaign"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. managers.statistics:total_completed_campaigns(),
		topic = managers.localization:text("menu_stats_total_completed_campaigns"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. managers.statistics:total_completed_objectives(),
		topic = managers.localization:text("menu_stats_total_completed_objectives"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. string.upper(managers.statistics:favourite_weapon()),
		topic = managers.localization:text("menu_stats_favourite_weapon"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. managers.statistics:hit_accuracy() .. "%",
		topic = managers.localization:text("menu_stats_hit_accuracy"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. managers.statistics:total_kills(),
		topic = managers.localization:text("menu_stats_total_kills"),
	})
	self:_add_stats({
		type = "text",
		data = "" .. managers.statistics:total_head_shots(),
		topic = managers.localization:text("menu_stats_total_head_shots"),
	})

	if _G.IS_PC then
		local y = 30

		for _, panel in ipairs(self._stats_items) do
			y = y + panel:h() + self.spacing
		end

		local safe_rect = managers.viewport:get_safe_rect_pixels()
		local panel = self._item_panel_parent:panel({
			y = y,
		})
		local text = panel:text({
			align = "center",
			halign = "center",
			vertical = "center",
			y = 0,
			color = self.row_item_color,
			font = self.font,
			font_size = tweak_data.menu.stats_font_size,
			layer = self.layers.items,
			render_template = Idstring("VertexColorTextured"),
			text = managers.localization:text("menu_visit_more_stats"),
			w = safe_rect.width,
			x = safe_rect.x,
		})
		local _, _, _, h = text:text_rect()

		text:set_h(h)
		panel:set_h(h)
	end
end

function MenuNodeStatsGui:_add_stats(params)
	local y = 0

	for _, panel in ipairs(self._stats_items) do
		y = y + panel:h() + self.spacing
	end

	local panel = self._item_panel_parent:panel({
		y = y,
	})
	local topic = panel:text({
		align = "right",
		halign = "right",
		vertical = "center",
		x = 0,
		y = 0,
		color = self.row_item_color,
		font = self.font,
		font_size = tweak_data.menu.stats_font_size,
		layer = self.layers.items,
		render_template = Idstring("VertexColorTextured"),
		text = params.topic,
		w = self:_left_align(),
	})
	local x, y, w, h = topic:text_rect()

	topic:set_h(h)
	panel:set_h(h)

	if params.type == "text" then
		local text = panel:text({
			align = "left",
			halign = "left",
			vertical = "center",
			y = 0,
			color = self.color,
			font = self.font,
			font_size = tweak_data.menu.stats_font_size,
			h = h,
			layer = self.layers.items,
			render_template = Idstring("VertexColorTextured"),
			text = params.data,
			x = self:_right_align(),
		})
	end

	if params.type == "progress" then
		local bg = panel:rect({
			align = "center",
			h = 22,
			halign = "center",
			vertical = "center",
			w = 256,
			color = Color.black:with_alpha(0.5),
			layer = self.layers.items - 1,
			x = self:_right_align(),
			y = h / 2 - 11,
		})
		local bar = panel:gradient({
			align = "center",
			halign = "center",
			orientation = "vertical",
			vertical = "center",
			gradient_points = {
				0,
				Color(1, 1, 0.6588235294117647, 0),
				1,
				Color(1, 0.6039215686274509, 0.4, 0),
			},
			h = bg:h() - 4,
			layer = self.layers.items,
			w = (bg:w() - 4) * params.data,
			x = self:_right_align() + 2,
			y = bg:y() + 2,
		})
		local text = panel:text({
			align = "center",
			halign = "center",
			valign = "center",
			vertical = "center",
			y = 0,
			color = self.color,
			font = self.font,
			font_size = tweak_data.menu.stats_font_size,
			h = h,
			layer = self.layers.items + 1,
			render_template = Idstring("VertexColorTextured"),
			text = params.text or "" .. math.floor(params.data * 100) .. "%",
			w = bg:w(),
			x = self:_right_align(),
		})
	end

	table.insert(self._stats_items, panel)
end

function MenuNodeStatsGui:_create_menu_item(row_item)
	MenuNodeStatsGui.super._create_menu_item(self, row_item)
end

function MenuNodeStatsGui:_setup_item_panel_parent(safe_rect)
	MenuNodeStatsGui.super._setup_item_panel_parent(self, safe_rect)
end

function MenuNodeStatsGui:_setup_item_panel(safe_rect, res)
	MenuNodeStatsGui.super._setup_item_panel(self, safe_rect, res)
end

function MenuNodeStatsGui:resolution_changed()
	MenuNodeStatsGui.super.resolution_changed(self)
end
