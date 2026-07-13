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
    local escaped = shellEscape(id)

    noctalia.runAsync("pass -c " .. escaped, function(result)
        if result.exitCode == 0 then
            noctalia.notify("Pass", noctalia.tr("notification.copied"))
            return
        end

        local err = (result.stderr or ""):lower()

        if err:find("gpg") then
            noctalia.notify("Pass", noctalia.tr("notification.unlocking"))

            noctalia.runInTerminal(
                "pass show " .. escaped .. " && pass -c " .. escaped
            )
            return
        end

        if err == "" then
            err = noctalia.tr("notification.copy_failed")
        end

        noctalia.notifyError("Pass", err)
    end)
end
