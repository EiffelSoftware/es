indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EGX_SHARED_GDL_GRAPH_PRINTER_STYLES

feature -- Path styles

	default_style: EGX_GDL_GRAPH_STYLE is
			-- Default style
		once
			create Result
			Result.set_line_color ("black")
			Result.set_line_thickness ("1")
			Result.set_line_style ("solid")
			Result.set_node_color ("white")
			Result.set_border_color ("black")
		ensure
			result_attached: Result /= Void
		end

	pass_style: EGX_GDL_GRAPH_STYLE is
			-- Pass style
		once
			create Result
			Result.set_line_color ("darkgreen")
			Result.set_line_thickness ("1")
			Result.set_line_style ("solid")
			Result.set_node_color ("white")
			Result.set_border_color ("darkgreen")
		ensure
			result_attached: Result /= Void
		end

	fail_style: EGX_GDL_GRAPH_STYLE is
			-- Pass style
		once
			create Result
			Result.set_line_color ("red")
			Result.set_line_thickness ("1")
			Result.set_line_style ("solid")
			Result.set_node_color ("white")
			Result.set_border_color ("red")
		ensure
			result_attached: Result /= Void
		end

end
