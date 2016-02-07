Feature: Read album information from the iTunes plit

  In order to get information about genre and style, as an iTunes user
  I need to get the artist and album names for all the music albums in iTunes.

  Scenario: Get the artist and album name of the first album

    This will break if the first album changes. Creted here to get started.

    Given there is an iTunes plist
    And it has at least one album
    When I get the first album
    Then it has the artist "ABBA"
    And the album title is "Gold"
