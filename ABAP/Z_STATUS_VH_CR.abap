@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for status'
@ObjectModel.representativeKey: 'Id'
@ObjectModel : { resultSet.sizeCategory: #XS }

define view entity Z_STATUS_VH_CR as select from ztrt067
{
    key id as Id,
    status as Status
}
