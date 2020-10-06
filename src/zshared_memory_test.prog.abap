REPORT zshared_memory_test.

*--------------------------------------------------------------------*
CLASS ltc_test DEFINITION FINAL FOR TESTING
  DURATION LONG
  RISK LEVEL HARMLESS.
*--------------------------------------------------------------------*

  PRIVATE SECTION.
    CONSTANTS many TYPE i VALUE 1000000.

    DATA handle TYPE REF TO cl_demo_flights.

    METHODS setup RAISING cx_static_check.

    METHODS:
      regular_object   FOR TESTING,
      shm_read_access  FOR TESTING RAISING cx_static_check,
      shm_write_access FOR TESTING RAISING cx_static_check,
      shm_attach_once FOR TESTING RAISING cx_static_check.
ENDCLASS.

*--------------------------------------------------------------------*
CLASS ltc_test IMPLEMENTATION.
*--------------------------------------------------------------------*

  METHOD setup.
    DATA flist TYPE REF TO cl_demo_flight_list.

    handle = cl_demo_flights=>attach_for_write( ).
    CREATE OBJECT flist AREA HANDLE handle.
    handle->set_root( flist ).
    handle->detach_commit( ).
  ENDMETHOD.


  METHOD regular_object.
    DO many TIMES.
      DATA(flist) = NEW cl_demo_flight_list( ).
      DATA(flights) = flist->flight_list.
    ENDDO.
  ENDMETHOD.


  METHOD shm_read_access.
    DATA flist TYPE REF TO cl_demo_flight_list.

    DO many TIMES.
      handle = cl_demo_flights=>attach_for_read( ).
      flist = handle->root.
      DATA(flights) = flist->flight_list.
      handle->detach( ).
    ENDDO.
  ENDMETHOD.


  METHOD shm_write_access.
    DATA flist TYPE REF TO cl_demo_flight_list.

    DO many TIMES.
      handle = cl_demo_flights=>attach_for_update( ).
      flist = handle->root.
      DATA(flights) = flist->flight_list.
      handle->detach_commit( ).
    ENDDO.
  ENDMETHOD.


  METHOD shm_attach_once.
    DATA flist TYPE REF TO cl_demo_flight_list.

    handle = cl_demo_flights=>attach_for_update( ).
    flist = handle->root.

    DO many TIMES.
      DATA(flights) = flist->flight_list.
    ENDDO.

    handle->detach_commit( ).
  ENDMETHOD.

ENDCLASS.
