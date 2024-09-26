@parallel=false
Feature: Error validations for customer API
  Background:
    * url baseUrl
    * def expiredToken = 'Bearer '+ expiredToken
    * def uuid = function(){ return java.util.UUID.randomUUID() }
    * def invalidContent = '☕ Ų̥̻͎̟̦͕̈̌̾́n̊̈ͯ̓̈́͐̀͏̱(i̷̛̯̰͖̥ͧ̽͒̎ͮc̶͙̩̤̱͙ͥ͋̒̃!o͇̱̼̜͓͕̥͎͂͊̉̑͘d͕̱͍̟̙͙̼͍̄̀#\ẻ̻̱̋ͣͫ̿͐̋͞)ab&+*?!'

  Scenario Outline: Test wrong auth header with <restMethod> and auth-header = <tokenAuth> and expected status code <statusCode>
    Given path 'path'
    And header Authorization = <tokenAuth>
    When method <restMethod>
    Then status <statusCode>
    Examples:
      | tokenAuth        |restMethod|statusCode|
      | ''               |GET       |401      |
      | 'wrong'          |GET       |401      |
      | 'Bearer '        |GET       |401      |
      | 'Bearer XXX'     |GET       |401      |
      | expiredToken     |GET       |401      |
      | invalidContent   |GET       |401      |
      | ''               |POST      |401      |
      | 'wrong'          |POST      |401      |
      | 'Bearer '        |POST      |401      |
      | 'Bearer XXX'     |POST      |401      |
      | expiredToken     |POST      |401      |
      | invalidContent   |POST      |401      |
      | ''               |PUT       |401      |
      | 'wrong'          |PUT       |401      |
      | 'Bearer '        |PUT       |401      |
      | 'Bearer XXX'     |PUT       |401      |
      | expiredToken     |PUT       |401      |
      | invalidContent   |PUT       |401      |
      | ''               |DELETE    |401      |
      | 'wrong'          |DELETE    |401      |
      | 'Bearer '        |DELETE    |401      |
      | 'Bearer XXX'     |DELETE    |401      |
      | expiredToken     |DELETE    |401      |
      | invalidContent   |DELETE    |401      |

  Scenario Outline: Perform CRUD operations without auth header: <restMethod> and the expected result must be <statusCode>
    Given path 'path'
    When method <restMethod>
    Then status <statusCode>
    Examples:
      |restMethod |statusCode|
      |GET        |401       |
      |POST       |401       |
      |PUT        |401       |
      |DELETE     |401       |

  Scenario Outline: Perform POST and PUT requests with -> no json body
    Given path 'path'
    And header Authorization = 'Bearer '+ authToken
    When method <restMethod>
    Then status <statusCode>
    Examples:
      | restMethod  |statusCode |
      | POST        |400        |
      | PUT         |400        |

  Scenario: Retrive a serviceid with an invalid serviceId
    * def serviceId = uuid()
    Given path 'path', serviceId
    And header Authorization = 'Bearer '+ authToken
    When method GET
    Then status 404

  Scenario Outline: Perform a GET request with all the parameters with an empty value
    Given path 'path'
    And param <paramName> = ''
    And header Authorization = 'Bearer '+ authToken
    When method GET
    Then status <statusCode>
    Examples:
      | paramName       |statusCode |
      | offset          |400        |
      | limit           |400        |

  Scenario Outline: Perform a GET request by passing invalid content as parameter
    Given path 'path'
    And param <paramName> = invalidContent
    And header Authorization = 'Bearer '+ authToken
    When method GET
    Then status <statusCode>
    Examples:
      | paramName       |statusCode |
      | offset          |400        |
      | limit           |400        |

  Scenario Outline: Perform a GET request by passing invalid values in parameters
    Given path 'path'
    And param <paramName> = <paramValue>
    And header Authorization = 'Bearer '+ authToken
    When method GET
    Then status <statusCode>
    Examples:
      |paramName        | paramValue  |statusCode |
      |offset           | '-1'        |400        |
      |offset           | '!'         |400        |
      |offset           | '-0'        |200        |
      |offset           | '-100'      |400        |
      |limit            | 'test'      |400        |
      |limit            | '-0'        |400        |
      |limit            | '-100'      |400        |
      |limit            | '1001'      |400        |
