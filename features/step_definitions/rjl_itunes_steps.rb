module KnowsTheDomain
  def itunes
    @itunes ||= Itunes.new
  end
end
World(KnowsTheDomain)

# Scenario Outline: Get artist group and genre information

Given(/^track (\d+)$/) do |track_id|
  itunes = Itunes.new
  $track = itunes.album( track_id )
end

Then(/^artist "([^"]*)", album "([^"]*)", grouping "([^"]*)", genre "([^"]*)"$/) do |artist, album, grouping, genre|
  expect($track["Artist"]).to eql(artist)
  expect($track["Album"]).to eql(album)
  expect($track["Grouping"]).to eql(grouping)
  expect($track["Genre"]).to eql(genre)
end




# Scenario: Change group and genre information without saving to disk

Given(/^track with id (\d+)$/) do |track_id|
  $track_id = track_id
  $track = itunes.album( track_id )
end

Given(/^an original grouping "([^"]*)"$/) do |old_grouping|
  expect($track["Grouping"]).to eql(old_grouping)
end

When(/^I change the grouping to "([^"]*)"$/) do |new_grouping|
  itunes.update_album( $track_id, "Grouping", new_grouping)
end

Then(/^all the album track groupings are "([^"]*)"$/) do |grouping|
  expect(itunes.same?( $track_id, grouping)).to be_truthy
end




# Scenario: Finding albums by artist and album name

Given(/^an iTunes collection$/) do
  itunes = Itunes.new
  expect(itunes.valid?).to be_truthy
end

When(/^I search for "([^"]*)", "([^"]*)"$/) do |artist, album|
  @album = Itunes::Album.new album, artist
  expect(@album).to exist
end

Then(/^I get an album with Grouping "([^"]*)" and Genre "([^"]*)"$/) do |grouping, genre|
  expect(@album.grouping).to eq(grouping)
  expect(@album.genre).to eq(genre)
end
