CLASS zcl_util_ec57 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_bill_hdr,
             bill_uuid TYPE sysuuid_x16,
           END OF ty_bill_hdr,
           BEGIN OF ty_bill_itm,
             item_uuid TYPE sysuuid_x16,
           END OF ty_bill_itm,
           tt_bill_hdr TYPE STANDARD TABLE OF ty_bill_hdr WITH EMPTY KEY,
           tt_bill_itm TYPE STANDARD TABLE OF ty_bill_itm WITH EMPTY KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_util_ec57.

    METHODS:
      set_hdr_value IMPORTING im_bill_hdr TYPE zhdr_ec57 EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value EXPORTING ex_bill_hdr TYPE zhdr_ec57,
      set_itm_value IMPORTING im_bill_itm TYPE zitm_ec57 EXPORTING ex_created TYPE abap_boolean,
      get_itm_value EXPORTING ex_bill_itm TYPE zitm_ec57,
      set_hdr_deletion IMPORTING im_bill_uuid TYPE sysuuid_x16,
      get_hdr_deletion EXPORTING ex_bill_uuids TYPE tt_bill_hdr,
      set_itm_deletion IMPORTING im_item_uuid TYPE sysuuid_x16,
      get_itm_deletion EXPORTING ex_item_uuids TYPE tt_bill_itm,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA mo_instance TYPE REF TO zcl_util_ec57.
    CLASS-DATA: gs_hdr_buff TYPE zhdr_ec57,
                gs_itm_buff TYPE zitm_ec57,
                gt_hdr_del  TYPE tt_bill_hdr,
                gt_itm_del  TYPE tt_bill_itm.
ENDCLASS.

CLASS zcl_util_ec57 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    gs_hdr_buff = im_bill_hdr.
    ex_created = abap_true.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_bill_hdr = gs_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    gs_itm_buff = im_bill_itm.
    ex_created = abap_true.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_bill_itm = gs_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_deletion.
    APPEND VALUE #( bill_uuid = im_bill_uuid ) TO gt_hdr_del.
  ENDMETHOD.

  METHOD get_hdr_deletion.
    ex_bill_uuids = gt_hdr_del.
  ENDMETHOD.

  METHOD set_itm_deletion.
    APPEND VALUE #( item_uuid = im_item_uuid ) TO gt_itm_del.
  ENDMETHOD.

  METHOD get_itm_deletion.
    ex_item_uuids = gt_itm_del.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr_buff, gs_itm_buff, gt_hdr_del, gt_itm_del.
  ENDMETHOD.
ENDCLASS.
