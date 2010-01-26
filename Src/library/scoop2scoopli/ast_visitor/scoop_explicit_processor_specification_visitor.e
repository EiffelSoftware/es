note
	description: "[
					Roundtrip visitor to process explicit processor specification node.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_bits_as,
			process_bits_symbol_as,
			process_formal_as,
			process_like_cur_as,
			process_like_id_as,
			process_none_type_as,
			process_explicit_processor_specification_as,
			process_class_as,
			process_feature_clause_as,
			process_feature_as,
			process_feat_name_id_as,
			process_feature_name_alias_as,
			process_infix_prefix_as
		end

	SCOOP_WORKBENCH
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

feature -- Access

	get_explicit_processor_specification (l_as: TYPE_AS): TUPLE [has_explicit_processor_specification: BOOLEAN; entity_name: STRING; has_handler: BOOLEAN] is
			-- Evaluate `a_type' and return the processor and the handler.
		local
			l_last_index: INTEGER
		do
			-- reset
			has_explicit_processor_specification := false
			has_handler := false
			entity_name := Void

			current_class_c := class_c

			-- remeber leaf list index
			l_last_index := last_index
			last_index := l_as.first_token (match_list).index

			-- process type as
			safe_process (l_as)

			-- set result
			create Result
			Result.has_explicit_processor_specification := has_explicit_processor_specification
			Result.entity_name := entity_name
			Result.has_handler := has_handler

			-- reset leaf list index
			last_index := l_last_index
		end

	get_explicit_processor_specification_by_class (a_feature_name: STRING; a_class_c: CLASS_C): TUPLE [has_explicit_processor_specification: BOOLEAN; entity_name: STRING; has_handler: BOOLEAN] is
			-- Evaluate `a_type' and return the processor and the handler.
		local
			l_last_index: INTEGER
		do
			-- reset
			has_explicit_processor_specification := false
			has_handler := false
			entity_name := Void
			feature_name := a_feature_name
			current_class_c := a_class_c

			-- remeber leaf list index
			l_last_index := last_index

			-- process type as
			safe_process (a_class_C.ast)

			-- set result
			create Result
			Result.has_explicit_processor_specification := has_explicit_processor_specification
			Result.entity_name := entity_name
			Result.has_handler := has_handler

			-- reset leaf list index
			last_index := l_last_index
		end

feature {NONE} -- Visitor implementation: Type nodes

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			safe_process (l_as.explicit_processor_specification)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			safe_process (l_as.explicit_processor_specification)
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			safe_process (l_as.explicit_processor_specification)
		end

	process_bits_as (l_as: BITS_AS) is
		do
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS) is
		do
		end

	process_formal_as (l_as: FORMAL_AS) is
		do
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		do
			-- the current type is the type obtained from the current class
			-- therefore it cannot be separate or has a expl. processor spec.
		end

	process_like_id_as (l_as: LIKE_ID_AS) is
		local
			l_anchor_name: STRING
			l_feature_i: FEATURE_I
			l_class_c: CLASS_C
			l_processor: like get_explicit_processor_specification_by_class
			l_processor_visitor: like Current
		do
			l_anchor_name := l_as.anchor.name
			if current_class_c.feature_table.has (l_anchor_name) then
				-- get original feature
				l_feature_i := current_class_c.feature_table.item(l_anchor_name)
				-- get class in which the feature is written
				l_class_c := system.class_of_id (l_feature_i.written_in)
				-- get the explicit processor specification by parsing the new class
				l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor (l_class_c)
				l_processor := l_processor_visitor.get_explicit_processor_specification_by_class (l_anchor_name, l_class_c)
				has_explicit_processor_specification := l_processor.has_explicit_processor_specification
				has_handler := l_processor.has_handler
				entity_name := l_processor.entity_name
			else
				error_handler.insert_error (create {INTERNAL_ERROR}.make("SCOOP Unexpected error: {SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR}.process_like_id_as."))
			end
		end

	process_none_type_as (l_as: NONE_TYPE_AS) is
		do
		end

	process_explicit_processor_specification_as (l_as: EXPLICIT_PROCESSOR_SPECIFICATION_AS) is
			-- Process `l_as'.
			-- added for SCOOP by paedde
		do
			has_explicit_processor_specification := true
			safe_process (l_as.entity)
			entity_name := l_as.entity.name
			if l_as.handler /= Void then
				has_handler := true
			end
		end

feature {NONE} -- Visitor implementation: Accessing a class

	process_class_as (l_as: CLASS_AS) is
		do
			if l_as.features /= Void then
				last_index := l_as.features.index
			end
			safe_process (l_as.features)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS) is
		do
			if l_as.features /= Void then
				last_index := l_as.features.index
			end
			safe_process (l_as.features)
		end

	process_feature_as (l_as: FEATURE_AS) is
		local
			i, nb: INTEGER
		do
			visited_feature_name := Void
			from
				i := 1
				nb := l_as.feature_names.count
			until
				i > nb
			loop
				safe_process (l_as.feature_names.i_th (i))
				if visited_feature_name.is_equal (feature_name) then
					safe_process (l_as.body.type)
				end
				i := i + 1
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS) is
		do
			visited_feature_name := l_as.feature_name.name
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS) is
		do
			visited_feature_name := l_as.feature_name.name
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
		do
			-- a like type cannot be an infix / prefix:
			-- Feature_name: Identifier_as_lower | Infix | Prefix
			-- Non_class_type: TE_LIKE Identifier_as_lower
			create visited_feature_name.make_empty
		end

feature {NONE} -- Implementation

	current_class_c: CLASS_C
		-- Reference to the 'CLASS_C' of the current processed class.

	feature_name: STRING
		-- Name of the feature we try to find

	visited_feature_name: STRING
		-- Return value when processing the current feature name

	entity_name: STRING
		-- Return value of current query

	has_handler: BOOLEAN
		-- Return value of current query

	has_explicit_processor_specification: BOOLEAN
		-- Returns true if the explicit processor specification is not void

;note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
