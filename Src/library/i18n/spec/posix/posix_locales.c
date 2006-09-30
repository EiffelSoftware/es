#include <langinfo.h>
#include <locale.h>
#include <time.h>
#include <malloc.h>
#include <string.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h> 
#include <iconv.h>
#include <errno.h>

#define BUFSIZE 30

wchar_t outbuf[BUFSIZE];

void convert (char * inbuf, size_t insize, wchar_t **out, size_t *outsize) {
	iconv_t cd;
	size_t nconv, avail, alloc;
	char *res, *tres, *wrptr, *inptr;
	
	*out = NULL;
	*outsize = 0;
	
	alloc = avail = insize + insize/4;
	if (!(res = malloc(alloc)))
	{
		perror("malloc");
		return;
	}

	wrptr = res;   // duplicate pointers because they
	inptr = inbuf; // get modified by iconv

	char *charset = nl_langinfo (CODESET);   /*serve a capire che charset
											   usa il locale attuale*/
	cd = iconv_open ("UTF-8", charset);    /*qualcosa che serve a dire a iconv
											 cosa deve converire in cosa*/
	if (cd == (iconv_t)(-1))
	{
		perror("iconv_open");
		free(res);
		return;
	}

	do
	{
		nconv = iconv (cd, &inptr, &insize, &wrptr, &avail); //la conversione
		if (nconv == (size_t)(-1))
		{
			if (errno == E2BIG) // need more room for result
			{
				tres = realloc(res, alloc += 20);
				avail += 20;
				if (!tres)
				{
					perror("realloc");
					break;
				}
				wrptr = tres + (wrptr - res);
				res = tres;
			}
			else // something wrong with input
				break;
			}
	} while (insize);

	if (iconv_close(cd))
		perror("iconv_close");

	*out = (wchar_t*) res;
	*outsize = wrptr - res; // should be == to (alloc - avail + 1)
	//TODO: should possibly null-terminate the result
}

struct lconv * mylocale;

int abday[7] = {ABDAY_1,ABDAY_2,ABDAY_3,ABDAY_4,ABDAY_5,ABDAY_6,ABDAY_7};

// get abbreviated  name of the i-th weekday ( in en_GB for 1: "Mon")


wchar_t blah[30];

wchar_t * get_abday (int a_int) {
	return nl_langinfo(abday[(a_int)%7]);
};

int day[7] = {DAY_1,DAY_2,DAY_3,DAY_4,DAY_5,DAY_6,DAY_7};

// get name of the i-th weekday ( in en_GB for 1: "Monday")
wchar_t * get_day (int a_int) {
	return nl_langinfo(day[(a_int)%7]);
}; 

int abmon[12] = {ABMON_1,ABMON_2,ABMON_3,ABMON_4,ABMON_5,ABMON_6,ABMON_7,ABMON_8,ABMON_9,ABMON_10,ABMON_11,ABMON_12};

// get abbreviated  name of the i-th month ( in en_GB for 1: "Jan")
wchar_t * get_abmon (int a_int) {
	return nl_langinfo(abmon[(a_int-1)%12]);
};

int mon[12] = {MON_1,MON_2,MON_3,MON_4,MON_5,MON_6,MON_7,MON_8,MON_9,MON_10,MON_11,MON_12};

// get name of the i-th month ( in en_GB for 1: "Januar")
wchar_t * get_mon (int a_int) {
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

/******************************
**** NUMERIC INFORMATIONS *****
******************************/


char * numeric_decimal_point () {
// 	return nl_langinfo (__DECIMAL_POINT);
	return mylocale->decimal_point;
}

char * numeric_group_separator () {
	return mylocale->thousands_sep;
}

char * numeric_grouping () {
	return mylocale->grouping;
}

/*****************************
**** CURRENCY INFORMATIONS ***
******************************/


/*Return the currency symbol, preceded by 
* "-" if the symbol should appear before the value,
* "+" if the symbol should appear after the value,
* "." if the symbol should replace the radix character. */
char * currency_symbol () {
	return nl_langinfo(CRNCYSTR);
}

char * currency_int_symbol () {
	return mylocale->int_curr_symbol;
}

char * currency_dec_point () {
	return mylocale->mon_decimal_point;
}

char * currency_thousend_sep () {
// 	return nl_langinfo (__MON_THOUSANDS_SEP);
	return mylocale->mon_thousands_sep;
}

char currency_numbers_after_dec_sepatator () {
// 	return nl_langinfo(__FRAC_DIGITS);
	return mylocale->frac_digits;
}

char currency_int_numbers_after_dec_sepatator () {
// 	return nl_langinfo(__FRAC_DIGITS);
	return mylocale->int_frac_digits;
}

char * currency_grouping () {
// 	return nl_langinfo (__MON_GROUPING);
	return mylocale->mon_grouping;
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
	mylocale = localeconv();
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
int is_available (char *a_locale) {
	char *prev_locale; //previous locale string
	char *t;
	prev_locale = lc_locale_name;
	t = setlocale (LC_ALL, a_locale); //try to set the locale
	set_locale (prev_locale);//restore the previous locale
	if (t != NULL) { //a_locale exists
		return 1;
	} else {	/*setlocale returned a NULL
			pointer therefore a_locale
			is not available*/
		return 0;
	}
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
	return NULL;
}
