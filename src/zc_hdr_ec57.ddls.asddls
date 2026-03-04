@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_HDR_EC57
  provider contract transactional_query
  as projection on ZI_HDR_EC57
{
  key BillUuid,
  
  @Search.defaultSearchElement: true
      BillNumber,
      
  @Search.defaultSearchElement: true
      CustomerName,
      
      BillingDate,
      
      @Semantics.amount.currencyCode: 'Currency'
      TotalAmount,
      
      // FIX: Add Value Help for Currency to prevent invalid entries like 'IND'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
      Currency,
      
      PaymentStatus,
      
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      
      /* Associations */
      _BillItems : redirected to composition child ZC_ITM_EC57
}
