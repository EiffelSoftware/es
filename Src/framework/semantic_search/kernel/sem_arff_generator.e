note
	description: "[
		Class to generate queryables into ARFF format
		Usage:
			call mutiple times `extend_queryable', then call `generate_maximal_arff', then call `wipe_out' to clean up.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_ARFF_GENERATOR

inherit
	SEM_QUERYABLE_VISITOR

	REFACTORING_HELPER

	SEM_SHARED_EQUALITY_TESTER

	SEM_FIELD_NAMES

	ITP_SHARED_CONSTANTS

create
	make_for_feature_transition,
	make_for_objects,
	make_for_snippet

feature{NONE} -- Initialization

	make_for_feature_transition
			-- Initialize Current for feature calls.
		do
			is_for_feature_transition := True
			reset
		ensure
			is_for_feature_transition_set: is_for_feature_transition
		end

	make_for_objects
			-- Initialize Current for objects.
		do
			is_for_objects := True
			reset
		ensure
			is_for_objects_set: is_for_objects
		end

	make_for_snippet
			-- Initialize Current for snippet.
		do
			is_for_snippet := True
			reset
		ensure
			is_for_snippet_set: is_for_snippet
		end

feature -- Basic operatioins

	extend_queryable (a_queryable: SEM_QUERYABLE; a_meta: detachable HASH_TABLE [STRING, STRING])
			-- Add information from `a_queryable' into Current.
			-- `a_meta' (is not Void) is a hash-table containing meta information for `a_queryable'.
			-- Key is data name, value is data value			
		require
			a_queryable_valid: is_queryable_valid (a_queryable)
		do
			meta := a_meta
			a_queryable.process (Current)
		end

	wipe_out
			-- Wipe out all data that has been processed so far.
			-- Prepare for new generation.
		do
			reset
		end

	generate_maximal_arff (a_name: STRING; a_medium: IO_MEDIUM)
			-- Generate maximal ARFF from data in Current.
			-- In this mode, all expressions in all added queryables will appear
			-- as an attribute in the final ARFF data. If some expressions only appear in some
			-- queryables, in the ARFF data, the will be missing values in lines
			-- for queryables in which those expressions does not appear.
			-- `a_name' is the name of the ARFF relation to be generated.
		local
			l_arff_relation: WEKA_ARFF_RELATION
			l_attributes: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_instance: HASH_TABLE [STRING, STRING]
			l_attr_name: STRING
			l_attr_value: STRING
			l_instance_values: ARRAYED_LIST [STRING]
		do
			l_attributes := arff_attributes
			create l_arff_relation.make (l_attributes)
			l_arff_relation.set_name (a_name)
			across instances as l_instances loop
				l_instance := l_instances.item
				create l_instance_values.make (l_attributes.count)
				across l_attributes as l_attrs loop
					l_attr_name := l_attrs.item.name
					l_attr_value := arff_value (l_attrs.item, l_instance, l_attr_name)
					l_instance_values.extend (l_attr_value)
				end
				l_arff_relation.extend (l_instance_values)
			end
			l_arff_relation.to_medium (a_medium)
		end

feature -- Status report

	is_for_feature_transition: BOOLEAN
			-- Is Current configured for feature transitions?

	is_for_objects: BOOLEAN
			-- Is Current configured for objects?

	is_for_snippet: BOOLEAN
			-- Is Current configured for snippet?

	is_queryable_valid (a_queryable: SEM_QUERYABLE): BOOLEAN
			-- Is `a_queryable' of correct type?
		do
			if is_for_feature_transition then
				Result := a_queryable.is_feature_call
			elseif is_for_objects then
				Result := a_queryable.is_objects
			elseif is_for_snippet then
				Result := a_queryable.is_snippet
			end
		end

feature{NONE} -- Process

	process_snippet (a_snippet: SEM_SNIPPET)
			-- Process `a_snippet'.
		do
			to_implement ("Support snippet later. 30.11.2010 Jasonw")
		end

	process_feature_call (a_call: SEM_FEATURE_CALL_TRANSITION)
			-- Process `a_call'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_change: EPA_EXPRESSION_CHANGE
			l_expr: EPA_EXPRESSION
			l_change_kind: INTEGER
			l_value: EPA_EXPRESSION_VALUE
		do
			last_queryable := a_call
			extend_instance

			extend_meta_attribute (class_attribute_name, a_call.class_.name, void_type)
			extend_meta_attribute (feature_attribute_name, a_call.feature_.feature_name, void_type)
			if a_call.uuid /= Void then
				extend_meta_attribute (uuid_attribute_name, a_call.uuid, void_type)
			end
			if meta /= Void and then meta.has (fault_id_field) then
				extend_meta_attribute (fault_signature_attribute_name, meta.item (fault_id_field), none_type)
			else
				extend_meta_attribute (fault_signature_attribute_name, nonsensical_value, none_type)
			end
			if meta /= Void and then meta.has (exception_tag_field) then
				extend_meta_attribute (exception_tag_attribute_name, meta.item (exception_tag_field), none_type)
			else
				extend_meta_attribute (exception_tag_attribute_name, nonsensical_value, none_type)
			end
			a_call.interface_preconditions.do_if (agent extend_attribute (?, property_kind_precondition), agent is_equation_suitable_as_attribute)
			a_call.interface_postconditions.do_if (agent extend_attribute (?, property_kind_postcondition), agent is_equation_suitable_as_attribute)

			from
				l_cursor := a_call.changes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_expr := l_cursor.key
				if a_call.is_interface_expression (l_expr) then
					if l_expr.type.is_integer or l_expr.type.is_boolean then
						integer_argumented_query_matcher.match (l_expr.text)
						if not integer_argumented_query_matcher.has_matched then
							across l_cursor.item as l_changes loop
								l_change := l_changes.item
								if l_change.is_absolute then
									l_change_kind := property_kind_absolute_change
								else
									l_change_kind := property_kind_relative_change
								end
								if not l_change.values.is_empty then
									l_value := value_from_expression (l_change.values.first)
									extend_attribute (create {EPA_EQUATION}.make (l_expr, l_value), l_change_kind)
								end
							end
						end
					end
				end
				l_cursor.forth
			end
		end

	value_from_expression (a_expression: EPA_EXPRESSION): EPA_EXPRESSION_VALUE
			-- Value constant from `a_expression'
		do
			if a_expression.is_boolean_constant then
				create {EPA_BOOLEAN_VALUE} Result.make (a_expression.text.to_boolean)
			elseif a_expression.is_integer_constant then
				create {EPA_INTEGER_VALUE} Result.make (a_expression.text.to_integer)
			end
		end

	is_equation_suitable_as_attribute (a_equation: EPA_EQUATION): BOOLEAN
			-- Is `a_equation' of boolean or integer type?
		do
			if a_equation.type.is_boolean or a_equation.type.is_integer then
				integer_argumented_query_matcher.match (a_equation.text)
				Result := not integer_argumented_query_matcher.has_matched
			end
		end



	class_attribute_name: STRING = "class"
	feature_attribute_name: STRING = "feature"
	uuid_attribute_name: STRING = "uuid"
	fault_signature_attribute_name: STRING = "fault_signature"
	exception_tag_attribute_name: STRING = "exception_tag"
	test_case_attribute_name: STRING = "test_case_name"

	process_objects (a_objects: SEM_OBJECTS)
			-- Process `a_objects'.
		do
			to_implement ("Support objects later. 30.11.2010 Jasonw")
		end

feature{NONE} -- Implementation

	reset
			-- Reset data structure for new generation.
		do
			create attributes.make (256)
			attributes.set_equality_tester (string_equality_tester)

			create attribute_types.make (256)
			attribute_types.compare_objects

			create default_values.make (256)
			default_values.compare_objects

			create value_strings.make (256)
			value_strings.set_equality_tester (string_equality_tester)

			create values_for_attribute.make (256)
			values_for_attribute.compare_objects

			create instances.make

			create integer_argumented_query_matcher.make
			integer_argumented_query_matcher.compile (".*\([0-9\-]+\).*")
		end

feature{NONE} -- Implementation

	attributes: DS_HASH_SET [STRING]
			-- Set of attributes that are corrected so far

	attribute_types: HASH_TABLE [TYPE_A, STRING]
			-- Table from attribute names to their types
			-- keys are name of attributes, values are types of those attributes.

	instances: LINKED_LIST [HASH_TABLE [STRING, STRING]]
			-- List of instances, each for an added queryable
			-- Keys of the hash-table is are attribute names,
			-- values are the value of those attributes.

	default_values: HASH_TABLE [STRING, STRING]
			-- Default values for attributes that are missing in some instances
			-- Keys are attribute names, values are the default values for those
			-- attributes.

	last_instance: detachable HASH_TABLE [STRING, STRING]
			-- The last extended instance by `extend_instance'

	value_strings: DS_HASH_SET [STRING]
			-- Value strings that are seen so far

	values_for_attribute: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Values for attributes
			-- Keys of the hash-table is attribute names
			-- Values of the hash-table is the set of values for that attribute.

	meta: detachable HASH_TABLE [STRING, STRING]
			-- Meta data for the queryable
			-- Key is data name, value is data value			

	integer_argumented_query_matcher: RX_PCRE_REGULAR_EXPRESSION
			-- Matcher for integer-argumented queries

	last_queryable: SEM_QUERYABLE
			-- Last queryable

feature{NONE} -- Status report

	has_any_instance: BOOLEAN
			-- Does `instances' have any instance yet?
		do
			Result := instances.count > 1
		ensure
			good_result: Result = (instances.count > 1)
		end

feature{NONE} -- Implementation

	extend_instance
			-- Extend a new instance, make the extended instance available
			-- at `last_instance'.
		do
			create last_instance.make (50)
			last_instance.compare_objects
			instances.extend (last_instance)
		end

	extend_attribute (a_equation: EPA_EQUATION; a_attribute_kind: INTEGER)
			-- Extend attribute described in `a_equation' into Current generator.
			-- `a_attribute_kind' indicates the kind of `a_equation'.
		require
			a_attribute_kind_valid: is_property_kind_valid (a_attribute_kind)
		local
			l_attr_name: STRING
			l_attributes: like attributes
		do
				-- Construct attribute name.
			create l_attr_name.make (64)
			l_attr_name.append (attribute_prefix (a_equation.type, a_attribute_kind))
			l_attr_name.append (anonymous_form (a_equation.expression))

			if not attributes.has (l_attr_name) then
				extend_new_attribute (l_attr_name, a_equation, a_attribute_kind)
			end
			last_instance.force (value_of_attribute (a_equation), l_attr_name)
		end

	value_of_attribute (a_equation: EPA_EQUATION): STRING
			-- Value for attribute with content `a_equation'
		require
			a_equation_valid: a_equation.type.is_boolean or a_equation.type.is_integer
		do
			if a_equation.value.is_nonsensical then
				Result := missing_value_string
			elseif a_equation.type.is_boolean then
				if a_equation.value.as_boolean.item then
					Result := true_string
				else
					Result := false_string
				end
			else
				Result := a_equation.value.text
			end
			value_strings.search (Result)
			if value_strings.found then
				Result := value_strings.found_item
			else
				value_strings.force_last (Result)
			end
		end

	extend_new_attribute (a_name: STRING; a_equation: EPA_EQUATION; a_kind: INTEGER)
			-- Extend new attribute name `a_name' with content `a_equation' of property kind `a_kind'.
		require
			a_kind_valid: is_property_kind_valid (a_kind)
			a_name_not_exist: not attributes.has (a_name)
		do
			attributes.force_last (a_name)
			attribute_types.force (a_equation.type, a_name)
			default_values.force (default_value (a_equation.type, a_kind), a_name)
		end

	extend_meta_attribute (a_name: STRING; a_value: STRING; a_type: TYPE_A)
			-- Extend a meta attribute named `a_name' with `a_value'
		local
			l_values: DS_HASH_SET [STRING]
		do
			if not attributes.has (a_name) then
				attributes.force_last (a_name)
				attribute_types.force (a_type, a_name)
				default_values.force (nonsensical_value, a_name)

				create l_values.make (5)
				l_values.set_equality_tester (string_equality_tester)
				values_for_attribute.force (l_values, a_name)
			end
			last_instance.force (a_value, a_name)
			values_for_attribute.item (a_name).force_last (a_value)
		end

	zero_string: STRING = "0"
	true_string: STRING = "1"
	missing_boolean_string: STRING = "2"
	false_string: STRING = "0"
	missing_value_string: STRING = "?"

	default_value (a_type: TYPE_A; a_attribute_kind: INTEGER): STRING
			-- Default value for attribute of type `a_type' of property kind `a_attribute_kind'
		require
			a_attribute_kind_valid: is_property_kind_valid (a_attribute_kind)
			a_type_valid: a_type.is_integer or a_type.is_boolean
		do
			if is_property_kind_change (a_attribute_kind) then
				if a_type.is_boolean then
					Result := missing_boolean_string
				elseif a_type.is_integer then
					Result := zero_string
				end
			else
				Result := missing_value_string
			end
		end

	attribute_prefix (a_type: TYPE_A; a_property_kind: INTEGER): STRING
			-- Prefix for an attribute'.			
			-- `a_type' indicates the type of the attribute.
			-- `a_property_kind' indicates the kind of the property
		require
			a_type_valid: a_type.is_boolean and a_type.is_integer
			a_property_type_valid: is_property_kind_valid (a_property_kind)
		do
			create Result.make (10)
			Result.append (property_kind_prefix (a_property_kind))
			Result.append (attribute_type_prifix (a_type))
		end

	attribute_type_prifix (a_type: TYPE_A): STRING
			-- Type prefix for `a_type'
		require
			a_type_valid: a_type.is_boolean and a_type.is_integer
		do
			create Result.make (3)
			if a_type.is_boolean then
				Result.append (boolean_type_prefix)
			elseif a_type.is_integer then
				Result.append (integer_type_prefix)
			end
		end

	is_property_kind_change (a_property_kind: INTEGER): BOOLEAN
			-- Is `a_property_kind' change-related?
			-- That is: either absolute change or relative change.
		require
			a_property_kind_valid: is_property_kind_valid (a_property_kind)
		do
			Result :=
				a_property_kind = property_kind_absolute_change or else
				a_property_kind = property_kind_relative_change
		end

	arff_attributes: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			-- List of ARFF attributes from `attributes'
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			l_type: TYPE_A
			l_attr_name: STRING
			l_attribute: WEKA_ARFF_ATTRIBUTE
		do
			create Result.make (attributes.count)
			from
				l_cursor := attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_attr_name := l_cursor.item
				l_type := attribute_types.item (l_attr_name)
				if l_type.is_boolean or l_type.is_integer then
					create {WEKA_ARFF_NUMERIC_ATTRIBUTE} l_attribute.make (l_attr_name)
				elseif l_type.is_void then
					create {WEKA_ARFF_STRING_ATTRIBUTE} l_attribute.make (l_attr_name)
				elseif l_type.is_none then
					create {WEKA_ARFF_NOMINAL_ATTRIBUTE} l_attribute.make (l_attr_name, values_for_attribute.item (l_attr_name))
				end
				Result.extend (l_attribute)
				l_cursor.forth
			end
		end

	arff_value (a_attribute: WEKA_ARFF_ATTRIBUTE; a_values: HASH_TABLE [STRING, STRING]; a_attr_name: STRING): STRING
			-- ARFF value for attribute named `a_attr_name'
		do
			a_values.search (a_attr_name)
			if a_values.found then
				Result := a_attribute.value (a_values.found_item)
			else
				Result := a_attribute.value (default_values.item (a_attr_name))
			end
		end

	anonymous_form (a_expression: EPA_EXPRESSION): STRING
			-- Anonymous form of `a_expression' in the context of `last_queryable'
		do
			if attached {SEM_FEATURE_CALL_TRANSITION} last_queryable as l_feat then
				Result := l_feat.anonymous_expression_text (a_expression)
			else
				Result := a_expression.text
			end
		end

end
