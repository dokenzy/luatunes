local http = require('socket.http')
local url = 'https://itunes.apple.com/search?term='
local json = require('dkjson')

itunes = {}

function itunes.tracks (name)
	local b, c, h = http.request(url..name)
	local data, pos, err = json.decode(b, 1, nil)
	return data
end

function itunes.save_artwork(artist)
	local response = itunes.tracks(artist)
	if type(response) == 'nil' then
		print('ERROR')
		return
	end
	results = response.results
	resultCount = response.resultCount
	for k, v in pairs(results) do
		local b, c, h = http.request(v.artworkUrl100)
		local img = io.open(itunes.tmp_img_name(k), 'wb')
		img:write(b)
		img:close()
	end
end

function itunes.tmp_img_name(index)
	return 'tmp'..index..'.jpg'
end

function itunes.clear_tmp_artwork()
	for i=1, resultCount do
		os.remove('tmp' .. i .. '.jpg')
	end
end

function itunes.normalize(str)
	str = str:gsub('&', '\\&'):gsub('_', '\\_')
	return str
end

return itunes
