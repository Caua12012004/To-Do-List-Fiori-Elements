@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'App de treinamento - Cauã Rodrigues'
@Search.searchable: true
@OData.publish: true
@ObjectModel : { resultSet.sizeCategory: #XS }

define root view entity Z_CDS_TR067 as select from ztrt065
{   
    @UI.lineItem: [{type:#FOR_ACTION, dataAction:'setStatusToConcluded', label:'Conclude'}]                                     
    key id as Id,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @UI.lineItem: [{position: 10, label: 'Nome'}]
    @UI.identification: [{position: 10, label: 'Nome'}]
    nome as Nome,
    case status 
        when 'Pendente' then 1
        when 'Concluído' then 3
        else 0 end as Criticality,
    @UI.lineItem: [{position: 20, label: 'Status'}]
    @UI.identification: [{position: 20, label: 'Status'}]
    @Consumption.valueHelpDefinition: [{ useForValidation: true, 
                                         entity: {   name: 'Z_STATUS_VH_CR' , 
                                                      element: 'Status'}     }] 
    status as Status,
    @UI.identification: [{position: 30, label: 'Descrição'}]
    cast(descricao as abap.sstring(300)) as Descricao
}