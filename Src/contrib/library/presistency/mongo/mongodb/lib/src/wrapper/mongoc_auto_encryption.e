note
	description: "Summary description for {MONGOC_AUTO_ENCRYPTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	MONGOC_AUTO_ENCRYPTION

feature -- Auto Encryption

	c_mongoc_auto_encryption_opts_new: POINTER
			-- Create a new mongoc_auto_encryption_opts_t.
			-- Returns: A new mongoc_auto_encryption_opts_t, which must be destroyed with mongoc_auto_encryption_opts_destroy().
			-- Note: Caller must set the required options:
			--   * mongoc_auto_encryption_opts_set_keyvault_namespace()
			--   * mongoc_auto_encryption_opts_set_kms_providers()
		note
			EIS: "name=mongoc_auto_encryption_opts_new", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_new.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_new()"
		end

	c_mongoc_auto_encryption_opts_set_keyvault_client (a_opts: POINTER; a_client: POINTER)
			-- Set the client to use for key vault operations.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_keyvault_client", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_client.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_keyvault_client ((mongoc_auto_encryption_opts_t *)$a_opts, (mongoc_client_t *)$a_client)"
		end

	c_mongoc_auto_encryption_opts_set_keyvault_client_pool (a_opts: POINTER; a_pool: POINTER)
			-- Set an optional separate client pool to use during key lookup for automatic encryption and decryption.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_keyvault_client_pool", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_client_pool.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_keyvault_client_pool ((mongoc_auto_encryption_opts_t *)$a_opts, (mongoc_client_pool_t *)$a_pool)"
		end

	c_mongoc_auto_encryption_opts_set_keyvault_namespace (a_opts: POINTER; a_db: POINTER; a_collection: POINTER)
			-- Set the namespace to use for the key vault.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_keyvault_namespace", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_keyvault_namespace.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_keyvault_namespace ((mongoc_auto_encryption_opts_t *)$a_opts, $a_db, $a_collection)"
		end

	c_mongoc_auto_encryption_opts_set_kms_providers (a_opts: POINTER; a_providers: POINTER)
			-- Set the KMS providers configuration.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_kms_providers", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_kms_providers.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_kms_providers ((mongoc_auto_encryption_opts_t *)$a_opts, (const bson_t *)$a_providers)"
		end

	c_mongoc_auto_encryption_opts_set_schema_map (a_opts: POINTER; a_schema_map: POINTER)
			-- Set the JSON Schema map for automatic encryption.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_schema_map", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_schema_map.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_schema_map ((mongoc_auto_encryption_opts_t *)$a_opts, (const bson_t *)$a_schema_map)"
		end

	c_mongoc_auto_encryption_opts_set_bypass_auto_encryption (a_opts: POINTER; a_bypass: BOOLEAN)
			-- Set whether to bypass automatic encryption.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_bypass_auto_encryption", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_bypass_auto_encryption.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_bypass_auto_encryption ((mongoc_auto_encryption_opts_t *)$a_opts, (bool)$a_bypass)"
		end

	c_mongoc_auto_encryption_opts_set_extra (a_opts: POINTER; a_extra: POINTER)
			-- Set extra options for the mongocryptd process.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_extra", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_extra.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_extra ((mongoc_auto_encryption_opts_t *)$a_opts, (const bson_t *)$a_extra)"
		end

	c_mongoc_auto_encryption_opts_set_encrypted_fields_map (a_opts: POINTER; a_encrypted_fields_map: POINTER)
			-- Set the encrypted fields map.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_encrypted_fields_map", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_encrypted_fields_map.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_encrypted_fields_map ((mongoc_auto_encryption_opts_t *)$a_opts, (const bson_t *)$a_encrypted_fields_map)"
		end

	c_mongoc_auto_encryption_opts_set_bypass_query_analysis (a_opts: POINTER; a_bypass: BOOLEAN)
			-- Set whether to bypass query analysis.
		note
			EIS: "name=mongoc_auto_encryption_opts_set_bypass_query_analysis", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_bypass_query_analysis.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_bypass_query_analysis ((mongoc_auto_encryption_opts_t *)$a_opts, (bool)$a_bypass)"
		end

	c_mongoc_auto_encryption_opts_set_tls_opts (a_opts: POINTER; a_tls_opts: POINTER)
			-- Set TLS options for Key Management Service (KMS) providers.
			-- `a_tls_opts': A BSON document mapping KMS providers to TLS options.
			-- Supported KMS providers: aws, azure, gcp, and kmip (may include name suffix with colon).
			-- TLS options per provider may include:
			--   * tlsCaFile: Optional<String>
			--   * tlsCertificateKeyFile: Optional<String>
			--   * tlsCertificateKeyFilePassword: Optional<String>
		note
			EIS: "name=mongoc_auto_encryption_opts_set_tls_opts", "src=https://mongoc.org/libmongoc/current/mongoc_auto_encryption_opts_set_tls_opts.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_auto_encryption_opts_set_tls_opts ((mongoc_auto_encryption_opts_t *)$a_opts, (const bson_t *)$a_tls_opts)"
		end

end
