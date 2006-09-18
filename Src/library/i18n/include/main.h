

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

char * currency_symbol ();

char * monetary_dec_point ();

char * currency_numbers_after_digit_sepatator ();

char * radix_char ();

char * thousend_sep();

char * locale_name ();

void set_locale (char *a_locale);

void set_default_locale ();

char * get_date_pattern (int day, int month, int year);

char * get_full_date_time (int h, int m, int s, int day, int month, int year);

char * get_time_pattern (int h, int m, int s);

char * get_am_pm_pattern (int h, int m, int s);
