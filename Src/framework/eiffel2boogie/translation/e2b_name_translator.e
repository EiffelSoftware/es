note
	description: "Translator to map Eiffel names to Boogie names."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_NAME_TRANSLATOR

inherit

	SHARED_WORKBENCH
		export {NONE} all end

feature -- Access

	boogie_name_for_feature (a_feature: FEATURE_I; a_context_type: TYPE_A): STRING
			-- Name for feature `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		local
			l_type_name: STRING
			l_feature_name: STRING
		do
			l_type_name := boogie_name_for_type (a_context_type)
			l_feature_name := a_feature.feature_name_32.as_lower
			Result := l_type_name + "." + l_feature_name
		ensure
			result_attached: attached Result
			result_valid: is_valid_feature_name (Result)
		end

	boogie_name_for_creation_routine (a_feature: FEATURE_I; a_context_type: TYPE_A): STRING
			-- Name for feature `a_feature' as a creation routine.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		local
			l_type_name: STRING
			l_feature_name: STRING
		do
			l_type_name := boogie_name_for_type (a_context_type)
			l_feature_name := a_feature.feature_name_32.as_lower
			Result := "create." + l_type_name + "." + l_feature_name
		ensure
			result_attached: attached Result
			result_valid: is_valid_feature_name (Result)
		end

	boogie_name_for_functional_feature (a_feature: FEATURE_I; a_context_type: TYPE_A): STRING
			-- Name for feature `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		local
			l_type_name: STRING
			l_feature_name: STRING
		do
			l_type_name := boogie_name_for_type (a_context_type)
			l_feature_name := a_feature.feature_name_32.as_lower
			Result := "fun." + l_type_name + "." + l_feature_name
		ensure
			result_attached: attached Result
		end

	feature_for_boogie_name (a_name: STRING): FEATURE_I
			-- Feature named `a_name' in Boogie code.
		require
			valid_feature_name: is_valid_feature_name (a_name)
		local
			l_name: STRING
			l_list: LIST [STRING]
			l_type_name: STRING
			l_feature_name: STRING
			l_type: TYPE_A
		do
			if a_name.starts_with ("create.") then
				l_name := a_name.twin
				l_name.remove_head (7)
			else
				l_name := a_name
			end
			if l_name.has ('.') then
				l_list := l_name.split ('.')
				l_type_name := l_list.i_th (1)
				l_feature_name := l_list.i_th (2)
			else
					-- Built in features
				l_type_name := "ANY"
				l_feature_name := l_name
			end
			l_type := type_for_boogie_name (l_type_name)
			Result := l_type.associated_class.feature_named_32 (l_feature_name)
		ensure
			result_attached: attached Result
		end

	boogie_name_for_type (a_type: TYPE_A): STRING
			-- Name for type `a_type'.
		require
			a_type_attached: attached a_type
		local
			l_type: TYPE_A
			i: INTEGER
			l_type_name: STRING
		do
			l_type := a_type.deep_actual_type
			check not l_type.is_like end

			if attached {FORMAL_A} l_type as l_formal then
				Result := "G" + l_formal.position.out
			elseif attached {TUPLE_TYPE_A} l_type then
				Result := "TUPLE"
			elseif attached {GEN_TYPE_A} l_type as l_gen_type then
				Result := l_gen_type.associated_class.name_in_upper.twin
				Result.append ("^")
				from
					i := l_gen_type.generics.lower
				until
					i > l_gen_type.generics.upper
				loop
					l_type_name := boogie_name_for_type (l_gen_type.generics.item (i))
					Result.append (l_type_name)
					if i < l_gen_type.generics.upper then
						Result.append ("#")
					end
					i := i + 1
				end
				Result.append ("^")
			else
				Result := l_type.associated_class.name_in_upper.twin
			end
		ensure
			result_attached: attached Result
			result_valid: is_valid_type_name (Result)
		end

	type_for_boogie_name (a_name: STRING): TYPE_A
			-- Type named `a_name' in Boogie code.
		require
			valid_type_name: is_valid_type_name (a_name)
		local
			l_class_name: STRING
			l_classes: LIST [CLASS_I]
		do
			if a_name.has ('^') then
				l_class_name := a_name.substring (1, a_name.index_of ('^', 1)-1)
					-- TODO: handle generic parameters
			else
				l_class_name := a_name
			end
			l_classes := universe.classes_with_name (l_class_name)
			if not l_classes.is_empty then
				Result := l_classes.first.compiled_class.actual_type
			end
		ensure
			result_attached: attached Result
		end

	precondition_predicate_name (a_feature: FEATURE_I; a_context_type: TYPE_A): STRING
			-- Precondition predicate name for feature `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		do
			Result := "pre." + boogie_name_for_feature (a_feature, a_context_type)
		ensure
			result_attached: attached Result
		end

	postcondition_predicate_name (a_feature: FEATURE_I; a_context_type: TYPE_A): STRING
			-- Postcondition predicate name for feature `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_type_attached: attached a_context_type
		do
			Result := "post." + boogie_name_for_feature (a_feature, a_context_type)
		ensure
			result_attached: attached Result
		end

	boogie_name_for_local (i: INTEGER): STRING
			-- Name for local with index `i'.
		require
			i_valid: i > 0
		do
			Result := "local" + i.out
		ensure
			result_attached: attached Result
		end

feature -- Status report

	is_valid_feature_name (a_name: STRING): BOOLEAN
			-- Can `a_name' be mapped to an Eiffel feature?
		do
				-- TODO: implement
			Result := True
		end

	is_valid_type_name (a_name: STRING): BOOLEAN
			-- Can `a_name' be mapped to an Eiffel type?
		do
				-- TODO: implement
			Result := True
		end

end
