indexing
	description: "Project units that represent a cluster. It is a list of sub-units."
	author: "Bernhard S. Buss"
	date: "20.june.2006"
	revision: "$Revision$"

class
	EMU_PROJECT_CLUSTER

inherit
	LINKED_LIST [EMU_PROJECT_UNIT]
		rename
			make as make_list
		export {NONE}
			default_create,
			make_list
		undefine
			copy,
			is_equal
		end

	EMU_PROJECT_UNIT
		undefine
			default_create
		redefine
			make
		end

	ANY
		undefine
			default_create
		end

create
	make


feature -- Creation

	make (a_name: STRING; a_project: EMU_PROJECT; a_creator: EMU_USER) is
			-- create a project cluster by its name and the creator.
		do
			Precursor {EMU_PROJECT_UNIT}(a_name, a_project, a_creator)
			--Precursor {LINKED_LIST}	-- initializes the empty list (inherited).
			make_list
		end


feature -- Modification

	add_class (a_class: EMU_PROJECT_CLASS) is
			-- add a class to the cluster.
		require
			a_class_not_void: a_class /= Void
			class_not_existant: not has_class (a_class.name)
		do
			extend (a_class)
			project.update_persist_storage
		ensure
			class_added: has_class (a_class.name)
		end


feature -- Access

	get_cluster (a_cluster_name: STRING): EMU_PROJECT_CLUSTER is
			-- return the cluster with name 'a_cluster_name'.
			-- requires cluster to exist.
		require
			has_cluster: has_cluster (a_cluster_name)
		do
			Result ?= i_th (index_of_cluster(a_cluster_name))
		ensure
			result_not_void: Result /= Void
		end

	get_class (a_class_name: STRING): EMU_PROJECT_CLASS is
			-- return the class with name 'a_class_name'.
			-- requires class to exist. (or at least unit with that name, then result is void, if not class unit, but cluster unit).
		require
			has_class: has_class (a_class_name)
		do
			Result ?= i_th (index_of_class(a_class_name))
		ensure
			result_not_void: Result /= Void
		end

	get_class_recursive (a_class_name: STRING): EMU_PROJECT_CLASS is
			-- return the class by name going recursively through sub-clusters.
			-- returns Void if class not found.
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
		local
			a_cluster: EMU_PROJECT_CLUSTER
		do
			if has_class (a_class_name) then
				Result := get_class (a_class_name)
			else
				from
					start
				until
					Result /= Void or else after
				loop
					a_cluster ?= item
					if a_cluster /= Void then
						Result := a_cluster.get_class_recursive (a_class_name)
					end
					forth
				end
			end
		end


feature -- Queries

	has_cluster (a_cluster_name: STRING): BOOLEAN is
			-- has this cluster a sub-cluster named 'a_cluster_name' ?
		require
			a_cluster_name_valid: a_cluster_name /= Void and then not a_cluster_name.is_empty
		do
			Result := index_of_cluster(a_cluster_name) >= 0
		end

	has_class (a_class_name: STRING): BOOLEAN is
			-- has this cluster a class named 'a_class_name' ?
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
		do
			Result := index_of_class(a_class_name) >= 0
		end

	index_of_cluster (a_cluster_name: STRING): INTEGER is
			-- get the index of a named cluster. returns -1 if not found.
		require
			a_cluster_name_valid: a_cluster_name /= Void and then not a_cluster_name.is_empty
		local
			a_cluster: EMU_PROJECT_CLUSTER
			found: BOOLEAN
		do
			from
				start
				Result := -1
			until
				after or else found
			loop
				a_cluster ?= item
				if (a_cluster /= Void and then a_cluster.name.is_equal (a_cluster_name)) then
					found := True
					Result := index
				end
				forth
			end
		end

	index_of_class (a_class_name: STRING): INTEGER is
			-- get the index of a named class. returns -1 if not found.
		require
			a_class_name_valid: a_class_name /= Void and then not a_class_name.is_empty
		local
			a_class: EMU_PROJECT_CLASS
			found: BOOLEAN
		do
			from
				start
				Result := -1
			until
				after or else found
			loop
				a_class ?= item
				if (a_class /= Void and then a_class.name.is_equal (a_class_name)) then
					found := True
					Result := index
				end
				forth
			end
		end


end
