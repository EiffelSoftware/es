note
    description: "[
        Object representing mongoc_auto_encryption_opts_t
        Options for enabling automatic encryption and decryption for In-Use Encryption.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=Auto Encryption Options", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_t.html", "protocol=uri"
    EIS: "name=In Use Encryption", "src=https://www.mongodb.com/docs/languages/c/c-driver/current/libmongoc/guides/in-use-encryption/", "protocol=uri"

class
    MONGODB_AUTO_ENCRYPTION

inherit

    MONGODB_WRAPPER_BASE
        rename
            make as memory_make
        end

create
    make

feature {NONE} -- Initialization

    make
            -- Create new auto encryption options.
        note
            EIS: "name=mongoc_auto_encryption_opts_new", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_new.html", "protocol=uri"
        do
        	memory_make
            make_by_pointer ({MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_new)
        end

feature -- Settings

    set_keyvault_client (a_client: MONGODB_CLIENT)
            -- Set an optional separate client to use during key lookup for automatic encryption and decryption.
            -- Only applies to automatic encryption on a single-threaded client.
            -- Note: The provided client:
            --   * Should not have automatic encryption enabled
            --   * Will only execute find commands against the key vault collection
            --   * MUST outlive any client which has been enabled to use it through enable_auto_encryption
        note
            EIS: "name=mongoc_auto_encryption_opts_set_keyvault_client", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_client.html", "protocol=uri"
        require
            is_usable: exists
            client_usable: a_client.exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_keyvault_client (item, a_client.item)
        end

    set_keyvault_client_pool (a_pool: MONGODB_CLIENT_POOL)
            -- Set an optional separate client pool to use during key lookup for automatic encryption and decryption.
            -- Only applies to automatic encryption on a client pool.
            -- Note:
            --   * It is invalid to set this for automatic encryption on a single-threaded client
            --   * The provided client pool should not have automatic encryption enabled
            --   * Will only execute find commands against the key vault collection
            --   * MUST outlive any client pool which has been enabled to use it through enable_auto_encryption
        note
            EIS: "name=mongoc_auto_encryption_opts_set_keyvault_client_pool", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_client_pool.html", "protocol=uri"
        require
            is_usable: exists
            pool_exists: a_pool.exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_keyvault_client_pool (item, a_pool.item)
        end

    set_keyvault_namespace (a_db: READABLE_STRING_GENERAL; a_collection: READABLE_STRING_GENERAL)
            -- Set the database and collection name of the key vault.
            -- The key vault is the specially designated collection containing encrypted data keys for In-Use Encryption.
            -- `a_db': The database name of the key vault collection.
            -- `a_collection': The collection name of the key vault collection.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_keyvault_namespace", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_namespace.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_db, l_collection: C_STRING
        do
            create l_db.make (a_db)
            create l_collection.make (a_collection)
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_keyvault_namespace (item, l_db.item, l_collection.item)
        end

    set_kms_providers (a_providers: BSON)
            -- Set the KMS providers configuration.
            -- `kms_providers`: The BSON document containing containing configruation for each KMS provider
        note
            EIS: "name=mongoc_auto_encryption_opts_set_kms_providers", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_kms_providers.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_kms_providers (item, a_providers.item)
        end

    set_schema_map (a_schema_map: BSON)
            -- Set the JSON Schema map for automatic encryption.
            -- `schema_map`: The where keys are collection namespaces and values are JSON schemas.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_schema_map", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_schema_map.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_schema_map (item, a_schema_map.item)
        end

    set_bypass_auto_encryption (a_bypass: BOOLEAN)
            -- Set whether to bypass automatic encryption.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_bypass_auto_encryption", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_bypass_auto_encryption.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_bypass_auto_encryption (item, a_bypass)
        end

    set_extra (a_extra: BSON)
            -- Set extra options for the mongocryptd process.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_extra", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_extra.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_extra (item, a_extra.item)
        end

	set_tls_opts (a_tls_opts: BSON)
            -- Set TLS options for Key Management Service (KMS) providers.
            -- The `a_tls_opts' should be a BSON document of the form:
            -- {
            --     "<KMS provider>": {
            --         "tlsCaFile": Optional<String>,
            --         "tlsCertificateKeyFile": Optional<String>,
            --         "tlsCertificateKeyFilePassword": Optional<String>
            --     }
            -- }
            -- Note:
            --   * Supported KMS providers: aws, azure, gcp, and kmip
            --   * Providers may include an optional name suffix with colon (e.g., "aws:name2")
            -- Example:
            -- {
            --     "kmip": { "tlsCaFile": "ca1.pem" },
            --     "aws": { "tlsCaFile": "ca2.pem" }
            -- }
        note
            EIS: "name=mongoc_auto_encryption_opts_set_tls_opts", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_tls_opts.html", "protocol=uri"
        require
            is_usable: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_tls_opts (item, a_tls_opts.item)
        end

    set_encrypted_fields_map (a_encrypted_fields_map: BSON)
            -- Set the encrypted fields map.
            -- `encrypted_fields`: The bson where keys are collection namespaces and values are encrypted fields documents.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_encrypted_fields_map", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_encrypted_fields_map.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_encrypted_fields_map (item, a_encrypted_fields_map.item)
        end

    set_bypass_query_analysis (a_bypass: BOOLEAN)
            -- Set whether to bypass query analysis.
        note
            EIS: "name=mongoc_auto_encryption_opts_set_bypass_query_analysis", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_bypass_query_analysis.html", "protocol=uri"
        require
            exists: exists
        do
            {MONGOC_AUTO_ENCRYPTION}.c_mongoc_auto_encryption_opts_set_bypass_query_analysis (item, a_bypass)
        end

    --TODO implement https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_kms_credential_provider_callback.html
    -- this require a callback implementation.

feature -- Removal

    dispose
            -- <Precursor>
        do
            if exists then
                c_mongoc_auto_encryption_opts_destroy (item)
            end
        end

feature -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

feature {NONE} -- Implementation

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_auto_encryption_opts_t *);"
		end


feature {NONE} -- Implementation

    c_mongoc_auto_encryption_opts_destroy (a_opts: POINTER)
            -- Free the auto encryption options.
        note
            EIS: "name=mongoc_auto_encryption_opts_destroy", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_destroy.html", "protocol=uri"
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_auto_encryption_opts_destroy ((mongoc_auto_encryption_opts_t *)$a_opts);"
        end

end
