note
	description: "A feature in a class described by a BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_FEATURE

inherit
	TEXTUAL_BON_ELEMENT
		redefine
			process_to_informal_textual_bon,
			process_to_formal_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (a_text_formatter: like text_formatter_decorator;
				  a_feature_name: attached like name;
				  a_feature_arguments: like arguments;
				  a_feature_type: like type;
				  a_feature_type_mark: like type_mark;
				  a_feature_comments: like comments;
				  a_feature_renaming_clause: like renaming_clause;
				  a_feature_precondition: like precondition;
				  a_feature_postcondition: like postcondition)
			-- Create a feature element
		do
			name 			:= a_feature_name
			arguments 		:= a_feature_arguments
			type 			:= a_feature_type
			type_mark		:= a_feature_type_mark
			comments		:= a_feature_comments
			renaming_clause := a_feature_renaming_clause
			precondition 	:= a_feature_precondition
			postcondition 	:= a_feature_postcondition
		end

feature -- Access
	arguments: LIST[TBON_FEATURE_ARGUMENT]
			-- What are the arguments to this feature?

	comments: LIST[STRING]
			-- What are the comments for this feature?

	name: attached TBON_IDENTIFIER
			-- What is the name of this feature?

	renaming_clause: TBON_RENAMING_CLAUSE
			-- What is the renaming clause of this feature?

	postcondition: TBON_POSTCONDITION
			-- What is the postcondition of this feature?

	precondition: TBON_PRECONDITION
			-- What is the precondition of this feature?

	type: TBON_TYPE
			-- What is the type of this feature?

	type_mark: TBON_TYPE_MARK
			-- What is the type mark of this feature?

feature -- Processing
	process_to_informal_textual_bon
			-- Process this element into informal textual BON.
		require else
			has_comments: has_comments
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_item_in_list: BOOLEAN
			i: INTEGER
		do
			l_text_formatter_decorator := text_formatter_decorator

			l_text_formatter_decorator.process_string_text (ti_double_quote, Void)
			from
				i := 1
				l_is_first_item_in_list := True
			until
				i >= comments.count
			loop
				-- If there are multiple comments, put them on separate lines.
				if not l_is_first_item_in_list then
					l_text_formatter_decorator.process_string_text (bti_backslash, Void)
					l_text_formatter_decorator.put_new_line
					l_text_formatter_decorator.process_string_text (bti_backslash, Void)
					l_text_formatter_decorator.put_space
					l_is_first_item_in_list := False
				end
				l_text_formatter_decorator.process_string_text (comments.i_th (i), Void)

				i := i + 1
			end
			l_text_formatter_decorator.process_string_text (ti_double_quote, Void)
		end

	process_to_formal_textual_bon
			-- Process this element into formal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator

			-- deferred/effective/redefined
			process_status

			l_text_formatter_decorator.put_space

			-- Feature name
			name.process_to_textual_bon

			-- Process type
			if has_type then
				-- Process type mark
				type_mark.process_to_textual_bon
				l_text_formatter_decorator.put_space
				type.process_to_formal_textual_bon
			end

			-- Process renaming clause
			if is_renamed then
				renaming_clause.process_to_textual_bon
			end

			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent
			l_text_formatter_decorator.indent

			-- Process comments
			if has_comments then
				process_comments_into_formal_textual_bon
			end

			l_text_formatter_decorator.exdent

			-- Process arguments
			if has_arguments then
				process_formal_textual_bon_list (arguments, Void, True)
				l_text_formatter_decorator.put_new_line
			end

			-- Process contracts
			if has_precondition then
				precondition.process_to_textual_bon
				l_text_formatter_decorator.put_new_line
			end
			if has_postcondition then
				postcondition.process_to_textual_bon
				l_text_formatter_decorator.put_new_line
			end
			if has_precondition or has_postcondition then
				l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)
			end

		end

feature {NONE} -- Implementation: Processing
	process_comments_into_formal_textual_bon
			-- Process feature comments into formal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_list_item: BOOLEAN
			i: INTEGER
		do
			l_text_formatter_decorator := text_formatter_decorator
			from
				i := 1
				l_is_first_list_item := True
			until
				i >= comments.count
			loop
				if not l_is_first_list_item then
					l_text_formatter_decorator.put_new_line
					l_is_first_list_item := False
				end
				process_textual_bon_comment (comments.i_th (i))
			end
		end

	process_status
			-- Process the status (deferred/effective/redefined) of the feature.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator

			if is_deferred then
				l_text_formatter_decorator.process_keyword_text (bti_deferred_keyword, Void)
			elseif is_effective then
				l_text_formatter_decorator.process_keyword_text (bti_effective_keyword, Void)
			elseif is_redefined then
				l_text_formatter_decorator.process_keyword_text (bti_redefined_keyword, Void)
			end
		end

feature -- Status report
	has_arguments: BOOLEAN
			-- Does this feature have any arguments?
		do
			Result := arguments /= Void
		end

	has_comments: BOOLEAN
			-- Does this feature have comments?
		do
			Result := comments /= Void
		end

	has_postcondition: BOOLEAN
			-- Does this feature have a postcondition?
		do
			Result := postcondition /= Void
		end

	has_precondition: BOOLEAN
			-- Does this feature have a precondition?
		do
			Result := precondition /= Void
		end

	has_type: BOOLEAN
			-- Does this feature have a type?
		do
			Result := type /= Void
		end

	is_deferred: BOOLEAN
			-- Is this feature deferred?

	is_effective: BOOLEAN
			-- Is this feature effective?

	is_redefined: BOOLEAN
			-- Is this feature redefined?

	is_renamed: BOOLEAN
			-- Is this feature renamed?
		do
			Result := renaming_clause /= Void
		end

feature -- Status setting
	set_deferred
			-- Set this feature to be deferred.
		do
			is_deferred := True
			is_effective := False
			is_redefined := False
		ensure
			is_deferred: is_deferred
			is_not_effective: not is_effective
			is_not_redefined: not is_redefined
		end

	set_effective
			-- Set this feature to be effective.
		do
			is_effective := True
			is_deferred := False
			is_redefined := False
		ensure
			is_effective: is_effective
			is_not_deferred: not is_deferred
			is_not_redefined: not is_redefined
		end

	set_redefined
			-- Set this feature to be redefined.
		do
			is_redefined := True
			is_deferred := False
			is_effective := False
		ensure
			is_redefined: is_redefined
			is_not_deferred: not is_deferred
			is_not_effective: not is_effective
		end

invariant
	deferred_status_is_consistent: is_deferred implies not is_effective and not is_redefined
	effective_status_is_consistent: is_effective implies not is_deferred and not is_redefined
	redefined_status_is_consistent: is_redefined implies not is_deferred and not is_effective
	must_have_arguments_if_not_void: has_arguments implies not arguments.is_empty
	must_have_comments_if_not_void: has_comments implies not comments.is_empty
	must_have_type_mark_if_type_is_present: has_type implies type_mark /= Void

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
end
