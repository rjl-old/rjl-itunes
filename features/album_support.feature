Feature: Manipulate album information directly

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

  Scenario: Changing album Grouping and Genre information in iTunes

    Given an iTunes collection
    And the album  "Retour - Best of Züri West" by "ZüriWest"
    When I change the Grouping to "Test Grouping"
    And I change the Genre to "Test Genre"
    Then the Grouping is "Test Grouping"
    And the Genre is "Test Genre"
