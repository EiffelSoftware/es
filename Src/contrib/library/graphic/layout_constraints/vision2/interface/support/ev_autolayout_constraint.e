note
	description: "A helper object for building a layout constraint defined with the visual format."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT_CONSTRAINT

feature -- Access

	widget: EV_WIDGET assign set_widget

	name: STRING assign set_name

	spacing: INTEGER assign set_spacing

	size: INTEGER assign set_size

	relative_size: EV_WIDGET assign set_relative_size

feature -- Element Change

	set_widget (a_widget: like widget)
		do
			widget := a_widget
		end

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_spacing (a_spacing: like spacing)
		do
			spacing := a_spacing
		end

	set_size (a_size: like size)
		do
			size := a_size
		end

	set_relative_size (a_relative_size: like relative_size)
		do
			relative_size := a_relative_size
		end

note
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
