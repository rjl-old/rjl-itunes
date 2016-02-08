Feature: Read and write album information

  Scenario: Reading album information

    Given an iTunes database
    When I get the first album
    Then the artist is "ZüriWest" and the album is "Retour - Best of Züri West"
    And the grouping is "Ruby Test" and the genre is "Rock"
