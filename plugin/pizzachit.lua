-- In this file you define the User commands, i.t how the user will interact with your plugin.

vim.api.nvim_set_keymap('n', '<C-l>', ':lua require("pizzachit").lookup()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-l>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>'
    else
        local pizzachit = require("pizzachit")
        return pizzachit.lookup()
    end
end, { expr = true, noremap = true })

vim.api.nvim_set_keymap('n', '<C-t>', ':lua require("pizzachit").pizzaThesaurus()<CR>', { noremap = true, silent = true })


vim.api.nvim_create_user_command("Lookup", require("pizzachit").lookup, {
  nargs = "?",
  desc = "Receipt example command",
  complete = function(arg_lead, _, _)
    return vim
      .iter(sub_cmds_keys)
      :filter(function(sub_cmd)
        return sub_cmd:find(arg_lead) ~= nil
      end)
      :totable()
  end,
})
