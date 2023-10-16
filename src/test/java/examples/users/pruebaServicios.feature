Feature: Prueba de servicios

  Background: 
    * url 'https://restful-booker.herokuapp.com'

  @generar
  Scenario: Generar Token de Autenticación
    Given path 'auth'
    And request
      """
      {
      "username": "admin",
      "password": "password123"
      }
      """
    When method POST
    Then status 200
    * def authToken = response.token
    * print 'Token generado:', authToken

  Scenario: Crear book 1
    Given path 'booking'
    And request
      """
      {
        "firstname": "Pedro",
        "lastname": "Gutierrez",
        "totalprice": 100,
        "depositpaid": true,
         "bookingdates" : {
        	"checkin": "2023-03-01",
        	"checkout": "2023-04-01"
        	},
        "additionalneeds": "Comics"
      }
      """
    When method POST
    Then status 200
    And match response.firstname == "Pedro"

  Scenario: Crear book 2
    Given path 'booking'
    And request
      """
      {
        "firstname": "Javier",
        "lastname": "Jaramillo",
        "totalprice": 356,
        "depositpaid": true,
        "bookingdates" : {
        	"checkin" : "2023-03-15",
        	"checkout" : "2023-04-15"
      },
        "additionalneeds": "Terror"
      }
      """
    When method POST
    Then status 200
    And match response.firstname == "Javier"

  Scenario: Consultar Reserva 1
    Given path 'booking/1'
    When method GET
    Then status 200
    And match response.firstname == "Pedro"

  Scenario: Consultar Reserva 2
    Given path 'booking/2'
    When method GET
    Then status 200
    And match response.firstname == "Javier"

  Scenario: Actualizar book 1
    * def result = call read('classpath:examples/users/createToken.feature@generar')
    Given path 'booking/1'
    And request
      """
      {
        "firstname": "Jose",
        "lastname": "Gutierrez",
        "totalprice": 100,
        "depositpaid": true,
        "bookingdates": {
            "checkin": "2023-05-12",
            "checkout": "2023-06-28"
        },
        "additionalneeds": "Comics"
      }
      """
    And header Cookie	 = 'token='+  result.response.token
    When method PUT
    Then status 200
    And match response.firstname == "Jose"

  Scenario: Actualizar book 2
    * def result = call read('classpath:examples/users/createToken.feature@generar')
    Given path 'booking/2'
    And request
      """
      {
        "firstname": "Javier",
        "lastname": "Mora",
        "totalprice": 356,
        "depositpaid": true,
        "bookingdates": {
            "checkin": "2023-06-20",
            "checkout": "2023-07-20"
        },
        "additionalneeds": "Terror"
      }
      """
    And header Cookie	 = 'token='+  result.response.token
    When method PUT
    Then status 200
    And match response.firstname == "Javier"

  Scenario: Eliminar Reserva 1
    * def result = call read('classpath:examples/users/createToken.feature@generar')
    Given path 'booking/1'
    And header Cookie	 = 'token='+  result.response.token
    When method DELETE
    Then status 201

  Scenario: Eliminar Reserva 2
    * def result = call read('classpath:examples/users/createToken.feature@generar')
    Given path 'booking/2'
    And header Cookie	 = 'token='+  result.response.token
    When method DELETE
    Then status 201
