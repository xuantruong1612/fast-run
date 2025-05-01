local M = {}
local config = require("fast-run.config")
local keymap = require("fast-run.keymap")

function M.register()
	vim.api.nvim_create_augroup("FastRunGroup", { clear = true })

	for lang, _ in pairs(config.supported_languages) do
		vim.api.nvim_create_autocmd("FileType", {
			group = "FastRunGroup",
			pattern = lang,
			callback = function()
				vim.keymap.set("n", "<leader>t", function()
					vim.cmd("w")

					local filetype = vim.bo.filetype
					local fullpath = vim.fn.expand("%:p")
					local dir = vim.fn.expand("%:p:h")
					local filename_noext = vim.fn.expand("%:t:r")
					local output_path = string.format("%s/%s", dir, filename_noext)
					local cmd

					vim.cmd("vertical rightbelow vsplit")
					vim.cmd("vertical resize 50")

					if filetype == "c" then
						cmd = string.format(
							'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
							output_path,
							fullpath,
							output_path
						)
					elseif filetype == "cpp" then
						cmd = string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)
					elseif filetype == "python" then
						cmd = string.format('term python3 "%s"', fullpath)
					elseif filetype == "java" then
						cmd = string.format('term javac "%s" && cd "%s" && java "%s"', fullpath, dir, filename_noext)
					elseif filetype == "javascript" or filetype == "js" then
						cmd = string.format('term node "%s"', fullpath)
					else
						print("No support file =))")
						return
					end

					vim.cmd(cmd)
					vim.cmd("startinsert")
					keymap.set_terminal_keymaps()
				end, { noremap = true, silent = true, buffer = true })
			end,
		})
	end
end

return M
