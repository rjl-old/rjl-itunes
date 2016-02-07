module KnowsTheDomain
  def itunes
    @itunes ||= Itunes.new
  end
end
World(KnowsTheDomain)

Given(/^album (\d+)$/) do |album_id|
  itunes = Itunes.new
  $album = itunes.album( album_id )
end

Then(/^artist "([^"]*)", album "([^"]*)", grouping "([^"]*)", genre "([^"]*)"$/) do |artist, album, grouping, genre|
  expect($album["Artist"]).to eql(artist)
  expect($album["Album"]).to eql(album)
  expect($album["Grouping"]).to eql(grouping)
  expect($album["Genre"]).to eql(genre)
end
