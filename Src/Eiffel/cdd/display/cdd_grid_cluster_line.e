indexing
	description: "Objects that display a cluster within a grid structure"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID_CLUSTER_LINE

inherit
	CDD_GRID_LINE [CONF_CLUSTER]
		rename
			row_data as target_cluster
		redefine
			make_with_row
		end

	CDD_GRID_HELPER [EIFFEL_CLASS_C, CDD_GRID_CLASS_LINE]
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make_with_row

feature {NONE} -- Initialization

	make_with_row (a_row: like grid_row; a_cluster: like target_cluster) is
			-- Set `grid_row' to `a_row' and `cluster_under_test' to `a_cluster'.
			-- Define first item of `grid_row' for displaying `cluster_under_test'.
		local
			l_cluster: CLUSTER_I
		do
			Precursor (a_row, a_cluster)

			name_item.set_pixmap (pixmaps.icon_pixmaps.tool_clusters_icon)
			name_item.token_writer.new_line
			l_cluster ?= target_cluster
			name_item.token_writer.process_cluster_name_text (target_cluster.name, l_cluster, False)
			name_item.set_text_with_tokens (name_item.token_writer.last_line.content)

			grid_row.select_actions.extend (agent do grid_row.disable_select end)
		end

feature -- Access

	data_from_test_case (a_tc: CDD_TEST_CASE): EIFFEL_CLASS_C is
			-- Attribute of `a_tc' displayed in sublines of `Current'.
		do
			Result := a_tc.class_under_test
		end

feature {NONE} -- Element change

	create_new_line (a_row_index: INTEGER; a_class: EIFFEL_CLASS_C) is
			-- Create a subline for displaying `a_class' with row at position `a_row_index'.
		do
			create last_created_line.make_with_row (grid.row (a_row_index), a_class)
		end

end -- Class CDD_GRID_CLUSTER_LINE
