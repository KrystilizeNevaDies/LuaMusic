--[[
Entrypoint

]]

local MIDI = require 'MIDI'

function Initialise()
  local File = io.open("test.txt", "w+")
  local Score = ReadMidi("test.mid")
  for k, Table in ipairs(Score) do
    if k ~= 1 and k ~= 2 then
      print(TableToString(Table))
    end
  end
end

function ReadMidi(FileName)
  local File = io.open(FileName)
  local MidiString = File:read("*all")
  File:close()
  return MIDI.opus2score(MIDI.to_millisecs(MIDI.midi2opus(MidiString)))
end

function WriteMidi(Score, FileName)
  local File = io.open(FileName, "w+")
  File:write(MIDI.score2midi(Score))
  File:close()
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function TableToString(tbl, indent)
  local Lines = {}
  if not indent then 
    table.insert(Lines, "{")
    indent = 1
  end
  for k, v in pairs(tbl) do
    if type(k) == "string" then
      formatting = string.rep("  ", indent) .. "[\"" .. k .. "\"]" .. " = "
    else
      formatting = string.rep("  ", indent) .. k .. " = "
    end
    if type(v) == "table" then
      table.insert(Lines, formatting .. "{")
      table.insert(Lines, TableToString(v, indent+1))
      table.insert(Lines, string.rep("  ", indent) .. "}" .. ",")
    elseif type(v) == 'boolean' then
      if v then
        table.insert(Lines, formatting .. "true" .. ",")
      else
        table.insert(Lines, formatting .. "false" .. ",")
      end
    elseif type(v) == 'string' then
      table.insert(Lines, formatting .. [["]] .. v .. [[",]])
    elseif type(v) == 'number' then
      table.insert(Lines, formatting .. v .. ",")
    else
      table.insert(Lines, formatting .. tostring(v) .. ",")
    end
  end
  if indent == 1 then 
    table.insert(Lines, "}")
  end
  return table.concat(Lines, "\r\n")
end


Initialise()