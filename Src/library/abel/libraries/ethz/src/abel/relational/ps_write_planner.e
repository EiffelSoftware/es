note
	description: "This class breaks cycles in the DB operation object graph and generates a totally ordered list of operations to be performed by the database backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_WRITE_PLANNER

create make

feature


	generate_plan (dependency_graph: PS_OBJECT_GRAPH_PART) : LIST[PS_OBJECT_GRAPH_PART]
			-- Generate the plan
		local
			dependencies_to_remove:LIST[ANY]
		do
			roots.extend(dependency_graph)

			-- todo: first find all relational collections and break their parents dependency / add them to roots
			across dependency_graph as graph_cursor
			loop
				if attached{PS_COLLECTION_PART} graph_cursor.item as collection and then collection.is_in_relational_mode then
	--				graph_cursor.previous.remove_dependency (graph_cursor.item)
	--				roots.extend (graph_cursor.item)
				end
			end


			from roots.start
			until roots.after
			loop
				break_cycles (roots.item)
			end


			Result:= topological_sort
			remove_noops (Result)

		end




	break_cycles (node:PS_OBJECT_GRAPH_PART)
		-- search and break cycles using a depth-first search
		do
			-- if node.is_visited
				-- we found a cycle  - break it
			-- elseif node.is_clean
				-- guaranteed to have no cycle - retreat
			--else
				-- node.mark_as_visited
				-- across dependencies as child loop
					-- if child.is_visited then remove_dependency (node, child)
					-- elseif not child.is_clean then break_cycles (child)
					-- end
				-- node.unmark_as_visited
				-- node.mark_as_clean
			--end



		end

	--trace: STACK[PS_ABSTRACT_DB_OPERATION]

	roots:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- A list of operations that no other operation depends on.






	remove_depencency (node, dependency:PS_OBJECT_GRAPH_PART)
		-- Removes a depencency by changing a dependency to SET_NULL and adding an appropriate UPDATE statement in the roots list
		do
			-- node.set_dependency_to_0 (dependency)
			-- if node.is_collection
				-- roots.extend (create {COLLECTION_ADD_ENTRY}.make (node, dependency)
			-- else
				-- roots.extend (create {PS_WRITE_OPERATION}.make_with_mode (node, collection)
				-- roots.last.references.extend (attr_name, dependency)
			--end
		end

	topological_sort:LIST[PS_OBJECT_GRAPH_PART]
		-- topologically sorts the items in the roots list (reversing the structure - objects with no dependency are now at the front.)
		do
			create {LINKED_LIST[PS_OBJECT_GRAPH_PART]} Result.make
		end

	remove_noops (a_plan:LIST [PS_OBJECT_GRAPH_PART])
		-- remove all "no-ops" (poid_only, set_null, or errors) from the list
		do
			from a_plan.start
			until a_plan.after
			loop

				a_plan.forth
			end
		end


feature {NONE} -- Initialization

	make
		do
			create roots.make
		--	create {LINKED_STACK[PS_ABSTRACT_DB_OPERATION]} trace.make
		end


end
