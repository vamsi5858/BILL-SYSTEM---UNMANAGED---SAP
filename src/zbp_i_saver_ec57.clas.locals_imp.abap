CLASS lsc_zi_hdr_ec57 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_zi_hdr_ec57 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " 1. Retrieve all transactional data from the Singleton Buffer
    DATA(lo_util) = zcl_util_ec57=>get_instance( ).

    lo_util->get_hdr_value( IMPORTING ex_bill_hdr = DATA(ls_bill_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_bill_itm = DATA(ls_bill_itm) ).
    lo_util->get_hdr_deletion( IMPORTING ex_bill_uuids = DATA(lt_hdr_del) ).
    lo_util->get_itm_deletion( IMPORTING ex_item_uuids = DATA(lt_itm_del) ).

    " 2. Physically SAVE or UPDATE the Header Table
    IF ls_bill_hdr IS NOT INITIAL.
      MODIFY zhdr_ec57 FROM @ls_bill_hdr.
    ENDIF.

    " 3. Physically SAVE or UPDATE the Item Table
    IF ls_bill_itm IS NOT INITIAL.
      MODIFY zitm_ec57 FROM @ls_bill_itm.
    ENDIF.

    " 4. Handle Deletions for Header
    IF lt_hdr_del IS NOT INITIAL.
      LOOP AT lt_hdr_del INTO DATA(ls_hdel).
        DELETE FROM zhdr_ec57 WHERE bill_uuid = @ls_hdel-bill_uuid.
      ENDLOOP.
    ENDIF.

    " 5. Handle Deletions for Items
    IF lt_itm_del IS NOT INITIAL.
      LOOP AT lt_itm_del INTO DATA(ls_idel).
        DELETE FROM zitm_ec57 WHERE item_uuid = @ls_idel-item_uuid.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    " 6. Clear the buffer to prevent data ghosting across sessions
    zcl_util_ec57=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
