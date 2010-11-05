note
	description: "Summary description for {SSA_SHAREd}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_SHARED

feature
	class_c: CLASS_C
		once
			Result := class_
		end

	feature_i: FEATURE_I
		once
			Result := feature_
		end

	feature_name: STRING
		once
			Result := feature_i.feature_name_32
		end

	temp_count: INTEGER_32_REF
		once
			create Result
			Result.set_item (0)
		end

	get_count: INTEGER
		do
			Result := temp_count.item
			temp_count.set_item (Result + 1)
		end

	set_class (a_c: CLASS_C)
		require
			nonvoid: attached a_c
		do
			class_ := a_c
			class_c.do_nothing
		end

	set_feature (a_f: FEATURE_I)
		require
			nonvoid: attached a_f
		do
			feature_ := a_f
			feature_i.do_nothing
		end

feature {NONE}
	class_: CLASS_C
	feature_: FEATURE_I

end
