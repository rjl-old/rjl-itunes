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


# Scenario: Changing album Grouping information in iTunes

Given(/^the album  "([^"]*)" by "([^"]*)"$/) do |album, artist|
  @album = Itunes::Album.new album, artist
  expect(@album).to exist
end

When(/^I change the Grouping to "([^"]*)"$/) do |new_grouping|
  @album.grouping = new_grouping
end

Then(/^the Grouping is "([^"]*)" when the iTunes colletion is reloaded$/) do |new_grouping|
  expect(@album.grouping).to eq(new_grouping)
end
