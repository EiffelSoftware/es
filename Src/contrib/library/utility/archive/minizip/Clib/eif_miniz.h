#ifndef EIF_MINIZ
#define EIF_MINIZ

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>

//#define MINIZ_NO_STDIO
// #define MINIZ_NO_ARCHIVE_WRITING_APIS
#define MINIZ_NO_TIME
#define MINIZ_NO_ZLIB_APIS

#include "miniz.h"

int unzip_archive(const char* archive_path, const char* extract_path, FILE* output);

int zip_directory(const char* dir_path, const char* zip_path, FILE* output);
	
#ifdef __cplusplus
}
#endif

#endif
