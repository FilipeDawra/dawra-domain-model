CLASS zcl_peca DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

      DATA id TYPE uuid READ-ONLY.
      DATA nome TYPE string READ-ONLY.

      METHODS constructor
      IMPORTING
      iv_id        TYPE uuid
      iv_nome TYPE string
      io_qtd_ini   TYPE REF TO zcl_quantidade.

      METHODS receber_estoque IMPORTING io_qtd TYPE REF TO zcl_quantidade.
      METHODS retirar_estoque IMPORTING io_qtd TYPE REF TO zcl_quantidade
      RETURNING VALUE(rv_sucesso) TYPE abap_bool.

      METHODS consultar_saldo RETURNING VALUE(rv_saldo) TYPE i.

  PRIVATE SECTION.

      DATA ms_saldo TYPE REF TO zcl_quantidade. " Protegido (-)
      DATA mt_historico TYPE STANDARD TABLE OF REF TO zcl_movimentacao_estoque. "Astesrisco (*)
ENDCLASS.

CLASS zcl_peca IMPLEMENTATION.
  METHOD constructor.
    me->id = iv_id.
    me->nome = iv_nome.
    me->ms_saldo = io_qtd_ini.
  ENDMETHOD.

  METHOD receber_estoque.
    "1. Atualiza o saldo (Uso do Value Object)
    me->ms_saldo = me->ms_saldo->somar( io_qtd ).

    "2. Registra o rastro (Criação da Entity de Histórico)
    APPEND NEW zcl_movimentacao_estoque( iv_tipo = 'ENTRADA'
                                        io_qtd = io_qtd ) TO me->mt_historico.
  ENDMETHOD.

  METHOD retirar_estoque.
    "1. Validação: o valor que vou retirar é maior do que eu tenho?
    IF io_qtd->valor > me->ms_saldo->valor.
        rv_sucesso = abap_false. " Não deu certo.
        RETURN.              "Sai do método aqui(como break/return Java)
    ENDIF.

    "Se passou aqui tem estoque
    "Como subtrair se o Value Object só tem somar.
    "Criamos uma quantidade negativa

    DATA(lo_qtd_negativa) = NEW zcl_quantidade(
        iv_valor = io_qtd->valor * -1
        iv_unidade = io_qtd->unidade
    ).

    "Atualizamos o saldo somando o negativo
    me->ms_saldo = me->ms_saldo->somar( lo_qtd_negativa ).

    "Registramos a saída no histórico
    APPEND NEW zcl_movimentacao_estoque(
        iv_tipo = 'SAIDA'
        io_qtd = io_qtd
    ) TO me->mt_historico.

    rv_sucesso = abap_true. "Sucesso!
  ENDMETHOD.

  METHOD consultar_saldo.
    rv_saldo = me->ms_saldo->valor.
  ENDMETHOD.

ENDCLASS.