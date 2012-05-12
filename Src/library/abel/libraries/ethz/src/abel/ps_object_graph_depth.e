note
	description: "This class collects information about the object graph depth strategy for objects."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

	documentation:
	"[
		Documentation of the object graph depth concept:
			For each operation on a repository the object has a certain object graph depth. The depth indicates how much of an object should be loaded.
			
			A depth of 1 for example means that only the basic types of an object (Numbers, Booleans and Strings)
			should be loaded/inserted/updated, but no referenced object. A depth of 2 means that, additionally to the basic types,
			all referenced objects  should be loaded/stored as if the repository operation has been called on them with 
			object graph depth 1 (you can already see how to continue this for higher numbers...)
			
			There are two special values for the depth: Object_graph_depth_infinite means that an object has to be loaded completely,
			i.e. that there are no more Void references. Object_graph_depth_repository means that the operation should use the global
			object graph depth defined in the Repository. Obviously, this cannot be set as a global value in a repository.
			
			The system's default values are Object_graph_depth_infinite for inserting and reading objects, and a depth of 1 for
			updates and deletions. These default values can be overwritten for a whole repository in the correpsonding instance of 
			PS_REPOSITORY or separately in each CLASS_MANAGER object.
			
			Note: On some repositories the actual object graph depth will be ignored, and it will always use Object_graph_depth_infinite
			instead. The reason is that some backends are faster with this option.
	]"

class
	PS_OBJECT_GRAPH_DEPTH

create
	make_rely_on_repository, make_default

feature -- Query settings

	query_depth: INTEGER
			-- object graph depth for queries, or reading objects in general

feature -- Insert settings

	insert_depth: INTEGER
			-- object graph depth for inserts


	is_update_during_insert_enabled:BOOLEAN = False
			-- Should an object be updated, if it is already in the database and it is referenced by a new object?


	custom_update_depth_during_insert:INTEGER
			-- The object graph depth that should be applied for an update to an object, which is found during insert and is already in the database.
		do
			Result:=update_depth
		end


feature -- Update settings

	update_depth: INTEGER
			-- object graph depth for updates
			-- Updates are somewhat special: For depth 1, the system will look at references and update them if they point to another object than before, but it will not
			-- call update on the referenced object. In addition, if an update operation finds a new (= not previously loaded) object,
			-- it will insert it with the insertion depth defined globally in the repository (usually Object_graph_depth_infinite)

	update_last_references:BOOLEAN = True
			-- Should the last (Depth = 1) references be updated?
			-- Note: This only covers the references (-> foreign keys) to objects, not the referenced object itself.


	is_insert_during_update_enabled:BOOLEAN = True
			-- Should the system automatically insert objects which are not present in the database and found during an update?


	custom_insert_depth_during_update:INTEGER
			-- The object graph depth that should be applied for an insert to an object, which is found during update but isn't yet in the database.	
		do
			Result:=insert_depth
		end

	throw_error_for_unknown_objects:BOOLEAN
			-- If a new object is found an (is_insert_during_update_enabled = False), should an error be thrown for a new object?
			-- Otherwise the reference is set to 0
		require
			no_automatic_insert: not is_insert_during_update_enabled
		do
			Result:= false
		end


feature -- Deletion settings

	deletion_depth: INTEGER
			-- Object graph depth for deletion

feature -- Modification

	set_query_depth (depth: INTEGER)
			-- Change the object graph depth for queries
		require
			depth_in_range: depth >= -1
		do
			query_depth := depth
		end

	set_insert_depth (depth: INTEGER)
			-- Change the object graph depth for insertion
		require
			depth_in_range: depth >= -1
		do
			insert_depth := depth
		end

	set_update_depth (depth: INTEGER)
			-- Change the object graph depth for updates
		require
			depth_in_range: depth >= -1
		do
			update_depth := depth
		end

	set_deletion_depth (depth: INTEGER)
			-- Change the object graph depth for deletion
		require
			depth_in_range: depth >= -1
		do
			deletion_depth := depth
		end

feature -- Status

	is_relying_on_repository: BOOLEAN
			-- Is an object graph depth set to Object_graph_depth_repository?
		do
			Result := query_depth >= 0 and insert_depth >= 0 and update_depth >= 0 and deletion_depth >= 0
		end

feature -- Creation

	make_rely_on_repository
			-- Create a new OBJECT_GRAPH_DEPTH object which relies on values in PS_REPOSITORY
		do
			query_depth := Object_graph_depth_repository
			insert_depth := Object_graph_depth_repository
			update_depth := Object_graph_depth_repository
			deletion_depth := Object_graph_depth_repository
		end

	make_default
			-- Create a new OBJECT_GRAPH_DEPTH object with our system's default values
		do
			query_depth := Object_graph_depth_infinite
			insert_depth := Object_graph_depth_infinite
			update_depth := 1
			deletion_depth := 1
		end

feature -- Constants

	Object_graph_depth_repository: INTEGER = -1
			-- Rely on the global repository value.

	Object_graph_depth_infinite: INTEGER = 0
	-- Load/store full object

invariant
	valid_range: query_depth >= -1 and insert_depth >= -1 and update_depth >= -1 and deletion_depth >= -1

end
