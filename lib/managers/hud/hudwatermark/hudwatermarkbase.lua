HUDWatermarkBase = HUDWatermarkBase or class()
HUDWatermarkBase.W = 500
HUDWatermarkBase.H = 80
HUDWatermarkBase.Y = 134
HUDWatermarkBase.A = 0.5
HUDWatermarkBase.TITLE_FONT = tweak_data.gui.fonts.din_compressed_outlined_42
HUDWatermarkBase.TITLE_FONT_SIZE = tweak_data.gui.font_sizes.size_42
HUDWatermarkBase.TEXT_FONT = tweak_data.gui.fonts.din_compressed_outlined_32
HUDWatermarkBase.TEXT_FONT_SIZE = tweak_data.gui.font_sizes.size_32

function HUDWatermarkBase:init(hud)
	self.WATERMARK_TYPE = "unset"

	self:_create_panel(hud)
	self:_create_text()
end

function HUDWatermarkBase:_create_panel(hud)
	local panel_params = {
		h = HUDWatermarkBase.H,
		halign = "center",
		layer = 1000,
		name = "watermark_panel",
		valign = "center",
		w = HUDWatermarkBase.W,
	}

	self._object = hud.panel:panel(panel_params)

	self._object:set_left(0)
	self._object:set_bottom(hud.panel:h() - 120)
end

function HUDWatermarkBase:_create_text()
	local watermark_title = "wm_" .. self.WATERMARK_TYPE .. "_warning"
	local watermark_text = ""

	watermark_title = watermark_title or "wm_unset_warning"
	watermark_title = utf8.to_upper(managers.localization:text(watermark_title))
	self._wmtitle = self._object:text({
		align = "center",
		alpha = HUDWatermarkBase.A,
		font = HUDWatermarkBase.TITLE_FONT,
		font_size = HUDWatermarkBase.TITLE_FONT_SIZE,
		h = self._object:h(),
		halign = "scale",
		name = "watermark_title",
		text = watermark_title,
		valign = "scale",
		vertical = "top",
		w = self._object:w(),
	})
end
