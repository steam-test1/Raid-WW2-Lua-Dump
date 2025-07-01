HUDNameVehicleLabel = HUDNameVehicleLabel or class(HUDNameLabel)

function HUDNameVehicleLabel:init(hud, params)
	self._vehicle_name = params.vehicle_name
	self._vehicle_unit = params.vehicle_unit
	self._id = params.id

	self:_create_panel(hud)
	self:_create_name()
end

function HUDNameVehicleLabel:_create_panel(hud)
	self._object = hud.panel:panel({
		h = HUDNameLabel.H,
		name = "vehicle_name_label_" .. self._vehicle_name,
		w = HUDNameLabel.W,
	})
end

function HUDNameVehicleLabel:_create_name()
	local tabs_texture = "guis/textures/pd2/hud_tabs"
	local bag_rect = {
		2,
		34,
		20,
		17,
	}
	local crim_color = tweak_data.chat_colors[1]
	local text = self._object:text({
		align = "left",
		h = 25,
		layer = -1,
		name = "text",
		vertical = "top",
		w = 256,
		color = crim_color,
		font = HUDNameLabel.PLAYER_NAME_FONT,
		font_size = HUDNameLabel.PLAYER_NAME_FONT_SIZE,
		text = utf8.to_upper(self._vehicle_name),
	})
	local bag = self._object:bitmap({
		layer = 0,
		name = "bag",
		visible = false,
		x = 1,
		y = 1,
		color = (crim_color * 1.1):with_alpha(1),
		texture = tabs_texture,
		texture_rect = bag_rect,
	})
	local bag_number = self._object:text({
		align = "left",
		h = 18,
		layer = -1,
		name = "bag_number",
		vertical = "top",
		visible = false,
		w = 32,
		color = crim_color,
		font = HUDNameLabel.PLAYER_NAME_FONT,
		font_size = HUDNameLabel.PLAYER_NAME_FONT_SIZE,
		text = utf8.to_upper(""),
	})

	self._object:text({
		align = "center",
		h = 18,
		layer = -1,
		name = "cheater",
		visible = false,
		w = 256,
		color = tweak_data.screen_colors.pro_color,
		font = HUDNameLabel.PLAYER_NAME_FONT,
		font_size = HUDNameLabel.PLAYER_NAME_FONT_SIZE,
		text = utf8.to_upper(managers.localization:text("menu_hud_cheater")),
	})
	self._object:text({
		align = "left",
		h = 18,
		layer = -1,
		name = "action",
		rotation = 360,
		vertical = "bottom",
		visible = false,
		w = 256,
		color = (crim_color * 1.1):with_alpha(1),
		font = HUDNameLabel.PLAYER_NAME_FONT,
		font_size = HUDNameLabel.PLAYER_NAME_FONT_SIZE,
		text = utf8.to_upper("Fixing"),
	})
end

function HUDNameVehicleLabel:id()
	return self._id
end

function HUDNameVehicleLabel:panel()
	return self._object
end

function HUDNameVehicleLabel:destroy()
	self._object:clear()
	self._object:parent():remove(self._object)
end

function HUDNameVehicleLabel:show()
	self._object:set_visible(true)
end

function HUDNameVehicleLabel:hide()
	self._object:set_visible(false)
end
