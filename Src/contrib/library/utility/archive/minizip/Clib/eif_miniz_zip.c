/* 
 * Portable ARCHIVE zip implementation using miniz
 * Only dependency is miniz.c
 */

#include "eif_miniz.h"

#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
    #include <windows.h>
    #include <direct.h>
    #define PATH_SEPARATOR '\\'
#else
    #include <dirent.h>
    #include <sys/stat.h>
    #include <unistd.h>
    #define PATH_SEPARATOR '/'
#endif

#define MAX_PATH 260
#define MAX_FILES 10000

typedef struct {
    char** paths;
    char** names;
    int count;
} FileList;

// Forward declarations
void free_file_list(FileList* list);
FileList list_directory(const char* dir_path, const char* prefix);
int read_file_to_zip(mz_zip_archive* zip, const char* path, const char* name);

#ifdef _WIN32
FileList list_directory(const char* dir_path, const char* prefix) {
    FileList result = {0};
    result.paths = (char**)malloc(MAX_FILES * sizeof(char*));
    result.names = (char**)malloc(MAX_FILES * sizeof(char*));
    
    WIN32_FIND_DATA find_data;
    char search_path[MAX_PATH];
    snprintf(search_path, sizeof(search_path), "%s\\*", dir_path);
    
    HANDLE find_handle = FindFirstFile(search_path, &find_data);
    if (find_handle == INVALID_HANDLE_VALUE) {
        return result;
    }

    do {
        if (strcmp(find_data.cFileName, ".") == 0 || strcmp(find_data.cFileName, "..") == 0) {
            continue;
        }

        char full_path[MAX_PATH];
        char rel_name[MAX_PATH];
        snprintf(full_path, sizeof(full_path), "%s\\%s", dir_path, find_data.cFileName);
        
        if (prefix && prefix[0]) {
            snprintf(rel_name, sizeof(rel_name), "%s/%s", prefix, find_data.cFileName);
        } else {
            snprintf(rel_name, sizeof(rel_name), "%s", find_data.cFileName);
        }

        if (find_data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
            FileList subdir = list_directory(full_path, rel_name);
            for (int i = 0; i < subdir.count && result.count < MAX_FILES; i++) {
                result.paths[result.count] = subdir.paths[i];
                result.names[result.count] = subdir.names[i];
                result.count++;
            }
            // Don't free subdir as we're using its allocated memory
        } else {
            result.paths[result.count] = _strdup(full_path);
            result.names[result.count] = _strdup(rel_name);
            result.count++;
        }
    } while (FindNextFile(find_handle, &find_data) && result.count < MAX_FILES);

    FindClose(find_handle);
    return result;
}
#else
FileList list_directory(const char* dir_path, const char* prefix) {
    FileList result = {0};
    result.paths = (char**)malloc(MAX_FILES * sizeof(char*));
    result.names = (char**)malloc(MAX_FILES * sizeof(char*));
    
    DIR* dir = opendir(dir_path);
    if (!dir) {
        return result;
    }

    struct dirent* entry;
    while ((entry = readdir(dir)) && result.count < MAX_FILES) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        char full_path[MAX_PATH];
        char rel_name[MAX_PATH];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);
        
        if (prefix && prefix[0]) {
            snprintf(rel_name, sizeof(rel_name), "%s/%s", prefix, entry->d_name);
        } else {
            snprintf(rel_name, sizeof(rel_name), "%s", entry->d_name);
        }

        struct stat st;
        if (stat(full_path, &st) == 0) {
            if (S_ISDIR(st.st_mode)) {
                FileList subdir = list_directory(full_path, rel_name);
                for (int i = 0; i < subdir.count && result.count < MAX_FILES; i++) {
                    result.paths[result.count] = subdir.paths[i];
                    result.names[result.count] = subdir.names[i];
                    result.count++;
                }
                // Don't free subdir as we're using its allocated memory
            } else {
                result.paths[result.count] = strdup(full_path);
                result.names[result.count] = strdup(rel_name);
                result.count++;
            }
        }
    }

    closedir(dir);
    return result;
}
#endif

void free_file_list(FileList* list) {
    if (!list) return;
    
    for (int i = 0; i < list->count; i++) {
        free(list->paths[i]);
        free(list->names[i]);
    }
    free(list->paths);
    free(list->names);
    list->count = 0;
}

int read_file_to_zip(mz_zip_archive* zip, const char* path, const char* name) {
    FILE* file = fopen(path, "rb");
    if (!file) return 0;

    fseek(file, 0, SEEK_END);
    size_t size = ftell(file);
    fseek(file, 0, SEEK_SET);

    void* buffer = malloc(size);
    if (!buffer) {
        fclose(file);
        return 0;
    }

    size_t read_size = fread(buffer, 1, size, file);
    fclose(file);

    if (read_size != size) {
        free(buffer);
        return 0;
    }

    int success = mz_zip_writer_add_mem(zip, name, buffer, size, MZ_BEST_COMPRESSION);
    free(buffer);
    return success;
}

int zip_directory(const char* dir_path, const char* zip_path, FILE* output) {
    mz_zip_archive zip = {0};
    if (!mz_zip_writer_init_file(&zip, zip_path, 0)) {
        if (output) { fprintf(output, "Failed to create ZIP file\n"); }
        return 0;
    }

    FileList files = list_directory(dir_path, "");
    int success = 1;

    for (int i = 0; i < files.count; i++) {
        fprintf(output, "Adding: %s\n", files.names[i]);
        if (!read_file_to_zip(&zip, files.paths[i], files.names[i])) {
            if (output) { fprintf(output, "Failed to add file: %s\n", files.paths[i]); }
            success = 0;
            break;
        }
    }

    free_file_list(&files);

    if (!mz_zip_writer_finalize_archive(&zip)) {
        if (output) { fprintf(output, "Failed to finalize ZIP archive\n"); }
        success = 0;
    }

    mz_zip_writer_end(&zip);
    return success;
}


