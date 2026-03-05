CLASS zcl_movimentacao_estoque DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA id TYPE uuid READ-ONLY.
    DATA tipo TYPE string READ-ONLY. "Entrada ou Saída
    DATA data_hora TYPE utclong READ-ONLY.
    DATA quantidade TYPE REF TO zcl_quantidade READ-ONLY.

  METHODS constructor IMPORTING iv_tipo TYPE string io_qtd TYPE REF TO zcl_quantidade.
ENDCLASS.

CLASS zcl_movimentacao_estoque IMPLEMENTATION.
  METHOD constructor.
    me->id           = cl_system_uuid=>create_uuid_x16_static(  ). "Gera id único
    me->tipo         = iv_tipo.
    me->quantidade   = io_qtd.
    me->data_hora    = utclong_current(  ). "Timestamp do ABAP cloud
  ENDMETHOD.
ENDCLASS.