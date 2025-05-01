local M = {}

local custom_commands = {}

function M.set_custom_commands(commands)
	custom_commands = commands
end

function M.get_run_command()
	local ft = vim.bo.filetype
	local filepath = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local filename_noext = vim.fn.expand("%:t:r")
	local output_path = dir .. "/" .. filename_noext

	-- Ưu tiên dùng custom command
	if custom_commands[ft] then
		return custom_commands[ft](filepath)
	end

	-- Mặc định hỗ trợ
	if ft == "c" then
		return string.format(
			'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
			output_path,
			filepath,
			output_path
		)
	elseif ft == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, filepath, output_path)
	elseif ft == "python" then
		return 'term python3 "' .. filepath .. '"'
	elseif ft == "java" then
		return string.format('term javac "%s" && cd "%s" && java "%s"', filepath, dir, filename_noext)
	elseif ft == "javascript" or ft == "js" then
		return 'term node "' .. filepath .. '"'
	end

	return nil
end

return M
