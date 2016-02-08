Feature: Manipulate album information directly

  We're going to be tagging Grouping and Style information at the album level
  So we need to say things like:

    album = itunes.albums(album: "Gold", artist: "Abba")
    album.exists?
    album.grouping = "Pop/Rock"
    album.genre = "Scandinavian Pop"

  TODO: We need to check it will find an album if only an album title is specified

  Scenario Outline: Different combinations of existing artist and album

    There's lots of "Greatest Hits" albums. Make sure we don't get the wrong ones.

    Given an iTunes collection
    When I search for "<artist>", "<album>"
    Then the album <exists>

      Examples:
        | artist      | album         | exists     |
        | Blondie     | Greatest Hits | true       |
        | Blondie     | Death Metal   | False      |
        | Spice Girls | Greatest Hits | False      |
        | Spice Girls | Death Metal   | False      |

  Scenario: Changing album Grouping and Genre information in iTunes

    Given an iTunes collection
    And the album "Retour - Best of Züri West" by "ZüriWest"
    When I change the Grouping to "Test Grouping"
    And I change the Genre to "Test Genre"
    Then the Grouping is "Test Grouping"
    And the Genre is "Test Genre"

  Scenario: Save Grouping and Genre informtion to iTunes

    Given an iTunes collection
    And the album "Thirteenth Step" by "A Perfect Circle blah"
    When I change the Genre to "a datestamp"
    And save the file
    Then Genre is still "a date stamp" when I reload the album
