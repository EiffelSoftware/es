note
	description: "[
			Object Representing Read Preference Modes
			This enum describes how reads should be dispatched. The default is MONGO_READ_PRIMARY.
			
			Read Modes
			MONGOC_READ_PRIMARY	Default mode. All operations read from the current replica set primary.
			MONGOC_READ_SECONDARY	All operations read from among the nearest secondary members of the replica set.
			MONGOC_READ_PRIMARY_PREFERRED	In most situations, operations read from the primary but if it is unavailable, operations read from secondary members.
			MONGOC_READ_SECONDARY_PREFERRED	In most situations, operations read from among the nearest secondary members, but if no secondaries are available, operations read from the primary.
			MONGOC_READ_NEAREST	Operations read from among the nearest members of the replica set, irrespective of the member’s type.

		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_read_mode_t", "src=http://mongoc.org/libmongoc/current/mongoc_read_mode_t.html", "protocol=uri"

class
	MONGODB_READ_MODE_ENUM

inherit

	MONGODB_ENUM

create
	make

feature {NONE} -- Initialization

	make
			-- Create an instance with default mode set as MONGO_READ_PRIMARY.
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_primary
		end


feature -- Change Element

	mark_read_primary
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_primary
		end

	mark_read_secondary
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_secondary
		end

	mark_read_primary_preferred
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_primary_preferred
		end

	mark_read_secondary_preferred
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_secondary_preferred
		end

	mark_mongoc_read_nearest
		do
			value := {MONGODB_EXTERNALS}.mongoc_read_nearest
		end

feature -- Status Report

	is_valid_value (a_value: INTEGER): BOOLEAN
		do
			Result := ((a_value = {MONGODB_EXTERNALS}.mongoc_read_primary) or else
				(a_value = {MONGODB_EXTERNALS}.mongoc_read_secondary) or else
				(a_value = {MONGODB_EXTERNALS}.mongoc_read_primary_preferred) or else
				(a_value = {MONGODB_EXTERNALS}.mongoc_read_secondary_preferred) or else
				(a_value = {MONGODB_EXTERNALS}.mongoc_read_nearest)
				)
		end

	is_mongo_read_primary: BOOLEAN
		do
			Result := value = {MONGODB_EXTERNALS}.mongoc_read_primary
		end

	is_mongo_read_secondary: BOOLEAN
		do
			Result := value = {MONGODB_EXTERNALS}.mongoc_read_secondary
		end

	is_mongo_read_primary_preferred: BOOLEAN
		do
			Result := value = {MONGODB_EXTERNALS}.mongoc_read_primary_preferred
		end

	is_mongo_read_secondary_preferred: BOOLEAN
		do
			Result := value = {MONGODB_EXTERNALS}.mongoc_read_secondary_preferred
		end

	is_mongo_read_nearest: BOOLEAN
		do
			Result := value = {MONGODB_EXTERNALS}.mongoc_read_nearest
		end

end
