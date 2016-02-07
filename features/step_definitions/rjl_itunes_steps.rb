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


When(/^I change the grouping to "([^"]*)"$/) do |new_grouping|
  itunes.update_album( $track_id, "Grouping", new_grouping)
end

Then(/^all the album track groupings are "([^"]*)"$/) do |grouping|
  expect(itunes.same?( $track_id, grouping)).to be_truthy
end
