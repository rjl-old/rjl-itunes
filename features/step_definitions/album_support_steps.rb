# Scenario: Finding albums by artist and album name

Given(/^an iTunes collection$/) do
  itunes = Itunes.new
  expect(itunes.valid?).to be_truthy
end

When(/^I search for "([^"]*)", "([^"]*)"$/) do |artist, album|
  @album = Itunes::Album.new album, artist
end

Then(/^the album (#{CAPTURE_TRUE_FALSE})$/) do |state|
  expect(@album.exists?).to be state
end

Then(/^I get an album with Grouping "([^"]*)" and Genre "([^"]*)"$/) do |grouping, genre|
  expect(@album.grouping).to eq(grouping)
  expect(@album.genre).to eq(genre)
end


# Scenario: Changing album Grouping information in iTunes

Given(/^the album "([^"]*)" by "([^"]*)"$/) do |album, artist|
  @album = Itunes::Album.new album, artist
  expect(@album.exists?).to be true
end

When(/^I change the Grouping to "([^"]*)"$/) do |new_grouping|
  @album.grouping = new_grouping
end

When(/^I change the Genre to "([^"]*)"$/) do |new_genre|
  @album.genre = new_genre
end

Then(/^the Grouping is "([^"]*)"$/) do |new_grouping|
  expect(@album.grouping).to eq(new_grouping)
end

Then(/^the Genre is "([^"]*)"$/) do |new_genre|
  expect(@album.genre).to eq(new_genre)
end


# Scenario: Save Grouping and Genre informtion

When(/^save the file$/) do
  @album.save
end

Then(/^Genre is still "([^"]*)" when I reload "([^"]*)" by "([^"]*)"$/) do |genre, album, artist|
  @album2 = Itunes::Album.new album, artist
  expect(@album2.genre).to eq(genre)


end
