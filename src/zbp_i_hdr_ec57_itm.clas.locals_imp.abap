CLASS lhc_BillItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE BillItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE BillItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ BillItem RESULT result.

    METHODS rba_Billheader FOR READ
      IMPORTING keys_rba FOR READ BillItem\_Billheader FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_BillItem IMPLEMENTATION.
  METHOD update.
    DATA: ls_bill_itm TYPE zitm_ec57,
          lv_created  TYPE abap_boolean.

    LOOP AT entities INTO DATA(ls_entity).
      ls_bill_itm = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

      zcl_util_ec57=>get_instance( )->set_itm_value(
        EXPORTING
          im_bill_itm = ls_bill_itm
        IMPORTING
          ex_created  = lv_created
      ).

      IF lv_created = abap_true.
        APPEND VALUE #( %tky = ls_entity-%tky ) TO mapped-billitem.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      zcl_util_ec57=>get_instance( )->set_itm_deletion( im_item_uuid = ls_key-ItemUuid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    SELECT * FROM zitm_ec57
      FOR ALL ENTRIES IN @keys
      WHERE item_uuid = @keys-ItemUuid
      INTO TABLE @DATA(lt_items).

    result = CORRESPONDING #( lt_items ).
  ENDMETHOD.

  METHOD rba_Billheader.
  ENDMETHOD.
ENDCLASS.
