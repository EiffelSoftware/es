#include "eif_types.h"
#include "eif_cecil.h"
#include "eif_macros.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "mysql.h"

#ifndef _EIFFELMYSQL_STMT_DATA
#define _EIFFELMYSQL_STMT_DATA
/* Data structure to hold result parameters and data for prepared statements */
typedef struct {
  char buffer[8];
  char *string;
  unsigned long length;
  double d;
  my_bool is_null, error;
} STMT_DATA;
#endif

/* Parameter and return value casting */
EIF_INTEGER   c_real_connect (EIF_POINTER mysql, EIF_POINTER row, EIF_POINTER host, EIF_POINTER username, EIF_POINTER password, EIF_POINTER db);
EIF_INTEGER   c_query        (EIF_POINTER mysql, EIF_POINTER query);
EIF_INTEGER   c_store_result (EIF_POINTER mysql, EIF_POINTER res);
EIF_INTEGER   c_num_rows     (EIF_POINTER res);
EIF_INTEGER   c_num_fields   (EIF_POINTER res);
EIF_REFERENCE c_column_at    (EIF_POINTER res,   EIF_INTEGER pos);
EIF_INTEGER   c_fetch_row    (EIF_POINTER res,   EIF_POINTER row);
EIF_REFERENCE c_at           (EIF_POINTER res,   EIF_POINTER row,   EIF_INTEGER pos);
void          c_seek         (EIF_POINTER res,   EIF_INTEGER pos);
void          c_free_result  (EIF_POINTER res);
EIF_INTEGER   c_insert_id    (EIF_POINTER mysql);
EIF_INTEGER   c_affected_rows(EIF_POINTER mysql);
void          c_close        (EIF_POINTER mysql);
EIF_INTEGER   c_errno        (EIF_POINTER mysql);
EIF_REFERENCE c_error        (EIF_POINTER mysql);

EIF_INTEGER   c_stmt_prepare       (EIF_POINTER mysql,   EIF_POINTER stmt,    EIF_POINTER bind, EIF_POINTER data, EIF_POINTER stmt_str);
void          c_stmt_close         (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_param_count   (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_set_null      (EIF_POINTER bind,    EIF_POINTER data,    EIF_INTEGER pos);
EIF_INTEGER   c_stmt_set_int       (EIF_POINTER bind,    EIF_POINTER data,    EIF_INTEGER pos, EIF_INTEGER val);
EIF_INTEGER   c_stmt_set_double    (EIF_POINTER bind,    EIF_POINTER data,    EIF_INTEGER pos, EIF_DOUBLE val);
EIF_INTEGER   c_stmt_set_string    (EIF_POINTER bind,    EIF_POINTER data,    EIF_INTEGER pos, EIF_POINTER val, EIF_INTEGER len);
EIF_INTEGER   c_stmt_execute       (EIF_POINTER stmt,    EIF_POINTER bind);
EIF_INTEGER   c_stmt_affected_rows (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_insert_id     (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_num_rows      (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_field_count   (EIF_POINTER stmt);
EIF_REFERENCE c_stmt_column_at     (EIF_POINTER stmt, EIF_INTEGER pos);
void          c_stmt_seek          (EIF_POINTER stmt,    EIF_INTEGER pos);
EIF_INTEGER   c_stmt_bind_result   (EIF_POINTER stmt,    EIF_POINTER resbind, EIF_POINTER resdata);
EIF_INTEGER   c_stmt_fetch         (EIF_POINTER stmt);
EIF_INTEGER   c_stmt_null_at       (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_is_int_at     (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_is_double_at  (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_is_string_at  (EIF_POINTER resbind, EIF_INTEGER pos);
EIF_INTEGER   c_stmt_int_at        (EIF_POINTER resdata, EIF_INTEGER pos);
EIF_DOUBLE    c_stmt_double_at     (EIF_POINTER resdata, EIF_INTEGER pos);
EIF_REFERENCE c_stmt_string_at     (EIF_POINTER resdata, EIF_INTEGER pos);
void          c_stmt_free          (EIF_POINTER stmt, EIF_POINTER bind,       EIF_POINTER data, EIF_POINTER resbind, EIF_POINTER resdata);

/* Data structure management */
int   _c_real_connect (MYSQL **mysql, MYSQL_ROW **row, const char *host, const char *username, const char *password, const char *db);
int   _c_query        (MYSQL *mysql, const char *query);
int   _c_store_result (MYSQL *mysql, MYSQL_RES **res);
int   _c_num_rows     (MYSQL_RES *res);
int   _c_num_fields   (MYSQL_RES *res);
int   _c_fetch_row    (MYSQL_RES *res, MYSQL_ROW *row);
void  _c_seek         (MYSQL_RES *res, int pos);
int   _c_at           (MYSQL_RES *res, MYSQL_ROW *row, int pos, char **s);
void  _c_free_result  (MYSQL_RES *res);
int   _c_insert_id    (MYSQL *mysql);
int   _c_affected_rows(MYSQL *mysql);
void  _c_close        (MYSQL *mysql);
int   _c_errno        (MYSQL *mysql);
const char* _c_error  (MYSQL *mysql);
const char* _c_column_at(MYSQL_RES *res, int pos);

int    _c_stmt_prepare       (MYSQL *mysql, MYSQL_STMT **stmt, MYSQL_BIND **bind, STMT_DATA **data, const char *stmt_str);
void   _c_stmt_close         (MYSQL_STMT *stmt);
int    _c_stmt_param_count   (MYSQL_STMT *stmt);
int    _c_stmt_set_null      (MYSQL_BIND *bind, STMT_DATA *data, int pos);
int    _c_stmt_set_int       (MYSQL_BIND *bind, STMT_DATA *data, int pos, int val);
int    _c_stmt_set_double    (MYSQL_BIND *bind, STMT_DATA *data, int pos, double val);
int    _c_stmt_set_string    (MYSQL_BIND *bind, STMT_DATA *data, int pos, const char *val, int len);
int    _c_stmt_execute       (MYSQL_STMT *stmt, MYSQL_BIND *bind);
int    _c_stmt_affected_rows (MYSQL_STMT *stmt);
int    _c_stmt_insert_id     (MYSQL_STMT *stmt);
int    _c_stmt_num_rows      (MYSQL_STMT *stmt);
int    _c_stmt_field_count   (MYSQL_STMT *stmt);
int    _c_stmt_bind_result   (MYSQL_STMT *stmt, MYSQL_BIND **resbind, STMT_DATA **resdata);
int    _c_stmt_fetch         (MYSQL_STMT *stmt);
void   _c_stmt_seek          (MYSQL_STMT *stmt, int pos);
int    _c_stmt_null_at       (MYSQL_BIND *resbind, int pos);
int    _c_stmt_is_int_at     (MYSQL_BIND *resbind, int pos);
int    _c_stmt_is_double_at  (MYSQL_BIND *resbind, int pos);
int    _c_stmt_is_string_at  (MYSQL_BIND *resbind, int pos);
int    _c_stmt_int_at        (STMT_DATA *resdata, int pos);
double _c_stmt_double_at     (STMT_DATA *resdata, int pos);
int    _c_stmt_string_at     (STMT_DATA *resdata, int pos, char **s);
void   _c_stmt_free          (MYSQL_STMT *stmt, MYSQL_BIND **bind, STMT_DATA **data, MYSQL_BIND **resbind, STMT_DATA **resdata);
const char* _c_stmt_column_at(MYSQL_STMT *stmt, int pos);

