local function init_enemy_list()
    storage.enemy_prototypes = {}

    for name, proto in pairs(prototypes.get_entity_filtered({{filter = "type", type = "unit"}})) do
		table.insert(storage.enemy_prototypes, name)
    end
	for name, proto in pairs(prototypes.get_entity_filtered({{filter = "type", type = "turret"}})) do
		table.insert(storage.enemy_prototypes, name)
    end
	for name, proto in pairs(prototypes.get_entity_filtered({{filter = "type", type = "unit-spawner"}})) do
		table.insert(storage.enemy_prototypes, name)
    end
end

-- Add button to all players
local function create_button(player)
    if player.gui.top.enemy_list_button then return end
    player.gui.top.add{
        type = "button",
        name = "enemy_list_button",
        caption = "Show Enemies"
    }
end

-- Create a scrollable grid window for selecting entities
local function show_entity_picker(player)
    -- Remove existing window if present
    if player.gui.center.enemy_picker_frame then
        player.gui.center.enemy_picker_frame.destroy()
    end

    local frame = player.gui.center.add{
        type = "frame",
        name = "enemy_picker_frame",
        caption = "Pick Enemy Entity",
        direction = "vertical"
    }

    local scroll = frame.add{
        type = "scroll-pane",
        name = "enemy_scroll",
        direction = "vertical"
    }

    scroll.style.maximal_height = 400
    scroll.style.minimal_width = 300

    local grid = scroll.add{
        type = "table",
        name = "enemy_grid",
        column_count = 4
    }

    for _, entity_name in ipairs(storage.enemy_prototypes) do
        grid.add{
            type = "sprite-button",
            name = "enemy_" .. entity_name,
            sprite = "entity/" .. entity_name,
            tooltip = entity_name
        }
    end

    -- Close button
    frame.add{
        type = "button",
        name = "enemy_picker_close",
        caption = "Close"
    }
end

-- GUI click handler
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.players[event.player_index]
    local element = event.element

    if not element.valid then return end

    if element.name == "enemy_list_button" then
        show_entity_picker(player)
    elseif element.name == "enemy_picker_close" then
        element.parent.destroy()
    elseif element.name:match("^enemy_") then
        local entity_name = element.name:sub(7)
        player.print("You selected: " .. entity_name)
        -- Do something with the selected entity
    end
end)

script.on_init(function()
    init_enemy_list()
	for _, player in pairs(game.players) do
        create_button(player)
    end
end)

script.on_configuration_changed(function()
    init_enemy_list()
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    create_button(player)
end)
