

char * get_abday (int a_int);

char * get_day (int a_int);

char * get_abmon (int a_int);

char * get_mon (int a_int);

char * am_designator ();

char * pm_designator ();

char * c_full_date_time_pattern ();

char * c_date_pattern ();

char * c_time_pattern ();

char * c_am_pm_format ();

char * numeric_decimal_point ();

char * numeric_group_separator ();

char * numeric_grouping ();

char * currency_symbol ();

char * currency_int_symbol ();

char * currency_dec_point ();

char * currency_thousend_sep ();

char * currency_grouping ();

int currency_numbers_after_digit_sepatator ();

int currency_int_numbers_after_digit_sepatator ();

char * locale_name ();

void set_locale (char *a_locale);

void set_default_locale ();

int is_available (char * a_locale);

char * ith_locale (int i);

