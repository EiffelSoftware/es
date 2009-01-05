indexing
	description:
		"[
			TODO: rename class, maybe merge with EP_NAME_MAPPER
			Generator for default names
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_DEFAULT_NAMES

feature -- Access

	attribute_name (a_feature: !FEATURE_I): STRING
			-- Name of attribute `a_feature' as used in Boogie code
		require
			is_attribute: a_feature.is_attribute
		local
			l_class_name: STRING
		do
			l_class_name := a_feature.written_class.name_in_upper
			Result := "field." + l_class_name + "." + mangled_feature_name (a_feature)
		end

	functional_feature_name (a_feature: !FEATURE_I): STRING
			-- Functional name of `a_feature' as used in Boogie code
		local
			l_class_name: STRING
		do
			l_class_name := a_feature.written_class.name_in_upper
			Result := "fun." + l_class_name + "." + mangled_feature_name (a_feature)
		end

	procedural_feature_name (a_feature: !FEATURE_I): STRING
			-- Procedural name of `a_feature' as used in Boogie code
		local
			l_class_name: STRING
		do
			l_class_name := a_feature.written_class.name_in_upper
			Result := "proc." + l_class_name + "." + mangled_feature_name (a_feature)
		end

	creation_routine_name (a_feature: !FEATURE_I): STRING
			-- Name of creation routine `a_feature' as used in Boogie code
		local
			l_class_name: STRING
		do
			l_class_name := a_feature.written_class.name_in_upper
			Result := "create." + l_class_name + "." + mangled_feature_name (a_feature)
		end

	argument_name (a_name: STRING): STRING
			-- Name of an argument as used in Boogie code
		do
			Result := "arg." + a_name
		end

	local_name (a_index: INTEGER): STRING
			-- Name of local as used in Boogie code
		do
			Result := "local" + a_index.out
		end

	feature_name_for_mangled_operator (a_operator: STRING): STRING
			-- Name of Eiffel feature of mangled operator
		local
			l_op: STRING
		do
			from
				Result := ""
				mangled_operator_names.start
			until
				mangled_operator_names.after or not Result.is_empty
			loop
				if mangled_operator_names.item_for_iteration.is_equal (a_operator) then
					l_op := mangled_operator_names.key_for_iteration
					if l_op.starts_with ("infix$") then
						Result := "infix %"" + l_op.substring (7, l_op.count) + "%""
					else
						check l_op.starts_with ("prefix$") end
						Result := "prefix %"" + l_op.substring (8, l_op.count) + "%""
					end
				end
				mangled_operator_names.forth
			end
		end

feature {NONE} -- Implementation

	mangled_feature_name (a_feature: !FEATURE_I): STRING
			-- Mangled feature name of `a_feature'
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if a_feature.is_infix then
				Result := mangled_operator_name ("infix", l_name.substring (8, l_name.count-1))
			elseif a_feature.is_prefix then
				Result := mangled_operator_name ("prefix", l_name.substring (9, l_name.count-1))
			else
				Result := l_name
			end
		end

	mangled_operator_name (a_type, a_operator: STRING): STRING is
			-- Mangled name of operator `a_operator'
		require
			not_empty: not a_operator.is_empty
		local
			l_key: STRING
		do
			l_key := a_type + "$" + a_operator
			if mangled_operator_names.has_key (l_key) then
				Result := mangled_operator_names.item (l_key)
			else
					-- Free operator, create a unique name
				Result := a_type + "$" + mangled_operator_names.count.out
				mangled_operator_names.put (Result, l_key)
			end
		ensure
			not_void: Result /= Void
		end

-- TODO: move this into "default_operator_names"
	mangled_operator_names: HASH_TABLE [STRING, STRING] is
			-- Mangled names for default operators
		once
			create Result.make(19)
			Result.compare_objects
--			Result.put ("op$not", "not")
--			Result.put ("op$plus", "+")
--			Result.put ("op$minus", "-")
--			Result.put ("op$mult", "*")
--			Result.put ("op$div", "/")
--			Result.put ("op$less", "<")
--			Result.put ("op$more", ">")
--			Result.put ("op$leq", "<=")
--			Result.put ("op$meq", ">=")
--			Result.put ("op$divdiv", "//")
--			Result.put ("op$vidvid", "\\")
--			Result.put ("op$hat", "^")
--			Result.put ("op$and", "and")
--			Result.put ("op$or", "or")
--			Result.put ("op$xor", "xor")
--			Result.put ("op$andthen", "and then")
--			Result.put ("op$orelse", "or else")
--			Result.put ("op$implies", "implies")
		end

end
