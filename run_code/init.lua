return {
	"run-code",
	lazy = false,
	config = function()
		require("plugins.run_code.runner").setup()
	end,
}
