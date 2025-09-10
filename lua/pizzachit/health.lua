local M = {}


---Validate the options table obtained from merging defaults and user options
local function validate_opts_table()
  local health = require("health")
  local opts = require("pizzachit.config").options

  local ok, err = pcall(function()
    vim.validate {
      name = { opts.name, "string" }
      --- validate other options here...
    }
  end)

  if not ok then
    health.report_error("Invalid setup options: " .. err)
  else
    health.report_info("opts are correctly set")
  end
end


---This function is used to check the health of the plugin
---It's called by `:checkhealth` command
M.check = function()
  print("pizzachit.nvim health check")
  validate_opts_table()

  -- Add more checks:
  --  - check for requirements
  --  - check for Neovim options (e.g. python support)
  --  - check for other plugins required
  --  - check for LSP setup
  --  ...
end


return M
