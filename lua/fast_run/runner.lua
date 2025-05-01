local M = {}

-- Lưu danh sách custom command
local custom_commands = {}

function M.set_custom_commands(commands)
	custom_commands = commands or {}
end

function M.get_run_command()
	local filetype = vim.bo.filetype
	local fullpath = vim.fn.expand("%:p") -- Đường dẫn đầy đủ
	local dir = vim.fn.expand("%:p:h") -- Thư mục chứa file
	local filename_noext = vim.fn.expand("%:t:r") -- Tên file không đuôi

	-- Ưu tiên custom
	if custom_commands[filetype] then
		local cmd = custom_commands[filetype]
		return string.format(cmd, fullpath, dir, filename_noext)
	end

	-- Mặc định
	if filetype == "c" then
		return string.format(
			'gcc -o "%s/%s" "%s" -lm -lpthread -ldl -lrt && "%s/%s"',
			dir,
			filename_noext,
			fullpath,
			dir,
			filename_noext
		)
	elseif filetype == "cpp" then
		return string.format('g++ -o "%s/%s" "%s" && "%s/%s"', dir, filename_noext, fullpath, dir, filename_noext)
	elseif filetype == "python" then
		return string.format('python3 "%s"', fullpath)
	elseif filetype == "java" then
		return string.format('javac "%s" && cd "%s" && java "%s"', fullpath, dir, filename_noext)
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('node "%s"', fullpath)
	elseif filetype == "go" then
		return string.format('go run "%s"', fullpath)
	elseif filetype == "rust" or filetype == "rs" then
		return string.format('cargo run --manifest-path "%s/Cargo.toml"', dir)
	end

	return nil -- Không hỗ trợ
end

return M
