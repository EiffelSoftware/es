note
	description:
		"Eiffel Vision autolayout. Implementation interface."
	legal: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_AUTOLAYOUT_I

inherit
	EV_FIXED_I
		redefine
			interface,
			extend
		end

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create lp.make
			lp.set_verbosity_level (3)
			create constraints.make

			layout.set_program (lp)
			resize_actions.extend (agent on_container_resize)
		end

feature -- Access

	last_constraint: detachable EV_LAYOUT_CONSTRAINT
			-- The last created constraint.
			-- Void if no constraint has been created yet.

feature -- Element Change

	create_linear_constraint (multiplier: DOUBLE; first_attribute: EV_LAYOUT_ATTRIBUTE; a_constant: DOUBLE; a_sign: INTEGER; second_attribute: EV_LAYOUT_ATTRIBUTE)
			-- Create a new layout constraint and apply it to the container.
			-- The widgets involved in the constraint must be in the container or creating
			-- the constraint will produce an error.
		local
			l_constraint: EV_LAYOUT_CONSTRAINT
		do
			create l_constraint.make (lp, multiplier, first_attribute, a_constant, a_sign, second_attribute)
			constraints.extend (l_constraint)

			last_constraint := l_constraint
		end

	create_single_linear_constraint (a_attribute: EV_LAYOUT_ATTRIBUTE; a_sign: INTEGER; a_constant: DOUBLE)
			-- Create a constraint that is applied to one widget only
			-- and has no relation to other elements.
			-- The widget involved in the constraint must be in the container or the
			-- constraint creation will produce an error.
		local
			l_constraint: EV_LAYOUT_CONSTRAINT
		do
			create l_constraint.make_single (lp, a_attribute, a_sign, a_constant)
			constraints.extend (l_constraint)

			last_constraint := l_constraint
		end

	create_constraints_with_format (a_layout_format: STRING; a_widgets: ARRAY [EV_WIDGET])
		local
			l_parser: EV_AUTOLAYOUT_PARSER
		do
			create l_parser.make_parser (a_layout_format, interface, a_widgets)
			l_parser.parse_layout

			if l_parser.is_parsed then
				l_parser.create_constraints
			end
		end

	create_constraint (a_expression: EV_LAYOUT_EXPRESSION)
		local
			l_constraint: EV_LAYOUT_CONSTRAINT
		do
			create l_constraint.make_with_expression (lp, a_expression)
			constraints.extend (l_constraint)

			last_constraint := l_constraint
		end

	extend (v: like item)
		do
			Precursor (v)
			v.layout.set_program (lp)

				-- Ensure that the minimum size of the widget is also
				-- taken into account in the auto layout solver.
			v.layout.set_minimum_size (v.minimum_width, v.minimum_height)

			update_objective_function
		end

	remove_constraint (a_constraint: EV_LAYOUT_CONSTRAINT)
		do
			a_constraint.constraint.remove
			constraints.prune_all (a_constraint)
			update_objective_function
			update_constraints
		ensure
			constraint_removed: not constraints.has (a_constraint)
		end

	update_constraints
		local
			l_subsystem_finder: LINEAR_PROGRAM_SUBSYSTEM_FINDER
			l_exception: DEVELOPER_EXCEPTION
		do
			lp.solve
			if not (lp.last_result = {LINEAR_PROGRAM_CONSTANTS}.result_type_optimal) then
				create l_subsystem_finder.make_with_program (lp)
					-- Analyze the linear program in the attempt to find the constraints in conflict.
					-- Since the linear program is infeasible we want to abort the program execution
					-- giving the user a suggestion on how the layout can be fixed.
					-- With a IIS finder we aim at reducing the linear program to a set of conflicting constraints.
				l_subsystem_finder.find
					-- Print the constraints subset in human readable format
				print ("Result type: " + lp.last_result.out + "%N%N")
				print (constraints_readable_representation)
					-- Abort execution
				create l_exception
				l_exception.set_description ("Invalid layout specifications. Check log output for more information.")
				l_exception.raise
			end
				-- Assign the new sizes to each widget
			from start
			until index > count
			loop
				update_widget_layout (item)

				forth
			end
		end

feature {NONE} -- Implementation

	on_container_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
				-- Update the container's size in the linear program.
				-- Set bounds on the container variables instead of
				-- creating constraints since it is more efficient.
			set_container_bounds (0, 0, a_width, a_height)
			update_constraints
		end

feature -- Output

	constraints_readable_representation: STRING
		local
			l_widgets: HASH_TABLE [EV_WIDGET_I, VARIABLE]
			l_widget: EV_WIDGET_I
			l_widget_name : STRING
		do
			create Result.make_empty
			create l_widgets.make (count + 1)

			across layout.positions as position loop l_widgets[position.item] := Current end

			from start
			until index > count
			loop
				l_widget := item.implementation
				across l_widget.layout.positions as position loop l_widgets[position.item] := l_widget end
				forth
			end

			across constraints as layout_constraint loop
					-- If the constraint is still contained in the linear program
					-- print out the constraint
				if layout_constraint.item.constraint.index > 0 then
					print ("Constraint " + layout_constraint.item.constraint.index.out + ": ")
					across layout_constraint.item.constraint.left_hand_side as term loop
						l_widget := l_widgets[term.item.variable]
						l_widget_name := l_widget.out
						l_widget_name := l_widget_name.substring (1, l_widget_name.index_of (']', 1))
							-- Take widget name CLASS [POINTER] and cut it after the bracket
							-- then append the name for the variable and print it
						print (l_widget_name + l_widget.layout.name_for_variable (term.item.variable) + " ")
					end
					print ("%N")
				end
			end
		end

feature {NONE} -- Implementation

	lp: LINEAR_PROGRAM
			-- The linear program describing
			-- the layout of the container.

	update_objective_function
		local
			l_terms: LINKED_LIST[TERM]
			l_term: TERM
		do
			create l_terms.make

			across lp.variables as variable loop
				create l_term.make (variable.item, 1)
				l_terms.extend (l_term)
			end

			lp.set_object_function (l_terms)
		end

	update_widget_layout (a_widget: EV_WIDGET)
		local
			l_layout: EV_LAYOUTABLE
			l_x, l_y, l_w, l_h: INTEGER
		do
			l_layout := a_widget.implementation.layout

			l_x := l_layout.left_position.value.rounded
			l_y := l_layout.top_position.value.rounded
			l_w := l_layout.width.value.rounded
			l_h := l_layout.height.value.rounded

			set_item_position (a_widget, l_x, l_y)
			set_item_size (a_widget, l_w, l_h)
		end

	set_container_bounds (a_x, a_y, a_width, a_height: INTEGER)
		do
			layout.left_position.set_bounds (a_x, a_x)
			layout.top_position.set_bounds (a_y, a_y)
			layout.width.set_bounds (a_x + a_width, a_x + a_width)
			layout.height.set_bounds (a_y + a_height, a_y + a_height)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	constraints: LINKED_LIST [EV_LAYOUT_CONSTRAINT]

	interface: detachable EV_AUTOLAYOUT note option: stable attribute end;

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
