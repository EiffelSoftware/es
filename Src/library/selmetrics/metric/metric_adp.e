class
	METRIC_ADP

inherit
	METRIC
	redefine
		make,
		evaluate,
		last_result,
		debug_output,
		process_class,
		process_group
	end

	QL_UTILITY

	METRIC_UTILITY

	QL_SHARED

	SHARED_SERVER

	METRIC_GRAPH_NODE_VISITOR
	redefine
		process_node
	end

create
	make

feature -- Creation

	make (an_item : QL_ITEM) is
		do
			ql_item := an_item
		end

feature -- Evaluation

	evaluate is
		do
			-- reset metric
			create dependency_graph.make
			create processed_classes.make ({INTEGER}.max_value)
			create cycle_involved_packages.make ({INTEGER}.max_value)
			create start_node.make (ql_item.name)
			dependency_graph.add_node (start_node)
			processed_classes.compare_objects
			cycle_involved_packages.compare_objects

			number_of_dependencies := 0
			number_of_cycles := 0
			total_cycle_length := 0

			-- we only process 'ql_item' if it is a group
			if ql_item.is_group then
				-- process the item (build up graph)
				ql_item.process (Current)

				-- now process the dependency graph to count the number
				-- of edges in the graph.
				dependency_graph.traverse (Current)
				dependency_graph.sweep
			end

		end

feature -- Result

	last_result : QL_QUANTITY is
		do
			create Result.make_with_value (adp)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "ADP METRIC%N"
			Result := Result + "start_node: %T%T"+start_node.id+"%N"
			Result := Result + "number of cycles:%T"+number_of_cycles.out+"%N"
			Result := Result + "number of edges:%T"+number_of_dependencies.out+"%N"
			Result := Result + "cycle lengths:%T%T"+total_cycle_length.out+"%N%N"
			Result := Result + "ADP:%T%T%T"+adp.out+"%N"
		end

feature {NONE} -- Implementation (node visitor)

	process_node (a_node : METRIC_GRAPH_NODE[ANY]) is
		local
			converted : METRIC_GRAPH_NODE[STRING]
			list : LIST[METRIC_GRAPH_NODE[STRING]]
		do
			-- count the number of edges!
			converted ?= a_node
			list := dependency_graph.outgoing_edges (converted)
			number_of_dependencies := number_of_dependencies + list.count

			-- uncomment to debug
--			from
--				list.start
--			until
--				list.after
--			loop
--				io.put_string (a_node.id.out+" -> "+list.item.id.out+"%N")
--				list.forth
--			end
		end

feature {NONE} -- Implementation (QL Visitor)

	get_node_from_graph (l_as : CLASS_I) : METRIC_GRAPH_NODE[STRING] is
			-- get the node that represents 'l_as' from the dependency graph or
			-- create it if it does not exist yet.
		local
			ql_group : QL_GROUP
		do
			ql_group ?= ql_item

			if ql_group.is_library then
				Result := dependency_graph.find_node_by_id (l_as.group.target.name)
			else
				Result := dependency_graph.find_node_by_id (l_as.group.name)
			end


			if Result = Void then
				if ql_group.is_library then
					create Result.make (l_as.group.target.name)
				else
					create Result.make (l_as.group.name)
				end
				dependency_graph.add_node (Result)
			end
		end

	calculate_dependencies_for_class (l_as: QL_CLASS; path_length: INTEGER) is
			-- this calculates all the forward dependencies of class 'l_as'. 'path_length'
			-- is the length of the path we traversed so far to reach 'l_as' in our
			-- dependency graph. if we find a circle, 'path_length' would be the length
			-- of the circle.
		local
			node : METRIC_GRAPH_NODE[STRING]
			other_node : METRIC_GRAPH_NODE[STRING]
			list : LIST[CLASS_I]
			tmp : LIST[CLASS_I]
		do
			-- get node for 'l_as'
			node := get_node_from_graph (l_as.class_i)

			-- this will construct the transitive hull of the forward dependencies
			-- of the package where 'l_as' is in. a forward dependency is a dependency
			-- that 'l_as' has (so either it uses some class in another package
			-- or it inherits from some class in another package).
			create {LINKED_LIST[CLASS_I]}list.make
			list.compare_objects
			tmp := supplier_classes (l_as)
			list.append (tmp)
			tmp := parent_classes (l_as)
			list.append (tmp)

			from
				list.start
			until
				list.after
			loop
				other_node := get_node_from_graph (list.item)

				if other_node /= node then
					dependency_graph.add_edge (node, other_node)

					-- if we wan't to establish an edge between the current processed
					-- node and the 'start_node' then we know we have found a circle
					-- in our forward dependency graph.
					if other_node = start_node and not cycle_involved_packages.has (node.id) then
						cycle_involved_packages.extend (node.id, node.id)
						number_of_cycles := number_of_cycles + 1
						total_cycle_length := total_cycle_length + path_length
					end

					-- process the class to find all it's forward dependencies.
					if not processed_classes.has (list.item) then
						processed_classes.extend (list.item, list.item)
						calculate_dependencies_for_class (query_class_item_from_class_i (list.item), path_length + 1)
					end
				end

				list.forth
			end
		end

	process_class (l_as: QL_CLASS) is
		do
			calculate_dependencies_for_class (l_as, 1)
		end

	process_group (l_as: QL_GROUP) is
		do
			process_classes_in_group (l_as)
		end

feature {NONE} -- Properties

	ql_item : QL_ITEM

	start_node : METRIC_GRAPH_NODE[STRING]
		-- this saves the node for which we built the dependency
		-- graph of. this means in this node, stands the name
		-- of the package given in 'ql_item'

	dependency_graph : METRIC_GRAPH[STRING]
		-- stores the dependency graph

	processed_classes : HASH_TABLE[CLASS_I, CLASS_I]
		-- we use a recursion to process all classes in packages
		-- so we have to know which one we parsed so far so we don't
		-- parse them twice and run into an endless loop

	cycle_involved_packages : HASH_TABLE[STRING, STRING]
		-- this stores a list of all packages that construct the cycle (ie. the
		-- last package before we run into 'start_node' in our dependency tree).
		-- we need this to avoid double reporting of cycles.

	number_of_dependencies : DOUBLE
		-- counts the number of total dependencies in the graph. thus
		-- the number of edges in the graph.

	number_of_cycles : DOUBLE
		-- this counts the number of found cycles in the graph

	total_cycle_length : DOUBLE
		-- this counts the number of edges in the graph that are used
		-- in a cycle

	adp : DOUBLE is
			-- calculates the ADP number. this is a percentual number of
			-- how many dependencies in the graph form a circle.
			--
			-- 0 means there are no circles
			-- 1 means there are only circles
		do
			if number_of_dependencies = 0 then
				Result := 0
			else
				Result := total_cycle_length / number_of_dependencies
			end
		end

invariant
	ql_item_set : ql_item /= Void

end
