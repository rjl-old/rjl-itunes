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
