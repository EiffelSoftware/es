note
	description: "Summary description for {SEM_VALIDATE_IMPLICATION_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_ANALYZE_IMPLICATION_CMD

inherit
	SHARED_WORKBENCH

	EPA_UTILITY

	EPA_FILE_UTILITY

	SHARED_EIFFEL_PROJECT

	SEMQ_UTILITY

	EPA_STRING_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature -- Basic operations

	execute
			-- Execute current command
		local
			l_output_file: PLAIN_TEXT_FILE
		do
			create l_output_file.make_create_read_write (config.output)
			create implications.make (100)
			implications.compare_objects
			load_implications (config.input)
			across implications as l_imps loop
				across l_imps.item as l_list loop
					io.put_string (l_imps.key + " : " + l_list.item.text + "%N")
					l_output_file.put_string (l_imps.key + " : " + l_list.item.text + "%N")
					process_implication (l_list.item, l_output_file)
				end
			end
			l_output_file.close
		end

	process_implication (a_implication: EPA_EXPRESSION; a_output: PLAIN_TEXT_FILE)
			-- Process `a_implication'.
		local
			l_structure: like implication_structure
			l_arff_relation: WEKA_ARFF_RELATION
			l_arff_loader: WEKA_ARFF_RELATION_LOADER
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_curly_form: STRING
			l_expr_attr_map: DS_HASH_TABLE [WEKA_ARFF_ATTRIBUTE, EPA_EQUATION]
			l_attr_name: STRING
			l_attr: WEKA_ARFF_ATTRIBUTE
			l_bool_id: INTEGER
			l_invariants: like invariants_from_arff_relation
			l_invs: DS_ARRAYED_LIST [STRING]
			l_sorter: DS_QUICK_SORTER [STRING]
			l_arff_path: FILE_NAME
		do
			l_class := a_implication.class_
			l_feature := a_implication.feature_
			l_structure := implication_structure (a_implication)

			create l_arff_loader
			create l_arff_path.make_from_string (config.arff_directory)
			l_arff_path.extend (l_class.name_in_upper)
			l_arff_path.extend (l_feature.feature_name.as_lower)
			l_arff_path.set_file_name (l_class.name_in_upper + "__" + l_feature.feature_name.as_lower + "__all__noname.arff")
			l_arff_loader.load_relation (l_arff_path.out)
			l_arff_relation := l_arff_loader.last_relation
				-- Find ARFF relation attributes corresponding to implication premises.
			create l_expr_attr_map.make (5)
			l_expr_attr_map.set_key_equality_tester (equation_equality_tester)
			across l_structure.premises as l_premises loop
				l_curly_form := expression_with_curly_braced_operands (l_class, l_feature, l_premises.item.expression)
				l_attr_name := l_curly_form.twin
				l_attr_name.prepend ("pre::b::")
				l_attr := l_arff_relation.attribute_by_name (l_attr_name)
				if l_attr = Void then
					l_attr_name := "pre::b::(" + l_curly_form.twin + ")"
					l_attr := l_arff_relation.attribute_by_name (l_attr_name)
				end
				l_expr_attr_map.force_last (l_attr, l_premises.item)
			end

				-- Process ARFF relation based on implication premises.
			from
				l_expr_attr_map.start
			until
				l_expr_attr_map.after
			loop
				check attached {EPA_BOOLEAN_VALUE} l_expr_attr_map.key_for_iteration.value as l_bool then
					l_bool_id := l_bool.item.to_integer
				end
				l_arff_relation := l_arff_relation.partitions_by_attribute_value (l_expr_attr_map.item_for_iteration).item (l_bool_id.out)
				l_arff_relation := l_arff_relation.projection (
					agent (att: WEKA_ARFF_ATTRIBUTE; a_neg_attr: WEKA_ARFF_ATTRIBUTE): BOOLEAN
						do
							Result := att.name /~ a_neg_attr.name
						end (?, l_expr_attr_map.item_for_iteration))
				l_expr_attr_map.forth
			end


			l_invariants := invariants_from_arff_relation (l_arff_relation, Void, Void)
			from
				l_invariants.start
			until
				l_invariants.after
			loop
				fixme ("We only output preconditions for the moment. Jasonw 25.01.2011")
				if l_invariants.key_for_iteration.name.has_substring ("ppt1") then
					create l_invs.make (l_invariants.item_for_iteration.count)
					from
						l_invariants.item_for_iteration.start
					until
						l_invariants.item_for_iteration.after
					loop
						l_invs.force_last (decoded_daikon_name (l_invariants.item_for_iteration.item_for_iteration.debug_output.as_string_8))
						l_invariants.item_for_iteration.forth
					end
					create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (
						agent (a, b: STRING): BOOLEAN
							do
								Result := a < b
							end))
					l_sorter.sort (l_invs)
					from
						l_invs.start
					until
						l_invs.after
					loop
						io.put_string ("%T" + l_invs.item_for_iteration)
						io.put_character ('%N')
						a_output.put_string ("%T" + l_invs.item_for_iteration)
						a_output.put_character ('%N')
						l_invs.forth
					end
				end
				l_invariants.forth
			end

		end

	implication_structure (a_implication: EPA_EXPRESSION): TUPLE [premises: LINKED_LIST [EPA_EQUATION]; consequent: EPA_EQUATION]
			-- Structure of `a_implication'
			-- `premises' are the list of premises (without "old")
			-- `consequent' is the consequent of the implication.
		local
			l_big_parts: LIST [STRING]
			l_premises_str: STRING
			l_consequent_str: STRING
			l_consequent: EPA_EQUATION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_parts: LIST [STRING]
			l_pre_str: STRING
			l_ast: EXPR_AS
			l_expr_str: STRING
			l_pre_expr: EPA_AST_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
			l_pre_equations: LINKED_LIST [EPA_EQUATION]
		do
			l_class := a_implication.class_
			l_feature := a_implication.feature_

			l_big_parts := string_slices (a_implication.text, " implies ")
			l_consequent_str := l_big_parts.last
			l_consequent_str.left_adjust
			l_consequent_str.right_adjust
			l_consequent := equation_from_text_equation (l_consequent_str, l_class, l_feature)
			create l_pre_equations.make
			l_premises_str := l_big_parts.first
			across string_slices (l_premises_str, " and ") as l_pres loop
				l_pre_equations.extend (equation_from_text_equation (l_pres.item, l_class, l_feature))
			end
			Result := [l_pre_equations, l_consequent]
		end

	equation_from_text_equation (a_text: STRING; a_class: CLASS_C; a_feature: FEATURE_I): EPA_EQUATION
			-- Equation from `a_text', removing all "old" keyword
		local
			l_text: STRING
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
		do
			l_text := a_text.twin
			l_text.replace_substring_all ("old ", "")
			check attached {BIN_EQ_AS} ast_from_expression_text (l_text) as l_equ then
				if attached {PARAN_AS} l_equ.left as l_paran then
					l_text := text_from_ast (l_paran.expr)
				end
				if not l_text.has ('.') and not l_text.has ('~') and not l_text.has ('=') then
					l_text.prepend (ti_current + ".")
				end
				create l_expr.make_with_text (a_class, a_feature, l_text, a_class)
				create l_value.make (text_from_ast (l_equ.right).to_boolean)
				create Result.make (l_expr, l_value)
			end
		end

feature{NONE} -- Implementations

	implications: HASH_TABLE [LINKED_LIST [EPA_EXPRESSION], STRING]
			-- List of loaded implications
			-- Keys are CLASS_NAME.feature_name, values are the list of
			-- implications associated with those features

	load_implications (a_path: STRING)
			-- Load implications from file whose absolute path is given by `a_path'
			-- into `implications'.
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_parts: LIST [STRING]
			l_feature_id: STRING
			l_invs: LINKED_LIST [EPA_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
		do
			create l_file.make_open_read (a_path)
			from
				l_file.read_line
			until
				l_file.after
			loop
				l_line := l_file.last_string.twin
				l_line.left_adjust
				l_line.right_adjust
				if not l_line.is_empty then
					l_feature_id := l_line.substring (1, l_line.index_of (':', 1) - 1)
					l_feature_id.right_adjust
					if not implications.has (l_feature_id) then
						create l_invs.make
						implications.force (l_invs, l_feature_id)
					end
					l_class := first_class_starts_with_name (l_feature_id.substring (1, l_feature_id.index_of ('.', 1) - 1))
					l_feature := l_class.feature_named (l_feature_id.substring (l_feature_id.index_of ('.', 1) + 1, l_feature_id.count))
					l_line := l_line.substring (l_line.index_of (':', 1) + 1, l_line.count)
					l_line.left_adjust
					l_line.right_adjust
					create l_expr.make_with_text (l_class, l_feature, l_line, l_class)
					l_invs := implications.item (l_feature_id)
					l_invs.extend (l_expr)
				end
				l_file.read_line
			end
		end

end
