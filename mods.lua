

if minetest.get_modpath("moretrees") then

	-- special fir check for snow
	local function fir_grow(pos)

		if minetest.find_node_near(pos, 1,
			{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then

			moretrees.grow_fir_snow(pos)
		else
			moretrees.grow_fir(pos)
		end
	end

	bonemeal:add_sapling({
		{"moretrees:beech_sapling", moretrees.spawn_beech_object, "soil"},
		{"moretrees:apple_tree_sapling", moretrees.spawn_apple_tree_object, "soil"},
		{"moretrees:oak_sapling", moretrees.spawn_oak_object, "soil"},
		{"moretrees:sequoia_sapling", moretrees.spawn_sequoia_object, "soil"},
		--{"moretrees:birch_sapling", moretrees.spawn_birch_object, "soil"},
		{"moretrees:birch_sapling", moretrees.grow_birch, "soil"},
		{"moretrees:palm_sapling", moretrees.spawn_palm_object, "soil"},
		{"moretrees:palm_sapling", moretrees.spawn_palm_object, "sand"},
		{"moretrees:date_palm_sapling", moretrees.spawn_date_palm_object, "soil"},
		{"moretrees:date_palm_sapling", moretrees.spawn_date_palm_object, "sand"},
		--{"moretrees:spruce_sapling", moretrees.spawn_spruce_object, "soil"},
		{"moretrees:spruce_sapling", moretrees.grow_spruce, "soil"},
		{"moretrees:cedar_sapling", moretrees.spawn_cedar_object, "soil"},
		{"moretrees:willow_sapling", moretrees.spawn_willow_object, "soil"},
		{"moretrees:rubber_tree_sapling", moretrees.spawn_rubber_tree_object, "soil"},
		{"moretrees:fir_sapling", fir_grow, "soil"},
		{"moretrees:poplar_sapling", moretrees.spawn_poplar_object, "soil"},
		{"moretrees:poplar_small_sapling", moretrees.spawn_poplar_small_object, "soil"}
	})

elseif minetest.get_modpath("technic_worldgen") then

	bonemeal.add_sapling({
		{"moretrees:rubber_tree_sapling", technic.rubber_tree_model, "soil"},
	})
end
