note
	description:
		"[
			Container that allows placement of widgets using layout constraints.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT

inherit
	EV_FIXED
		redefine
			implementation,
			create_implementation
		end

feature -- Operations

	create_constraint (a_expression: EV_LAYOUT_EXPRESSION)
			-- Create a new layout constraint based on the given expression.
			-- The widgets involved in the constraint must be in the container.
		require
			expression_not_void: a_expression /= Void
		do
			implementation.create_constraint (a_expression)
		ensure
			last_constraint_set: last_constraint /= Void
		end

	create_constraints_with_format (a_layout_format: STRING; a_widgets: ARRAY [EV_WIDGET])
		require
			layout_not_empty: a_layout_format /= Void and then not a_layout_format.is_empty
			widgets_not_empty: a_widgets /= Void and then a_widgets.count > 0
		do
			implementation.create_constraints_with_format (a_layout_format, a_widgets)
		ensure
			last_constraint_set: last_constraint /= Void
		end

	update_constraints
			-- When a constraint has changed, the container can be manually triggered
			-- to reflect the UI changes immediately.
		do
			implementation.update_constraints
		end

feature -- Access

	last_constraint: detachable EV_LAYOUT_CONSTRAINT
			-- The last created constraint.
			-- Void if no constraint has been created yet.
		do
			Result := implementation.last_constraint
		end

	constraints: LINKED_LIST [EV_LAYOUT_CONSTRAINT]
		do
			Result := implementation.constraints
		end

feature {EV_AUTOLAYOUT_PARSER} -- Operations

	create_linear_constraint (multiplier: DOUBLE; first_attribute: EV_LAYOUT_ATTRIBUTE; a_constant: DOUBLE; a_sign: INTEGER; second_attribute: EV_LAYOUT_ATTRIBUTE)
			-- Create a new layout constraint and apply it to the container.
			-- The widgets involved in the constraint must be in the container or creating
			-- the constraint will produce an error.
		do
			implementation.create_linear_constraint (multiplier, first_attribute, a_constant, a_sign, second_attribute)
		end


	create_single_linear_constraint (a_attribute: EV_LAYOUT_ATTRIBUTE; a_sign: INTEGER; a_constant: DOUBLE)
			-- Create a constraint that is applied to one widget only
			-- and has no relation to other elements.
			-- The widget involved in the constraint must be in the container or the
			-- constraint creation will produce an error.
		do
			implementation.create_single_linear_constraint (a_attribute, a_sign, a_constant)
		end

feature -- Element change

	remove_constraint (a_constraint: EV_LAYOUT_CONSTRAINT)
		do
			implementation.remove_constraint (a_constraint)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_AUTOLAYOUT_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EV_AUTOLAYOUT_IMP} implementation.make
		end

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
