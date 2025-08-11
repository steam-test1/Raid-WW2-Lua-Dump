core:module("CoreElementShape")
core:import("CoreShapeManager")
core:import("CoreMissionScriptElement")
core:import("CoreTable")

ElementShape = ElementShape or class(CoreMissionScriptElement.MissionScriptElement)

function ElementShape:init(...)
	ElementShape.super.init(self, ...)

	self._shapes = {}

	local new_shape

	if not self._values.shape_type or self._values.shape_type == "box" then
		new_shape = CoreShapeManager.ShapeBoxMiddle:new({
			depth = self._values.depth,
			height = self._values.height,
			position = self._values.position,
			rotation = self._values.rotation,
			width = self._values.width,
		})
	elseif self._values.shape_type == "cylinder" then
		new_shape = CoreShapeManager.ShapeCylinderMiddle:new({
			height = self._values.height,
			position = self._values.position,
			radius = self._values.radius,
			rotation = self._values.rotation,
		})
	elseif self._values.shape_type == "sphere" then
		new_shape = CoreShapeManager.ShapeSphere:new({
			position = self._values.position,
			radius = self._values.radius,
			rotation = self._values.rotation,
		})
	elseif self._values.shape_type == "unit" then
		self._shape_units = {}

		for _, id in ipairs(self._values.unit_ids) do
			local unit

			if Application:editor() then
				unit = managers.editor:layer("Statics"):created_units_pairs()[id]
			else
				unit = self._mission_script:worlddefinition():get_unit_by_id(id)
			end

			if unit then
				table.insert(self._shape_units, unit)
			end
		end
	end

	if new_shape then
		self:_add_shape(new_shape)
	end
end

function ElementShape:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

function ElementShape:_add_shape(shape)
	table.insert(self._shapes, shape)
end

function ElementShape:get_shapes()
	return self._shapes
end

function ElementShape:is_inside_shape(pos)
	for _, shape in ipairs(self._shapes) do
		if shape:is_inside(pos) then
			return true
		end
	end

	if self._shape_units then
		for _, unit in ipairs(self._shape_units) do
			if alive(unit) then
				local data = unit:unit_data()
				local oobb

				if data and data._object_oobb then
					local object = unit:get_object(Idstring(data._object_oobb))

					oobb = object:oobb()
				else
					oobb = unit:oobb()
				end

				if self._values.grow then
					oobb:grow(self._values.grow)
				end

				if oobb:point_inside(pos) then
					return true
				end
			end
		end
	end

	return false
end

function ElementShape:client_on_executed(...)
	return
end
