note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_TRANSLATION_UNIT

feature -- Access

	id: STRING
			-- Unique ID of this translation unit.
		deferred
		end

feature -- Basic operations

	translate
			-- Translate this unit.
		deferred
		end

feature {NONE} -- Helper functions

	type_id (a_type: TYPE_A): STRING
			-- Id for type `a_type'.
		local
			l_type: TYPE_A
			i: INTEGER
		do
			l_type := a_type.deep_actual_type
			check not l_type.is_like end

			if attached {FORMAL_A} l_type as l_formal then
				Result := "G" + l_formal.position.out
			elseif attached {GEN_TYPE_A} l_type as l_gen_type then
				Result := l_gen_type.associated_class.name_in_upper.twin
				Result.append ("^")
				from
					i := l_gen_type.generics.lower
				until
					i > l_gen_type.generics.upper
				loop
					Result.append (type_id (l_gen_type.generics.i_th (i)))
					if i < l_gen_type.generics.upper then
						Result.append ("#")
					end
					i := i + 1
				end
				Result.append ("^")
			else
				Result := l_type.associated_class.name_in_upper.twin
			end
		end

	feature_id (a_feature: FEATURE_I): STRING
			-- Id for feature `a_feature'.
		do
			Result := a_feature.feature_name_32.as_string_8
-- TODO: use body index to account for renaming
--			Result := "f-body-" + a_feature.body_index.out
		end

invariant
	id_attached: attached id
	id_valid: not id.is_empty

end
