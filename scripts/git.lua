BASE_URL = "https://raw.githubusercontent.com/DrPeeper/ComputerCraft/master"

-- add files here as our repo grows
FILES = {
	"/lib/fuel.lua",
	"/lib/inv.lua",
	"/lib/nav.lua",
	"/lib/dig.lua",
	"/bin/quarry",
	"/bin/trash_can",
	"/bin/dumb_farm.lua",
	"/bin/wood_farmer.lua",
	"/bin/dumb_farm.lua",
	"/scripts/git.lua",
}

function getFile(filename)
	-- download file from github
	local resp = http.get(BASE_URL .. filename)
	if resp == nil then
		print("Download failed for " .. BASE_URL .. filename)
		return
	end

	-- write file
	local file = fs.open(filename, "w")
	file.write(resp.readAll())
	file.close()
end

-- entry point
-- make sure directories exist
if not fs.exists("/lib") then
	fs.makeDir("/lib")
end
if not fs.exists("/bin") then
	fs.makeDir("/bin")
end
if not fs.exists("/scripts") then
	fs.makeDir("/scripts")
end

for _, file in ipairs(FILES) do
	print("Downloading " .. file .. "...")
	getFile(file)
end

