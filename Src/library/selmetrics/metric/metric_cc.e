class
	METRIC_CC

inherit
	METRIC
	redefine
		make,
		evaluate,
		last_result,
		debug_output,
		process_class,
		process_real_feature,
		process_group
	end

	QL_UTILITY

	METRIC_UTILITY

	QL_SHARED

	SHARED_SERVER

	AST_ITERATOR
	redefine
		process_if_as,
		process_loop_as,
		process_inspect_as
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
			-- reset counter
			cc := 0

			-- process the item
			ql_item.process (Current)
		end

feature -- Result

	last_result : QL_QUANTITY is
		do
			create Result.make_with_value (cc)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "CC METRIC%N"
			Result := Result + "complexity:%T"+cc.out+"%N"
		end

feature {NONE} -- Implementation (QL iterator)

	process_real_feature (l_as : QL_REAL_FEATURE) is
		local
			feature_i : FEATURE_I
		do
			feature_i := l_as.e_feature.associated_feature_i
			class_id := feature_i.access_class.class_id

			cc := cc + 1
			safe_process (feature_i.body)
		end

	process_class (l_as : QL_CLASS) is
		do
			-- process all features in the given class
			process_real_features_in_class (l_as)
		end

	process_group (l_as : QL_GROUP) is
		do
			-- process all classes in the given cluster
			process_classes_in_group (l_as)
		end

feature {NONE} -- Implementation (AST iterator)

	match_list : LEAF_AS_LIST is
		do
			Result := match_list_server.item(class_id)
		end

	iterate_list (list : LIST[AST_EIFFEL]) is
			-- iterate through a list of AST nodes and process them
		do
			from
				list.start
			until
				list.after
			loop
				safe_process (list.item)
				list.forth
			end
		end

	process_if_as (l_as: IF_AS) is
		do
			-- we add 1 for the if statement to the cyclomatic complexity
			-- as well as an arbitrary number of 'elseif' statements. the
			-- else statement is not counted (but processed), since it does
			-- not add any node in the CFG (the statements of else are attached
			-- to the 'false' edge of the corresponding if)
			cc := cc + 1

			-- process the compound of the if statement
			if l_as.compound /= Void then
				iterate_list (l_as.compound)
			end

			-- add all elseif statements
			if l_as.elsif_list /= Void then
				cc := cc + l_as.elsif_list.count
				iterate_list (l_as.elsif_list)
			end

			-- add all else statements
			if l_as.else_part /= Void then
				iterate_list (l_as.else_part)
			end
		end

	process_loop_as (l_as: LOOP_AS) is
		do
			-- the loop always adds 1 to the Cyclomatic Complexity as
			-- there's no 'else' statement or the like
			cc := cc + 1

			-- process the compound
			if l_as.compound /= Void then
				iterate_list (l_as.compound)
			end
		end

	process_inspect_as (l_as: INSPECT_AS) is
		do
			if l_as.case_list /= Void then
				-- add the number of case's to the Cyclomatic Complexity
				cc := cc + l_as.case_list.count
				iterate_list (l_as.case_list)

				if l_as.else_part /= Void then
					iterate_list (l_as.else_part)
				end
			end
		end


feature {NONE} -- Properties

	ql_item : QL_ITEM

	class_id : INTEGER
		-- the id of the class we are currently evaluating

	cc : DOUBLE
		-- the counter that counts the cyclomatic complexity

invariant
	ql_item_set: ql_item /= Void

end
