
bonemeal = {}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP .. "/intllib.lua")


-- special pine check for nearby snow
local function pine_grow(pos)

	if minetest.find_node_near(pos, 1,
		{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then

		default.grow_new_snowy_pine_tree(pos)
	else
		default.grow_new_pine_tree(pos)
	end
end

local function banana_grow(pos)
  farming.generate_tree({x=pos.x, y=pos.y+1, z=pos.z}, "default:tree", "farming_plus:banana_leaves",  farming.good_ground, {["farming_plus:banana"]=10},true)
end

local function cacoa_grow(pos)
  farming.generate_tree({x=pos.x, y=pos.y+1, z=pos.z}, "default:tree", "farming_plus:cocoa_leaves", {"default:sand", "default:desert_sand"}, {["farming_plus:cocoa"]=20},true)
end

-- default saplings
local saplings = {
	{"default:sapling", default.grow_new_apple_tree, "soil"},
	{"default:junglesapling", default.grow_jungle_tree, "soil"},
	{"default:acacia_sapling", default.grow_new_acacia_tree, "soil"},
	{"default:aspen_sapling", default.grow_new_aspen_tree, "soil"},
	{"default:pine_sapling", pine_grow, "soil"},
	{"default:bush_sapling", default.grow_bush, "soil"},
	{"default:acacia_bush_sapling", default.grow_acacia_bush, "soil"},
	{"ferns:sapling_giant_tree_fern", abstract_ferns.grow_giant_tree_fern, "soil"},
	{"ferns:sapling_tree_fern", abstract_ferns.grow_tree_fern, "soil"},
	{"farming_plus:cocoa_sapling", cacoa_grow, "soil"},
	{"farming_plus:banana_sapling", banana_grow, "soil"},
}

----- local functions


-- particles
local function particle_effect(pos)

	minetest.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png",
	})
end


-- tree type check
local function grow_tree(pos, object)

	if type(object) == "table" and object.axiom then
		-- grow L-system tree
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, object)

	elseif type(object) == "string" and minetest.registered_nodes[object] then
		-- place node
		minetest.set_node(pos, {name = object})

	elseif type(object) == "function" then
		-- function
		object(pos)
	end
end


-- sapling check
local function check_sapling(pos, nodename)

	for n = 1, #saplings do
                            if saplings[n][1] == nodename then
				particle_effect(pos)
				if nodename == "ferns:sapling_giant_tree_fern" or nodename == "ferns:sapling_tree_fern" or nodename == "farming_plus:cocoa_sapling" or nodename ==  "farming_plus:banana_sapling"then
				      minetest.remove_node(pos)
				      grow_tree({x=pos.x,y=pos.y-1,z=pos.z}, saplings[n][2])
				else
				      grow_tree(pos, saplings[n][2])
				    
				end
			
			    end
				
	end
end


-- global functions


-- add to sapling list
-- {sapling node, schematic or function name, "soil"|"sand"|specific_node}
--e.g. {"default:sapling", default.grow_new_apple_tree, "soil"}

function bonemeal:add_sapling(list)

	for n = 1, #list do
		table.insert(saplings, list[n])
	end
end


-- global on_use function for bonemeal
function bonemeal:on_use(pos, strength)

	-- get node pointed at
	local node = minetest.get_node(pos)

	-- return if nothing there
	if node.name == "ignore" then
		return
	end

	-- check for tree growth if pointing at sapling
	if minetest.get_item_group(node.name, "sapling") > 0 then
		check_sapling(pos, node.name)
		return
	end

end


----- items


-- bonemeal (strength 2)
minetest.register_craftitem("bonemeal:bonemeal", {
	description = S("Bone Meal"),
	inventory_image = "bonemeal_item.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)

		-- did we point at a node?
		if pointed_thing.type ~= "node" or user.is_fake_player then
			return
		end

		-- is area protected?
		if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
			return
		end
		local imeta = itemstack:get_metadata()
		
		if imeta == nil or imeta == "" then
		    local name = user:get_player_name()
		    imeta = name
		    itemstack:set_metadata(imeta)
		else
		  local name = user:get_player_name()
		  if imeta ~= name then
		      minetest.chat_send_player(name,"You cannot borrow this device !")
		  else
		     bonemeal:on_use(pointed_thing.under, 2)
		  end 
		end

		return itemstack
	end,
	
	
	on_place = function(itemstack, placer, pointed_thing)
	
	      local pos = minetest.get_pointed_thing_position(pointed_thing)
	      local name = placer:get_player_name()
	      
	    if pos then
	   
	      local light = minetest.get_node_light(pos)
	      local dlight = minetest.get_node_light({x=pos.x, y=pos.y -1, z=pos.z})
	      local ulight = minetest.get_node_light({x=pos.x, y=pos.y +1, z=pos.z})
	      
	      minetest.chat_send_player(name, " >>>  lightlevel of pointed node = "..light.."  <<<     below it = "..dlight..",   above it = "..ulight)
	    end
	    
	end,
})



-- add support for other mods
dofile(minetest.get_modpath("bonemeal") .. "/mods.lua")

print (S("[bonemeal] loaded"))
