local module = {}
module.ext = "csv"

local function ParseCSVLine (line,sep)
  local res = {}
  local pos = 1
  sep = sep or ';'
  while true do
    local c = string.sub(line,pos,pos)
    if (c == "") then break end
    if (c == '"') then
      -- quoted value (ignore separator within)
      local txt = ""
      repeat
        local startp,endp = string.find(line,'^%b""',pos)
        txt = txt..string.sub(line,startp+1,endp-1)
        pos = endp + 1
        c = string.sub(line,pos,pos)
        if (c == '"') then txt = txt..'"' end
        -- check first char AFTER quoted string, if it is another
        -- quoted string without separator, then append it
        -- this is the way to "escape" the quote char in a quote. example:
        --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
      until (c ~= '"')
      table.insert(res,txt)
      assert(c == sep or c == "")
      pos = pos + 1
    else
      -- no quotes used, just look for the first separator
      local startp,endp = string.find(line,sep,pos)
      if (startp) then
        table.insert(res,string.sub(line,pos,startp-1))
        pos = endp + 1
      else
        -- no separator found -> use rest of string and terminate
        table.insert(res,string.sub(line,pos))
        break
      end
    end
  end
  return res
end

module.loadf = function(file, data)
  local first = true 
  for line in io.lines(file) do
    local lt = ParseCSVLine(line, ";")
    if first then
      for _,k in ipairs(lt) do data.keys[#data.keys+1]=  k end
      first = false
    else
      data = data + lt
    end
  end
end

module.dumpf = function(data, file)
  return nil
end

module.loads = function(str, data)
  return nil
end

module.dumps = function(data)
  return nil
end

return module
