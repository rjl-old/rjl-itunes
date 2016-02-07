Feature: Read album information from the iTunes plit

  In order to get information about genre and style, as an iTunes user
  I need to get the artist and album names for all the music albums in iTunes.

  Scenario Outline: Get artist group and genre information

    This checks we can get album information

    Given album <id>
    Then artist "<artist>", album "<album>", grouping "<grouping>", genre "<genre>"

      Examples:
        | id   | artist   | album                       | grouping | genre |
        | 2574 | ZüriWest | Retour - Best of Züri West  | Ruby Test | Rock |
