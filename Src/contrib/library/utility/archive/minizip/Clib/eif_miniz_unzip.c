/* 
 * Portable ARCHIVE unzip implementation using miniz
 * Only dependency is miniz.c
 */

#include "eif_miniz.h"

#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
    #include <direct.h>     /* for _mkdir */
#else
    #include <sys/stat.h>   /* for mkdir */
    #include <sys/types.h>
#endif

#define MAX_PATH 260
#define MAX_FILENAME 256

typedef struct {
    size_t size;
    void* data;
} Buffer;

Buffer read_file(const char* filename) {
    Buffer buffer = {0};
    FILE* file = fopen(filename, "rb");
    if (!file) return buffer;
    
    fseek(file, 0, SEEK_END);
    buffer.size = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    buffer.data = malloc(buffer.size);
    if (buffer.data) {
        fread(buffer.data, 1, buffer.size, file);
    }
    fclose(file);
    return buffer;
}

int write_file(const char* filename, const void* data, size_t size) {
    FILE* file = fopen(filename, "wb");
    if (!file) return 0;
    
    size_t written = fwrite(data, 1, size, file);
    fclose(file);
    return written == size;
}

int make_directory(const char* path) {
#ifdef _WIN32
    return _mkdir(path);
#else
    return mkdir(path, 0755);
#endif
}

int unzip_archive(const char* archive_path, const char* extract_path, FILE* output) {
    // Read the ARCHIVE file into memory
    Buffer archive = read_file(archive_path);
    if (!archive.data) {
        if (output) { fprintf(output, "Failed to read ARCHIVE file\n"); }
        return 0;
    }

    // Initialize miniz
    mz_zip_archive zip = {0};
    if (!mz_zip_reader_init_mem(&zip, archive.data, archive.size, 0)) {
        if (output) { fprintf(output, "Failed to initialize ZIP reader\n"); }
        free(archive.data);
        return 0;
    }

    // Create extraction directory
    make_directory(extract_path);

    // Extract all files
    int file_count = (int)mz_zip_reader_get_num_files(&zip);
    for (int i = 0; i < file_count; i++) {
        mz_zip_archive_file_stat file_stat;
        if (!mz_zip_reader_file_stat(&zip, i, &file_stat)) {
            continue;
        }

        // Skip directories
        if (mz_zip_reader_is_file_a_directory(&zip, i)) {
            continue;
        }

        // Create output path
        char out_path[MAX_PATH];
        snprintf(out_path, sizeof(out_path), "%s/%s", extract_path, file_stat.m_filename);

        // Create directories in path if they don't exist
        char* p = out_path;
        while ((p = strchr(p + 1, '/'))) {
            *p = '\0';
            make_directory(out_path);
            *p = '/';
        }

        // Extract file
        size_t size;
        void* data = mz_zip_reader_extract_to_heap(&zip, i, &size, 0);
        if (data) {
            write_file(out_path, data, size);
            free(data);
            if (output) { fprintf(output, "Extracted: %s (%zu bytes)\n", file_stat.m_filename, size); }
        }
    }

    mz_zip_reader_end(&zip);
    free(archive.data);
    return 1;
}
