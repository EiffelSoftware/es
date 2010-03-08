indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EGX_GDL_GRAPH_STYLE

feature -- Access

	line_thickness: STRING
			-- Line thickness

	line_color: STRING
			-- Line color

	line_style: STRING
			-- Line style

	node_color: STRING
			-- Node color

	border_color: STRING
			-- Border color

feature -- Setting

	set_line_color (a_line_color: like line_color) is
			-- Set `line_color' with `a_line_color'.
		require
			a_line_color_attached: a_line_color /= Void
		do
			line_color := a_line_color
		ensure
			line_color_set: line_color = a_line_color
		end

	set_line_style (a_line_style: like line_style) is
			-- Set `line_style' with `a_line_style'.
		require
			a_line_style_attached: a_line_style /= Void
		do
			line_style := a_line_style
		ensure
			line_style_set: line_style = a_line_style
		end

	set_line_thickness (a_line_thickness: like line_thickness) is
			-- Set `line_thickness' with `a_line_thickness'.
		require
			a_line_thickness_attached: a_line_thickness /= Void
		do
			line_thickness := a_line_thickness
		ensure
			line_thickness_set: line_thickness = a_line_thickness
		end

	set_node_color (a_node_color: like node_color) is
			-- Set `node_color' with `a_node_color'.
		require
			a_node_color_attached: a_node_color /= Void
		do
			node_color := a_node_color
		ensure
			node_color_set: node_color = a_node_color
		end

	set_border_color (a_border_color: like border_color) is
			-- Set `border_color' with `a_border_color'.
		require
			a_border_color_attached: a_border_color /= Void
		do
			border_color := a_border_color
		ensure
			border_color_set: border_color = a_border_color
		end

end
