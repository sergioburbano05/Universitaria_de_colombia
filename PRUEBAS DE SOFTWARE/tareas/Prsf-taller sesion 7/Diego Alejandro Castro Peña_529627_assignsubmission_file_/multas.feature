
Feature: Sistema de multas por devolución tardía
  Como estudiante de la Universitaria de Colombia
  Quiero conocer y gestionar mis multas de biblioteca
  Para poder planificar mis reservas de libros

  Scenario: AC-1 Cálculo de multa por 3 días de retraso
    Given que un estudiante tiene un libro con 3 días de retraso
    When el sistema consulta el monto de la multa
    Then el sistema debe calcular un total de 1500 COP

  Scenario: AC-2 Estudiante sin multa pendiente
    Given que un estudiante no tiene libros vencidos
    When el sistema consulta su estado de cuenta
    Then el mensaje debe decir "Sin multa pendiente"

  Scenario: AC-3 Bloqueo por multa pendiente
    Given que un estudiante tiene una multa mayor a 0
    When intenta realizar una nueva reserva de libro
    Then el sistema debe rechazar la reserva
    And mostrar un mensaje de bloqueo por morosidad
