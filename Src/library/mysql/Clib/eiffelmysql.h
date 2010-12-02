#include "eif_types.h"
#include "eif_cecil.h"
#include "eif_macros.h"

/* Parameter and return value casting */
EIF_INTEGER   c_real_connect (EIF_POINTER mysql, EIF_POINTER row, EIF_POINTER host, EIF_POINTER username, EIF_POINTER password, EIF_POINTER db);
EIF_INTEGER   c_query        (EIF_POINTER mysql, EIF_POINTER query);
EIF_INTEGER   c_store_result (EIF_POINTER mysql, EIF_POINTER res);
EIF_INTEGER   c_num_rows     (EIF_POINTER res);
EIF_INTEGER   c_num_fields   (EIF_POINTER res);
EIF_INTEGER   c_fetch_row    (EIF_POINTER res,   EIF_POINTER row);
EIF_REFERENCE c_at           (EIF_POINTER res,   EIF_POINTER row,   EIF_INTEGER pos);
void          c_free_result  (EIF_POINTER res);
EIF_INTEGER   c_insert_id    (EIF_POINTER mysql);
EIF_INTEGER   c_affected_rows(EIF_POINTER mysql);
void          c_close        (EIF_POINTER mysql);
EIF_INTEGER   c_errno        (EIF_POINTER mysql);
EIF_REFERENCE c_error        (EIF_POINTER mysql);

EIF_INTEGER   c_stmt_prepare       (EIF_POINTER mysql, EIF_POINTER stmt, EIF_POINTER bind, EIF_POINTER data, EIF_POINTER stmt_str);
void          c_stmt_close         (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_param_count   (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_set_null      (EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_set_int       (EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos, EIF_INTEGER val);
EIF_INTEGER   c_stmt_set_string    (EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos, EIF_POINTER val, EIF_INTEGER len);
EIF_INTEGER   c_stmt_execute       (EIF_POINTER stmt, EIF_POINTER bind);
EIF_INTEGER   c_stmt_affected_rows (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_insert_id     (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_num_rows      (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_field_count   (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_bind_result   (EIF_POINTER stmt, EIF_POINTER resbind, EIF_POINTER resdata);
EIF_INTEGER   c_stmt_fetch         (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_null_at       (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_type_at       (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_int_at        (EIF_POINTER resdata, EIF_INTEGER pos);
EIF_REFERENCE c_stmt_string_at     (EIF_POINTER resdata, EIF_INTEGER pos);
void          c_stmt_free          (EIF_POINTER stmt, EIF_POINTER bind, EIF_POINTER data, EIF_POINTER resbind, EIF_POINTER resdata);

