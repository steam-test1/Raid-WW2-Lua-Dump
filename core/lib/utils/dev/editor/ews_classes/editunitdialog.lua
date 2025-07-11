core:import("CoreEditorUtils")

EditUnitDialog = EditUnitDialog or class(CoreEditorEwsDialog)

function EditUnitDialog:init(toolbar, btn)
	local styles = managers.editor:format_dialog_styles("DEFAULT_DIALOG_STYLE,RESIZE_BORDER,MINIMIZE_BOX")

	CoreEditorEwsDialog.init(self, nil, "Edit Unit", "", Vector3(300, 150, 0), Vector3(620, 410, 0), styles)
	self:create_panel("VERTICAL")
	self._dialog:set_min_size(Vector3(620, 410, 0))
	self._dialog:connect("EVT_CLOSE_WINDOW", callback(self, self, "dialog_closed"), "")
	self._dialog:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")

	self._pages = {}
	self._notebook = EWS:Notebook(self._panel, "", "NB_TOP,NB_MULTILINE")

	self._notebook:connect("EVT_KEY_DOWN", callback(self, self, "key_cancel"), "")
	self._panel_sizer:add(self._notebook, 1, 0, "EXPAND")
	self._dialog_sizer:add(self._panel, 1, 5, "EXPAND,ALL")
end

function EditUnitDialog:add_page(data)
	local name = data.name
	local start_page = data.start_page
	local class = data.class
	local panel = EWS:ScrolledWindow(self._notebook, "", "VSCROLL,TAB_TRAVERSAL")

	panel:set_scroll_rate(Vector3(0, 1, 0))
	panel:set_virtual_size_hints(Vector3(0, 0, 0), Vector3(1, -1, -1))

	local sizer = EWS:BoxSizer("VERTICAL")

	panel:set_sizer(sizer)

	local nr = self._notebook:add_page(panel, name, start_page)

	table.insert(self._pages, {
		class = class,
		name = name,
		nr = nr,
		panel = panel,
	})

	return panel, sizer
end

function EditUnitDialog:set_enabled(unit, units)
	for _, page in ipairs(self._pages) do
		if page.class then
			page.panel:set_enabled(true)
			page.panel:set_enabled(page.class:is_editable(unit, units))
			self._notebook:set_page_text(page.nr, page.panel:enabled() and page.name .. "*" or page.name)
		end
	end

	local title = "Edit Unit"

	if units and #units > 1 then
		title = "Edit Unit: " .. #units .. " selected units"
	elseif alive(unit) then
		local unit_name = self:_stripped_unit_name(unit:name():s())

		title = "Edit Unit: " .. unit_name
	end

	self._dialog:set_title(title)
end

function EditUnitDialog:_stripped_unit_name(name)
	local reverse = string.reverse(name)
	local i = string.find(reverse, "/")

	name = string.reverse(string.sub(reverse, 0, i - 1))

	return name
end

function EditUnitDialog:update(t, dt)
	local current_page = self:_current_page()

	if current_page then
		current_page.class:update(t, dt)
	end
end

function EditUnitDialog:_current_page()
	if not self._dialog:visible() then
		return nil
	end

	for i, page in ipairs(self._pages) do
		if self._notebook:get_current_page() == self._notebook:get_page(page.nr) then
			return page
		end
	end
end

function EditUnitDialog:dialog_closed(data, event)
	for _, page in ipairs(self._pages) do
		if page.class then
			page.class:dialog_closed()
		end
	end

	event:skip()
end

EditUnitBase = EditUnitBase or class()

function EditUnitBase:init()
	self._debug = false
	self._brush = Draw:brush()
	self._pen = Draw:pen()
end

function EditUnitBase:update()
	return
end

function EditUnitBase:dialog_closed()
	return
end

function EditUnitBase:update_debug(ctrlr)
	self._debug = ctrlr:get_value()
end
