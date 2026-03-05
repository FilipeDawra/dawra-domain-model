CLASS zcl_teste_inventario DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun. " O 'main' do ABAP Cloud
ENDCLASS.

CLASS zcl_teste_inventario IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " 1. Criamos a quantidade inicial (Value Object)
    DATA(lo_qtd_inicial) = NEW zcl_quantidade( iv_valor = 10 iv_unidade = 'UN' ).

    " 2. Criamos a nossa Aggregate Root (Peca)
    DATA(lo_parafuso) = NEW zcl_peca(
        iv_id      = cl_system_uuid=>create_uuid_x16_static( )
        iv_nome    = 'Parafuso de Titânio'
        io_qtd_ini = lo_qtd_inicial
    ).

    out->write( |Peca: { lo_parafuso->nome } | ).
    out->write( |Saldo Inicial: { lo_parafuso->consultar_saldo( ) }| ).

    " 3. Executamos uma operação de negócio
    "DATA(lo_entrada) = NEW zcl_quantidade( iv_valor = 5 iv_unidade = 'UN' ).
    "lo_parafuso->receber_estoque( lo_entrada ).

    "5. Outra operação de negócio
    DATA(lo_saida) = NEW zcl_quantidade( iv_valor = 10 iv_unidade = 'UN' ).
    lo_parafuso->retirar_estoque( lo_saida ).

    " 4. Verificamos o resultado (Estado atualizado + rastro no log)
    out->write( |Saldo após saida: { lo_parafuso->consultar_saldo( ) }| ).
    out->write( 'Operação concluída com sucesso e rastro gerado.' ).
  ENDMETHOD.
ENDCLASS.