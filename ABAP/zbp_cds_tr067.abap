CLASS lhc_Z_CDS_TR067 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Tasks RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE tasks.

    METHODS settaskstatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR tasks~settaskstatus.
    METHODS setstatustoconcluded FOR MODIFY
      IMPORTING keys FOR ACTION tasks~setstatustoconcluded.
    METHODS alterstatus FOR MODIFY
      IMPORTING keys FOR ACTION tasks~alterstatus.

ENDCLASS.

CLASS lhc_Z_CDS_TR067 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA lv_task_id  TYPE ztrt065-id.
    DATA lv_id_i TYPE i.
    DATA lv_id_n TYPE n LENGTH 10.

    SELECT MAX( id ) FROM ztrt065 INTO (lv_task_id).

    IF lv_task_id IS NOT INITIAL.
       lv_id_n = lv_task_id.
       lv_id_i = lv_id_n.
       lv_id_i = lv_id_i + 1.
       lv_id_n = lv_id_i.

       lv_task_id = lv_id_n.
    ELSE.
       lv_id_i = 1.
       lv_id_n = lv_id_i.
       lv_task_id = lv_id_n.
    ENDIF.

    mapped-tasks = VALUE #( ( %cid = entities[ 1 ]-%cid
                                 Id = lv_task_id ) ).
  ENDMETHOD.

  METHOD setTaskStatus.
      READ ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
        ENTITY Tasks
          FIELDS ( Status )
          WITH CORRESPONDING #( keys )
        RESULT DATA(tasks)
        FAILED DATA(read_failed).

      DELETE tasks WHERE Status IS NOT INITIAL.
      CHECK tasks IS NOT INITIAL.

      MODIFY ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
          ENTITY Tasks
            UPDATE SET FIELDS
            WITH VALUE #( FOR task IN tasks ( %tky    = task-%tky
                                                  Status = 'Pendente' ) )
        REPORTED DATA(update_reported).

        "Set the changing parameter
        reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setStatusToConcluded.
    READ ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
        ENTITY Tasks
          FIELDS ( Status )
          WITH CORRESPONDING #( keys )
        RESULT DATA(tasks)
        FAILED DATA(read_failed).

    MODIFY ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
          ENTITY Tasks
            UPDATE SET FIELDS
            WITH VALUE #( FOR task IN tasks ( %tky    = task-%tky
                                                  Status = 'Concluído' ) ).
  ENDMETHOD.

  METHOD alterStatus.
    READ ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
      ENTITY Tasks
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
      RESULT DATA(tasks)
      FAILED DATA(read_failed).

    LOOP AT tasks INTO DATA(task).
        IF task-Status = 'Pendente'.
          MODIFY ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
            ENTITY Tasks
            UPDATE FIELDS ( Status )
            WITH VALUE #( ( %tky = task-%tky Status = 'Concluído') ).
        ELSE.
          MODIFY ENTITIES OF Z_CDS_TR067 IN LOCAL MODE
            ENTITY Tasks
            UPDATE FIELDS ( Status )
            WITH VALUE #( ( %tky = task-%tky Status = 'Pendente') ).
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.