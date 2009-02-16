class
	METRIC_INSTABILITY

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
			-- reset state
			create {LINKED_LIST[CLASS_I]}client_list.make
			create {LINKED_LIST[CLASS_I]}supplier_list.make

			client_list.compare_objects
			supplier_list.compare_objects

			-- process the item
			ql_item.process (Current)
		end

feature -- Result

	last_result : QL_QUANTITY is
		do
			create Result.make_with_value (instability)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "INSTABILITY METRIC%N"
			Result := Result + "Ca:%T%T" + Ca.out + "%N"
			Result := Result + "Ce:%T%T" + Ce.out + "%N%N"
			Result := Result + "instability:%T" + instability.out + "%N"
		end

feature {NONE} -- Implementation (QL Visitor)

	is_same_group (orig : CLASS_I; other : QL_CLASS) : BOOLEAN is
		do
			Result := orig.group = other.class_i.group
		end

	process_class (l_as: QL_CLASS) is
		local
			list : LIST[CLASS_I]
		do
			-- add all new clients to client list
			from
				list := client_classes (l_as)
				list.start
			until
				list.after
			loop
				if not is_same_group (list.item, l_as) and not client_list.has (list.item) then
					client_list.extend (list.item)
				end
				list.forth
			end

			-- add all new heir classes to client list
			from
				list := heir_classes (l_as)
				list.start
			until
				list.after
			loop
				if not is_same_group (list.item, l_as) and not client_list.has (list.item) then
					client_list.extend (list.item)
				end
				list.forth
			end

			-- add all new suppliers to supplier list
			from
				list := supplier_classes (l_as)
				list.start
			until
				list.after
			loop
				if not is_same_group (list.item, l_as) and not supplier_list.has (list.item) then
					supplier_list.extend (list.item)
				end
				list.forth
			end

			-- add all new parent classes to supplier list
			from
				list := parent_classes (l_as)
				list.start
			until
				list.after
			loop
				if not is_same_group (list.item, l_as) and not supplier_list.has (list.item) then
					supplier_list.extend (list.item)
				end
				list.forth
			end
		end

	process_group (l_as: QL_GROUP) is
		do
			process_classes_in_group (l_as)
		end

feature {NONE} -- Implementation (Result)

	Ca : DOUBLE is
			-- number of classes outside the package that depend on this package. this means
			-- all classes that have a client relation.
		do
			Result := client_list.count
		end

	Ce : DOUBLE is
			-- number of classes inside the package that depend on classes outside this package.
			-- this means all classes that have a supplier relation.
		do
			Result := supplier_list.count
		end

	instability : DOUBLE is
		do
			if (Ca+Ce) = 0 then
				Result := 0
			else
				Result := Ce / (Ca + Ce)
			end
		end

feature {NONE} -- Properties

	ql_item : QL_ITEM

	client_list : LIST[CLASS_I]
		-- distinct list of all classes that are in a client relation
		-- to the processed classes

	supplier_list : LIST[CLASS_I]
		-- distinct list of all classes that are in a client relation
		-- to the processed classes

invariant
	ql_item_set: ql_item /= Void

end
