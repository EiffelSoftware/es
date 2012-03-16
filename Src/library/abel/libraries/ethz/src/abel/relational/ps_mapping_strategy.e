note
	description:
		"[
			 This class deals with the actual database structure.
			 It takes metadata information and returns an array of attribute name/value pairs of strings of the actual object (with one pair being the primary key).
			 It only loads or stores the strings, numbers and booleans a single object, and never follows any references.
			 For references, it will use and return the foreign keys in the database.
			 The class is mainly responsible to get the inheritance right. It gets the inheritance structure from the metadata.
			 It is also responsible to compile queries into sql when possible, and filter them if necessary.
			 If a database error occurs, it will be written into the transaction.

		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"


deferred class
	PS_MAPPING_STRATEGY

inherit
	PS_EIFFELSTORE_EXPORT

feature {PS_EIFFELSTORE_EXPORT} -- CRUD operations

	retrieve_an_object (query: PS_QUERY [ANY]; metadata: PS_METADATA; transaction: PS_TRANSACTION): detachable HASH_TABLE [STRING, STRING] --attribute name is the hash key
			-- Retrieves an object in a query. It will remember the query and return the next object that matches the criteria
			-- If not possible to compile to SQL completely (agents...), it will just do a "best effort" compile and might return some that don't fit.
			-- It will return void if there are no more objects.
			-- The function will also search for descendants of the class denoted in the generic argument of PS_QUERY (not ANY, the actual type...)
		deferred
		end

	insert (object: HASH_TABLE [STRING, STRING]; metadata: PS_METADATA; transaction: PS_TRANSACTION): INTEGER
			-- Inserts `object' into `database' and returns the primary key of the newly inserted object.
			-- In hashtable `object' everey referenced item needs to have the correct foreign key
		deferred
		end

	update (object: ARRAY [PS_PAIR [STRING, STRING]]; metadata: PS_METADATA; transaction: PS_TRANSACTION)
			-- Updates `object' in the database. `Object' is assumed to have the correct primary key, and the name/value pairs to be updated
		deferred
		end

	delete (object: ARRAY [PS_PAIR [STRING, STRING]]; metadata: PS_METADATA; transaction: PS_TRANSACTION)
			-- Delete `object', identified by the primary key in the hashtable, from the database
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Database access

	database: detachable MYSQLI_CLIENT

	set_database (a_client: MYSQLI_CLIENT)
		do
			database := a_client
		end

end
