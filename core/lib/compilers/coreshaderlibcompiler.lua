require("core/lib/compilers/CoreCompilerSystem")

CoreShaderLibCompiler = CoreShaderLibCompiler or class()
CoreShaderLibCompiler.SHADER_NAME = "base"
CoreShaderLibCompiler.TEMP_PATH = "core\\temp\\"
CoreShaderLibCompiler.SHADER_PATH = "core\\shader_sources\\"
CoreShaderLibCompiler.RT_PATH = "shaders\\"
CoreShaderLibCompiler.ROOT_PATH = "..\\"

function CoreShaderLibCompiler:compile(file, dest, force_recompile)
	if file.name ~= "shaders/base" or file.type ~= "render_template_database" then
		return false
	end

	if not force_recompile and self:up_to_date(file, dest) then
		dest:skip_update("render_template_database", file.name, file.properties)

		if target() == "win32" then
			dest:skip_update("shaders", "core/temp/" .. self.SHADER_NAME, {
				"d3d11",
			})
		elseif target() == "ps4" then
			dest:skip_update("shaders", "core/temp/" .. self.SHADER_NAME, {})
		elseif target() == "xb1" then
			dest:skip_update("shaders", "core/temp/" .. self.SHADER_NAME, {})
		else
			error("[CoreShaderLibCompiler] Unknown target: " .. target())
		end

		return true
	end

	cat_print("debug", "[CoreShaderLibCompiler] Compiling: " .. file.path)

	local params = self:create_make_file()

	self:run_compiler()

	if target() == "win32" then
		self:copy_file(self:base_path() .. self.TEMP_PATH .. self.SHADER_NAME .. ".d3d11.win32.shaders", "core/temp/" .. self.SHADER_NAME, {
			"d3d11",
		}, dest)
	elseif target() == "ps4" then
		self:copy_file(self:base_path() .. self.TEMP_PATH .. self.SHADER_NAME .. ".ps4.shaders", "core/temp/" .. self.SHADER_NAME, {}, dest)
	elseif target() == "xb1" then
		self:copy_file(self:base_path() .. self.TEMP_PATH .. self.SHADER_NAME .. ".xb1.shaders", "core/temp/" .. self.SHADER_NAME, {}, dest)
	else
		error("[CoreShaderLibCompiler] Unknown target: " .. target())
	end

	self:cleanup(params)

	return false
end

function CoreShaderLibCompiler:cleanup(params)
	cat_print("debug", "[CoreShaderLibCompiler] Cleaning...")
end

function CoreShaderLibCompiler:base_path()
	return self:root_path() .. "assets\\"
end

function CoreShaderLibCompiler:root_path()
	local path = data_path_abs() .. self.ROOT_PATH
	local f

	function f(s)
		local str, i = string.gsub(s, "\\[%w_%.%s]+\\%.%.\\", "\\")

		return i > 0 and f(str) or str
	end

	local out_path = f(path)

	if string.sub(out_path, -1) ~= "\\" then
		out_path = out_path .. "\\"
	end

	return out_path
end

function CoreShaderLibCompiler:up_to_date(file, dest)
	return dest:up_to_date(file.path, "render_template_database", file.name, file.properties) and dest:up_to_date("core\\shader_sources\\base", "shader_source", "core/shader_sources/base", {}) and dest:up_to_date("core\\shader_sources\\common_include", "shader_source", "core/shader_sources/common_include", {})
end

function CoreShaderLibCompiler:copy_file(from, to, properties, dest)
	local from_file = io.open(from, "rb")

	if from_file then
		local archive = dest:update("shaders", to, properties)
		local bin_str = from_file:read("*a")

		archive:write(bin_str)
		archive:close()
		from_file:close()
	elseif from:find(" ") then
		error(string.format("[CoreShaderLibCompiler] %s was not compiled! Your project path has a space in it (engine doesn't support spaces yet).", from))
	else
		cat_print("debug", string.format("[CoreShaderLibCompiler] %s was not compiled! You might be missing dll's...?.", from))
	end
end

function CoreShaderLibCompiler:create_make_file()
	local make_params = self:get_make_params()
	local file = assert(io.open(self:base_path() .. self.TEMP_PATH .. "make.xml", "w+"))

	file:write("<make>\n")
	file:write("\t<silent_fail/>\n")
	file:write("\t<rebuild/>\n")
	file:write("\t<file_io\n")

	for k, v in pairs(make_params) do
		file:write("\t\t" .. k .. "=\"" .. string.gsub(v, "/", "\\") .. "\"\n")
	end

	file:write("\t/>\n</make>\n")
	file:close()

	return make_params
end

function CoreShaderLibCompiler:run_compiler()
	local cmd = string.format("%saux_assets\\engine\\bin\\shaderdev\\shaderdev -m \"%s%smake.xml\"", self:root_path(), self:base_path(), self.TEMP_PATH)
	local file = assert(io.popen(cmd, "r"), cmd)

	for line in file:lines() do
		cat_print("debug", line)
	end
end

function CoreShaderLibCompiler:get_make_params()
	local rt = self:base_path() .. self.RT_PATH .. self.SHADER_NAME
	local src = self:base_path() .. self.SHADER_PATH .. self.SHADER_NAME
	local tmp = self:base_path() .. self.TEMP_PATH
	local make_params = {}

	make_params.source = src .. ".shader_source"
	make_params.working_directory = tmp
	make_params.render_templates = rt .. ".render_template_database"

	if target() == "win32" then
		make_params.win32d3d11 = tmp .. self.SHADER_NAME .. ".d3d11.win32.shaders"
		make_params.ogl = tmp .. self.SHADER_NAME .. ".ogl.win32.shaders"
		make_params.ps4 = ""
		make_params.xb1 = ""
	elseif target() == "ps4" then
		make_params.win32d3d11 = ""
		make_params.ogl = ""
		make_params.ps4 = tmp .. self.SHADER_NAME .. ".ps4.shaders"
		make_params.xb1 = ""
	elseif target() == "xb1" then
		make_params.win32d3d11 = ""
		make_params.ogl = ""
		make_params.ps4 = ""
		make_params.xb1 = tmp .. self.SHADER_NAME .. ".xb1.shaders"
	else
		error("[CoreShaderLibCompiler] Unknown target: " .. target())
	end

	return make_params
end
