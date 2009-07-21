indexing
	description: "Summary description for {JS_SPEC_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_SPEC_GENERATOR

inherit
	SHARED_SERVER

	DOCUMENTATION_EXPORT

	JS_HELPER_ROUTINES

create
	make

feature

	make
		do
			create output.make
			create predicate_definition_parser.make
			create assertion_parser.make
			create spec_adapter.make
			create spec_printer.make
		end

	process_class (a_class: !CLASS_C)
		local
			l_supplier: CLASS_C
		do
			output.reset

				-- First collect specs from supplier classes of `a_class' (excluding `a_class' itself) that are not expanded or external (e.g. INTEGER_32).
			from
				a_class.suppliers.start
			until
				a_class.suppliers.off
			loop
				l_supplier := a_class.suppliers.item.supplier
				if
					l_supplier /= Void and then
					l_supplier.class_id /= a_class.class_id and then
					not l_supplier.is_expanded and then
					not l_supplier.is_external
				then
					collect_spec_of_class (l_supplier)
				end
				a_class.suppliers.forth
			end
				-- Now collect the specs from `a_class' itself.
			collect_spec_of_class (a_class)
		end

	generated_specs: !STRING
		do
			Result := output.string
		end

feature {NONE}

	output: !JS_OUTPUT_BUFFER

	match_list: LEAF_AS_LIST

	predicate_definition_parser: JS_PREDICATE_DEFINITION_PARSER

	assertion_parser: JS_ASSERTION_PARSER

	spec_adapter: JS_SPEC_ADAPTER

	spec_printer: JS_SPEC_PRINTER

	collect_spec_of_class (a_class: !CLASS_C)
			-- Collects the shallow spec of a class, i.e. the suppliers of `a_class' are not considered.
		do
			-- TODO: issue a warning if a_class uses inheritance

			match_list := match_list_server.item (a_class.class_id)

			output.put_line ("class " + a_class.name_in_upper)
			output.put_line ("{")

			output.indent

			collect_predicates (a_class.ast.top_indexes)
			collect_predicates (a_class.ast.bottom_indexes)

			collect_specs_of_creation_routines (a_class)

			collect_specs_of_normal_routines (a_class)

			output.unindent

			output.put_line ("}%N")
		end

	collect_predicates (a_indexing_clause: INDEXING_CLAUSE_AS)
		local
			l_content: STRING
			l_predicate_def: JS_SPEC_NODE
		do
			-- TODO: implement a way to "define" or "export" a predicate,
			--       possibly with tags, i.e. sl_predicate_export and sl_predicate_define
			if a_indexing_clause /= Void then
				from
					a_indexing_clause.start
				until
					a_indexing_clause.off
				loop
					if
						{l_index_as: !INDEX_AS} a_indexing_clause.item and then
						equal (l_index_as.tag.name.as_upper, "SL_PREDICATE")
					then
						l_content := l_index_as.content_as_string
						l_content := l_content.substring (2, l_content.count - 1)
						predicate_definition_parser.reset
						predicate_definition_parser.set_input_buffer (create {YY_BUFFER}.make (l_content))
						predicate_definition_parser.parse
						if predicate_definition_parser.error_count = 0 then
							l_predicate_def := predicate_definition_parser.predicate_definition

							-- Substitute types and Void.
							spec_adapter.with_class_context
							l_predicate_def.accept (spec_adapter)

							-- Now output the pretty printed definition
							spec_printer.reset
							l_predicate_def.accept (spec_printer)
							output.put_line ("define " + spec_printer.output + ";%N")
						else
							error ("Error parsing predicate definition: " + l_content)
						end
					end
					a_indexing_clause.forth
				end
			end
		end

	collect_spec_of_routine (as_creation_procedure: BOOLEAN; a_feature_as: !FEATURE_AS; a_feature_i: !FEATURE_I)
		local
			comments: EIFFEL_COMMENTS
			region: ERT_TOKEN_REGION
			where: STRING
			what: STRING
		do
			output.put_line (routine_signature (as_creation_procedure, a_feature_i) + " :")

			output.indent

			if {b: !BODY_AS} a_feature_as.body and then {r: !ROUTINE_AS} b.content then

				where := a_feature_i.written_class.name_in_upper + "." + a_feature_i.feature_name

					-- Get the precondition
				if {pre: !REQUIRE_AS} r.precondition then
					create region.make (pre.first_token (match_list).index, r.routine_body.first_token (match_list).index)
					comments := match_list.extract_comment (region)

					what := where + " precondition"
					output.put_line ("{" + assertion_from_comments (comments, what, a_feature_i) + "}")
				else
					error (where + ": precondition missing")
				end

					-- Get the postcondition
				if {post: !ENSURE_AS} r.postcondition then
					create region.make (post.first_token (match_list).index, r.end_keyword.first_token (match_list).index)
					comments := match_list.extract_comment (region)

					what := where + " postcondition"
					output.put_line ("{" + assertion_from_comments (comments, what, a_feature_i) + "};")
				else
					error (where + ": postcondition missing")
				end
			else
				error (where + ": spec missing")
			end

			output.unindent
		end

	assertion_from_comments (a_comments: EIFFEL_COMMENTS; what: STRING; where: !FEATURE_I): STRING
		local
			sl_prefix: STRING
			l_string: STRING
			sl_assertion: STRING
			l_assertion: JS_SPEC_NODE
		do
			sl_prefix := "SL--"

			from
				a_comments.start
				sl_assertion := Void
			until
				a_comments.off
			loop
				l_string := a_comments.item.content
				if l_string.count > sl_prefix.count and then equal (l_string.substring (1, sl_prefix.count), sl_prefix) then
					if sl_assertion = Void then
						sl_assertion := l_string.substring (sl_prefix.count + 1, l_string.count)
					else
						error (what + " defined more than once")
					end
				end
				a_comments.forth
			end

			if sl_assertion /= Void then
				assertion_parser.reset
				assertion_parser.set_input_buffer (create {YY_BUFFER}.make (sl_assertion))
				assertion_parser.parse
				if assertion_parser.error_count = 0 then
					l_assertion := assertion_parser.assertion

					-- Substitute variables, types & void
					spec_adapter.with_feature_context (where)
					l_assertion.accept (spec_adapter)

					-- Now pretty print the AST
					spec_printer.reset
					l_assertion.accept (spec_printer)
					Result := spec_printer.output
				else
					error ("Error parsing " + what)
				end
			else
				error (what + " missing")
			end
		end

	collect_specs_of_normal_routines (a_class: !CLASS_C)
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			if a_class.has_feature_table then
				from
					a_class.feature_table.start
				until
					a_class.feature_table.after
				loop
					l_feature := a_class.feature_table.item_for_iteration
					check l_feature /= Void end
					l_attached_feature := l_feature

						-- Only write routines which are written in that class
					if l_feature.is_routine and then l_feature.written_in = a_class.class_id and {body: !FEATURE_AS} l_attached_feature.body then
						collect_spec_of_routine (False, body, l_attached_feature)
					end

					a_class.feature_table.forth
				end
			end
		end

	collect_specs_of_creation_routines (a_class: !CLASS_C)
		local
			l_creator_name: STRING
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_feature_body: FEATURE_AS
			l_attached_feature_body: !FEATURE_AS
		do
			if a_class.creators /= Void then
				from
					a_class.creators.start
				until
					a_class.creators.after
				loop
					l_creator_name := a_class.creators.key_for_iteration

					l_feature := a_class.feature_named (l_creator_name)
					check l_feature /= Void end
					l_attached_feature := l_feature

					l_feature_body := l_attached_feature.body
					check l_feature_body /= Void end
					l_attached_feature_body := l_feature_body

						-- Check if creation routine is not yet generated. This can happen if a subclass
						-- uses the same feature as a creation routine as the parent.
					--if not feature_list.is_creation_routine_already_generated (l_attached_feature) then
						collect_spec_of_routine (True, l_attached_feature_body, l_attached_feature)
					--end

					a_class.creators.forth

				end
			end
		end

end
