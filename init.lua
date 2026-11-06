vim.loader.enable()

_G.turalowski = require("turalowski.utils")

require("turalowski.config.options")
require("turalowski.config.keymaps")
require("turalowski.config.autocmds")
require("turalowski.config.commands")
require("turalowski.config.workarounds")

require("turalowski.plugins")
