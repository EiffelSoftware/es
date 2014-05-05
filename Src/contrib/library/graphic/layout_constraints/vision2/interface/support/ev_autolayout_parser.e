note
	description: "Summary description for {EV_AUTOLAYOUT_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT_PARSER

inherit
	EV_AUTOLAYOUT_READER
		export {NONE} all end
	EV_AUTOLAYOUT_TOKENS
		export {NONE} all end

create
	make_parser

feature {NONE} -- Initialization

	make_parser (a_layout_format: STRING; a_container: EV_AUTOLAYOUT; a_widgets: ARRAY [EV_WIDGET])
			-- Initialize `Current'.
		require
			layout_not_empty: a_layout_format /= Void and then not a_layout_format.is_empty
			container_not_void: a_container /= Void
			widgets_not_empty: a_widgets /= Void and then not a_widgets.is_empty
		do
			make (a_layout_format)

			container := a_container
			is_parsed := True

			create widgets.make
			a_widgets.do_all (agent (w: EV_WIDGET) do widgets.extend (w) end)

			create errors.make
			create constraints.make
		end

feature -- Status report

	is_parsed: BOOLEAN
			-- Is parsed?

	errors: LINKED_LIST [STRING]
			-- Current errors

	current_errors: STRING
			-- Current errors as string
		do
			create Result.make_empty
			from
				errors.start
			until
				errors.after
			loop
				Result.append_string (errors.item + "%N")
				errors.forth
			end
		end

feature -- Element change

	report_error (e: STRING)
			-- Report error `e'
		require
			e_not_void: e /= Void
		do
			errors.force (e)
		end

feature -- Commands

	parse_layout
		    -- Parse layout data `representation'
		    -- start ::= V | H
		do
		   	if is_valid_start_symbol then
		   		parse_arrangement
		   	    parse
		        if has_next then
		            is_parsed := False
		        end
		    else
		        is_parsed := False
		        report_error ("Syntax error unexpected token, expecting `H' or `V'")
		    end
		end

	create_constraints
		require
			parsed_successfully: is_parsed
		do
			from constraints.start
			until constraints.after
			loop
				if not constraints.islast then
					create_spacing_constraint (constraints.item, constraints[constraints.index + 1])
				end
				if constraints.item.size > 0 then
					create_size_constraint (constraints.item.widget, constraints.item.size)
				elseif constraints.item.relative_size /= Void then
					create_relative_size_constraint (constraints.item, constraints[constraints.index + 1])
				end
				constraints.forth
			end
		end

	create_spacing_constraint (first_constraint, second_constraint: EV_AUTOLAYOUT_CONSTRAINT)
		local
			l_first_attribute, l_second_attribute: EV_LAYOUT_ATTRIBUTE
		do
			if first_constraint.name.is_equal (al_LAYOUT_OPEN.out) then
				l_first_attribute := second_layout_attribute (first_constraint.widget.layout)
			else
				l_first_attribute := first_layout_attribute (first_constraint.widget.layout)
			end

			if second_constraint.name.is_equal (al_LAYOUT_CLOSE.out) then
				l_second_attribute := first_layout_attribute (second_constraint.widget.layout)
			else
				l_second_attribute := second_layout_attribute (second_constraint.widget.layout)
			end

			container.create_linear_constraint (1, l_first_attribute, first_constraint.spacing, {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal, l_second_attribute)
		end

	create_size_constraint (a_widget: EV_WIDGET; a_size: INTEGER)
		local
			l_attribute: EV_LAYOUT_ATTRIBUTE
		do
			l_attribute := size_attribute (a_widget.layout)
			container.create_single_linear_constraint (l_attribute, {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal, a_size)
		end

	create_relative_size_constraint (first_constraint, second_constraint: EV_AUTOLAYOUT_CONSTRAINT)
		local
			l_first_attribute, l_second_attribute: EV_LAYOUT_ATTRIBUTE
		do
			l_first_attribute := size_attribute (first_constraint.widget.layout)
			l_second_attribute := size_attribute (second_constraint.widget.layout)
			container.create_linear_constraint (1, l_first_attribute, 0, {EV_LAYOUT_CONSTRAINT}.constraint_sign_equal, l_second_attribute)
		end

feature {NONE} -- Parsing

	parse_arrangement
		do
			is_horizontal_arrangement := (actual = al_HORIZONTAL)
			next
		end

	parse
			-- Parse layout data `representation'
		do
			from
			until not has_next or not is_parsed
			loop
				inspect actual
				when al_LAYOUT_OPEN then
					if constraints.is_empty then
						parse_widget
					else
						is_parsed := False
						report_error ("The container symbol '{' can only be used at the beginning of the layout")
					end
				when al_WIDGET_OPEN then
					parse_widget
				when al_LAYOUT_CLOSE then
					parse_widget
					if has_next then
						is_parsed := False
						report_error ("The container symbol '}' can only be used at the end of the layout")
					else
						is_parsed := True
					end
				when al_DASH then
					next
					parse_distance
				else
					is_parsed := False
					report_error ("Layout is not well formed")
				end
			end
		end

	parse_widget
		require
			widgets_not_empty: not widgets.is_empty
		local
			l_constraint: EV_AUTOLAYOUT_CONSTRAINT
		do
			create l_constraint

			inspect actual
			when al_LAYOUT_OPEN, al_LAYOUT_CLOSE then
				l_constraint.widget := container
				l_constraint.name := actual.out
				next
			when al_WIDGET_OPEN then
				next
				l_constraint.widget := widgets.first
				widgets.start
				widgets.remove
				l_constraint.name := parse_widget_name

				parse_optional_size (l_constraint)

				if actual = al_WIDGET_CLOSE then
					next
				else
					is_parsed := False
					report_error ("Syntax error: unexpected token. Expecting ']' but found " + actual.out)
				end
			else
				report_error ("Widget format is not well defined")
			end

			constraints.extend (l_constraint)
		end

	parse_widget_name : STRING
		local
			l_done: BOOLEAN
		do
			create Result.make_empty
			from l_done := False
			until not has_next or l_done
			loop
				if actual.is_alpha_numeric then
					Result.append_character (actual)
					next
				else
					l_done := True
				end
			end
		end

	parse_optional_size (a_constraint: EV_AUTOLAYOUT_CONSTRAINT)
		require
			constraint_not_void: a_constraint /= Void
		local
			l_number: INTEGER
		do
			inspect actual
			when al_SIZE_OPEN then
				next
					-- FIXME: it could actually be another widget's name
				l_number := parse_number
				if actual = al_SIZE_CLOSE then
					next
				else
					is_parsed := False
					report_error ("Syntax error: unexpected token. Expecting ')' but found " + actual.out)
				end
			else
				-- No optional size to be parsed
			end
			a_constraint.size := l_number
		end

	parse_distance
		require
			constraints_not_empty: not constraints.is_empty
		local
			l_spacing: INTEGER
		do
			l_spacing := al_DEFAULT_SPACING
			if actual.is_digit then
				l_spacing := parse_number
				next
			end
			constraints.last.spacing := l_spacing
		end

	parse_number: INTEGER
		local
			l_number: STRING
			l_is_digit: BOOLEAN
		do
			create l_number.make_empty
			from l_is_digit := actual.is_digit
			until not l_is_digit or not has_next
			loop
				l_number.append_character (actual)
				next
				l_is_digit := actual.is_digit
			end
			if l_number.is_integer then
				Result := l_number.to_integer
			else
				report_error ("Expected a number, found: [ " + l_number  + " ]")
			end
		end

feature {NONE} -- Implementation

	is_valid_start_symbol: BOOLEAN
			-- expecting `{' or `[' as start symbol
		do
			if attached representation as s and then s.count > 0 then
				Result := s[1] = al_HORIZONTAL or s[1] = al_VERTICAL
			end
		end

	is_horizontal_arrangement: BOOLEAN

	first_layout_attribute: FUNCTION [EV_LAYOUTABLE, TUPLE, EV_LAYOUT_ATTRIBUTE]
		do
			if is_horizontal_arrangement then
				Result := agent {EV_LAYOUTABLE}.right_attribute
			else
				Result := agent {EV_LAYOUTABLE}.bottom_attribute
			end
		end

	second_layout_attribute: FUNCTION [EV_LAYOUTABLE, TUPLE, EV_LAYOUT_ATTRIBUTE]
		do
			if is_horizontal_arrangement then
				Result := agent {EV_LAYOUTABLE}.left_attribute
			else
				Result := agent {EV_LAYOUTABLE}.top_attribute
			end
		end

	size_attribute: FUNCTION [EV_LAYOUTABLE, TUPLE, EV_LAYOUT_ATTRIBUTE]
		do
			if is_horizontal_arrangement then
				Result := agent {EV_LAYOUTABLE}.width_attribute
			else
				Result := agent {EV_LAYOUTABLE}.height_attribute
			end
		end

	container: EV_AUTOLAYOUT

	widgets: LINKED_LIST [EV_WIDGET]

	constraints: LINKED_LIST [EV_AUTOLAYOUT_CONSTRAINT]

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
