class
	METRIC_ABSTRACTION

inherit
	METRIC
	redefine
		make,
		evaluate,
		last_result,
		debug_output,
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
			-- process the item
			ql_item.process (Current)
		end

feature -- Result

	last_result : QL_QUANTITY is
		do
			create Result.make_with_value (abstraction)
		end

feature -- Debug

	debug_output : STRING is
		do
			Result := "ABSTRACTION METRIC%N"
			Result := Result + "Na:%T"+Na.out+"%N"
			Result := Result + "Nc:%T"+Nc.out+"%N%N"
			Result := Result + "abstraction:%T"+abstraction.out+"%N"
		end

feature {NONE} -- Implementation (QL Visitor)

	process_group (l_as: QL_GROUP) is
		do
			Na := abstract_classes_of_group (l_as).count
			Nc := classes_of_group (l_as).count
		end

feature {NONE} -- Implementation (Result)

	abstraction : DOUBLE is
		do
			if Nc = 0 then
				Result := 0
			else
				Result := Na / Nc
			end
		end


feature {NONE} -- Properties

	ql_item : QL_ITEM

	Na : DOUBLE
		-- number of abstract classes in group

	Nc : DOUBLE
		-- total number of classes in group

invariant
	ql_item_set: ql_item /= Void

end
