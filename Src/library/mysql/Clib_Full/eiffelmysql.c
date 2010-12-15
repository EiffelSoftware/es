#include "eiffelmysql.h"

/* Parameter and return value casting */

EIF_INTEGER c_real_connect(EIF_POINTER mysql, EIF_POINTER row, EIF_POINTER host, EIF_POINTER username, EIF_POINTER password, EIF_POINTER db) {
  return (EIF_INTEGER) _c_real_connect((MYSQL**)mysql, (MYSQL_ROW**)row, (const char *)host, (const char *)username, (const char *)password, (const char *)db);
}

EIF_INTEGER c_query(EIF_POINTER mysql, EIF_POINTER query) {
  return (EIF_INTEGER) _c_query(*(MYSQL**)mysql, (const char *)query);
}

EIF_INTEGER c_store_result(EIF_POINTER mysql, EIF_POINTER res) {
  return (EIF_INTEGER) _c_store_result(*(MYSQL**)mysql, (MYSQL_RES**)res);
}

EIF_INTEGER c_num_rows(EIF_POINTER res) {
  return (EIF_INTEGER) _c_num_rows(*(MYSQL_RES**)res);
}

EIF_INTEGER c_num_fields(EIF_POINTER res) {
  return (EIF_INTEGER) _c_num_fields(*(MYSQL_RES**)res);
}

EIF_INTEGER c_fetch_row(EIF_POINTER res, EIF_POINTER row) {
  return (EIF_INTEGER) _c_fetch_row(*(MYSQL_RES**)res, *(MYSQL_ROW**)row);
}

EIF_REFERENCE c_at(EIF_POINTER res, EIF_POINTER row, EIF_INTEGER pos) {
  char *s;
  int len;
  len = _c_at(*(MYSQL_RES**)res, *(MYSQL_ROW**)row, (int)pos, &s);
  return eif_make_string(s, len);
}

EIF_REFERENCE c_column_at(EIF_POINTER res, EIF_INTEGER pos) {
  char *column;
  column = (char *)_c_column_at(*(MYSQL_RES**)res, (int)pos);
  return eif_make_string(column, strlen(column));
}
void c_seek (EIF_POINTER res, EIF_INTEGER pos) {
  _c_seek(*(MYSQL_RES**)res, (int)pos);
}

void c_free_result(EIF_POINTER res) {
  _c_free_result(*(MYSQL_RES**)res);
}

EIF_INTEGER c_insert_id(EIF_POINTER mysql) {
  return (EIF_INTEGER) _c_insert_id(*(MYSQL**)mysql);
}

EIF_INTEGER c_affected_rows(EIF_POINTER mysql) {
  return (EIF_INTEGER) _c_affected_rows(*(MYSQL**)mysql);
}

void c_close(EIF_POINTER mysql) {
  _c_close(*(MYSQL**)mysql);
}

EIF_INTEGER c_errno(EIF_POINTER mysql) {
  return (EIF_INTEGER) _c_errno(*(MYSQL**)mysql);
}

EIF_REFERENCE c_error(EIF_POINTER mysql) {
  return eif_string((char *)_c_error(*(MYSQL**)mysql));
}

EIF_INTEGER c_stmt_prepare(EIF_POINTER mysql, EIF_POINTER stmt, EIF_POINTER bind, EIF_POINTER data, EIF_POINTER stmt_str) {
  return (EIF_INTEGER) _c_stmt_prepare(*(MYSQL**)mysql, (MYSQL_STMT**)stmt, (MYSQL_BIND**)bind, (STMT_DATA**)data, (const char *)stmt_str);
}

void c_stmt_close(EIF_POINTER stmt) {
  _c_stmt_close(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_param_count(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_param_count(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_set_null(EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_set_null(*(MYSQL_BIND**)bind, *(STMT_DATA**)data, (int)pos);
}

EIF_INTEGER c_stmt_set_int(EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos, EIF_INTEGER val) {
  return (EIF_INTEGER) _c_stmt_set_int(*(MYSQL_BIND**)bind, *(STMT_DATA**)data, (int)pos, (int)val);
}

EIF_INTEGER c_stmt_set_double(EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos, EIF_DOUBLE val) {
  return (EIF_INTEGER) _c_stmt_set_double(*(MYSQL_BIND**)bind, *(STMT_DATA**)data, (int)pos, (double)val);
}

EIF_INTEGER c_stmt_set_string(EIF_POINTER bind, EIF_POINTER data, EIF_INTEGER pos, EIF_POINTER val, EIF_INTEGER len) {
  return (EIF_INTEGER) _c_stmt_set_string(*(MYSQL_BIND**)bind, *(STMT_DATA**)data, (int)pos, (const char *)val, (int)len);
}

EIF_INTEGER c_stmt_execute(EIF_POINTER stmt, EIF_POINTER bind) {
  return (EIF_INTEGER) _c_stmt_execute(*(MYSQL_STMT**)stmt, *(MYSQL_BIND**)bind);
}

EIF_INTEGER c_stmt_affected_rows(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_affected_rows(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_insert_id(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_insert_id(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_num_rows(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_num_rows(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_field_count(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_field_count(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_bind_result(EIF_POINTER stmt, EIF_POINTER resbind, EIF_POINTER resdata) {
  return (EIF_INTEGER) _c_stmt_bind_result(*(MYSQL_STMT**)stmt, (MYSQL_BIND**)resbind, (STMT_DATA**)resdata);
}

EIF_INTEGER c_stmt_fetch(EIF_POINTER stmt) {
  return (EIF_INTEGER) _c_stmt_fetch(*(MYSQL_STMT**)stmt);
}

EIF_INTEGER c_stmt_null_at(EIF_POINTER resbind, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_null_at(*(MYSQL_BIND**)resbind, (int)pos);
}

EIF_INTEGER c_stmt_is_int_at(EIF_POINTER resbind, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_is_int_at(*(MYSQL_BIND**)resbind, (int)pos);
}

EIF_INTEGER c_stmt_is_double_at(EIF_POINTER resbind, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_is_double_at(*(MYSQL_BIND**)resbind, (int)pos);
}

EIF_INTEGER c_stmt_is_string_at(EIF_POINTER resbind, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_is_string_at(*(MYSQL_BIND**)resbind, (int)pos);
}

EIF_INTEGER c_stmt_int_at(EIF_POINTER resdata, EIF_INTEGER pos) {
  return (EIF_INTEGER) _c_stmt_int_at(*(STMT_DATA**)resdata, (int)pos);
}

EIF_DOUBLE c_stmt_double_at(EIF_POINTER resdata, EIF_INTEGER pos) {
  return (EIF_DOUBLE) _c_stmt_double_at(*(STMT_DATA**)resdata, (int)pos);
}

EIF_REFERENCE c_stmt_string_at(EIF_POINTER resdata, EIF_INTEGER pos) {
  char *s;
  int len;
  len = _c_stmt_string_at(*(STMT_DATA**)resdata, (int)pos, &s);
  return eif_make_string(s, len);
}

EIF_REFERENCE c_stmt_column_at(EIF_POINTER stmt, EIF_INTEGER pos) {
  char *s;
  s = (char *)_c_stmt_column_at(*(MYSQL_STMT**)stmt, (int)pos);
  return eif_make_string(s, strlen(s));
}

void c_stmt_seek(EIF_POINTER stmt, EIF_INTEGER pos) {
  _c_stmt_seek(*(MYSQL_STMT**)stmt, (int)pos);
}

void c_stmt_free(EIF_POINTER stmt, EIF_POINTER bind, EIF_POINTER data, EIF_POINTER resbind, EIF_POINTER resdata) {
  _c_stmt_free(*(MYSQL_STMT**)stmt, (MYSQL_BIND**)bind, (STMT_DATA**)data, (MYSQL_BIND**)resbind, (STMT_DATA**)resdata);
}

/* Data structure management */

int _c_real_connect(MYSQL **mysql, MYSQL_ROW **row, const char *host, const char *username, const char *password, const char *db) {
  *mysql = (MYSQL*)malloc(sizeof(MYSQL)); // free: _c_close
  mysql_init(*mysql);
  mysql_options(*mysql, MYSQL_READ_DEFAULT_GROUP, "EiffelMySQL");
  if (mysql_real_connect(*mysql, host, username, password, db, 0, NULL, 0) == 0) return -1;
  *row = (MYSQL_ROW*)malloc(sizeof(MYSQL_ROW));
  return 0;
}

int _c_query(MYSQL *mysql, const char *query) {
  return mysql_query(mysql, query);
}

int _c_store_result(MYSQL *mysql, MYSQL_RES **res) {
  if ((*res = mysql_store_result(mysql)) == 0) return -1;
  return 0;
}

int _c_num_rows(MYSQL_RES *results) {
  return mysql_num_rows(results);
}

int _c_num_fields(MYSQL_RES *results) {
  return mysql_num_fields(results);
}

int _c_fetch_row(MYSQL_RES *results, MYSQL_ROW *row) {
  if ((*row = mysql_fetch_row(results)) == 0) return -1;
  return 0;
}
int _c_at(MYSQL_RES *results, MYSQL_ROW *row, int pos, char **s) {
  if ((*row)[pos]) {
    *s = (*row)[pos];
  } else {
    *s = "NULL";
  }
  return mysql_fetch_lengths(results)[pos];
}

void _c_free_result(MYSQL_RES *results) {
  mysql_free_result(results);
}

int _c_insert_id(MYSQL *mysql) {
  return mysql_insert_id(mysql);
}

int _c_affected_rows(MYSQL *mysql) {
  return mysql_affected_rows(mysql);
}

void _c_seek(MYSQL_RES *res, int pos) {
  mysql_data_seek(res, pos);
}
const char* _c_column_at(MYSQL_RES *res, int pos) {
  return mysql_fetch_field_direct(res, pos)->name;
}

void _c_close(MYSQL *mysql) {
  mysql_close(mysql);
  if (mysql != 0) free(mysql);
  mysql = 0;
}

int _c_errno(MYSQL *mysql) {
  return mysql_errno(mysql);
}

const char* _c_error(MYSQL *mysql) {
  return mysql_error(mysql);
}

int _c_stmt_prepare(MYSQL *mysql, MYSQL_STMT **stmt, MYSQL_BIND **bind, STMT_DATA **data, const char *stmt_str) {
  int fields;
  if ((*stmt = mysql_stmt_init(mysql)) == 0) return -1;
  *bind = 0;
  if (mysql_stmt_prepare(*stmt, stmt_str, strlen(stmt_str)) != 0) return -1;
  fields = mysql_stmt_param_count(*stmt);
  if (fields > 0) {
    *bind = (MYSQL_BIND*)malloc(sizeof(MYSQL_BIND) * fields); // free: _c_stmt_free
    *data = (STMT_DATA*) malloc(sizeof(STMT_DATA) * fields); // free: _c_stmt_free
    memset(*bind, 0, sizeof(MYSQL_BIND) * fields);
    memset(*data, 0, sizeof(STMT_DATA) * fields);
  }
  return 0;
}

void _c_stmt_close(MYSQL_STMT *stmt) {
  mysql_stmt_close(stmt);
}

int _c_stmt_param_count (MYSQL_STMT *stmt) {
  return mysql_stmt_param_count(stmt);
}

int _c_stmt_set_null(MYSQL_BIND *bind, STMT_DATA *data, int pos) {
  data[pos].is_null       = 1;
  bind[pos].buffer_type   = MYSQL_TYPE_NULL;
  bind[pos].buffer        = 0;
  bind[pos].buffer_length = 0;
  bind[pos].is_null       = &data[pos].is_null;
  bind[pos].length        = 0;
  return 0;
}

int _c_stmt_set_int(MYSQL_BIND *bind, STMT_DATA *data, int pos, int val) {
  data[pos].length        = val;
  bind[pos].buffer_type   = MYSQL_TYPE_LONG;
  bind[pos].buffer        = &data[pos].length;
  bind[pos].buffer_length = 0;
  bind[pos].is_null       = 0;
  bind[pos].length        = 0;
  return 0;
}

int _c_stmt_set_double(MYSQL_BIND *bind, STMT_DATA *data, int pos, double val) {
  data[pos].d             = val;
  bind[pos].buffer_type   = MYSQL_TYPE_DOUBLE;
  bind[pos].buffer        = &data[pos].d;
  bind[pos].buffer_length = 0;
  bind[pos].is_null       = 0;
  bind[pos].length        = 0;
  return 0;
}

int _c_stmt_set_string(MYSQL_BIND *bind, STMT_DATA *data, int pos, const char *val, int len) {
  data[pos].length        = len;
  bind[pos].buffer_type   = MYSQL_TYPE_STRING;
  bind[pos].buffer        = (char *)val;
  bind[pos].buffer_length = data[pos].length;
  bind[pos].is_null       = 0;
  bind[pos].length        = &data[pos].length;
  return 0;
}

int _c_stmt_execute(MYSQL_STMT *stmt, MYSQL_BIND *bind) {
  if (mysql_stmt_bind_param(stmt, bind) != 0) return -1;
  if (mysql_stmt_execute(stmt) != 0) return -1;
  return 0;
}

int _c_stmt_affected_rows(MYSQL_STMT *stmt) {
  return mysql_stmt_affected_rows(stmt);
}

int _c_stmt_insert_id(MYSQL_STMT *stmt) {
  return mysql_stmt_insert_id(stmt);
}

int _c_stmt_num_rows(MYSQL_STMT *stmt) {
  return mysql_stmt_num_rows(stmt);
}

int _c_stmt_field_count(MYSQL_STMT *stmt) {
  return mysql_stmt_field_count(stmt);
}

int _c_stmt_bind_result(MYSQL_STMT *stmt, MYSQL_BIND **resbind, STMT_DATA **resdata) {
  int yes;
  int fields;
  int i;
  STMT_DATA* _resdata;
  MYSQL_BIND* _resbind;

  // Metadata (check if result exists)
  MYSQL_RES *metadata = mysql_stmt_result_metadata(stmt);
  MYSQL_FIELD *field;
  if (metadata == 0) return -1; // no result set

  // Buffer entire result on client (to find string sizes)
  yes = 1;
  mysql_stmt_attr_set(stmt, STMT_ATTR_UPDATE_MAX_LENGTH, &yes);
  if (mysql_stmt_store_result(stmt) != 0) return -1;

  // Prepare BIND
  fields = mysql_stmt_field_count(stmt);

  if (fields > 0) {
    if (*resdata == 0) {
      *resdata = (STMT_DATA*) malloc(sizeof(STMT_DATA) * fields); // free: _c_stmt_free
      memset(*resdata, 0, sizeof(STMT_DATA) * fields);
    }
    if (*resbind == 0) {
      *resbind = (MYSQL_BIND*)malloc(sizeof(MYSQL_BIND) * fields); // free: _c_stmt_free
      memset(*resbind, 0, sizeof(MYSQL_BIND) * fields);
    }
    _resdata = *resdata;
    _resbind = *resbind;
    i = 0;
    while((field = mysql_fetch_field(metadata))) {
     _resbind[i].buffer_type     = field->type;
     _resbind[i].is_null         = &_resdata[i].is_null;
     _resbind[i].length          = &_resdata[i].length;
     _resbind[i].error           = &_resdata[i].error;
     if (IS_NUM(field->type)) {
       _resbind[i].buffer        = &_resdata[i].buffer;
       _resbind[i].buffer_length = 0;
     } else {
       if (_resbind[i].buffer != 0) {
         free(_resbind[i].buffer); // Free existing buffer
       }
       _resbind[i].buffer        = malloc(field->max_length); // free: _c_stmt_free
       _resbind[i].buffer_length = field->max_length;
       _resdata[i].string        = _resbind[i].buffer;
     }
     ++i;
    }
    mysql_free_result(metadata);
    if (mysql_stmt_bind_result(stmt, *resbind) != 0) return -1;
  } else {
    mysql_free_result(metadata);
  }
  return 0;
}

int _c_stmt_fetch(MYSQL_STMT *stmt) {
  if (mysql_stmt_fetch(stmt) != 0) return -1;
  return 0;
}

int _c_stmt_null_at(MYSQL_BIND *resbind, int pos) {
  return *resbind[pos].is_null;
}

int _c_stmt_is_int_at(MYSQL_BIND *resbind, int pos) {
  switch(resbind[pos].buffer_type) {
    case MYSQL_TYPE_TINY:
    case MYSQL_TYPE_SHORT:
    case MYSQL_TYPE_INT24:
    case MYSQL_TYPE_LONG: // TODO: unsigned
    case MYSQL_TYPE_LONGLONG: // TODO: (unsigned) long long
    return 1;
  }
  return 0;
}

int _c_stmt_is_double_at(MYSQL_BIND *resbind, int pos) {
  switch(resbind[pos].buffer_type) {
    case MYSQL_TYPE_FLOAT:
    case MYSQL_TYPE_DOUBLE:
    return 1;
  }
  return 0;
}

int _c_stmt_is_string_at(MYSQL_BIND *resbind, int pos) {
  switch(resbind[pos].buffer_type) {
    case MYSQL_TYPE_STRING:
    case MYSQL_TYPE_VAR_STRING:
    case MYSQL_TYPE_TINY_BLOB:
    case MYSQL_TYPE_BLOB:
    case MYSQL_TYPE_MEDIUM_BLOB:
    case MYSQL_TYPE_LONG_BLOB:
    return 1;
  }
  return 0;
}

int _c_stmt_int_at(STMT_DATA *resdata, int pos) {
  return *(int*)(resdata[pos].buffer);
}

double _c_stmt_double_at(STMT_DATA *resdata, int pos) {
  return *(double*)(resdata[pos].buffer);
}

int _c_stmt_string_at(STMT_DATA *resdata, int pos, char **s) {
  *s = resdata[pos].string;
  return resdata[pos].length;
}

void _c_stmt_seek(MYSQL_STMT *stmt, int pos) {
  mysql_stmt_data_seek(stmt, pos);
}

const char* _c_stmt_column_at(MYSQL_STMT *stmt, int pos) {
  MYSQL_RES *metadata;
  metadata = mysql_stmt_result_metadata(stmt);
  mysql_field_seek(metadata, pos);
  return mysql_fetch_field(metadata)->name;
}

void  _c_stmt_free(MYSQL_STMT *stmt, MYSQL_BIND **bind, STMT_DATA **data, MYSQL_BIND **resbind, STMT_DATA **resdata) {
  int i, fields;
  if(*resdata != 0) {
    fields = mysql_stmt_field_count(stmt);
    for(i = 0; i < fields; ++i) {
      if ((*resdata)[i].string != 0) {
        free((*resdata)[i].string);
      }
    }
    free(*resdata);
  }
  if(*bind != 0) free(*bind);
  if(*data != 0) free(*data);
  if(*resbind != 0) free(*resbind);
  *resdata = 0;
  *bind = 0;
  *data = 0;
  *resbind = 0;
}


