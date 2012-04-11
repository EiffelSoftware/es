indexing
	description: "Wrapper class for ICONFIGURATION"
	author: "Ruihua Jin"
	date: "$Date: 2008/02/12 10:14:59$"
	revision: "$Revision: 1.0$"

class
	CONFIGURATION

create
	make,
	make_global,
	make_new,
	make_clone

feature {NONE}  -- Initialization

	make (c: ICONFIGURATION) is
			-- Initialize `iconfig' with `c'.
		require
			c_not_void: c /= Void
		do
			iconfig := c
		end

	make_global is
			-- Initialize `iconfig' with the global db4o `ICONFIGURATION' context
			-- for the running CLR session.
		do
			make ({DB_4O_FACTORY}.configure)
		end

	make_new is
			-- Initialize `iconfig' with a fresh, independent configuration
			-- with all options set to their default values.
		do
			make ({DB_4O_FACTORY}.new_configuration)
		end

	make_clone is
			-- Initialize `iconfig' with a fresh configuration
			-- with all option values set to the values currently configured
			-- for the global db4o configuration context.
		do
			make ({DB_4O_FACTORY}.clone_configuration)
		end


feature  -- Wrapper of ICONFIGURATION

	activation_depth: INTEGER is
			-- Configured activation depth
		do
			Result := iconfig.activation_depth
		end

	activation_depth_integer (depth: INTEGER) is
			-- Set activation depth.
		require
			depth_nonnegative: depth >= 0
		do
			iconfig.activation_depth (depth)
		end

	add (configuration_item: ICONFIGURATION_ITEM) is
			-- Add `configuration_item' to be applied when an object_container or object_server is opened.
		require
			configuration_item_not_void: configuration_item /= Void
		do
			iconfig.add (configuration_item)
		end

	add_alias (alias_: IALIAS) is
			-- Add a new Alias for a class, namespace or package.
		require
			alias_not_void: alias_ /= Void
		do
			iconfig.add_alias (alias_)
		end

	allow_version_updates (flag: BOOLEAN) is
			-- Turn automatic database file format version updates on.
		do
			iconfig.allow_version_updates (flag)
		end

	automatic_shut_down (flag: BOOLEAN) is
			-- Turn automatic shutdown of the engine on and off.
		do
			iconfig.automatic_shut_down (flag)
		end

	block_size (bytes: INTEGER) is
			-- Set the storage data blocksize for new object_containers.
		require
			bytes_in_range: bytes > 0 and bytes < 128
		do
			iconfig.block_size (bytes)
		end

	b_tree_cache_height (height: INTEGER) is
			-- Configure caching of BTree nodes.
		require
			height_nonnegative: height >= 0
		do
			iconfig.b_tree_cache_height (height)
		end

	b_tree_node_size (size: INTEGER) is
			-- Configure the size of BTree nodes in indexes.
		require
			size_positive: size > 0
		do
			iconfig.b_tree_node_size (size)
		end

	callbacks (flag: BOOLEAN) is
			-- Turn callback methods on and off.
		do
			iconfig.callbacks (flag)
		end

	call_constructors (flag: BOOLEAN) is
			-- Advise db4o to try instantiating objects with/without calling constructors.
		do
			iconfig.call_constructors (flag)
		end

	class_activation_depth_configurable (flag: BOOLEAN) is
			-- Turn individual class activation depth configuration on and off.
		do
			iconfig.class_activation_depth_configurable (flag)
		end

	client_server: ICLIENT_SERVER_CONFIGURATION is
			-- Client/server configuration interface
		do
			Result := iconfig.client_server
		end

	database_growth_size (bytes: INTEGER) is
			-- Configure the size database files should grow in bytes, when no free slot is found within.
		require
			bytes_positive: bytes > 0
		do
			iconfig.database_growth_size (bytes)
		end

	detect_schema_changes (flag: BOOLEAN) is
			-- Configure whether db4o checks all persistent classes upon system startup, for added or removed fields.
		do
			iconfig.detect_schema_changes (flag)
		end

	diagnostic: IDIAGNOSTIC_CONFIGURATION is
			-- Configuration interface for diagnostics
		do
			Result := iconfig.diagnostic
		end

	disable_commit_recovery is
			-- Turn commit recovery off.
		do
			iconfig.disable_commit_recovery
		end

	discard_free_space (byte_count: INTEGER) is
			-- Configure the minimum size of free space slots in the database file that are to be reused.
		require
			byte_count_nonnegative: byte_count >= 0
		do
			iconfig.discard_free_space (byte_count)
		end

	encrypt (flag: BOOLEAN) is
			-- Configure the use of encryption.
		do
			iconfig.encrypt (flag)
		end

	exceptions_on_not_storable (flag: BOOLEAN) is
			-- Configure whether Exceptions are to be thrown, if objects can not be stored.
		do
			iconfig.exceptions_on_not_storable (flag)
		end

	flush_file_buffers (flag: BOOLEAN) is
			-- Configure file buffers to be flushed during transaction commits.
		do
			iconfig.flush_file_buffers (flag)
		end

	freespace: IFREESPACE_CONFIGURATION is
			-- Freespace configuration interface
		do
			Result := iconfig.freespace
		end

	generate_uui_ds_integer (setting: INTEGER) is
			-- Configure db4o to generate UUIDs for stored objects.
		require
			valid_setting: setting = -1 or setting = 1 or setting = {INTEGER}.max_value
		do
			iconfig.generate_uui_ds (setting)
		end

	generate_uui_ds_config_scope (setting: CONFIG_SCOPE) is
			-- Configure db4o to generate UUIDs for stored objects.
		require
			setting_not_void: setting /= Void
		do
			iconfig.generate_uui_ds (setting)
		end

	generate_version_numbers_integer (setting: INTEGER) is
			-- Configure db4o to generate version numbers for stored objects.
		require
			valid_setting: setting = -1 or setting = 1 or setting = {INTEGER}.max_value
		do
			iconfig.generate_version_numbers (setting)
		end

	generate_version_numbers_config_scope (setting: CONFIG_SCOPE) is
			-- Configure db4o to generate version numbers for stored objects.
		require
			setting_not_void: setting /= Void
		do
			iconfig.generate_version_numbers (setting)
		end

	intern_strings: BOOLEAN is
			-- Will strings be interned?
		do
			Result := iconfig.intern_strings
		end

	intern_strings_boolean (flag: BOOLEAN) is
			-- Configures db4o to call #intern () on strings upon retrieval.
		do
			iconfig.intern_strings (flag)
		end

	io_ (adapter: IO_ADAPTER) is
			-- Allow to configure db4o to use a customized byte IO adapter.
		require
			adapter_not_void: adapter /= Void
		do
			iconfig.io (adapter)
		end

	lock_database_file (flag: BOOLEAN) is
			-- Turn the database file locking thread off, if false.
		do
			iconfig.lock_database_file (flag)
		end

	mark_transient (attribute_name: SYSTEM_STRING) is
			-- Mark fields as transient with custom attributes.
		require
			nonempty_name: not {SYSTEM_STRING}.is_null_or_empty (attribute_name)
		do
			iconfig.mark_transient (attribute_name)
		end

	message_level (level: INTEGER) is
			-- Set the detail level of db4o messages.
		require
			level_in_range: level > -2 and level < 4
		do
			iconfig.message_level (level)
		end

	object_class (clazz: SYSTEM_OBJECT): OBJECT_CLASS is
			-- `OBJECT_CLASS' object to configure the specified class.
			-- `clazz' can be `TYPE[SYSTEM_OBJECT]', `SYSTEM_TYPE' or
			-- any other object used as a template.
		require
			clazz_not_void: clazz /= Void
		local
			type: TYPE[SYSTEM_OBJECT]
			systype: SYSTEM_TYPE
			ioc: IOBJECT_CLASS
		do
			type ?= clazz
			if (type /= Void) then
				systype := type.to_cil
				ioc := iconfig.object_class (systype)
			else
				systype ?= clazz
				if (systype = Void) then
					systype := clazz.get_type
					ioc := iconfig.object_class (clazz)
				else
					ioc := iconfig.object_class (systype)
				end
			end
			Result := create {OBJECT_CLASS}.make (Current, systype)
		end

	optimize_native_queries: BOOLEAN is
			-- Will Native Queries be optimized dynamically?
		do
			Result := iconfig.optimize_native_queries
		end

	optimize_native_queries_boolean (optimizeNQ: BOOLEAN) is
			-- If set to true, db4o will try to optimize native queries dynamically at query execution time,
			-- otherwise it will run native queries in unoptimized mode as SODA evaluations.
		do
			iconfig.optimize_native_queries (optimizeNQ)
		end

	password (pass: SYSTEM_STRING) is
			-- Protect the database file with a password.
		require
			nonempty_pass: not {SYSTEM_STRING}.is_null_or_empty (pass)
		do
			iconfig.password (pass)
		end

	queries: IQUERY_CONFIGURATION is
			-- Query configuration interface
		do
			Result := iconfig.queries
		end

	read_only (flag: BOOLEAN) is
			-- Turn readOnly mode on and off.
		do
			iconfig.read_only (flag)
		end

	reflect_with (reflector: IREFLECTOR) is
			-- Configure the use of a specially designed reflection implementation.
		require
			reflector_not_void: reflector /= Void
		do
			iconfig.reflect_with (reflector)
		end

	refresh_classes is
			-- Force analysis of all Classes during a running session.
		do
			iconfig.refresh_classes
		end

	register_type_handler (predicate: ITYPE_HANDLER_PREDICATE; type_handler: ITYPE_HANDLER_4) is
			-- Register special TYPE_HANDLERs for customized marshalling and customized comparisons.
		require
			predicate_not_void: predicate /= Void
			type_handler_not_void: type_handler /= Void
		do
			iconfig.register_type_handler (predicate, type_handler)
		end

	remove_alias (alias_: IALIAS) is
			-- Remove `alias_' previously added with CONFIGURATION.add_alias.
		require
			alias_not_void: alias_ /= Void
		do
			iconfig.remove_alias (alias_)
		end

	reserve_storage_space (byte_count: INTEGER_64) is
			-- Reserve a number of bytes in database files.
		require
			byte_count_nonnegative: byte_count > 0
		do
			iconfig.reserve_storage_space (byte_count)
		end

	set_blob_path (path: SYSTEM_STRING) is
			-- Configure the path to be used to store and read Blob data.
		require
			nonempty_path: not {SYSTEM_STRING}.is_null_or_empty (path)
		do
			iconfig.set_blob_path (path)
		end

	set_class_loader (class_loader: SYSTEM_OBJECT) is
			-- Configure db4o to use a custom `class_loader'.
		require
			class_loader_not_void: class_loader /= Void
		do
			iconfig.set_class_loader (class_loader)
		end

	set_out (out_stream: TEXT_WRITER) is
			-- Assign `out_stream' where db4o is to print its event messages.
		require
			out_stream_not_void: out_stream /= Void
		do
			iconfig.set_out (out_stream)
		end

	test_constructors (flag: BOOLEAN) is
			-- Configure whether db4o should try to instantiate one instance of each persistent class on system startup.
		do
			iconfig.test_constructors (flag)
		end

	unicode (flag: BOOLEAN) is
			-- Configure the storage format of Strings.
		do
			iconfig.unicode (flag)
		end

	update_depth (depth: INTEGER) is
			-- Specify the global update depth.
		require
			depth_nonnegative: depth >= 0
		do
			iconfig.update_depth (depth)
		end

	weak_reference_collection_interval (milliseconds: INTEGER) is
			-- Configure the timer for WeakReference collection.
		require
			milliseconds_positive: milliseconds > 0
		do
			iconfig.weak_reference_collection_interval (milliseconds)
		end

	weak_references (flag: BOOLEAN) is
			-- Turn weak reference management on or off.
		do
			iconfig.weak_references (flag)
		end


feature

	iconfig: ICONFIGURATION
			-- The actual `ICONFIGURATION' object for db4o database

end
