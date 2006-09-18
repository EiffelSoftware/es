#include <stdio.h>
#include <langinfo.h>
#include <locale.h>
#include <time.h>
#include <malloc.h>
#include <string.h>
#include <dirent.h>

int abday[7] = {ABDAY_1,ABDAY_2,ABDAY_3,ABDAY_4,ABDAY_5,ABDAY_6,ABDAY_7};

// get abbreviated  name of the i-th weekday ( in en_GB for 1: "Mon")
char * get_abday (int a_int) {
	return nl_langinfo(abday[(a_int)%7]);
};

int day[7] = {DAY_1,DAY_2,DAY_3,DAY_4,DAY_5,DAY_6,DAY_7};

// get name of the i-th weekday ( in en_GB for 1: "Monday")
char * get_day (int a_int) {
	return nl_langinfo(day[(a_int)%7]);
}; 

int abmon[12] = {ABMON_1,ABMON_2,ABMON_3,ABMON_4,ABMON_5,ABMON_6,ABMON_7,ABMON_8,ABMON_9,ABMON_10,ABMON_11,ABMON_12};

// get abbreviated  name of the i-th month ( in en_GB for 1: "Jan")
char * get_abmon (int a_int) {
	return nl_langinfo(abmon[(a_int-1)%12]);
};

int mon[12] = {MON_1,MON_2,MON_3,MON_4,MON_5,MON_6,MON_7,MON_8,MON_9,MON_10,MON_11,MON_12};

// get name of the i-th month ( in en_GB for 1: "Januar")
char * get_mon (int a_int) {
	return nl_langinfo(mon[(a_int-1)%12]);
};

/*The return values are strings which can be used in the representation
*of time as an hour from 1 to 12 plus an am/pm specifier. 
*NOTE: in locales which do not use this time representation
*these strings might be empty, in which case the am/pm format cannot be used at all*/
char * am_designator () {
	return nl_langinfo(AM_STR);
}

//read comment of am_designator
char * pm_designator () {
	
	return nl_langinfo(PM_STR);
} 

//return format string with date and time in  locale-specific way.
char * c_full_date_time_pattern () {
	return nl_langinfo(D_T_FMT);
}

//return format string with date in  locale-specific way.
char * c_date_pattern () {
	return nl_langinfo(D_FMT);
}

//return format string with time in locale-specific way.
char * c_time_pattern () {
	return nl_langinfo(T_FMT);
}

/*The return value represents time in the am/pm format. 
* NOTE thatam_designator if the am/pm format does not make any sense for the selected locale,
* the return value might be the same as the one for T_FMT or even empty.*/
char * c_am_pm_format () {
	return nl_langinfo(T_FMT_AMPM);
}

char * numeric_decimal_point () {
// 	return nl_langinfo(DECIMAL_POINT);
	return nl_langinfo (__DECIMAL_POINT);
}

/*Return the currency symbol, preceded by 
* "-" if the symbol should appear before the value,
* "+" if the symbol should appear after the value,
* "." if the symbol should replace the radix character. */
char * currency_symbol () {
	return nl_langinfo(CRNCYSTR);
}

char * monetary_dec_point () {
	return nl_langinfo(__MON_DECIMAL_POINT);
}

char * monetary_thousend_sep () {
	return nl_langinfo (__MON_THOUSANDS_SEP);
}

char * monetary_grouping () {
	return nl_langinfo (__MON_GROUPING);
}

char * currency_numbers_after_dec_sepatator () {
	return nl_langinfo(__FRAC_DIGITS);
}

char * radix_char () {
	return nl_langinfo (RADIXCHAR);
}

//Return separator character for thousands (groups of three digits).
char *thousend_sep() {
	return nl_langinfo(THOUSEP);
}

//String with the name of the current locale name
char lc_locale_name[20];

//Retuns pointer to current locale name
char * locale_name () {
	return lc_locale_name;
}

/*Set the locale to a_locale, if the locale is available,
* otherwise we use the POSIX locale*/
void set_locale (char *a_locale) {
	char * t;
	t = setlocale (LC_ALL, a_locale);
	if (t != NULL) {
		strcpy( lc_locale_name, t);
	} else { //a_locale is not available
		strcpy(lc_locale_name,"POSIX");
	}
}

//set locale to the user locale settings
void set_default_locale () {
	set_locale ("");
}


//is a_locale available?
int is_available (char * a_locale) {
	char *prev_locale; //previous locale string
	char *t;
	prev_locale = lc_locale_name;
	t = setlocale (LC_ALL, a_locale); //try to set the locale
	if (t != NULL) { //a_locale exists
		return 1;
	} else {	/*setlocale returned a NULL
			pointer therefore a_locale
			is not available*/
		return 0;
	}
	//restore the previous locale
	set_locale (prev_locale);
}

// To obtain the list of the available locales
// I go to the directory "/usr/share/i18n/locales/"
// the locale informations files are stored.
// and put the list of the files found
// there in localelist. But before doing that
// I check if it is really available
struct dirent **localelist;

int init_available_locales () {
	return scandir("/usr/share/i18n/locales/", &localelist, 0, alphasort);
}

char * ith_locale (int i) {
	if (localelist == NULL)
		init_available_locales ();
	if (is_available (localelist[i]->d_name))
// 		check if it is really available
		return localelist[i]->d_name;
	else
		return NULL;
}

//Struct defined in time.h
struct tm *tmp;
time_t t;


//initialize the tmp struct, in a locale specific way
//used to avoid Segmentation faults :-)
void initialize_time_struct () {
	tmp = malloc(sizeof(struct tm));
	t = time(NULL);
   	tmp = localtime(&t);
}

//Set the time relative fields in the tmp struct
void set_time (int h, int m, int s) {
	tmp->tm_hour = h;
	tmp->tm_min = m;
	tmp->tm_sec = s;
}

//Set the date relative fields in the tmp struct
void set_date (int day, int month, int year) {
	tmp->tm_mday = day;
	tmp->tm_mon = month-1;
	tmp->tm_year = year+1900;
}

//String that contains locale specific "full date time pattern"
char full_date_time[300];

//Set the full_date_time string
void set_full_date_time (int h, int m, int s, int day, int month, int year) {
	initialize_time_struct ();
	set_time (h, m, s);
	set_date (day, month, year);
	strftime(full_date_time, sizeof(full_date_time), c_full_date_time_pattern(), tmp);
};

/*Return the pointer to the "full_date_time" string, that is initialized
*according the arguments*/
char * get_full_date_time (int h, int m, int s, int day, int month, int year) {
	set_full_date_time (h, m, s, day, month, year);
	return full_date_time;
}

//String that contains locale specific "date pattern"
char date_pattern[100];

//Set the date_pattern
void set_date_pattern (int day, int month, int year) {
	initialize_time_struct ();
	set_date (day, month, year);
	strftime(date_pattern, sizeof(date_pattern), c_date_pattern(), tmp);
} 

/*Return the pointer to the "date_pattern" string, that is initialized
*according the arguments*/
char * get_date_pattern (int day, int month, int year) {
	set_date_pattern (day, month, year);
	return date_pattern;
}

//String that contains locale specific "time pattern"
char time_pattern[100];

//Set the time_pattern
void set_time_pattern (int h, int m, int s) {
	initialize_time_struct ();
	set_time (h, m, s);
	strftime(time_pattern, sizeof(time_pattern), c_time_pattern(), tmp);
} 

/*Return the pointer to the "time_pattern" string, that is initialized
*according the arguments*/
char * get_time_pattern (int h, int m, int s) {
	set_time_pattern(h, m, s);
	return time_pattern;
}

//String that contains locale specific "am_pm_format"
char am_pm_format[100];

//Set the am_pm_format
void set_am_pm_pattern (int h, int m, int s) {
	initialize_time_struct ();
	set_time (h, m, s);
	strftime(am_pm_format, sizeof(am_pm_format), c_am_pm_format (), tmp);
} 

/*Return the pointer to the "am_pm_patternern" string, that is initialized
*according the arguments*/
char * get_am_pm_pattern (int h, int m, int s) {
	set_am_pm_pattern(h, m, s);
	return am_pm_format;
}

