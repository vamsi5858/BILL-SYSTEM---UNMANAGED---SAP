@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View for Bill Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ITM_EC57
  as select from zitm_ec57 as BillItems
  association to parent ZI_HDR_EC57 as _BillHeader
    on $projection.BillUuid = _BillHeader.BillUuid
{
  key item_uuid             as ItemUuid,
  
      @ObjectModel.foreignKey.association: '_BillHeader' 
      bill_uuid             as BillUuid,
      
      item_position         as ItemPosition,
      product_id            as ProductId,
      
      @Semantics.quantity.unitOfMeasure: 'Quantityunits'
      quantity              as Quantity,
      quantityunits         as Quantityunits,
      
      _BillHeader.Currency  as Currency,
      
      @Semantics.amount.currencyCode: 'Currency' 
      unit_price            as UnitPrice,
      
      @Semantics.amount.currencyCode: 'Currency'
      subtotal              as Subtotal,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      // FIX: Add the missing Global ETag field required by the Behavior Definition
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      /* Associations */
      _BillHeader
}
