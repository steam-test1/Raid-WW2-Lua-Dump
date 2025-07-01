core:module("SystemMenuManager")
require("lib/managers/dialogs/KeyboardInputDialog")

PS4KeyboardInputDialog = PS4KeyboardInputDialog or class(KeyboardInputDialog)

function PS4KeyboardInputDialog:show()
	local data = {}

	data.title = self:title()
	data.text = self:input_text()
	data.filter = self:filter()
	data.limit = self:max_count() or 0
	data.callback = callback(self, self, "done_callback")

	PS4:display_keyboard(data)

	local success = PS4:is_displaying_box()

	if success then
		self._manager:event_dialog_shown(self)
	end

	return success
end

function PS4KeyboardInputDialog:done_callback(input_text, success)
	KeyboardInputDialog.done_callback(self, success, input_text)
end
