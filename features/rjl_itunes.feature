Feature: Read album information from the iTunes plit

  In order to get information about genre and style, as an iTunes user
  I need to get the artist and album names for all the music albums in iTunes.

  Scenario Outline: Get artist group and genre information

    This checks we can get album information

    Given track <id>
    Then artist "<artist>", album "<album>", grouping "<grouping>", genre "<genre>"

      Examples:
        | id   | artist   | album                       | grouping | genre |
        | 2574 | ZüriWest | Retour - Best of Züri West  | Ruby Test | Rock |


  Scenario: Change group and genre information without saving to disk

    These tests interact directly with the Hash parsed from the XML
    So we say things like:

      track = itunes.album( track_id )
      puts track["Artist"]
      itunes.update_album( $track_id, "Grouping", new_grouping)

    Given track with id 2574
    And an original grouping "Ruby Test"
    When I change the grouping to "Ruby Test2"
    Then all the album track groupings are "Ruby Test2"


  Scenario: Finding albums by artist and album name

    We're going to be tagging Grouping and Style information at the album level
    So we need to say things like:

      album = itunes.albums(album: "Gold", artist: "Abba")
      album.grouping = "Pop/Rock"
      album.genre = "Scandinavian Pop"

    TODO: We need to check it will find an album if only an album title is specified

    Given an iTunes collection
    When I search for "ZüriWest", "Retour - Best of Züri West"
    Then I get an album with Grouping "Ruby Test" and Genre "Rock"
