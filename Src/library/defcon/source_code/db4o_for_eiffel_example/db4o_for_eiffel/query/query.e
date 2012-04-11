indexing
	description: "db4o query wrapper to handle field name translation and SODA Query constraints"
	author: "Carl Rosenberger, Ruihua Jin"
	date: "$Date: 2008/01/08 15:51:07$"
	revision: "$Revision: 2.0$"

class
	QUERY

inherit
	INTERNAL
	ATTRIBUTE_NAME_HELPER

create
	make, make_extent, make_from_query


feature {NONE}  -- Initialization

	make (oc: IOBJECT_CONTAINER) is
			-- Initialize with `oc'.
		require
			oc_not_void: oc /= Void
		do
			make_from_query (oc.query)
		end

	make_extent (oc: IOBJECT_CONTAINER; ext: SYSTEM_TYPE) is
			-- Initialize with `oc' and `ext'.
		require
			oc_not_void: oc /= Void
			extent_not_void: ext /= Void
		local
			c: CONSTRAINT
		do
			make (oc)
			c := constrain (ext)
		end

	make_from_query (q: IQUERY) is
			-- Initialize with `q'.
		require
			q_not_void: q /= Void
		do
			executed := false
			query := q
		end


feature	-- Use

	order_descending: QUERY is
			-- Add a descending order criteria to this node of the query graph and
			-- return `Current' to allow the chaining of method calls.
		require
			not_executed: not executed
		do
			query := query.order_descending
			Result := Current
		end

	order_ascending: QUERY is
			-- Add an ascending order criteria to this node of the query graph and
			-- return `Current' to allow the chaining of method calls.
		require
			not_executed: not executed
		do
			query := query.order_ascending
			Result := Current
		end

	execute: IOBJECT_SET is
			-- Execute `query' and return the result of `query'.
		require
			not_executed: not executed
		do
			executed := true
			Result := query.execute
		end

	descend (eiffel_fieldname: SYSTEM_STRING; extenttype: SYSTEM_TYPE): QUERY is
			-- A reference to a descendant node of `eiffel_fieldname' in the query graph
		require
			not_executed: not executed
			fieldname_not_empty: not {SYSTEM_STRING}.is_null_or_empty (eiffel_fieldname)
			extenttype_not_void: extenttype /= Void
		local
			sub_node: IQUERY
			netname: SYSTEM_STRING
			all_names: LINKED_LIST[SYSTEM_STRING]
		do
			netname := get_net_field_name (eiffel_fieldname, extenttype)
			sub_node := query.descend (netname)
			create Result.make_from_query (sub_node)
			all_names := get_all_field_names (netname, extenttype)
			Result.set_names (all_names)
			Result.set_parent (Current)
			Result.set_class_extent (extenttype)
			if (children = Void) then
				create children.make
			end
			children.extend (Result)
		end

	constraints: ICONSTRAINTS is
			-- An `ICONSTRAINTS' object that holds an array of all constraints on this node.
		require
			not_executed: not executed
		do
			Result := query.constraints
		end

	constrain (constraint: SYSTEM_OBJECT): CONSTRAINT is
			-- Add `constraint' to `Current' node and
			-- return a new `CONSTRAINT' for this query node or
			-- `Void' for objects implementing the `IEVALUATION' interface.
		require
			constraint_not_void: constraint /= Void
			not_executed: not executed
		local
			type: TYPE[SYSTEM_OBJECT]
			con: SYSTEM_OBJECT
			querycon: ICONSTRAINT
			nodecon: ICONSTRAINT
			or_queries: LINKED_LIST[IQUERY]
			extra_constraints: LINKED_LIST[ICONSTRAINT]
		do
			type ?= constraint
			if (type = Void) then
				con := constraint
			else
				con := type.to_cil
			end
			querycon := query.constrain (con)
			create Result.make (querycon)
			if (parent /= Void) then
				or_queries := get_or_queries
				if (or_queries /= Void and then or_queries.count > 0) then
					create extra_constraints.make
					from
						or_queries.start
						or_queries.forth   -- or_queries.first = querycon
					until
						or_queries.after
					loop
						nodecon := or_queries.item.constrain (con)
						querycon := querycon.or_ (nodecon)
						extra_constraints.extend (nodecon)
						or_queries.forth
					end
					Result.set_descendant_constraints (extra_constraints)
				end
			end
		end

	sort_by (comparator: IQUERY_COMPARATOR): QUERY is
			-- Sort the resulting `IOBJECT_SET' by `comparator' and
			-- return `Current' to allow the chaining of method calls.
		require
			not_executed: not executed
			comparator_not_void: comparator /= Void
		do
			query := query.sort_by (comparator)
			Result := Current
		end

feature  -- Access

	query: IQUERY
			-- The actual db4o query object

	executed: BOOLEAN
			-- Is `query' already executed?


feature {QUERY}  -- Implementation and access to related query nodes for ancestor and descendant classes

	class_extent: SYSTEM_TYPE
			-- Class extent of `Current'

	children: LINKED_LIST[QUERY]
			-- Child queries of `Current'			

	parent: QUERY
			-- Parent query			

	set_parent (p: QUERY) is
			-- Set `parent' to `p'.
		require
			p_not_void: p /= Void
		do
			parent := p
		end

	set_class_extent (ext: SYSTEM_TYPE) is
			-- Set `class_extent' to `ext'.
		require
			extent_not_void: ext /= Void
		do
			class_extent := ext
		end

	names: LINKED_LIST[SYSTEM_STRING]
			-- All names of the query node

	set_names (n: LINKED_LIST[SYSTEM_STRING]) is
			-- Set `names' to `n'.
		require
			n_not_empty: n /= Void and n.count > 0
		do
			names := n
		end

	get_or_queries: LINKED_LIST[IQUERY] is
			-- All `IQUERY's made from `parent.names' (recursively) and `names'
		require
			parent_not_void: parent /= Void
		local
			parent_query: QUERY
			subquery: QUERY
			queries: LINKED_LIST[QUERY]
			nodes: LINKED_LIST[IQUERY]
			topquery: QUERY
		do
			create queries.make
			queries.extend (Current)
			from
				parent_query := parent
			until
				parent_query = Void
			loop
				queries.extend (parent_query)
				parent_query := parent_query.parent
			end
			topquery := queries.last
			create nodes.make
			nodes.extend (topquery.query)
			queries.prune (topquery)
			from
				queries.finish
			until
				queries.before
			loop
				subquery := queries.item
				nodes := subquery.descend_names (nodes)
				queries.back
			end
			Result := nodes
		ensure
			Result_not_empty: Result /= Void and Result.count > 0
		end

	descend_names (nodes: LINKED_LIST[IQUERY]): LINKED_LIST[IQUERY] is
			-- Descend `names' from `nodes'.
		require
			nodes_not_empty: nodes /= Void and nodes.count > 0
			parent_not_void: parent /= Void
		local
			q: IQUERY
			n: SYSTEM_STRING
		do
			create Result.make
			from
				names.start
			until
				names.after
			loop
				n := names.item
				from
					nodes.start
				until
					nodes.after
				loop
					q := nodes.item
					Result.extend (q.descend (n))
					nodes.forth
				end
				names.forth
			end
		ensure
			Result_not_empty: Result /= Void and Result.count > 0
		end

feature  -- Indexing

	optimize (config: ICONFIGURATION) is
			-- Optimize `Current' and `children' recursively
			-- by setting index for fields involved.
		local
			configuration: CONFIGURATION
		do
			create configuration.make (config)
			if (class_extent /= Void and then names /= Void) then
				configuration.object_class (class_extent).object_field (names.first).indexed (True)
			end
			if (children /= Void) then
				from
					children.start
				until
					children.after
				loop
					children.item.optimize (config)
					children.forth
				end
			end
		end

invariant
	query_not_void: query /= Void
	parent_implies_names: parent /= Void implies names /= Void
	no_empty_names: names /= Void implies names.count > 0
	no_empty_children: children /= Void implies children.count > 0

end
