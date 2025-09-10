local M = {}
M.keyLookup = function(data,key)
  if type(data[key]) == "string" then
    data=data[key]
  elseif type(data[key]) == "table" then
    local data_keys = "|Subkeys: "
    for key, value in pairs(data[key]) do
      data_keys = data_keys .. key .. ','
    end
    data = data_keys
  end
  return data
end
M.completion = function(data,cWORD,lastMatch)
  -- grab all the subkeys from the file
  local subKeys = {}
  local popupMenu = {}
  for key, value in pairs(data) do
    table.insert(subKeys, key)
  end

  for _, val in ipairs(subKeys) do
      local lookupValue = M.keyLookup(data,val)
      -- Filter down the list to only entries that are valid based on the last key we used.
      if val:match("^" .. lastMatch) then
        -- If the cWORD does not end in : and we don't have a partial match with :, then do this
          if string.sub(cWORD,-1) ~= ':' and string.sub(cWORD,-string.len(lastMatch)-1) ~= (':' .. lastMatch) then
            table.insert(popupMenu, { word = ":" .. val .. ":", menu = lookupValue })
          else
            table.insert(popupMenu, { word = val .. ":", menu = lookupValue })
          end
      end
  end

  -- go to the end of the cWORD and start insert mode
  vim.api.nvim_input("<Esc>a")
  vim.schedule(function()
    vim.api.nvim_call_function('complete', {vim.fn.col('.')-string.len(lastMatch), popupMenu})
  end)
  return
end

M.getData = function()
-- Open up the yaml file
  local yaml = require("pizza_chit.config").options.yaml
	local file = io.open(yaml, "r")  -- Open the file in read mode
	local content = file:read("*all")          -- Read the entire file content into a string
	file:close()
-- Parse the yaml file
	local yaml = require("pizza_chit.YAMLParserLite")
	local data = yaml.parse(content)
  return data
end

M.lookup = function()
  -- back up a step to look for my cWORD.  Need this to avoid first key loop
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col > 0 then
    vim.api.nvim_win_set_cursor(0, {vim.fn.line('.'), col - 1})
  end
  local cWORD = vim.fn.expand('<cWORD>')
-- Parse the data
  local data = M.getData()
-- Check if the cWORD is blank.  If so, then we don't need to think so much.
  if cWORD == '' then
      M.completion(data,cWORD,cWORD)
      return
  end

-- Create a table of all the keys in cWORD
  keys = {}
	for key in string.gmatch(cWORD, "([^" .. ":" .. "]+)") do
    if key ~= nil then
      table.insert(keys, key)
    end
	end

-- Loop through the keys to try to lookup the value
	for index, key in ipairs(keys) do
		if type(data[key]) == "string" then
      vim.api.nvim_input("<Esc>ciW" .. vim.fn.escape(data[key], '\\"') .. "<Esc>")
      return
    elseif type(data[key]) == "table" then
			data=data[key]
    else
      vim.api.nvim_input("<Esc>hE")
      M.completion(data,cWORD,key)
      return
    end
	end
  vim.api.nvim_input("<Esc>hE")
  M.completion(data,cWORD,'')
end


M.pizzaThesaurus = function()
  -- Lookup values using neovim thesaurus function
  -- Identify the thesaurus
  local yaml = require("pizza_chit.config").options.yaml
  local thesaurus_file = require("pizza_chit.config").options.thesaurus
  -- Update the thesaurus file
  local yq_command = string.format([[cat %s | yq 'to_entries | map({(.key): .value.IP})' | awk -F '"' '/:/ {printf "%%s %%s\n", $2,$4}' >> %s]] ,
  yaml, thesaurus_file)
  os.execute(yq_command)
  vim.opt.thesaurus = thesaurus_file
  -- go to the end of the current word
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ea', true, true, true), 'n', true)
  --  then simulate pressing the c_x+c_t to access the thesaurus
  vim.defer_fn(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-x><c-t><c-t>', true, true, true), 'i', true)
  end, 100)
end
return M
