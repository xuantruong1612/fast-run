local M = {}

-- System check
local uname = vim.loop.os_uname()
local os_name = uname.sysname:lower()

local is_windows = os_name:find("windows") ~= nil
local is_linux = os_name:find("linux") ~= nil
local is_macos = os_name:find("darwin") ~= nil

function M.get_run_command(filetype, fullpath, dir, filename_noext)
	local output_path = string.format("%s/%s", dir, filename_noext)

	if filetype == "c" then
		if is_windows then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread && "%s"', output_path, fullpath, output_path)
		elseif is_linux then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"', output_path, fullpath, output_path)
		elseif is_macos then
			return string.format('term clang -o "%s" "%s" -lm && "%s"', output_path, fullpath, output_path)
		end

	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)

	elseif filetype == "python" then
		local py = is_windows and "python" or "python3"
		return string.format('term %s "%s"', py, fullpath)

	elseif filetype == "java" then
		-- Dùng java class name không có .java
		return string.format('term javac "%s" && cd "%s" && java "%s"', fullpath, dir, filename_noext)

	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', fullpath)
	end

	return nil
end

return M
