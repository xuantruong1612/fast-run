local M = {}
local supported_languages = {}

function M.setup(opts)
	opts = opts or {}
	supported_languages = {}

	if opts.enable and type(opts.enable) == "table" then
		for _, lang in ipairs(opts.enable) do
			supported_languages[lang] = true
		end
	end

	-- Tạo autocmd theo từng filetype được enable
	vim.api.nvim_create_augroup("FastRunGroup", { clear = true })

	for lang, _ in pairs(supported_languages) do
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

					vim.api.nvim_buf_set_keymap(0, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
					vim.api.nvim_buf_set_keymap(0, "t", "<Up>", "<C-\\><C-n><Up>", { noremap = true, silent = true })
					vim.api.nvim_buf_set_keymap(
						0,
						"t",
						"<Down>",
						"<C-\\><C-n><Down>",
						{ noremap = true, silent = true }
					)
				end, { noremap = true, silent = true, buffer = true })
			end,
		})
	end
end

return M
