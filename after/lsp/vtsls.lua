-- Same TypeScript settings for .ts and .js files.
local ts = {
	-- Update imports when a file is moved or renamed.
	updateImportsOnFileMove = { enabled = "always" },
	-- Completing a function also inserts its call parentheses and parameters.
	suggest = { completeFunctionCalls = true },
	-- Short inlay hints: parameters, return types and members, but no variable types.
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

return {
	settings = {
		complete_function_calls = true,
		vtsls = {
			-- Use the project's own TypeScript from node_modules when present.
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = { enableServerSideFuzzyMatch = true },
			},
		},
		typescript = ts,
		javascript = ts,
	},
}
