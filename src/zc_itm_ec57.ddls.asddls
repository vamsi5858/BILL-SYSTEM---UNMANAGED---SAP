@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_ITM_EC57
  as projection on ZI_ITM_EC57
{
  key ItemUuid,
      BillUuid,
      
  @Search.defaultSearchElement: true
      ItemPosition,
      
  @Search.defaultSearchElement: true
      ProductId,
      
      @Semantics.quantity.unitOfMeasure: 'Quantityunits'
      Quantity,
      Quantityunits,
      
      // Included from the Interface View fix
      Currency,
      
      @Semantics.amount.currencyCode: 'Currency'
      UnitPrice,
      
      @Semantics.amount.currencyCode: 'Currency'
      Subtotal,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      // This links back to the Header Consumption View
      _BillHeader : redirected to parent ZC_HDR_EC57
}
