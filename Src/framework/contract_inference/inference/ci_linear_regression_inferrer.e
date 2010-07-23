note
	description: "Class to infer linear regression related contracts"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_LINEAR_REGRESSION_INFERRER

inherit
	CI_DATA_MINING_BASED_INFERRER
		redefine
			is_arff_needed
		end

	WEKA_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Status report

	is_arff_needed: BOOLEAN = True
			-- Is ARFF data needed?

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_loader: WEKA_ARFF_RELATION_PARSER
		do
				-- Initialize.
			logger.put_line_with_time ("Start inferring linear regression related contracts.")
			data := a_data
			setup_data_structures

			create l_loader.make ("D:\jasonw\projects\inferrer\EIFGENs\project\Contract_inference\data\LINKED_LIST__extend.arff2")
			l_loader.parse_relation
			arff_relation := l_loader.last_relation
--			arff_relation := data.arff_relation.cloned_object
			value_sets := arff_relation.value_set

			collect_dependent_attributes
			if not dependent_attributes.is_empty then
				collect_regressor_attributes

			end

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts
		end

feature{NONE} -- Implementation

	dependent_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes used as dependent variables in regression

	regressor_attributes: DS_HASH_TABLE [DS_HASH_SET [WEKA_ARFF_ATTRIBUTE], WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes used as regressors in regression

feature{NONE} -- Implementation

	collect_dependent_attributes
			-- Collect `dependent_attributes'.
		local
			l_attr: WEKA_ARFF_ATTRIBUTE
			l_ok: BOOLEAN
			l_name: STRING
			l_to_name: STRING
			l_to_attr: WEKA_ARFF_ATTRIBUTE
		do
			create dependent_attributes.make (10)
			dependent_attributes.set_equality_tester (weka_arff_attribute_equality_tester)

				-- Iterate through all attributes and find out attributes that satisfy:
				-- 1. is numeric.
				-- 2. describes a postcondition.
				-- 3. the value set does not contain the missing value "?".
				-- 4. that attribute is potentially changable.
			across arff_relation.attributes as l_attrs loop
				l_attr := l_attrs.item
				l_ok :=
					l_attr.is_numeric and then
					l_attr.name.has_substring (once "post::") and then
					not value_sets.item (l_attr).has (once "?")
				if l_ok then
					l_name := string_slices (l_attr.name, once "::").last
					l_to_name := "%"to::" + l_name
					if arff_relation.has_attribute_by_name (l_to_name) then
						l_to_attr := arff_relation.attribute_by_name (l_to_name)
						l_ok := value_sets.item (l_to_attr).count > 1
						if l_ok then
							dependent_attributes.force_last (l_attr)
						end
					end
				end
			end

				-- Logging.
			log_attributes ("Found the following dependent attributes:", dependent_attributes)
		end

	collect_regressor_attributes
			-- Collect `regressor_attributes'.
		local
			l_attr, l_reg_attr: WEKA_ARFF_ATTRIBUTE
			l_ok: BOOLEAN
			l_name: STRING
			l_prefix: STRING
			l_strs: LIST [STRING]
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
			l_regressors: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
		do
			create regressor_attributes.make (10)
			regressor_attributes.set_key_equality_tester (weka_arff_attribute_equality_tester)

			from
				l_cursor := dependent_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_attr := l_cursor.item
				create l_regressors.make (10)
				l_regressors.set_equality_tester (weka_arff_attribute_equality_tester)
				regressor_attributes.force_last (l_regressors, l_attr)

					-- Iterate through all attributes and find out those satisfying:
					-- 1. is numeric.
					-- 2. do not describe a change (to:: or by::).
					-- 3. the value set does not contain the missing value "?".
				across arff_relation.attributes as l_attrs loop
					l_reg_attr := l_attrs.item
					l_ok :=
						l_reg_attr /= l_attr and then
						l_reg_attr.is_numeric and then
						l_reg_attr.name.has_substring (once "pre::") and then --or l_reg_attr.name.has_substring (once "post::")) and then
						not value_sets.item (l_reg_attr).has (once "?")

					if l_ok then
						l_regressors.force_last (l_reg_attr)
					end
				end
				if l_regressors.is_empty then
					dependent_attributes.remove (l_attr)
					regressor_attributes.remove (l_attr)
				else
					log_attributes ("For attribute " + l_attr.name + ", found the following regressions:", l_regressors)
					l_cursor.forth
				end
			end
		end

feature{NONE} -- Implementation

	build_linear_regressions
			-- Build linear regression.
		local
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
		do
				-- Iterate through all dependent attribute,
				-- for each attribute, try to build a linear regression.
			from
				l_cursor := dependent_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.forth
			end
		end

	build_linear_regression (a_dependent_attribute: WEKA_ARFF_ATTRIBUTE; a_regressor_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE])
		do

		end

feature{NONE} -- Logging

	log_attributes (a_message: STRING; a_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE])
			-- Log `a_attributes' with `a_message'.
		local
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
		do
			logger.push_fine_level
			logger.put_line_with_time (a_message)
			from
				l_cursor := a_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%T" + l_cursor.item.name)
				l_cursor.forth
			end
			logger.put_line ("")
			logger.pop_level
		end
end
