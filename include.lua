local function registerEnum(name, elements)
  -- Look for a previous enum and add elements to the new one
  local partialEnum = rawget(_G, name)

  if partialEnum and type(partialEnum) == "table" then
    for key in pairs(partialEnum) do
      table.insert(elements, key)
    end
  end

  -- Now actually generate the enum
  local generatedEnum = {}
  local currentIndex = 1

  for _, key in ipairs(elements) do
    if not generatedEnum[key] then
      generatedEnum[key] = currentIndex
      currentIndex = currentIndex + 1
    end
  end

  -- Register enum into global environment
  rawset(_G, name, generatedEnum)
end

local unpack = unpack or table.unpack

function enum(name)
  assert(type(name) == "string", "Expected [string] name for enum constructor, got " .. type(name))

  return function(elements)
    assert(type(elements) == "table", "Expected [table] elements for enum constructor got " .. type(elements))

    for index = 1, select("#", unpack(elements)) do
      assert(elements[index] ~= nil, "A nil parameter was passed to enum " .. name .. ", check scope or spell")
      assert(type(elements[index]) == "string", "Non-string parameter passed to enum " .. name .. " - " .. type(elements[index]))
    end

    assert(#elements ~= 0, "Can't create enum without elements")

    return registerEnum(name, elements)
  end
end
