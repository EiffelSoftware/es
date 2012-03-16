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

feature -- Access

	query_depth: INTEGER
			-- object graph depth for queries, or reading objects in general

	insert_depth: INTEGER
			-- object graph depth for inserts

	update_depth: INTEGER
			-- object graph depth for updates
			-- Updates are somewhat special: For depth 1, the system will look at references and update them if they point to another object than before, but it will not
			-- call update on the referenced object. In addition, if an update operation finds a new (= not previously loaded) object,
			-- it will insert it with the insertion depth defined globally in the repository (usually Object_graph_depth_infinite)

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
