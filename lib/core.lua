local module = {}
local sfmt = string.format

local DATASET = '@dataset'


local _line_metatable = {
  __tostring = function(t)
    return table.concat(t, ';')
  end,
  __index = function(t, k)
    if type(k) == 'string' then
      local dataset = t[DATASET]
      local kidx = dataset.keys[k]
      if kidx then
        return rawget(t, kidx)
      else
        return rawget(t, k)
      end
    else
      return rawget(t, k)
    end
  end,
}

local _dataset_metatable = {
  __len = function(t) return #t.data end,
  __add = function(t, l)
    if #t.keys ~= #l then error(sfmt("Bad line lenght %d, must be %d", #l, #t.keys)) end
    l[DATASET] = t
    setmetatable(l, _line_metatable)
    rawset(t.data, #t.data+1, l)
    return t
  end,
  __index = function(t, k)
    return rawget(t.data, k)
  end,
}

local _keys_metatable = {
  __newindex = function(t, k, v)
    rawset(t, k, v)
    rawset(t, v, k)
  end,
  __tostring = function(t)
    return table.concat(t, ';')
  end,
}

module.new = function()
  local new = {}
  -- Set of data like data[row][columns]
  new.data = {} 
  -- Keys like keys[x] = y and keys[y] = x
  new.keys = {}
  -- Indexes
  new.index = {}
  setmetatable(new, _dataset_metatable)
  setmetatable(new.keys, _keys_metatable)

  function new:print(num)
    print(self.keys)
    for i = 1,num or #self.data do
      print(self[i])
    end
  end

  return new
end

return module
