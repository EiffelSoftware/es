note
	description: "[
					Roundtrip visitor to evaluate type of local attribute.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_TYPE_LOCALS_PRINTER

inherit
	SCOOP_PROXY_TYPE_VISITOR
		redefine
			process_like_cur_as,
			process_like_id_as,
			process_generic_class_type_as
		end

create
	make_with_context

feature {NONE} -- Roundtrip: process nodes

	process_like_id_as (l_as: LIKE_ID_AS) is
		do
--			if class_as.feature_table.has (l_as.anchor.name) then
--				l_feature_i := class_as.feature_table.item (l_as.anchor.name)
--				l_type_a := l_feature_i.type

--				evaluate_like_id_type_flags (l_type_a.is_expanded, l_type_a.is_separate)
--			end

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.like_keyword (match_list))
			safe_process (l_as.anchor)
--			create iterator
--			iterator.setup (class_as, match_list, True, True)
--			iterator.set_context (context)
--			iterator.process_ast_node (l_as.anchor)


			-- process attachment mark
--			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))
--			last_index := l_as.like_keyword (match_list).index
--			-- process anchor
--			process_leading_leaves (l_as.anchor.index)
--			if l_type_a.is_formal then

--				l_formal_a ?= l_type_a
--				create l_name.make_from_string (class_c.generics.i_th (l_formal_a.position).name.name.as_upper)
--				process_class_name_str (l_name, False, context, match_list)
--			else
--				-- get class name of actual type

--				-- process actual type a
--				l_type_a := l_type_a.actual_type

--				process_actual_type_a (l_type_a)


--			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		do
			-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
			evaluate_like_current_type_flags

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))

			-- process attachment mark
			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

			-- process like keyword
			safe_process (l_as.like_keyword (match_list))

--			if is_print_with_prefix then
--				-- SCOOP proxy class
--				safe_process (l_as.current_keyword)
--			else
				-- original / client class
				-- print 'implementation' instead of 'current'
				context.add_string (" implementation_")
				last_index := l_as.current_keyword.last_token (match_list).index
--			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
			evaluate_generic_class_type_flags (l_as.is_expanded, l_as.is_separate)

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))

			-- process attachment mark
			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

			-- skip expanded_keyword
			if l_as.is_expanded then
				last_index := l_as.expanded_keyword_index
			end

			-- process class name
			process_class_name (l_as.class_name, is_print_with_prefix, context, match_list)
			if l_as.class_name /= Void then
				last_index := l_as.class_name.last_token (match_list).index
			end

			-- process internal generics			
			-- no `SCOOP_SEPARATE__' prefix.
			l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
			if generics_to_substitute /= void and not generics_to_substitute.is_empty then
				l_generics_visitor.set_generics_to_substitute (generics_to_substitute)
			end
			l_generics_visitor.process_type_locals (l_as.internal_generics, False, not is_filter_detachable)
			if l_as.internal_generics /= Void then
				last_index := l_as.internal_generics.last_token (match_list).index
			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

feature {NONE} -- TYPE_A implementation

	process_actual_type_a (l_type_a: TYPE_A) is
		require
			l_type_a /= Void
		local
			ast_rdtrip: SCOOP_CONTEXT_AST_PRINTER
			is_formal_generic: BOOLEAN
			i, nb: INTEGER
			l_name: STRING
			l_formal_a: FORMAL_A
		do
			if l_type_a.is_formal then
				-- it is a formal generic parameter
				l_formal_a ?= l_type_a
				create l_name.make_from_string (class_c.generics.i_th (l_formal_a.position).name.name.as_upper)
				process_class_name_str (l_name, False, context, match_list)
			elseif l_type_a.has_generics then
				-- formal generic or with explicit type
				from
					i := 1
					nb := l_type_a.generics.count
				until
					i > nb
				loop
					if l_type_a.generics.item (i).is_formal then
						is_formal_generic := True
					end

					i := i + 1
				end

				if is_formal_generic then
					-- print out current name
					create l_name.make_from_string (l_type_a.associated_class.name_in_upper)
					process_class_name_str (l_name, False, context, match_list)

					-- get current formal generic parameters
				--	context.add_string ("[")
					from
						i := 1
						nb := l_type_a.generics.count
					until
						i > nb
					loop
						if l_type_a.generics.item (i).is_formal then
							l_formal_a ?= l_type_a.generics.item (i)
							if l_formal_a.has_attached_mark then
								context.add_string ("!")
							elseif l_formal_a.has_detachable_mark then
								context.add_string ("?")
							end
							create l_name.make_from_string (class_c.generics.i_th (l_formal_a.position).name.name.as_upper)
							process_class_name_str (l_name, False, context, match_list)
						else
							process_class_name_str (l_type_a.generics.item (i).name, False, context, match_list)
						end

						if i < nb then
							context.add_string (", ")
						end
						i := i + 1
					end
				--	context.add_string ("]")
				elseif l_type_a.is_like_current then
					context.add_string ("[like implementation_]")
				else
					-- just print out the actual type

					create ast_rdtrip
					ast_rdtrip.setup (class_as, match_list, True, True)
					ast_rdtrip.set_context (context)
					if feature_as.body.type /= void then
						ast_rdtrip.process_ast_node (feature_as.body.type)
					end
				--	process_class_name_str (l_type_a.actual_type., False, context, match_list)
				end
			else
				-- just print out the actual type
				process_class_name_str (l_type_a.actual_type.name, False, context, match_list)
			end
		end

feature {NONE} -- Feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_separate and not is_expanded then
				is_print_with_prefix := True
			else
				is_print_with_prefix := False
			end
			is_filter_detachable := True
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_separate and not is_expanded then
				is_print_with_prefix := True
			else
				is_print_with_prefix := False
			end
			is_filter_detachable := True
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_separate then
				is_print_with_prefix := True
			else
				is_print_with_prefix := False
			end
			is_filter_detachable := True
		end

	evaluate_like_current_type_flags is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := True
			is_filter_detachable := True
		end

	 evaluate_like_id_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_separate and not is_expanded then
				is_print_with_prefix := True
			else
				is_print_with_prefix := False
			end
			is_filter_detachable := True
		end

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_PROXY_TYPE_LOCALS_PRINTER
