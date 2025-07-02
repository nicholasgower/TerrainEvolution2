function OnInit( )
  storage.te = { }
  storage.te = {
    tiles = { },
    chunks = { },
    grass_trees = { },
    dirt_trees = { },
    desert_trees = { },
    sand_trees = { },
    nuclear_trees = { },
    dead_trees = { },
    random = game.create_random_generator( )
  }
  InitBiomeTrees( )
  InitDailyCycles( )
end

function OnSettingsChange( event )
  local surface = game.surfaces[ 1 ]
  if event.setting == "dynamic_daily_cycle"
    then
    InitDailyCycles( )
  end
  if event.setting == "the_night_is_dark_and_full_of_terror"
    then
    local weights = settings.global[ "the_night_is_dark_and_full_of_terror" ].value
    if weights ~= "dynamic"
      then
      weights = weights / 100
      surface.brightness_visual_weights = { weights, weights, weights }
    else
    end
  end
end

function InitDailyCycles( )
  local surface = game.surfaces[ 1 ]
  local dawn = surface.dawn
  local morning = surface.morning
  local evening = surface.evening
  local dusk = surface.dusk
        surface.dawn = 0.9999
        surface.morning = 0.5001
        surface.evening = 0.4999
        surface.dusk = 0.0001
end

function DailyCycles( event )
  local surface = game.surfaces[ 1 ]
  local day = Round( event.tick / 25000 )
  local year, modf_year = math.modf( day / 360 )
  local day_of_year = Round( modf_year * 360 )
  local moon_month, moon_modf_day = math.modf( day_of_year / 28 )
  local day_of_moon_month = Round( moon_modf_day * 28 ) + 1
  local dusk = surface.dusk
  local evening = surface.evening
  local morning = surface.morning
  local dawn = surface.dawn
  if settings.global[ "the_night_is_dark_and_full_of_terror" ].value == "dynamic"
    then
      local weights = Round( math.sin( math.rad( day_of_moon_month / 28 * 180 ) ), 2 )
      surface.brightness_visual_weights = { weights, weights, weights }
  end
  if settings.global[ "dynamic_daily_cycle" ].value == "middle_latitude"
    then
    local k = 1 / 6 / 180
    local j = day_of_year
    if j > 180
      then
      j = 360 - day_of_year
    end
    dusk = k * j + 1 / 6
    delta = dusk * 0.01
    dusk = dusk + delta
    evening = k * j + 0.25
    morning = 1 - evening
    dawn = 1 - dusk
  else if settings.global[ "dynamic_daily_cycle" ].value == "the_winter_is_coming"
      then
      if day_of_year < 180
        then
        dusk = 0.01
        evening = 0.02
        morning = 0.98
        dawn = 0.99
      else
        dusk = 0.48
        evening = 0.49
        morning = 0.51
        dawn = 0.52
      end
    else
      dusk = 0.25
      evening = 0.45
      morning = 0.55
      dawn = 0.75
    end
    if ( day_of_year == 180 or day_of_year == 0 )
      then
      InitDailyCycles( )
    end
  end
  surface.dawn = dawn
  surface.dusk = dusk
  surface.morning = morning
  surface.evening = evening
end

function InitBiomeTrees( )
  GrassBiomeTrees( )
  DirtBiomeTrees( )
  DesertBiomeTrees( )
  SandBiomeTrees( )
  NuclearBiomeTrees( )
  DeadBiomeTrees( )
end

function BiomeTiles( name )
  local biome = {
    [ "landfill" ] = "dirt",
    [ "grass-1" ] = "grass",
    [ "grass-2" ] = "grass",
    [ "grass-3" ] = "grass",
    [ "grass-4" ] = "grass",
    [ "dry-dirt" ] = "desert",
    [ "dirt-1" ] = "desert",
    [ "dirt-2" ] = "desert",
    [ "dirt-3" ] = "desert",
    [ "dirt-4" ] = "desert",
    [ "dirt-5" ] = "dirt",
    [ "dirt-6" ] = "dirt",
    [ "dirt-7" ] = "dirt",
    [ "red-desert-0" ] = "desert",
    [ "red-desert-1" ] = "desert",
    [ "red-desert-2" ] = "desert",
    [ "red-desert-3" ] = "desert",
    [ "sand-1" ] = "sand",
    [ "sand-2" ] = "sand",
    [ "sand-3" ] = "sand",
    [ "nuclear-ground" ] = "nuclear",
  }
  if biome[ name ]
    then
    return biome[ name ]
  else
    return false
  end
end

function OnLoad( )
end

function GrassBiomeTrees( )
  if #storage.te.grass_trees == 0
    then
    local trees = {
      [ "tree-01" ] = true,
      [ "tree-02" ] = true,
      [ "tree-02-red" ] = false,
      [ "tree-03" ] = false,
      [ "tree-04" ] = false,
      [ "tree-05" ] = false,
      [ "tree-06" ] = false,
      [ "tree-06-brown" ] = false,
      [ "tree-07" ] = false,
      [ "tree-08" ] = false,
      [ "tree-08-brown" ] = false,
      [ "tree-08-red" ] = false,
      [ "tree-09" ] = false,
      [ "tree-09-brown" ] = false,
      [ "dry-tree" ] = false,
      [ "dead-tree-desert" ] = false,
      [ "dead-grey-trunk" ] = false,
      [ "dead-dry-hairy-tree" ] = false,
      [ "dry-hairy-tree" ] = false,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}}) do
      if tree.type == "tree"
        then
        if trees[ tree.name ]
          then
          table.insert( storage.te.grass_trees, tree.name )
        end
      end
    end
  end
end

function DirtBiomeTrees( )
  if #storage.te.dirt_trees == 0
    then
    local trees = {
      [ "tree-01" ] = false,
      [ "tree-02" ] = false,
      [ "tree-02-red" ] = false,
      [ "tree-03" ] = true,
      [ "tree-04" ] = true,
      [ "tree-05" ] = false,
      [ "tree-06" ] = false,
      [ "tree-06-brown" ] = false,
      [ "tree-07" ] = false,
      [ "tree-08" ] = false,
      [ "tree-08-brown" ] = false,
      [ "tree-08-red" ] = false,
      [ "tree-09" ] = false,
      [ "tree-09-brown" ] = false,
      [ "dry-tree" ] = false,
      [ "dead-tree-desert" ] = false,
      [ "dead-grey-trunk" ] = false,
      [ "dead-dry-hairy-tree" ] = false,
      [ "dry-hairy-tree" ] = false,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}} ) do
      if tree.type == "tree"
        then
        if trees[ tree.name ]
          then
          table.insert( storage.te.dirt_trees, tree.name )
        end
      end
    end
  end
end

function DesertBiomeTrees( )
  if #storage.te.desert_trees == 0
    then
    local trees = {
      [ "tree-01" ] = false,
      [ "tree-02" ] = false,
      [ "tree-02-red" ] = false,
      [ "tree-03" ] = false,
      [ "tree-04" ] = false,
      [ "tree-05" ] = false,
      [ "tree-06" ] = false,
      [ "tree-06-brown" ] = false,
      [ "tree-07" ] = true,
      [ "tree-08" ] = true,
      [ "tree-08-brown" ] = false,
      [ "tree-08-red" ] = false,
      [ "tree-09" ] = true,
      [ "tree-09-brown" ] = false,
      [ "dry-tree" ] = false,
      [ "dead-tree-desert" ] = false,
      [ "dead-grey-trunk" ] = false,
      [ "dead-dry-hairy-tree" ] = false,
      [ "dry-hairy-tree" ] = false,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}} ) do
      if tree.type == "tree"
        then
        if trees[ tree.name ]
          then
          table.insert( storage.te.desert_trees, tree.name )
        end
      end
    end
  end
end

function SandBiomeTrees( )
  if #storage.te.sand_trees == 0
    then
    local trees = {
      [ "tree-01" ] = false,
      [ "tree-02" ] = false,
      [ "tree-02-red" ] = true,
      [ "tree-03" ] = false,
      [ "tree-04" ] = false,
      [ "tree-05" ] = true,
      [ "tree-06" ] = false,
      [ "tree-06-brown" ] = false,
      [ "tree-07" ] = false,
      [ "tree-08" ] = false,
      [ "tree-08-brown" ] = true,
      [ "tree-08-red" ] = true,
      [ "tree-09" ] = false,
      [ "tree-09-brown" ] = true,
      [ "dry-tree" ] = false,
      [ "dead-tree-desert" ] = false,
      [ "dead-grey-trunk" ] = false,
      [ "dead-dry-hairy-tree" ] = false,
      [ "dry-hairy-tree" ] = false,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}} ) do
      if tree.type == "tree"
        then
        if trees[ tree.name ]
          then
          table.insert( storage.te.sand_trees, tree.name )
        end
      end
    end
  end
end

function NuclearBiomeTrees( )
  if #storage.te.nuclear_trees == 0
    then
    local trees = {
      [ "tree-01" ] = false,
      [ "tree-02" ] = false,
      [ "tree-02-red" ] = false,
      [ "tree-03" ] = false,
      [ "tree-04" ] = false,
      [ "tree-05" ] = false,
      [ "tree-06" ] = true,
      [ "tree-06-brown" ] = true,
      [ "tree-07" ] = false,
      [ "tree-08" ] = false,
      [ "tree-08-brown" ] = false,
      [ "tree-08-red" ] = false,
      [ "tree-09" ] = false,
      [ "tree-09-brown" ] = false,
      [ "dry-tree" ] = false,
      [ "dead-tree-desert" ] = false,
      [ "dead-grey-trunk" ] = false,
      [ "dead-dry-hairy-tree" ] = false,
      [ "dry-hairy-tree" ] = false,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}} ) do
      if tree.type == "tree"
        then
        if trees[ tree.name ]
          then
          table.insert( storage.te.nuclear_trees, tree.name )
        end
      end
    end
  end
end

function DeadBiomeTrees( )
  if #storage.te.dead_trees == 0
    then
    local trees = {
      [ "tree-01" ] = false,
      [ "tree-02" ] = false,
      [ "tree-02-red" ] = false,
      [ "tree-03" ] = false,
      [ "tree-04" ] = false,
      [ "tree-05" ] = false,
      [ "tree-06" ] = false,
      [ "tree-06-brown" ] = false,
      [ "tree-07" ] = false,
      [ "tree-08" ] = false,
      [ "tree-08-brown" ] = false,
      [ "tree-08-red" ] = false,
      [ "tree-09" ] = false,
      [ "tree-09-brown" ] = false,
      [ "dry-tree" ] = true,
      [ "dead-tree-desert" ] = true,
      [ "dead-grey-trunk" ] = true,
      [ "dead-dry-hairy-tree" ] = true,
      [ "dry-hairy-tree" ] = true,
    }
    for _, tree in pairs( prototypes.get_entity_filtered{{filter = "type", type = "tree"}} ) do
      if tree.type == "tree" then
        if trees[ tree.name ]
          then
          table.insert( storage.te.dead_trees, tree.name )
        end
      end
    end
  end
end

function GetRandomTree( biome )
  if biome == "grass"
    then
    return storage.te.grass_trees[ storage.te.random( 1, #storage.te.grass_trees )]
  elseif biome == "dirt"
    then
    return storage.te.dirt_trees[ storage.te.random( 1, #storage.te.dirt_trees )]
  elseif biome == "desert"
    then
    return storage.te.desert_trees[ storage.te.random( 1, #storage.te.desert_trees )]
  elseif biome == "sand"
    then
    return storage.te.sand_trees[ storage.te.random( 1, #storage.te.sand_trees )]
  elseif biome == "nuclear"
    then
    return storage.te.nuclear_trees[ storage.te.random( 1, #storage.te.nuclear_trees )]
  elseif biome == "dead"
    then
    return storage.te.dead_trees[ storage.te.random( 1, #storage.te.dead_trees )]
  end
end

function NatureEvents( event )
  storage.te.tiles = { }
  local surface = game.surfaces[ 1 ]
  for j = 1, settings.global[ "chunks" ].value do
    RandomChunk( surface )
    if settings.global[ "more_agressive_base_chunks" ].value
      then
      RandomBaseChunk( surface )
    end
  end
  if #storage.te.tiles > 0
    then
    surface.set_tiles( storage.te.tiles )
  end
  -- if event.nth_tick == 600
  --   then
  --   Screenshot( event )
  -- end
  if event.nth_tick == 25000
    then
    DailyCycles( event )
  end
  if event.nth_tick == 50000
    then
    ChunkProcessor( event )
  end
end

function ChunkProcessor( event )
  local surface = game.surfaces[ 1 ]
  if settings.global[ "more_agressive_base_chunks" ].value
    then
    storage.te.chunks = { }
    local chunks = surface.get_chunks( )
    local force = game.players[ 1 ].force
    for chunk in chunks do
      if surface.count_entities_filtered({ area = chunk.area, force = force }) > 0
        then
        storage.te.chunks[ #storage.te.chunks + 1 ] = chunk
      end
    end
  end
  surface.regenerate_decorative( nil, { surface.get_random_chunk( )})
end

function RandomBaseChunk( surface )
  if #storage.te.chunks > 0
    then
    EvolutionProcessor( storage.te.chunks[ storage.te.random( 1, #storage.te.chunks )], surface )
  else
    ChunkProcessor( )
  end
end

function RandomChunk( surface )
  EvolutionProcessor( surface.get_random_chunk( ), surface )
end

function RandomPosition( position )
  position[ 1 ] = position[ 1 ] + storage.te.random( -64, 64 )
  position[ 2 ] = position[ 2 ] + storage.te.random( -64, 64 )
  return position
end

function EvolutionProcessor( chunk, surface )
  local minimal_pollution = settings.global[ "minimal_pollution" ].value
  local new_trees_chance = settings.global[ "new_trees_chance" ].value
  local new_trees_count = settings.global[ "new_trees_count" ].value
  local trees_evolution_count = settings.global[ "trees_evolution_count" ].value
  local trees_evolution_chance = settings.global[ "trees_evolution_chance" ].value
  local trees_rotted_count = settings.global[ "trees_rotted_count" ].value
  local trees_rotted_chance = settings.global[ "trees_rotted_chance" ].value
  local trees_rotted_tiles = settings.global[ "trees_rotted_tiles" ].value
  local template = settings.global[ "template" ].value
  local pollution = Round( surface.get_pollution( chunk ))
  local chance = Round( pollution / ( minimal_pollution / 25 ))
  local limit = Round( chance / 10 )
  if limit > 8
    then
    limit = 8
  end
  local position = {( chunk.x * 32 ) + storage.te.random( -32, 32 ), ( chunk.y * 32 ) + storage.te.random( -32, 32 )}
  if pollution > minimal_pollution
    then
    for i = 1, limit do
      SoilEvolution( surface, RandomPosition( position ), 2, chance )
      if settings.global[ "flood" ].value
        then
        Flood ( surface, RandomPosition( position ), 2, chance )
      end
      if settings.global[ "drought" ].value
        then
        Drought ( surface, RandomPosition( position ), 2, chance )
      end
      if settings.global[ "fire" ].value
        then
        Fire( surface, RandomPosition( position ), 1, chance )
      end
    end
  else
    if surface.evening >= 0.32
      then
      for i = 1, new_trees_count do
        if template == "random"
          then
          TreeExpansion( surface, RandomPosition( position ), new_trees_chance )
        else
          TreeForestExpansion( surface, RandomPosition( position ), new_trees_chance )
        end
      end
    end
  end
  TreeEvolution( surface, position, trees_evolution_count, trees_evolution_chance )
  TreeRotted( surface, position, trees_rotted_count, trees_rotted_chance, trees_rotted_tiles )
end

-- function Screenshot( event )
--   path = "timelapse/" .. string.format( "%06d", event.tick / event.nth_tick ) .. ".png",
--   game.take_screenshot{ resolution = { 1280, 720 }, quality = 88, zoom = 0.2, path = path, show_gui = false }
-- end

function SoilEvolution( surface, position, limit, chance )
  local tile_names = {
    "landfill",
    "grass-1",
    "grass-2",
    "grass-3",
    "grass-4",
    "dry-dirt",
    "dirt-1",
    "dirt-2",
    "dirt-3",
    "dirt-4",
    "dirt-5",
    "dirt-6",
    "dirt-7",
    "red-desert-0",
    "red-desert-1",
    "red-desert-2",
    "red-desert-3",
    "sand-1",
    "sand-2",
    "sand-3",
  }

  local terraformation = {
    [ "landfill" ] = "sand-1",
    [ "grass-1" ] = "dry-dirt",
    [ "grass-2" ] = "dry-dirt",
    [ "grass-3" ] = "dry-dirt",
    [ "grass-4" ] = "dry-dirt",
    [ "dry-dirt" ] = "sand-2",
    [ "dirt-1" ] = "sand-2",
    [ "dirt-2" ] = "sand-2",
    [ "dirt-3" ] = "sand-2",
    [ "dirt-4" ] = "red-desert-0",
    [ "dirt-5" ] = "dry-dirt",
    [ "dirt-6" ] = "dry-dirt",
    [ "dirt-7" ] = "dry-dirt",
    [ "red-desert-0" ] = "sand-2",
    [ "red-desert-1" ] = "sand-2",
    [ "red-desert-2" ] = "sand-2",
    [ "red-desert-3" ] = "sand-2",
    [ "sand-1" ] = "nuclear-ground",
    [ "sand-2" ] = "nuclear-ground",
    [ "sand-3" ] = "nuclear-ground",
  }

  local tiles = surface.find_tiles_filtered{ position = position, radius = 16, name = tile_names, limit = limit }
  if tiles ~= nil then
    for _, tile in pairs ( tiles ) do
      if storage.te.random( 1, 99 ) < chance
        then
        if game.tile_prototypes[terraformation[ tile.name ]] ~= nil
          then
            table.insert( storage.te.tiles, { name = terraformation[ tile.name ], position = tile.position })
          end
      end
    end
  end
end

function Flood ( surface, position, limit, chance )
  local water_tiles = surface.find_tiles_filtered{ position = position, radius = 16, collision_mask = "water-tile", limit = limit }
  if water_tiles ~= nil
    then
    for _, water_tile in pairs ( water_tiles ) do
      if storage.te.random( 1, 99 ) < chance
        then
        local name = "wooden-chest"
        local center = water_tile.position
        local radius = 0
        local precision = 1
        local force_to_tile_center = true
        local newpos = surface.find_non_colliding_position( name, center, radius, precision, force_to_tile_center )
        if newpos ~= nil
          then
          local ground_tiles = surface.find_tiles_filtered{ position = newpos, radius = 1, name = "nuclear-ground", limit = 2 }
          if ground_tiles ~= nil
            then
            for _, ground_tile in pairs ( ground_tiles ) do
              table.insert( storage.te.tiles, { name = "water", position = ground_tile.position })
            end
          end
        end
      end
    end
  end
end

function Drought ( surface, position, limit, chance )
  local ground_tiles = surface.find_tiles_filtered{ position = position, radius = 1.5, collision_mask = "ground-tile", limit = limit }
  if ground_tiles ~= nil
    then
    for _, ground_tile in pairs ( ground_tiles ) do
      if storage.te.random( 1, 99 ) < chance
        then
        local water_tiles = surface.find_tiles_filtered{ position = ground_tile.position, radius = 1, collision_mask = "water-tile", limit = 1 }
        if water_tiles ~= nil
          then
          for _, water_tile in pairs ( water_tiles ) do
            table.insert( storage.te.tiles, { name = "sand-1", position = water_tile.position })
          end
        end
      end
    end
  end
end

function Fire( surface, position, limit, chance )
  local trees = surface.find_entities_filtered{ position = position, radius = 8, type = "tree", limit = limit }
  if trees ~= nil
    then
    for _, tree in pairs ( trees ) do
      if storage.te.random( 1, 99 ) < chance or tree.tree_stage_index > 2
        then
        surface.create_entity({ name = "fire-flame-on-tree", position = tree.position })
      end
    end
  end
end

function ScorchedSoil( event )
  if event.damage_type ~= nil
    then
    if event.damage_type.name == "fire" and event.entity.type == "tree"
      then
      event.entity.surface.set_tiles({ tiles = { name = "nuclear-ground", position = event.entity.position }})
    else
      BloodedSoil( event )
    end
  end
end

function BloodedSoil( event )
  if settings.global[ "hello_Ripley" ].value
    then
    local blacklist = {
      [ "refined-organic-concrete" ] = true,
      [ "refined-hazard-organic-concrete-left" ] = true,
      [ "refined-hazard-organic-concrete-right" ] = true,
      [ "underground-electric-tile" ] = true,
    }
    local tile = event.entity.surface.get_tile( event.entity.position.x, event.entity.position.y )
    if not blacklist[ tile.name ]
      then
      event.entity.surface.set_tiles({ tiles = { name = "grass-1", position = event.entity.position }})
    end
  end
end

function TreeEvolution( surface, position, limit, chance )
  local trees = surface.find_entities_filtered{ position = position, radius = 16, type = "tree", limit = limit }
  if trees ~= nil
    then
    for _, tree in pairs ( trees ) do
      if storage.te.random( 1, 99 ) < chance
        then
        if tree.tree_color_index_max == 0 or tree.tree_color_index == tree.tree_color_index_max or tree.name == "tree-06" or tree.name == "tree-06-brown" or tree.graphics_variation > 9
          then
          surface.create_entity({ name = GetRandomTree( "dead" ), position = tree.position })
          if settings.global[ "weathering_of_cliffs" ].value
            then
            local cliffs = surface.find_entities_filtered{ position = tree.position, radius = 2, type = "cliff", limit = 1 }
            for _, cliff in pairs ( cliffs ) do
              if storage.te.random( 1, 99 ) < 5
                then
                surface.create_entity({ name = "rock-big", position = cliff.position })
                cliff.destroy({ do_cliff_correction = true })
              end
            end
          end
          tree.destroy( )
        else
          tree.tree_color_index = tree.tree_color_index + 1
        end
      end
    end
  end
end

function TreeRotted( surface, position, limit, chance, tiles )
  local tile_names = {
    "landfill",
    "grass-1",
    "grass-2",
    "grass-3",
    "grass-4",
    "dry-dirt",
    "dirt-1",
    "dirt-2",
    "dirt-3",
    "dirt-4",
    "dirt-5",
    "dirt-6",
    "dirt-7",
    "red-desert-0",
    "red-desert-1",
    "red-desert-2",
    "red-desert-3",
    "sand-1",
    "sand-2",
    "sand-3",
    "nuclear-ground",
  }
  local terraformation = {
    [ "landfill" ] = "dry-dirt",
    [ "grass-1" ] = "grass-1",
    [ "grass-2" ] = "grass-1",
    [ "grass-3" ] = "grass-2",
    [ "grass-4" ] = "grass-3",
    [ "dry-dirt" ] = "dirt-7",
    [ "dirt-1" ] = "dirt-2",
    [ "dirt-2" ] = "dirt-3",
    [ "dirt-3" ] = "dirt-4",
    [ "dirt-4" ] = "dirt-5",
    [ "dirt-5" ] = "dirt-6",
    [ "dirt-6" ] = "dirt-7",
    [ "dirt-7" ] = "grass-4",
    [ "red-desert-0" ] = "dry-dirt",
    [ "red-desert-1" ] = "red-desert-0",
    [ "red-desert-2" ] = "red-desert-1",
    [ "red-desert-3" ] = "red-desert-2",
    [ "sand-1" ] = "red-desert-3",
    [ "sand-2" ] = "red-desert-3",
    [ "sand-3" ] = "red-desert-3",
    [ "nuclear-ground" ] = "sand-1",
  }
  local trees = surface.find_entities_filtered{ name = storage.te.dead_trees, position = position, radius = 32, type = "tree", limit = limit }
  if trees ~= nil
    then
    for _, tree in pairs ( trees ) do
      local tiles = surface.find_tiles_filtered{ position = tree.position, radius = 2, name = tile_names, limit = trees_rotted_tiles }
      for _, tile in pairs ( tiles ) do
        if storage.te.random( 1, 99 ) < chance
          then
          tree.destroy( )
          PlaceGrassToTile( surface, tile.position )
          if game.tile_prototypes[terraformation[ tile.name ]] ~= nil
            then
              table.insert( storage.te.tiles, { name = terraformation[ tile.name ], position = tile.position })
            end
        end
      end
    end
  end
end

function TreeExpansion( surface, position, chance )
  if storage.te.random( 1, 99 ) < chance
    then
    local trees = surface.count_entities_filtered{ position = position, radius = 19, type = "tree" }
    if trees < settings.global[ "max_trees_count" ].value
      then
      local name = "tree-01"
      local center = position
      local radius = 18
      local precision = 1
      local force_to_tile_center = true
      local newpos = surface.find_non_colliding_position( name, center, radius, precision, force_to_tile_center )
      if newpos ~= nil
        then
        local biome = BiomeTiles( surface.get_tile( newpos ).name )
        if biome
          then
          tree = surface.create_entity({ name = GetRandomTree( biome ), position = newpos })
          if tree.tree_color_index_max ~= 0
            then
            tree.tree_color_index = 1
          end
        end
      end
    else
      TreeEvolution( surface, position, 8, 100 )
      PlaceGrassToPosition( surface, position )
    end
  end
end

function TreeForestExpansion( surface, position, chance )
  if storage.te.random( 1, 99 ) < chance
    then
    local trees_count = surface.count_entities_filtered{ position = position, radius = 19, type = "tree" }
    if trees_count == 0
      then
      TreeExpansion( surface, position, chance )
    end
    if trees_count < settings.global[ "max_trees_count" ].value
      then
      local trees = surface.find_entities_filtered{ position = position, radius = 1.5, type = "tree", limit = 1 }
      if trees ~= nil
        then
        for _, tree in pairs ( trees ) do
          if settings.global[ "template" ].value == "sparse_forest"
            then
            name = "nuclear-reactor"
            precision = 2.5
          elseif settings.global[ "template" ].value == "forest"
            then
            name = "radar"
            precision = 1.5
          else
            name = tree.name
            precision = 0.5
          end
          local center = tree.position
          local radius = 18
          if storage.te.random( 1, 99 ) > 20
            then
            force_to_tile_center = true
          else
            force_to_tile_center = false
          end
          local newpos = surface.find_non_colliding_position( name, center, radius, precision, force_to_tile_center )
          if newpos ~= nil
            then
            local biome = BiomeTiles( surface.get_tile( newpos ).name )
            if biome
              then
              tree = surface.create_entity({ name = GetRandomTree( biome ), position = newpos })
              if tree.tree_color_index_max ~= 0
                then
                tree.tree_color_index = 1
              end
            end
          end
        end
      end
    else
      TreeEvolution( surface, position, 8, 100 )
      PlaceGrassToPosition( surface, position )
    end
  end
end

function PlaceGrassToPosition( surface, position )
  local tile_position = {
    x = position[ 1 ],
    y = position[ 2 ]
  }
  PlaceGrassToTile( surface, tile_position )
end

function PlaceGrassToTile( surface, position )
  local tile_position = {
    x = position.x + 0.5,
    y = position.y + 0.5
  }
  local tile = surface.get_tile( position )
  if tile.name == "grass-1"
    then
    local grass = {
      {
        name = "green-carpet-grass",
        position = tile_position,
        amount = 1
      }
    }
    surface.create_decoratives({ check_collision = true, decoratives = grass })
  end
end

function GetTimeLenght( time )
  local day_time_minutes = Round( time * 24 * 60 )
  local day_time_hours = Round( day_time_minutes / 60, 2 )

  return string.format( "%d:%02d", day_time_hours, day_time_minutes % 60 )
end

function Round( num, decimal )
  local mult = 10 ^ ( decimal or 0 )
  return math.floor( num * mult + 0.5 ) / mult
end

function Orientation( orientation )
  if orientation >= 0 and orientation <= 0.125
    then
    return "↑"
  end
  if orientation >= 0.125 and orientation <= 0.25
    then
    return "↗"
  end
  if orientation >= 0.25 and orientation <= 0.375
    then
    return "→"
  end
  if orientation >= 0.375 and orientation <= 0.5
    then
    return "↘"
  end
  if orientation >= 0.5 and orientation <= 0.625
    then
    return "↓"
  end
  if orientation >= 0.625 and orientation <= 0.75
    then
    return "↙"
  end
  if orientation >= 0.75 and orientation <= 0.875
    then
    return "←"
  end
  if orientation >= 0.875
    then
    return "↖"
  end
end

function ShowCurrentDate( event )
  local player = game.players[ event.player_index ]
  local surface = player.surface
  local day_time_minutes = Round( math.fmod(( surface.daytime + 0.5 ), 1 ) * 24 * 60 )
  local day_time_hours = day_time_minutes / 60
  local day = Round( event.tick / 25000 )
  local year, modf_year = math.modf( day / 360 )
  local day_of_year = Round( modf_year * 360 )
  local month, modf_day = math.modf( day_of_year / 30 )
  local dusk = surface.dusk
  local evening = surface.evening
  local morning = surface.morning
  local dawn = surface.dawn
  local day_lenght = dusk * 2
  local night_lenght = ( 0.5 - evening ) * 2
  local dusk_lenght = 1 - ( day_lenght + night_lenght )
  local day_of_month = Round( modf_day * 30 )
  day_of_month = day_of_month + 1
  year = year + 1
  month = month + 1
  local evolution_factor = Round( game.forces.enemy.evolution_factor, 2 ) * 100
  local wind_speed = Round( surface.wind_speed, 2 ) * 100
  local wind_orientation = surface.wind_orientation
  local pollution = Round( surface.get_pollution( player.position ))
  local total_pollution = Round( surface.get_total_pollution( ))
  player.clear_console( )
  game.print{ "info.current_time", string.format( "%d:%02d", day_time_hours, day_time_minutes % 60 ), day_of_month, month, year }
  game.print{ "info.current_day_lenght", GetTimeLenght( day_lenght )}
  game.print{ "info.current_dusk_lenght", GetTimeLenght( dusk_lenght )}
  game.print{ "info.current_night_lenght", GetTimeLenght( night_lenght )}
  game.print{ "info.pollution", pollution, total_pollution }
  game.print{ "info.evolution_factor", evolution_factor }
  game.print{ "info.wind", Orientation( wind_orientation ), wind_speed }
end

script.on_init( OnInit )
script.on_load( OnLoad )
script.on_nth_tick( settings.global[ "nature_events_every" ].value, NatureEvents )
script.on_nth_tick( 25000, NatureEvents )
script.on_nth_tick( 50000, NatureEvents )
script.on_event( defines.events.on_entity_died, ScorchedSoil, {{ filter = "type", type = "tree" }, { filter = "type", type = "unit" }, { filter = "type", type = "unit-spawner" }})
script.on_event( defines.events.on_runtime_mod_setting_changed, OnSettingsChange )
script.on_event( "show_current_date", ShowCurrentDate )

