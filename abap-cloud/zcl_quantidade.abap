CLASS zcl_quantidade DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA valor TYPE i READ-ONLY.
    DATA unidade TYPE string READ-ONLY.

    METHODS constructor IMPORTING iv_valor TYPE i iv_unidade TYPE string.

    METHODS somar IMPORTING io_outra TYPE REF TO zcl_quantidade
                  RETURNING VALUE(ro_resultado) TYPE REF TO zcl_quantidade.
ENDCLASS.

CLASS zcl_quantidade IMPLEMENTATION.

    METHOD constructor.

        me->valor = iv_valor.
        me->unidade = iv_unidade.

    ENDMETHOD.

    METHOD SOMAR.
        "Lógica de proteção de dominio
        IF me->unidade = io_outra->unidade.
            ro_resultado = NEW zcl_quantidade( iv_valor = me->valor + io_outra->valor
                                               iv_unidade = me->unidade ).

        ENDIF.
    ENDMETHOD.

ENDCLASS.

