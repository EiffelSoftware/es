note
    description: "[
        Object representing a mongoc_index_model_t structure.
        
        The mongoc_index_model_t structure encapsulates the details of an index specification,
        including the keys to index and additional options.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_index_model_t", "src=https://mongoc.org/libmongoc/current/mongoc_collection_create_indexes_with_opts.html#mongoc-index-model-t", "protocol=uri"

class
    MONGODB_INDEX_MODEL

inherit
    MONGODB_WRAPPER_BASE
        rename
            make as make_base
        end

create
    make

feature -- Creation

    make (a_keys: BSON; a_opts: detachable BSON)
            -- Create a new index model.
            -- `a_keys`: A BSON document containing the index keys
            -- `a_opts`: Optional settings for the index
        local
            l_opts: POINTER
        do
            if attached a_opts then
                l_opts := a_opts.item
            end
            make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_index_model_new (a_keys.item, l_opts))
        end

feature -- Removal

    dispose
            -- <Precursor>
        do
            if shared then
                c_mongoc_index_model_destroy (item)
            end
        end

feature {NONE} -- Measurement

    structure_size: INTEGER
            -- Size to allocate (in bytes)
        do
            Result := struct_size
        end

    struct_size: INTEGER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return sizeof(mongoc_index_model_t *);"
        end

    c_mongoc_index_model_destroy (a_model: POINTER)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_index_model_destroy ((mongoc_index_model_t *)$a_model);"
        end

end
