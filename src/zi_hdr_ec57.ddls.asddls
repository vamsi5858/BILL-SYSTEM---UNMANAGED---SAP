@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View for Bill Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_HDR_EC57
  as select from zhdr_ec57 as BillHeader
  composition [0..*] of ZI_ITM_EC57 as _BillItems
{
  key bill_uuid             as BillUuid,
      bill_number           as BillNumber,
      customer_name         as CustomerName,
      billing_date          as BillingDate,
      
      @Semantics.amount.currencyCode: 'Currency'
      total_amount          as TotalAmount,
      currency              as Currency,
      payment_status        as PaymentStatus,
      
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      // FIX: Added the missing Global ETag field required by the Behavior Definition
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      /* Associations */
      _BillItems
}
