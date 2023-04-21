--[[
	Author: T Sliger
	Date: Nov 11 2020
	Updated: Apr 20 2023

	Purpose: parse .obj data into opengl commands
]]

local vertices = {}
local normals = {}
local textures = {}

local strings = {}
local faces = {}

currV = 0;

function parse()
	local fileName = arg[1]

	-- File not valid name extension
	if (not fileName or not string.match(fileName, "%.obj$")) then
		print('ERROR: did not provide a file name to parse')
		return
	end

	file = io.open (fileName, "r")

	-- File not loaded
	if (not file) then 
		print('ERROR: could not load file, .obj could be corrupted or does not exist')
		return
	end

	io.input(file)
	local len = 0;

	for line in io.lines() do
		local ty = string.match(line, "(.) ")

		if ty == "v" then
			local _, x, y, z = string.match(line, "(.+) (.+) (.+) (.+)")
			local vec3 = {}
			vec3.x = x;
			vec3.y = y;
			vec3.z = z;

			table.insert(vertices, vec3);
		end

		if ty == "t" then
			local _, x, y = string.match(line, "(.+) (.+) (.+)")
			local vec3 = {}
			vec3.x = x;
			vec3.y = y;

			table.insert(textures, vec3);
		end

		if ty == "n" then
			local _, x, y, z = string.match(line, "(.+) (.+) (.+) (.+)")
			local vec3 = {}
			vec3.x = x;
			vec3.y = y;
			vec3.z = z;

			table.insert(normals, vec3);
		end

		if ty == "f" then
			local _, x, y, z = string.match(line, "(.+) (.+) (.+) (.+)")
			local vec3 = {}
			vec3[1] = x;
			vec3[2] = y;
			vec3[3] = z;

			table.insert(faces, vec3);
		end

    	len  = len + 1
    end

    io.close(file)
end



function output()
	parse()

	for _, face in pairs (faces) do
		for i = 1, 3 do
			local v, t, n = string.match(face[i], "(.+)/(.+)/(.+)")

			local vert = vertices[tonumber(v)]

			local tex = textures[tonumber(t)]

			local norm = normals[tonumber(n)]

			local str = "glTexCoord2f("..tex.x.."f,"..tex.y.."f); glVertex3f("..vert.x.."f,"..vert.y.."f,"..vert.z.."f); "

			table.insert(strings, str)
		end

	end

	local file = io.open("model.txt", "w")

	for _, str in pairs(strings) do
		file:write(str.."\n")
	end

	io.close(file)
end

output();