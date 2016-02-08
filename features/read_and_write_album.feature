Feature: Read and write album information

  Scenario: Reading album information

    Given an iTunes database
    When I get the first album
    Then the artist is "ZüriWest" and the album is "Retour - Best of Züri West"
    And the grouping is "Ruby Test" and the genre is "Rock"

  Scenario: Writing album grouping and genre information

    Given an iTunes database
    When I get the first album
    And  I set grouping to "Test Grouping" and genre to "Test Genre" and save
    Then The reloaded grouping and genre are "Test Grouping" and genre to "Test Genre"
