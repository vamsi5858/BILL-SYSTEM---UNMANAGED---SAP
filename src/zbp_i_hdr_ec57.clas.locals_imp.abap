CLASS lhc_BillHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR BillHeader RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE BillHeader.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE BillHeader.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE BillHeader.

    METHODS read FOR READ
      IMPORTING keys FOR READ BillHeader RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK BillHeader.

    METHODS rba_Billitems FOR READ
      IMPORTING keys_rba FOR READ BillHeader\_Billitems FULL result_requested RESULT result LINK association_links.

    METHODS cba_Billitems FOR MODIFY
      IMPORTING entities_cba FOR CREATE BillHeader\_Billitems.
ENDCLASS.

CLASS lhc_BillHeader IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD lock.
    " Unmanaged locking logic can be implemented here if required
  ENDMETHOD.

  METHOD create.
    DATA: ls_bill_hdr TYPE zhdr_ec57,
          lv_created  TYPE abap_boolean.

    LOOP AT entities INTO DATA(ls_entity).
      ls_bill_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

      IF ls_bill_hdr-bill_uuid IS INITIAL.
        TRY.
            ls_bill_hdr-bill_uuid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
        ENDTRY.
      ENDIF.

      zcl_util_ec57=>get_instance( )->set_hdr_value(
        EXPORTING im_bill_hdr = ls_bill_hdr
        IMPORTING ex_created  = lv_created ).

      IF lv_created = abap_true.
        APPEND VALUE #( %cid = ls_entity-%cid
                        BillUuid = ls_bill_hdr-bill_uuid ) TO mapped-billheader.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_bill_hdr TYPE zhdr_ec57,
          lv_created  TYPE abap_boolean.

    LOOP AT entities INTO DATA(ls_entity).
      ls_bill_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

      zcl_util_ec57=>get_instance( )->set_hdr_value(
        EXPORTING im_bill_hdr = ls_bill_hdr
        IMPORTING ex_created  = lv_created ).

      IF lv_created = abap_true.
        APPEND VALUE #( BillUuid = ls_bill_hdr-bill_uuid ) TO mapped-billheader.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      zcl_util_ec57=>get_instance( )->set_hdr_deletion( im_bill_uuid = ls_key-BillUuid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    SELECT * FROM zhdr_ec57 FOR ALL ENTRIES IN @keys
      WHERE bill_uuid = @keys-BillUuid INTO TABLE @DATA(lt_bills).
    result = CORRESPONDING #( lt_bills ).
  ENDMETHOD.

  METHOD rba_Billitems.
    SELECT * FROM zitm_ec57 FOR ALL ENTRIES IN @keys_rba
      WHERE bill_uuid = @keys_rba-BillUuid INTO TABLE @DATA(lt_items).
  ENDMETHOD.

  METHOD cba_Billitems.
    DATA: ls_bill_itm TYPE zitm_ec57,
          lv_created  TYPE abap_boolean.

    LOOP AT entities_cba INTO DATA(ls_cba).
      LOOP AT ls_cba-%target INTO DATA(ls_target).
        ls_bill_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).
        ls_bill_itm-bill_uuid = ls_cba-BillUuid.

        IF ls_bill_itm-item_uuid IS INITIAL.
          TRY.
              ls_bill_itm-item_uuid = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
        ENDIF.

        zcl_util_ec57=>get_instance( )->set_itm_value(
          EXPORTING im_bill_itm = ls_bill_itm
          IMPORTING ex_created  = lv_created ).

        IF lv_created = abap_true.
          APPEND VALUE #( %cid = ls_target-%cid
                          ItemUuid = ls_bill_itm-item_uuid ) TO mapped-billitem.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
