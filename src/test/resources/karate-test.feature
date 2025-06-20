@REQ_HU_001 @MarvelApi @agente1
Feature: HU001 Pruebas CRUD en Marvel API

Background:
  Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maamuril/api/characters'

@id:1 @Marvel @ObtenerPersonajes
Scenario: T-API-HU-001-CA01- Obtener todos los personajes
  When method GET
  Then status 200
    And match response != null
    And match response[*].id != null
    And match response[*].name != null

@id:2 @Marvel @ObtenerPersonajePorId
Scenario: T-API-HU-001-CA02- Obtener personaje por Id
  * def personaje = read('classpath:../data/Marvel/personaje.json')
  * personaje.name = personaje.name + '_' + java.util.UUID.randomUUID()
  And request personaje
  When method POST
  Then status 201
  And def personajeId = response.id

  Given path personajeId
  When method GET
  Then status 200
  And match response.name == personaje.name
  And match response.alterego == personaje.alterego

@id:3 @Marvel @ObtenerPersonajePorIdInexistente
  Scenario: T-API-HU-001-CA03- Obtener personaje por Id inexistente
  Given path 99999
  When method GET
  Then status 404
  And match response.error == 'Character not found'

@id:4 @Marvel @CrearPersonajeValido
Scenario: T-API-HU-001-CA04- Crear un personaje válido
  * def personaje = read('classpath:../data/Marvel/personaje.json')
  * personaje.name = personaje.name + '_' + java.util.UUID.randomUUID()
  And request personaje
  When method POST
  Then status 201
  And match response.id != null
  And match response.name == personaje.name
  And match response.alterego == personaje.alterego
  And match response.description == personaje.description
  And match response.powers == personaje.powers

@id:5 @Marvel @CrearPersonajeDuplicado
Scenario: T-API-HU-001-CA05- Crear un personaje duplicado
  * def personaje = read('classpath:../data/Marvel/personaje.json')
  And request personaje
  When method POST
  Then status 400
  And match response.error == 'Character name already exists'

@id:6 @Marvel @CrearPersonajeConDatosInvalidos
Scenario: T-API-HU-001-CA06- Crear un personaje con datos invalidos
  * def personajeInvalido = read('classpath:../data/Marvel/personaje_invalido.json')
  And request personajeInvalido
  When method POST
  Then status 400
  And match response.name == "Name is required"
  And match response.description == "Description is required"
  And match response.powers == "Powers are required"

@id:7 @Marvel @ActualizarPersonajeValido
Scenario: T-API-HU-001-CA07- Actualizar personaje valido
  * def personaje = read('classpath:../data/Marvel/personaje.json')
  * personaje.name = personaje.name + '_' + java.util.UUID.randomUUID()
  And request personaje
  When method POST
  Then status 201
  And def personajeId = response.id

  * personaje.description = 'Nuevo Alter Ego'
  Given path personajeId
  And request personaje
  When method PUT
  Then status 200
  And match response.id == personajeId
  And match response.description == 'Nuevo Alter Ego'

@id:8 @Marvel @ActualizarPersonajeInexistente
Scenario: T-API-HU-001-CA08- Actualizar personaje inexistente
  * def personajeInexistente = read('classpath:../data/Marvel/personaje_inexistente.json')
  Given path 99999
  And request personajeInexistente
  When method PUT
  Then status 404
  And match response.error == "Character not found"

@id:9 @Marvel @EliminarPersonajeValido
Scenario: T-API-HU-001-CA09- Eliminar Personaje Valido
  * def personaje = read('classpath:../data/Marvel/personaje.json')
  * personaje.name = personaje.name + '_' + java.util.UUID.randomUUID()
  And request personaje
  When method POST
  Then status 201
  And def personajeId = response.id

  Given path personajeId
  When method DELETE
  Then status 204

  Given path personajeId
  When method GET
  Then status 404
  And match response.error == "Character not found"

@id:10 @Marvel @EliminarPersonajeInexistente
Scenario: T-API-HU-001-CA10- Eliminar Personaje Inexistente
  Given path 99999
  When method DELETE
  Then status 404
  And match response.error == "Character not found"
