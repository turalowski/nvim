-- Empty rules like ".a {}" are not reported.
local lint = { lint = { emptyRules = "ignore" } }

return {
	settings = {
		css = lint,
		scss = lint,
		less = lint,
	},
}
