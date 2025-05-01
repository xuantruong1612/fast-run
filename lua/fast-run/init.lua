local M = {}

local config = require("fast-run.config")
local runner = require("fast-run.runner")

function M.setup(opts)
	config.setup(opts)
	runner.register()
end

return M
