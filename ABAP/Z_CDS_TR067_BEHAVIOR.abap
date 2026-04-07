managed implementation in class zbp_cds_tr067 unique;
strict ( 2 );

define behavior for Z_CDS_TR067 alias Tasks
persistent table ztrt065
lock master
authorization master ( instance )
early numbering
//etag master <field_name>
{
  create;
  update;
  delete;

  field ( readonly ) Id;
  determination setTaskStatus on save {field Status; create;}
  action setStatusToConcluded;
  action alterStatus;
}