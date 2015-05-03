require('helpers')
core = require('core')

local module = {}

module.formats = {} 

for _,f in ipairs({"csv", "json", "xls", "table"}) do
  local m = require('format/'..f)
  if type(m) == 'table' then
    table.insert(module.formats, m)
  end
end

function module:loadf(filename)
  local new = nil
  if not filename then return new end
  _, _,ext = split_filename(filename) 
  for _, fmt in ipairs(self.formats) do
    if ext == fmt.ext then
      new = core.new()
      fmt.loadf(filename, new)
    end
  end
  return new
end

return module
