function help()
  decho([[
` _________                           ___ ___           .___
 /   _____/__________    ____  ____  /   |   \ __ __  __| _/
 \_____  \\____ \__  \ _/ ___\/ __ \/    ~    \  |  \/ __ | 
 /        \  |_> > __ \\  \__\  ___/\    Y    /  |  / /_/ | 
/_______  /   __(____  /\___  >___  >\___|_  /|____/\____ | 
        \/|__|       \/     \/    \/       \/            \/ 
                   A Mudlet package for Legends of the Jedi
                                        Created By: Xavious
-----------------------------------------------------------
                     STANDARD COMMANDS
-----------------------------------------------------------
helpspace            - Display this help screen
hidespace            - Hide the mini window
showspace            - Show the mini window
-----------------------------------------------------------
                     MOUSE INTERACTIONS
-----------------------------------------------------------
left+click fields    - Sort ships by Type, Name, Proximity,
                     - Position, or Velocity

right+click ships    - Contextually status, target, locate, 
                     - or jump to a target ship
-----------------------------------------------------------
                    DEBUGGING COMMANDS
-----------------------------------------------------------
dumpships            - Print ship tables
clearships           - Purge the ships tables
spacedebug <1/0>     - Turn debugging on (1) or off (0)
-----------------------------------------------------------
  ]])
end

function spacehud.show()
  spacehud.container:show()
  spacehud.container:raiseAll()
end

function spacehud.hide()
  spacehud.container:hide()
end

function clickSettings()
  debug("clickSettings")
  spacehud.settings_container:show()
  spacehud.input.type:print(spacehud.type_width)
  spacehud.input.name:print(spacehud.name_width)
  spacehud.input.xyz:print(spacehud.xyz_width)
  spacehud.input.proximity:print(spacehud.proximity_width)
  spacehud.input.position:print(spacehud.position_width)
  spacehud.input.velocity:print(spacehud.velocity_width)
end

function clickSave()
  debug("clickSave")
  spacehud.type_width = spacehud.input.type:getText()
  spacehud.name_width = spacehud.input.name:getText()
  spacehud.xyz_width = spacehud.input.xyz:getText()
  spacehud.proximity_width = spacehud.input.proximity:getText()
  spacehud.position_width = spacehud.input.position:getText()
  spacehud.velocity_width = spacehud.input.velocity:getText()
  spacehud.settings_container:hide()
  updateHud()
end

function setDebug()
  spacehud.debug = tonumber(matches[2])
  if spacehud.debug == 1 then
    print("Debugging mode: ON")
  else
    print("Debugging mode: OFF")
  end
end

function debug(message)
  if spacehud.debug == 1 then
    print(message)
  end
end

function dumpShips()
  print("Ships:")
  display(spacehud.ships)
  print("\nShip_Candidates:")
  display(spacehud.ship_candidates)
  print("\nMy_Coordinates")
  display(spacehud.my_ship)
end

function clearShips()
  debug("Clearing ships..")
  spacehud.ships = {}
  spacehud.ship_candidates = {}
  updateHud()
end

function addShip(ship)
  debug("addShip fired")
  spacehud.ships[ship.name] = {}
  spacehud.ships[ship.name].name = ship.name or "?"
  spacehud.ships[ship.name].type = ship.type or "?"
  spacehud.ships[ship.name].x = ship.x or "?"
  spacehud.ships[ship.name].y = ship.y or "?"
  spacehud.ships[ship.name].z = ship.z or "?"
  spacehud.ships[ship.name].proximity = ship.proximity or "?"
  spacehud.ships[ship.name].position = ship.position or "?"
  spacehud.ships[ship.name].velocity = ship.velocity or "?"
  spacehud.ships[ship.name].incoming = ship.incoming or nil
end
  
function removeShip(ship)
  debug("removeShip:"..ship)
  if spacehud.ships[ship] ~= nil then
    spacehud.ships[ship] = nil
  end
  updateHud()
end

function updateShip(ship)
    debug("Calling updateShip")
    for attribute in pairs(ship) do
      debug(attribute..": "..ship[attribute])
      spacehud.ships[ship.name][attribute] = ship[attribute]
    end
end

function lookupShip(ship)
  if spacehud.ship_candidates[ship] == nil then
    spacehud.ship_candidates[ship] = {}
  end 
end

--Basically we compare the last full radar capture against our current data.
--if something exists in spacehud.ships already, but it's not in spacehud.ship_candidates, then
--that means it wasn't in the last scan and it should be removed.
function checkShips()
  debug("checkShips fired")
  -- Premptively clear projectiles, since they are not uniquely identified
  -- and will not update/remove properly as a result.
  if next(spacehud.ships) then
    for ship in pairs(spacehud.ships) do
      if string.find(spacehud.ships[ship].type, "Projectile") then
        debug("Object is a projectile")
        removeShip(ship)
      end
    end
  end
  if next(spacehud.ship_candidates) then
    for ship_candidate in pairs(spacehud.ship_candidates) do
      debug("Ship candidate:"..ship_candidate)
      if spacehud.ships[ship_candidate] == nil then
        addShip(spacehud.ship_candidates[ship_candidate])
      elseif spacehud.ships[ship_candidate] ~= nil then
        if spacehud.ship_candidates[ship_candidate].x ~= nil and spacehud.ships[ship_candidate].x ~="?" then
          if tonumber(spacehud.ship_candidates[ship_candidate].x) > tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].x) then
            spacehud.ship_candidates[ship_candidate].x_diff = "+"
          elseif tonumber(spacehud.ship_candidates[ship_candidate].x) < tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].x) then
            spacehud.ship_candidates[ship_candidate].x_diff = "-"
          elseif spacehud.ships[ship_candidate].x_diff ~= nil then
            spacehud.ships[ship_candidate].x_diff = nil
          end
          if tonumber(spacehud.ship_candidates[ship_candidate].y) > tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].y) then
            spacehud.ship_candidates[ship_candidate].y_diff = "+"
          elseif tonumber(spacehud.ship_candidates[ship_candidate].y) < tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].y) then
            spacehud.ship_candidates[ship_candidate].y_diff = "-"
          elseif spacehud.ships[ship_candidate].y_diff ~= nil then
            spacehud.ships[ship_candidate].y_diff = nil
          end
          if tonumber(spacehud.ship_candidates[ship_candidate].z) > tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].z) then
            spacehud.ship_candidates[ship_candidate].z_diff = "+"
          elseif tonumber(spacehud.ship_candidates[ship_candidate].z) < tonumber(spacehud.ships[spacehud.ship_candidates[ship_candidate].name].z) then
            spacehud.ship_candidates[ship_candidate].z_diff = "-"
          elseif spacehud.ships[ship_candidate].z_diff ~= nil then
            spacehud.ships[ship_candidate].z_diff = nil
          end
        else
        end
        updateShip(spacehud.ship_candidates[ship_candidate])
      end
      for ship in pairs(spacehud.ships) do
        if spacehud.ship_candidates[spacehud.ships[ship].name] == nil then
          removeShip(spacehud.ships[ship].name)
        end
      end
    end
  else
    clearShips()
    updateHud()
  end
  debug("Exiting checkShips")
  spacehud.ship_candidates = {}
end

function triggerShipRadar()
  debug("triggerShipRadar")
  lookupShip(matches.ship_name)
  spacehud.ship_candidates[matches.ship_name].type = matches.ship_type
  spacehud.ship_candidates[matches.ship_name].name = matches.ship_name
  spacehud.ship_candidates[matches.ship_name].x = matches.ship_x
  spacehud.ship_candidates[matches.ship_name].y = matches.ship_y
  spacehud.ship_candidates[matches.ship_name].z = matches.ship_z
end

function getProjectileName (projectile)
  debug("getProjectileName")
  if projectile == "A Heavy Rocket" then
    rocket_count = rocket_count + 1
    projectile_count = rocket_count
  elseif projectile == "A Concussion missile" then
    missile_count = missile_count + 1
    projectile_count = missile_count
  elseif projectile == "A Torpedo" then
    torpedo_count = torpedo_count + 1
    projectile_count = torpedo_count
  end
  projectile_name = projectile..projectile_count
  return projectile_name
end

function triggerProjectileRadar()
  debug("triggerProjectileRadar")
  projectile_name = getProjectileName(matches.ship_name)
  lookupShip(projectile_name)
  spacehud.ship_candidates[projectile_name].type = "Projectile"
  spacehud.ship_candidates[projectile_name].name = projectile_name
  spacehud.ship_candidates[projectile_name].x = matches.ship_x
  spacehud.ship_candidates[projectile_name].y = matches.ship_y
  spacehud.ship_candidates[projectile_name].z = matches.ship_z
  if matches.incoming == " (Incoming)" then
    spacehud.ship_candidates[projectile_name].type = spacehud.ship_candidates[projectile_name].type..matches.incoming
    spacehud.ship_candidates[projectile_name].incoming = 1
  end
end

function triggerProjectileProximity()
  debug("triggerProjectileProximity")
  projectile_name = getProjectileName(matches.ship_name)
  lookupShip(projectile_name)
  spacehud.ship_candidates[projectile_name].type = "Projectile"
  spacehud.ship_candidates[projectile_name].name = projectile_name
  spacehud.ship_candidates[projectile_name].proximity = matches.ship_proximity
  if matches.incoming == " (Incoming)" then
    spacehud.ship_candidates[projectile_name].type = spacehud.ship_candidates[projectile_name].type..matches.incoming
    spacehud.ship_candidates[projectile_name].incoming = 1
  end
end

function triggerFleetRadar()
  debug("triggerFleetRadar")
  lookupShip(matches.ship_name)
  spacehud.ship_candidates[matches.ship_name].type = matches.ship_type
  spacehud.ship_candidates[matches.ship_name].name = matches.ship_name
  spacehud.ship_candidates[matches.ship_name].x = matches.ship_x
  spacehud.ship_candidates[matches.ship_name].y = matches.ship_y
  spacehud.ship_candidates[matches.ship_name].z = matches.ship_z
  if matches.ship_position ~= '' then
    spacehud.ship_candidates[matches.ship_name].position = matches.ship_position
  end
  --Check to see if they were part of a battlegroup
  if matches.ship_leader_name ~= '' then
    spacehud.ship_candidates[matches.ship_name].leader_type = matches.ship_leader_type
    spacehud.ship_candidates[matches.ship_name].leader_name = matches.ship_leader_name
  end
end
  
function triggerShipProximity()
  debug("triggerShipProximity")
  lookupShip(matches.ship_name)
  spacehud.ship_candidates[matches.ship_name].type = matches.ship_type
  spacehud.ship_candidates[matches.ship_name].name = matches.ship_name
  spacehud.ship_candidates[matches.ship_name].proximity = matches.ship_proximity
end
  
function triggerShipVelocity()
  debug("triggerShipVelocity")
  lookupShip(matches.ship_name)
  spacehud.ship_candidates[matches.ship_name].type = matches.ship_type
  spacehud.ship_candidates[matches.ship_name].name = matches.ship_name
  spacehud.ship_candidates[matches.ship_name].velocity = matches.ship_velocity
end

function triggerProjectileVelocity()
  debug("triggerProjectileVelocity")
  projectile_name = getProjectileName(matches.ship_name)
  lookupShip(projectile_name)
  spacehud.ship_candidates[projectile_name].type = "Projectile"
  spacehud.ship_candidates[projectile_name].name = projectile_name
  spacehud.ship_candidates[projectile_name].velocity = matches.ship_velocity
  if matches.incoming == " (Incoming)" then
    spacehud.ship_candidates[projectile_name].type = spacehud.ship_candidates[projectile_name].type..matches.incoming
    spacehud.ship_candidates[projectile_name].incoming = 1
  end
end

--It just so happens that this string ends multiple space recon commands
--so we're going to use it as something of an "end case" for the capture.
function triggerMyCoordinates()
  debug("triggerMyCoordinates")
  spacehud.my_ship.x = matches.my_x
  spacehud.my_ship.y = matches.my_y
  spacehud.my_ship.z = matches.my_z
  rocket_count = 0
  missile_count = 0
  torpedo_count = 0
  checkShips()
  updateHud()
end

function triggerShipLaunch()
  debug("triggerShipLaunch")
  local ship = {}
  ship.type = matches.ship_type
  ship.name = matches.ship_name
  ship.x = matches.ship_x
  ship.y = matches.ship_y
  ship.z = matches.ship_z
  addShip(ship)
  updateHud()
end

function triggerShipEntersSystem()
  debug("triggerShipEntersSystem")
  local ship = {}
  ship.type = matches.ship_type
  ship.name = matches.ship_name
  ship.x = matches.ship_x
  ship.y = matches.ship_y
  ship.z = matches.ship_z
  addShip(ship)
  updateHud()
end

function triggerShipLand()
  debug("triggerShipLand")
  removeShip(matches.ship_name)
end

function triggerShipLeavesSystem()
  debug("triggerShipLeavesSystem")
  removeShip(matches.ship_name)
end

function triggerShipExplodes()
  debug("triggerShipExplodes")
  removeShip(matches.ship_name)
end

function triggerShipTractored()
  debug("triggerShipTractored")
  removeShip(matches.ship_name)
end

function triggerShipHangarLaunch()
    debug("triggerShipHangarLaunch")
    local ship = {}
    ship.type = matches.ship_type
    ship.name = matches.ship_name
    ship.x = matches.ship_x
    ship.y = matches.ship_y
    ship.z = matches.ship_z
    addShip(ship)
    updateHud()
end

function triggerShipHangarLand()
  debug("triggerShipHangarLand")
  removeShip(matches.ship_name)
end

function triggerShipDisappears()
    debug("triggerShipDisappears")
    removeShip(matches.ship_name)
end

function triggerEnterHyperspace()
    debug("triggerEnterHyperspace")
end

function triggerExitHyperspace()
    debug("triggerExitHyperspace")
    --clearShips()
    updateHud()
end

function triggerMyShipLands()
    debug("triggerMyShipLand")
    --spacehud.container:hide()
end

function triggerMyShipLaunch()
    debug("triggerMyShipLaunch")
    --spacehud.container:show()
end

function triggerMyShipReadout()
    debug("triggerMyShipReadout")
    spacehud.my_ship.x = matches.ship_x
    spacehud.my_ship.y = matches.ship_y
    spacehud.my_ship.z = matches.ship_z
end

function triggerProximityAlert()
    debug("triggerProximityAlert")
    local ship = {}
    ship.name = matches.ship_name
    ship.type = matches.ship_type
    ship.x = matches.ship_x
    ship.y = matches.ship_y
    ship.z = matches.ship_z
    if spacehud.ships[matches.ship_name] == nil then
      addShip(ship)
    else
      updateShip(ship)
    end
    updateHud()
end

function sortShipType()
  spacehud.sort_by = "type"
  spacehud.sort_by_invert = spacehud.sort_by_invert * -1
  debug("Sort by type")
  updateHud()
end

function sortShipName()
  spacehud.sort_by = "name"
  spacehud.sort_by_invert = spacehud.sort_by_invert * -1
  debug("Sort by name")
  updateHud()
end

function sortShipProximity()
  spacehud.sort_by = "proximity"
  spacehud.sort_by_invert = spacehud.sort_by_invert * -1
  debug("Sort by proximity")
  updateHud()
end

function sortShipPosition()
  spacehud.sort_by = "position"
  spacehud.sort_by_invert = spacehud.sort_by_invert * -1
  debug("Sort by position")
  updateHud()
end

function sortShipVelocity()
  spacehud.sort_by = "velocity"
  spacehud.sort_by_invert = spacehud.sort_by_invert * -1
  debug("Sort by velocity")
  updateHud()
end

function sortShips()
  local sorted_ships = {}
  if spacehud.sort_by== "proximity" then
    for _,v in pairs(spacehud.ships) do
      table.insert(sorted_ships, v)
    end
    table.sort(sorted_ships, function(a,b)
      if spacehud.sort_by_invert < 0 then
        if a.proximity ~= '?' and b.proximity ~= '?' then
          return tonumber(a.proximity) < tonumber(b.proximity)
        else
          return a.proximity < b.proximity
        end
      else
        if a.proximity ~= '?' and b.proximity ~= '?' then
          return tonumber(a.proximity) > tonumber(b.proximity)
        else
          return a.proximity > b.proximity
        end
      end
    end)
  elseif spacehud.sort_by== "name" then
    for _,v in pairs(spacehud.ships) do
      table.insert(sorted_ships, v)
    end
    table.sort(sorted_ships, function(a,b)
      if spacehud.sort_by_invert < 0 then
        return a.name < b.name
      else
        return a.name > b.name
      end
    end)
  elseif spacehud.sort_by== "position" then
    for _,v in pairs(spacehud.ships) do
      table.insert(sorted_ships, v)
    end
    table.sort(sorted_ships, function(a,b)
      if spacehud.sort_by_invert < 0 then
        return a.position < b.position
      else
        return a.position > b.position
      end
    end)
  elseif spacehud.sort_by== "velocity" then
    for _,v in pairs(spacehud.ships) do
        table.insert(sorted_ships, v)
    end
    table.sort(sorted_ships, function(a,b)
      if spacehud.sort_by_invert < 0 then
        if a.velocity ~= '?' and b.velocity ~= '?' then
          return tonumber(a.velocity) < tonumber(b.velocity)
        else
          return a.velocity < b.velocity
        end
        else
        if a.velocity ~= '?' and b.velocity ~= '?' then
          return tonumber(a.velocity) > tonumber(b.velocity)
        else
          return a.velocity > b.velocity
        end
      end
    end)
  else
    for _,v in pairs(spacehud.ships) do
      table.insert(sorted_ships, v)
    end
    table.sort(sorted_ships, function(a,b)
      if spacehud.sort_by_invert < 0 then
        return a.type < b.type
      else
        return a.type > b.type
      end
    end)
  end
  return sorted_ships
end

function updateHud()
  debug("updateHud")
  local TableMaker = require("SpaceHud/ftext").TableMaker
  spacehud.table = TableMaker:new({
    formatType = "c",
    printHeaders = false,
    headCharacter = "",
    footCharacter = "",
    edgeCharacter = "",
    --frameColor = "white",
    rowSeparator = "-",
    separator = "|",
    --separatorColor = "grey",
    autoEcho = true,
    autoEchoConsole = "spacehud_console",
    autoClear = true,
    allowPopups = true,
    separateRows = true,
    title = "SpaceHud",
    titleColor = "red",
    printTitle = false
  })
  spacehud.table:addColumn({name = "type", width = spacehud.type_width, textColor = "<cyan>"})
  spacehud.table:addColumn({name = "name", width = spacehud.name_width, textColor = "<cyan>"})
  spacehud.table:addColumn({name = "x", width = spacehud.xyz_width, textColor = "<red>"})
  spacehud.table:addColumn({name = "y", width = spacehud.xyz_width, textColor = "<red>"})
  spacehud.table:addColumn({name = "z", width = spacehud.xyz_width, textColor = "<red>"})
  spacehud.table:addColumn({name = "prox", width = spacehud.proximity_width, textColor = "<yellow>"})
  spacehud.table:addColumn({name = "pos", width = spacehud.position_width, textColor = "<orange>"})
  spacehud.table:addColumn({name = "vel", width = spacehud.velocity_width, textColor = "<purple>"})
  spacehud.table:addRow({
    {"type", [[sortShipType()]], "sort by type"},
    {"name", [[sortShipName()]], "sort by name"},
    "x",
    "y",
    "z",
    {"prox", [[sortShipProximity()]], "sort by proximity"},
    {"pos", [[sortShipPosition()]], "sort by position"},
    {"vel", [[sortShipVelocity()]], "sort by velocity"}
  })
  local sorted_ships = sortShips()
  for ship in pairs(sorted_ships) do
    x_diff = sorted_ships[ship].x_diff or ""
    y_diff = sorted_ships[ship].y_diff or ""
    z_diff = sorted_ships[ship].z_diff or ""
    if string.find(sorted_ships[ship].type, "Projectile") then
      sorted_ships[ship].name = string.gsub(sorted_ships[ship].name, "(%d+)", "")
      if sorted_ships[ship].incoming == 1 then
        sorted_ships[ship].type = "<red>"..sorted_ships[ship].type
        sorted_ships[ship].name = "<red>"..sorted_ships[ship].name
      else
        sorted_ships[ship].type = "<white>"..sorted_ships[ship].type
        sorted_ships[ship].name = "<white>"..sorted_ships[ship].name
      end
    end
    local statusShip = function()
      send("status \""..sorted_ships[ship].type.." '"..sorted_ships[ship].name.."'\"")
    end
    local infoShip = function()
      send("info \""..sorted_ships[ship].type.." '"..sorted_ships[ship].name.."'\"")
    end
    local locateShip = function()
      send("locateship "..sorted_ships[ship].name)
    end
    local targetShip = function()
      send("target "..sorted_ships[ship].name)
    end
    local calculateShip = function ()
      send("calculate local "..sorted_ships[ship].x.." "..sorted_ships[ship].y.." "..sorted_ships[ship].z)
    end
    spacehud.table:addRow({
      sorted_ships[ship].type,
      {sorted_ships[ship].name, 
        {
          statusShip,
          infoShip,
          locateShip,
          targetShip,
          calculateShip
        }, 
        {"Status", "Info", "Locate", "Target", "Calculate to"}
      },
      sorted_ships[ship].x.." "..x_diff,
      sorted_ships[ship].y.." "..y_diff,
      sorted_ships[ship].z.." "..z_diff,
      sorted_ships[ship].proximity,
      string.sub(sorted_ships[ship].position, 1, 3),
      sorted_ships[ship].velocity
    })
  end
  spacehud.table:assemble()
end

-- Get current installed version from package info
function getCurrentVersion()
  local package_info = getPackageInfo("SpaceHud")
  if package_info and package_info.version then
    return package_info.version
  end
  return "unknown"
end

-- Version comparison function (semantic versioning)
function compareVersions(v1, v2)
  -- Remove 'v' prefix if present
  v1 = v1:gsub("^v", "")
  v2 = v2:gsub("^v", "")

  -- Split versions into parts
  local v1_parts = {}
  local v2_parts = {}

  for num in v1:gmatch("%d+") do
    table.insert(v1_parts, tonumber(num))
  end

  for num in v2:gmatch("%d+") do
    table.insert(v2_parts, tonumber(num))
  end

  -- Compare each part
  for i = 1, math.max(#v1_parts, #v2_parts) do
    local v1_part = v1_parts[i] or 0
    local v2_part = v2_parts[i] or 0

    if v1_part < v2_part then
      return -1  -- v1 is older
    elseif v1_part > v2_part then
      return 1   -- v1 is newer
    end
  end

  return 0  -- versions are equal
end

-- Handle update check response
function handleUpdateCheck(event, filename)
  -- Only handle our update check download
  if not filename or not filename:match("spacehud_update_check%.json") then
    return
  end

  -- Kill the event handler after first successful call
  if spacehud.update_check_handler then
    killAnonymousEventHandler(spacehud.update_check_handler)
    spacehud.update_check_handler = nil
  end

  -- Read the downloaded JSON file
  local file = io.open(filename, "r")
  if not file then
    cecho("\n[<cyan>SpaceHud<reset>] <red>Update check failed - could not retrieve version info<reset>\n")
    return
  end

  local content = file:read("*all")
  file:close()

  -- Parse JSON to extract latest release tag
  local latest_version = content:match('"tag_name"%s*:%s*"([^"]+)"')

  if not latest_version then
    cecho("\n[<cyan>SpaceHud<reset>] <red>Update check failed - could not parse version from GitHub<reset>\n")
    return
  end

  -- Get current installed version
  local current_version = getCurrentVersion()

  -- Compare versions
  local comparison = compareVersions(current_version, latest_version)

  if comparison < 0 then
    -- Update available
    local download_url = content:match('"browser_download_url"%s*:%s*"([^"]+%.mpackage)"')
    if not download_url then
      -- No .mpackage found, just show release page
      local release_url = string.format("https://github.com/%s/releases/latest", spacehud.config.github_repo)
      cecho("\n[<cyan>SpaceHud<reset>] <green>Update available!<reset> <yellow>v" .. current_version .. "<reset> → <white>" .. latest_version .. "<reset>\n")
      cecho("[<cyan>SpaceHud<reset>] Download from: <cyan>" .. release_url .. "<reset>\n")
      return
    end

    -- Store the download info
    spacehud.pending_update = {
      version = latest_version,
      url = download_url
    }

    -- Show update popup
    showUpdatePopup(current_version, latest_version)
  else
    cecho("\n[<cyan>SpaceHud<reset>] You are running the latest version (<white>v" .. current_version .. "<reset>)\n")
  end
end

-- Show update popup with Yes/No buttons
function showUpdatePopup(current_version, latest_version)
  -- Close existing popup if any
  if spacehud.update_popup then
    spacehud.update_popup:hide()
    spacehud.update_popup = nil
  end

  -- Create background overlay as a Label (supports setStyleSheet)
  spacehud.update_popup = Geyser.Label:new({
    name = "spacehud_update_popup",
    x = "0", y = "0",
    width = "100%", height = "100%",
  })

  spacehud.update_popup:setStyleSheet([[
    background-color: rgba(0, 0, 0, 180);
  ]])

  -- Create the dialog box (centered within the overlay)
  spacehud.update_dialog = Geyser.Label:new({
    name = "spacehud_update_dialog",
    x = "40%", y = "40%",
    width = "500px", height = "300px",
  }, spacehud.update_popup)

  spacehud.update_dialog:setStyleSheet([[
    background-color: rgb(47, 49, 54);
    border: 2px solid rgb(100, 105, 115);
    border-radius: 10px;
  ]])

  -- Title
  local title = Geyser.Label:new({
    name = "spacehud_update_title",
    x = 0, y = "10px",
    width = "100%", height = "40px",
  }, spacehud.update_dialog)

  title:setStyleSheet([[
    background-color: transparent;
    color: rgb(88, 214, 141);
    font-size: 18pt;
    font-weight: bold;
    qproperty-alignment: 'AlignCenter';
  ]])
  title:echo("SpaceHud Update Available!")

  -- Message
  local message = Geyser.Label:new({
    name = "spacehud_update_message",
    x = "20px", y = "60px",
    width = "460px", height = "120px",
  }, spacehud.update_dialog)

  message:setStyleSheet([[
    background-color: transparent;
    color: rgb(220, 220, 220);
    font-size: 12pt;
    qproperty-alignment: 'AlignCenter';
    qproperty-wordWrap: true;
  ]])

  local msg_text = string.format([[<p style="text-align: center; line-height: 1.5;">
Current Version: v%s<br/>
Latest Version: %s<br/>
<br/>
Would you like to download and install it now?
</p>]], current_version, latest_version)
  message:echo(msg_text)

  -- Yes button
  local yes_button = Geyser.Label:new({
    name = "spacehud_update_yes",
    x = "80px", y = "220px",
    width = "150px", height = "50px",
  }, spacehud.update_dialog)

  yes_button:setStyleSheet([[
    QLabel {
      background-color: rgb(88, 214, 141);
      border: 1px solid rgb(70, 180, 120);
      border-radius: 5px;
      color: rgb(0, 0, 0);
      font-size: 14pt;
      font-weight: bold;
      qproperty-alignment: 'AlignCenter';
    }
    QLabel:hover {
      background-color: rgb(100, 230, 160);
    }
  ]])
  yes_button:echo("Yes")
  yes_button:setClickCallback(function()
    if spacehud.update_popup then
      spacehud.update_popup:hide()
      spacehud.update_popup = nil
    end
    confirmUpdateInstall()
  end)

  -- No button
  local no_button = Geyser.Label:new({
    name = "spacehud_update_no",
    x = "270px", y = "220px",
    width = "150px", height = "50px",
  }, spacehud.update_dialog)

  no_button:setStyleSheet([[
    QLabel {
      background-color: rgb(64, 68, 75);
      border: 1px solid rgb(100, 105, 115);
      border-radius: 5px;
      color: rgb(220, 220, 220);
      font-size: 14pt;
      font-weight: bold;
      qproperty-alignment: 'AlignCenter';
    }
    QLabel:hover {
      background-color: rgb(80, 85, 95);
    }
  ]])
  no_button:echo("No")
  no_button:setClickCallback(function()
    if spacehud.update_popup then
      spacehud.update_popup:hide()
      spacehud.update_popup = nil
    end
    cecho("\n[<cyan>SpaceHud<reset>] Update cancelled. Run <white>spaceupdate<reset> again later to install.\n")
    spacehud.pending_update = nil
  end)
end

-- Confirm and start the update installation
function confirmUpdateInstall()
  if not spacehud.pending_update then
    return
  end

  local version = spacehud.pending_update.version
  local url = spacehud.pending_update.url
  local filename = getMudletHomeDir() .. "/SpaceHud_" .. version .. ".mpackage"

  cecho("\n[<cyan>SpaceHud<reset>] Downloading <white>" .. version .. "<reset>...\n")

  -- Register event handler for download completion
  if spacehud.install_handler then
    killAnonymousEventHandler(spacehud.install_handler)
  end
  spacehud.install_handler = registerAnonymousEventHandler("sysDownloadDone", "handleInstallDownload")

  -- Store the filename for the handler
  spacehud.install_filename = filename

  -- Download the package
  downloadFile(filename, url)
end

-- Handle the downloaded package
function handleInstallDownload(event, filename)
  -- Only handle our install download
  if not filename or filename ~= spacehud.install_filename then
    return
  end

  -- Kill the event handler
  if spacehud.install_handler then
    killAnonymousEventHandler(spacehud.install_handler)
    spacehud.install_handler = nil
  end

  cecho("\n[<cyan>SpaceHud<reset>] <green>Download complete!<reset> Installing package...\n")

  -- Uninstall old version first for clean update
  uninstallPackage("SpaceHud")

  -- Install the new package and check result
  local success = installPackage(filename)

  if success then
    cecho("[<cyan>SpaceHud<reset>] <green>Installation complete!<reset> The updated package is now active.\n")
    cecho("[<cyan>SpaceHud<reset>] <yellow>Note:<reset> If you experience issues, try reloading your profile.\n")
  else
    cecho("[<cyan>SpaceHud<reset>] <red>Installation failed!<reset> Please try downloading manually from:\n")
    cecho("[<cyan>SpaceHud<reset>] <cyan>https://github.com/" .. spacehud.config.github_repo .. "/releases/latest<reset>\n")
  end

  -- Clear pending update
  spacehud.pending_update = nil
  spacehud.install_filename = nil
end

-- Check for updates from GitHub
function checkForUpdates(force)
  if not force and spacehud.config.update_check_done then
    return  -- Only check once per session unless forced
  end

  spacehud.config.update_check_done = true

  local api_url = string.format("https://api.github.com/repos/%s/releases/latest", spacehud.config.github_repo)
  local temp_file = getMudletHomeDir() .. "/spacehud_update_check.json"

  -- Register event handler for download completion
  if spacehud.update_check_handler then
    killAnonymousEventHandler(spacehud.update_check_handler)
  end
  spacehud.update_check_handler = registerAnonymousEventHandler("sysDownloadDone", "handleUpdateCheck")

  -- Download the GitHub API response
  downloadFile(temp_file, api_url)
end

-- Manual update check (can be called anytime by user)
function manualUpdateCheck()
  cecho("\n[<cyan>SpaceHud<reset>] Checking for updates...\n")
  checkForUpdates(true)  -- Force check
end

-- Check for updates on load (once per session)
checkForUpdates(false)