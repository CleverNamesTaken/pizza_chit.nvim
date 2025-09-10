-- In this file you define the User commands, i.t how the user will interact with your plugin.

vim.api.nvim_set_keymap('n', '<C-l>', ':lua require("pizza_chit").lookup()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-l>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>'
    else
        local pizza_chit = require("pizza_chit")
        return pizza_chit.lookup()
    end
end, { expr = true, noremap = true })

vim.api.nvim_set_keymap('n', '<C-t>', ':lua require("pizza_chit").pizzaThesaurus()<CR>', { noremap = true, silent = true })


vim.api.nvim_create_user_command("Lookup", require("pizza_chit").lookup, {
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
