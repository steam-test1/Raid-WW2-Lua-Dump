InputTweakData = InputTweakData or class()

function InputTweakData:init(tweak_data)
	self.gamepad = {
		aim_assist_gradient_max = 0.8,
		aim_assist_gradient_max_distance = 3000,
		aim_assist_gradient_min = 0.6,
		aim_assist_look_speed = 20,
		aim_assist_move_speed = 10,
		aim_assist_move_th_max = 0.9,
		aim_assist_move_th_min = 0.1,
		aim_assist_snap_speed = 200,
		aim_assist_use_sticky_aim = true,
		look_speed_dead_zone = 0.02,
		look_speed_fast = 340,
		look_speed_standard = 110,
		look_speed_steel_sight = 60,
		look_speed_transition_occluder = 0.95,
		look_speed_transition_to_fast = 0.55,
		look_speed_transition_zone = 0.95,
		uses_keyboard = true,
	}
	self.controller_buttons = {}
	self.controller_buttons.xb1 = {
		a = utf8.char(57344),
		b = utf8.char(57345),
		back = utf8.char(57348),
		d_down = utf8.char(57358),
		d_left = utf8.char(57360),
		d_right = utf8.char(57361),
		d_up = utf8.char(57359),
		left_shoulder = utf8.char(57352),
		left_thumb = utf8.char(57356),
		left_trigger = utf8.char(57354),
		right_shoulder = utf8.char(57353),
		right_thumb = utf8.char(57357),
		right_trigger = utf8.char(57355),
		start = utf8.char(57349),
		stick_l = utf8.char(57350),
		stick_r = utf8.char(57351),
		x = utf8.char(57346),
		y = utf8.char(57347),
	}
	self.controller_buttons.ps4 = {
		a = utf8.char(57444),
		b = utf8.char(57445),
		back = utf8.char(57448),
		d_down = utf8.char(57458),
		d_left = utf8.char(57460),
		d_right = utf8.char(57461),
		d_up = utf8.char(57459),
		left_shoulder = utf8.char(57452),
		left_thumb = utf8.char(57456),
		left_trigger = utf8.char(57454),
		right_shoulder = utf8.char(57453),
		right_thumb = utf8.char(57457),
		right_trigger = utf8.char(57455),
		start = utf8.char(57449),
		stick_l = utf8.char(57450),
		stick_r = utf8.char(57451),
		x = utf8.char(57446),
		y = utf8.char(57447),
	}

	local function valid_range(data, var, b, c, ex_b, ex_c)
		local a = data[var]
		local valid = true

		if not ex_b then
			valid = valid and b <= a
		else
			valid = valid and b < a
		end

		if not ex_c then
			valid = valid and a <= c
		else
			valid = valid and a < c
		end

		if not valid then
			Application:error("" .. var .. " value is " .. a .. " it should be in the range [" .. b .. (ex_b and "<" or "<=") .. var .. (ex_c and "<" or "<=") .. c .. "]")
		end
	end

	valid_range(self.gamepad, "look_speed_dead_zone", 0, 1, true, false)
	valid_range(self.gamepad, "look_speed_transition_zone", 0, 1, true, true)
	valid_range(self.gamepad, "look_speed_transition_occluder", 0, 1, true, true)
	valid_range(self.gamepad, "aim_assist_gradient_min", 0, 1, false, false)
	valid_range(self.gamepad, "aim_assist_gradient_max", 0, 1, false, false)
	valid_range(self.gamepad, "aim_assist_move_th_min", 0, 1, false, false)
	valid_range(self.gamepad, "aim_assist_move_th_max", 0, 1, false, false)
	print("[InputTweakData] Init")
end
