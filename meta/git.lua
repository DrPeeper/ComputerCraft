-- TODO: change maxtrussell -> DrPeeper
BASE_URL = "https://raw.githubusercontent.com/maxtrussell/ComputerCraft/master"

-- add files here as our repo grows
FILES = {
	"/lib/fuel.lua",
	"/lib/inv.lua",
	"/bin/dumb_tunnel.lua",
	"/bin/test.lua",
}

function getFile(filename)
	-- download file from github
	download = http.get(BASE_URL .. filename)
	if download == nil then
		print("Download failed for " .. BASE_URL .. filename)
	end
	contents = download.readAll()

	-- write file
	file = fs.open(filename, "w")
	file.write(contents)
	file.close()
end

-- entry point
-- make sure directories exist
fs.makeDir("/lib")
fs.makeDir("/bin")

for _, file in ipairs(FILES) do
	print("Downloading " .. file .. "...")
	getFile(file)
end

