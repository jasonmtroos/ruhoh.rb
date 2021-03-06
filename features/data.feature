Feature: Data
  As a content publisher
  I want to define arbitrary data objects
  so I can quickly display and iterate through this data within my content

  Scenario: Defining a basic data structure in data.yml
    Given the file "data.yml" with body:
      """
      ---
      name: "jade"
      address:
        city: "alhambra"
      fruits:
        - mango
        - kiwi
      """
      And the file "_root/index.html" with body:
        """
        <name>{{ data.name }}</name>
        <city>{{ data.address.city }}</city>
        <ul>
        {{# data.fruits }}
          <li>{{ . }}</li>
        {{/ data.fruits }}
        </ul>
        """
    When I compile my site
    Then my compiled site should have the file "index.html"
      And this file should contain the content node "name|jade"
      And this file should contain the content node "city|alhambra"
      And this file should contain the content node "li|mango"
      And this file should contain the content node "li|kiwi"

  Scenario: Defining a basic data structure in data.json
    Given the file "data.json" with body:
      """
      {
        "address": {
          "city": "alhambra"
        }, 
        "name": "jade", 
        "fruits": [
          "mango", 
          "kiwi"
        ]
      }
      """
      And the file "_root/index.html" with body:
        """
        <name>{{ data.name }}</name>
        <city>{{ data.address.city }}</city>
        <ul>
        {{# data.fruits }}
          <li>{{ . }}</li>
        {{/ data.fruits }}
        </ul>
        """
    When I compile my site
    Then my compiled site should have the file "index.html"
      And this file should contain the content node "name|jade"
      And this file should contain the content node "city|alhambra"
      And this file should contain the content node "li|mango"
      And this file should contain the content node "li|kiwi"


  Scenario: Defining a basic data structure in data.json and merging with a theme data.json
    Given a config file with values:
      | theme-test | { "use" : "theme" } |
      And the file "data.json" with body:
      """
      {
        "address": {
          "city": "alhambra"
        }, 
        "name": "jade", 
        "fruits": [
          "mango", 
          "kiwi"
        ]
      }
      """
      And the file "theme-test/data.json" with body:
        """
        {
          "address": {
            "city": "Berkeley"
          },
          "greeting": "Hai!"
        }
        """
      And the file "_root/index.html" with body:
        """
        <name>{{ data.name }}</name>
        <city>{{ data.address.city }}</city>
        <greeting>{{ data.greeting }}</greeting>
        <ul>
        {{# data.fruits }}
          <li>{{ . }}</li>
        {{/ data.fruits }}
        </ul>
        """
    When I compile my site
    Then my compiled site should have the file "index.html"
      And this file should contain the content node "name|jade"
      And this file should contain the content node "city|Berkeley"
      And this file should contain the content node "li|mango"
      And this file should contain the content node "li|kiwi"
      And this file should contain the content node "greeting|Hai!"

Scenario: Defining a basic data structure in custom data collection
  Given a config file with values:
    | meta | { "use" : "data" } |
  Given the file "meta/data.json" with body:
    """
    {
      "address": {
        "city": "alhambra"
      }, 
      "name": "jade", 
      "fruits": [
        "mango", 
        "kiwi"
      ]
    }
    """
    And the file "_root/index.html" with body:
      """
      <name>{{ meta.data.name }}</name>
      <city>{{ meta.data.address.city }}</city>
      <ul>
      {{# meta.data.fruits }}
        <li>{{ . }}</li>
      {{/ meta.data.fruits }}
      </ul>
      """
  When I compile my site
  Then my compiled site should have the file "index.html"
    And this file should contain the content node "name|jade"
    And this file should contain the content node "city|alhambra"
    And this file should contain the content node "li|mango"
    And this file should contain the content node "li|kiwi"
