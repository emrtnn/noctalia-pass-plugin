local entries = {}

local function shellEscape(str)
  return "'" .. str:gsub("'", "'\\''") .. "'"
end

noctalia.state.watch("entries", function(value)
  entries = value or {}
end)

function onQuery(query)
    local results = {}

    for _, entry in ipairs(entries) do
        local score

        if query == "" then
            -- Show all entries, preserving alphabetical order.
            score = 1
        else
            score = noctalia.fuzzyScore(query, entry.path)
        end

        if score then
            table.insert(results, {
                id = entry.id,
                title = entry.title,
                subtitle = entry.subtitle ~= "" and entry.subtitle or nil,
                glyph = "key",
                score = score,
            })
        end
    end

    launcher.setResults(query, results)
end

function onActivate(id)
  local cmd = "pass -c " .. shellEscape(id)

  noctalia.runAsync(cmd, function(result)
    if result.exitCode == 0 then
      noctalia.notify("Pass", "Password copied.")
    else
      local err = result.stderr
      if err == "" then
        err = "Failed to copy password."
      end

      noctalia.notifyError("Pass", err)
    end
  end)
end
