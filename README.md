Fork and 2.0 port of [TerrainEvolution](https://mods.factorio.com/mod/TerrainEvolution) by Cheshirrski. This current version makes as few changes as possible to the mod to maintain the creator's original vision. Future updates will add new changes. I don't speak Russian, so I can't verify how well that existing English text matches the creator's native Russian text.

The mod adds a dynamic terrain change to the game.

In areas with high pollution, soil degradation occurs along the chain grass-> earth-> desert-> sand-> wasteland. Coastal water cells will sometimes dry out to form sand cells. Coastal wasteland cages will occasionally flood to form a water cage. In areas with high pollution, nothing grows and there is a chance of forest fires. Trees damaged by pollution have a 100% chance of catching fire. Fires create wasteland cells.

- Trees grow in areas without pollution. The trees gradually change color and dry out. Withered trees decompose and there is a gradual restoration of the soil along the reverse, but slower chain of wasteland -> sand -> desert -> earth -> grass. Each biome has its own tree species. The wastelands are home to the ugliest trees, but they have the shortest life cycle.

- Cells with any coating are not subject to change, but nothing grows on them.

- When a tree near a cliff dries up, there is a 5% chance that the cliff cell will disappear.

- Hi Ripley - With this setting, beetle blood eats away at any surface, but improves the soil cage to the max.

### How it works - 

Every n ticks, a random chunk (or several) is selected, the pollution in the chunk is read and, depending on the pollution, certain processes occur. In aggressive mode, there is an additional passage through the chunks, which contain the player's buildings.

Adds an annual cycle to the game. The duration of the day, night, twilight is calculated separately for each day. To simplify calculations, a year lasts 360 days, 30 days in a month. The crash occurred on the 1st of the 1st year. 90th, 270th day - equinox, 180 - summer solstice, 360 - winter solstice.

## Presets:
 - Winter is coming - half a year is a very short day, half a year is a very short night
 - Middle-earth - daily cycles like in middle latitudes
 - Equator - the default factorio world with short nights and twilight without a dynamic change in duration

For the first two presets - trees do not grow until the length of the day is less than the length of the night

New setting to change the darkness of the night

The mod has many settings, everything can be customized for yourself. 

## Special Thanks

- The people of Ukraine, including Cheshirrski. The ongoing war in Ukraine prevents Cheshirrski from updating their mods themselves.