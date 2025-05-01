local M = {}

local custom_commands = {}

function M.set_custom_commands(commands)
	custom_commands = commands
end

function M.get_run_command()
	local filetype = vim.bo.filetype
	local filepath = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local filename_noext = vim.fn.expand("%:t:r")
	local output_path = dir .. "/" .. filename_noext

	-- Ưu tiên custom command từ user
	if custom_commands[filetype] then
		return custom_commands[filetype](filepath)
	end

	-- Mặc định
	if filetype == "c" then
		return string.format(
			'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
			output_path,
			filepath,
			output_path
		)
	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, filepath, output_path)
	elseif filetype == "python" then
		return string.format('term python3 "%s"', filepath)
	elseif filetype == "java" then
		return string.format('term javac "%s" && cd "%s" && java "%s"', filepath, dir, filename_noext)
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', filepath)
	end

	return nil
end

return M
