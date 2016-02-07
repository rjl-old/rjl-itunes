Feature: Read album information from the iTunes plit

  In order to get information about genre and style, as an iTunes user
  I need to get the artist and album names for all the music albums in iTunes.

  Scenario: Get the artist and album name of the first album

    This will break if the first album changes. Created here to get started.

    Given there is an iTunes plist
    And it has at least one album
    When I get the album with id 2574
    Then it has the artist "ZüriWest"
    And the album title is "Retour - Best of Züri West"
