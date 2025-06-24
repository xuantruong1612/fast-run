local M = {}

-- System check
local uname = vim.loop.os_uname()
local os_name = uname.sysname:lower()

local is_windows = os_name:find("windows") ~= nil
local is_linux = os_name:find("linux") ~= nil
local is_macos = os_name:find("darwin") ~= nil

function M.get_run_command(filetype, fullpath, dir, filename_noext)
	local output_path = string.format("%s/%s", dir, filename_noext)
	------------------------------------------------------------
	if filetype == "c" then
		if is_windows then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread && "%s"', output_path, fullpath, output_path)
		elseif is_linux then
			return string.format(
				'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
				output_path,
				fullpath,
				output_path
			)
		elseif is_macos then
			return string.format('term clang -o "%s" "%s" -lm && "%s"', output_path, fullpath, output_path)
		end
	------------------------------------------------------------
	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)
	------------------------------------------------------------
	elseif filetype == "python" then
		local py = is_windows and "python" or "python3"
		return string.format('term %s "%s"', py, fullpath)
	------------------------------------------------------------
	elseif filetype == "java" then
		-- Tự động lấy package từ đầu file
		local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
		local pkg = ""
		for _, line in ipairs(lines) do
			local m = line:match("^%s*package%s+([%w%.]+)%s*;")
			if m then
				pkg = m
				break
			end
		end
		local file = vim.fn.expand("%:t:r")
		local classname = pkg ~= "" and (pkg .. "." .. file) or file

		local src_dir = dir
		local project_root = vim.fn.fnamemodify(src_dir, ":h")
		local src_path = project_root .. "/src"
		local test_path = project_root .. "/test"
		local bin_path = project_root .. "/bin"

		if is_windows then
			return string.format(
				[[term mkdir "%s" && powershell -Command "Get-ChildItem -Recurse -Filter *.java -Path '%s','%s' | ForEach-Object { $_.FullName } | javac -d '%s' -" && java -cp "%s" "%s"]],
				bin_path,
				src_path,
				test_path,
				bin_path,
				bin_path,
				classname
			)
		else
			return string.format(
				[[term mkdir -p "%s" && find "%s" "%s" -name "*.java" | xargs javac -d "%s" && java -cp "%s" "%s"]],
				bin_path,
				src_path,
				test_path,
				bin_path,
				bin_path,
				classname
			)
		end
	------------------------------------------------------------
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', fullpath)
	end

	return nil
end

return M
