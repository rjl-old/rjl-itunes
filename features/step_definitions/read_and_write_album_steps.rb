Given(/^an iTunes database$/) do
  expect { itunes = Itunes.new }.not_to raise_error
end

When(/^I get the first album$/) do
  $album = itunes.albums.first
  expect($album).not_to be_nil
end

Then(/^the artist is "([^"]*)" and the album is "([^"]*)"$/) do |artist, album|
  expect($album.artist).to eq(artist)
  expect($album.album).to eq(album)
end

Then(/^the grouping is "([^"]*)" and the genre is "([^"]*)"$/) do |grouping, genre|
  expect($album.grouping).to eq(grouping)
  expect($album.genre).to eq(genre)
end

When(/^I set grouping to "([^"]*)" and genre to "([^"]*)" and save$/) do |grouping, genre|
  $album = itunes.albums.first
  $album.grouping = grouping
  $album.genre = genre
end

Then(/^The reloaded grouping and genre are "([^"]*)" and genre to "([^"]*)"$/) do |grouping, genre|
  itunes.save
  itunes_new = Itunes.new
  $album = itunes_new.albums.first
  expect($album.grouping).to eq(grouping)
  expect($album.genre).to eq(genre)

end
