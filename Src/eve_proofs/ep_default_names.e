indexing
	description:
		"[
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

feature {NONE} -- Implementation

	mangled_feature_name (a_feature: !FEATURE_I): STRING
			-- Mangled feature name of `a_feature'
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if a_feature.is_infix then
				Result := mangled_operator_name (l_name.substring (8, l_name.count-1))
			elseif a_feature.is_prefix then
				Result := mangled_operator_name (l_name.substring (9, l_name.count-1))
			else
				Result := l_name
			end
		end

	mangled_operator_name (a_operator: STRING): STRING is
			-- Mangled name of operator `a_operator'
		require
			not_empty: not a_operator.is_empty
		do
			if mangled_operator_names.has_key (a_operator) then
				Result := mangled_operator_names.item (a_operator)
			else
					-- Free operator, create a unique name
				Result := "op$" + mangled_operator_names.count.out
				mangled_operator_names.put (Result, a_operator)
			end
		ensure
			not_void: Result /= Void
		end

	mangled_operator_names: HASH_TABLE [STRING, STRING] is
			-- Mangled names for default operators
		once
			create Result.make(19)
			Result.compare_objects
			Result.put ("op$not", "not")
			Result.put ("op$plus", "+")
			Result.put ("op$minus", "-")
			Result.put ("op$mult", "*")
			Result.put ("op$div", "/")
			Result.put ("op$less", "<")
			Result.put ("op$more", ">")
			Result.put ("op$leq", "<=")
			Result.put ("op$meq", ">=")
			Result.put ("op$divdiv", "//")
			Result.put ("op$vidvid", "\\")
			Result.put ("op$hat", "^")
			Result.put ("op$and", "and")
			Result.put ("op$or", "or")
			Result.put ("op$xor", "xor")
			Result.put ("op$andthen", "and then")
			Result.put ("op$orelse", "or else")
			Result.put ("op$implies", "implies")
		end

end
