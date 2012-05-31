note
	description: "This class breaks cycles in the DB operation object graph and generates a totally ordered list of operations to be performed by the database backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_WRITE_PLANNER

inherit{NONE}
	REFACTORING_HELPER

create make

feature


	generate_plan (dependency_graph: PS_OBJECT_GRAPH_PART) : LIST[PS_OBJECT_GRAPH_PART]
			-- Generate the plan
		local
			dependencies_to_remove:LIST[ANY]
		do

			roots.wipe_out
			sorted_operations.wipe_out
			roots.extend(dependency_graph)

			-- first find all relational collections and break their parents dependency / add them to roots
			across dependency_graph as graph_cursor
			loop
				fixme ("The whole collection planning has to be rethought...")
--				if attached{PS_COLLECTION_PART[ITERABLE[ANY]]} graph_cursor.item as coll and then coll.is_in_relational_mode then
--					graph_cursor.previous.remove_dependency (graph_cursor.item)
--					roots.extend (graph_cursor.item)
--				end
			end


			-- now break all cycles
			fixme ("Is this loop required? At the moment disabled because it will loop infinitely if it's there")
--			from
				roots.start
--			until roots.after
--			loop
				break_cycles (roots.item)
--				roots.forth
--			end
--			check dependency_graph.dependencies.count < 1 end

			-- Do a topological sort and remove no-ops from the list
			topological_sort
			remove_noops (sorted_operations)

			Result:= sorted_operations
			--print (sorted_operations.count.out)
		end




	break_cycles (node:PS_OBJECT_GRAPH_PART)
		-- search and break all cycles
		local
			cursor:PS_OBJECT_GRAPH_CURSOR
		do
			from
				cursor:= node.new_cursor
				cursor.set_handler (agent remove_dependency (?, ?))
			until
				cursor.after
			loop
				cursor.item.set_visited (False) -- prepare for next step
				cursor.forth
			end
		end


	roots:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- A list of operations that no other operation depends on.


	sorted_operations: LINKED_LIST [PS_OBJECT_GRAPH_PART]



	remove_dependency (node, dependency:PS_OBJECT_GRAPH_PART)
		-- Removes a depencency by changing a dependency to SET_NULL and adding an appropriate UPDATE statement in the roots list
		local
			new_update:PS_SINGLE_OBJECT_PART
		do
			if attached {PS_COLLECTION_PART[ITERABLE[ANY]]} node as col then
				roots.extend (col.split (dependency))
			elseif attached {PS_SINGLE_OBJECT_PART} node as obj then

				create new_update.make_with_mode (obj.object_id, obj.write_mode.Update)
				new_update.add_attribute (obj.get_attribute_name (dependency), dependency)
				roots.extend (new_update)
			end

			node.remove_dependency (dependency)


		end

	topological_sort
		-- topologically sorts the items in the roots list (reversing the structure - objects with no dependency are now at the front.)
		do
			across roots as cursor loop visit(cursor.item)  end
		end

	visit (node:PS_OBJECT_GRAPH_PART)
		-- visit a node for topological sorting
		do
			if not node.is_visited then
				node.set_visited (True)

				across node.dependencies as cursor
				loop
					visit (cursor.item)
				end

				sorted_operations.extend(node)
			end
		end

	remove_noops (a_plan: LIST [PS_OBJECT_GRAPH_PART])
		-- remove all "No_operations" from the list
		do
			from a_plan.start
			until a_plan.after
			loop
				if a_plan.item.write_mode = a_plan.item.write_mode.No_operation then
					a_plan.remove
				else
					a_plan.forth
				end
			end
		end


feature {NONE} -- Initialization

	make
		do
			create roots.make
			create sorted_operations.make
		end


end
