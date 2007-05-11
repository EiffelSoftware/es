indexing
	description: "Objects that creates a window that lets the user inspect the vision layout of current application"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LAYOUT_INSPECTOR

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

create
	default_create

feature {NONE} -- Implementation

	initialize is
			-- Initialize `Current' to set up tests.
		do
			Precursor {EV_TITLED_WINDOW}

			create horizontal_box
			create tree
			create vertical_box
			create refresh_button.make_with_text_and_action ("refresh", agent update_info)
			create hide_button.make_with_text_and_action ("hide", agent hide_widget)
			create show_button.make_with_text_and_action ("show", agent show_widget)
			create info_label.default_create
			info_label.align_text_left
			vertical_box.extend (refresh_button)
			vertical_box.extend (hide_button)
			vertical_box.extend (show_button)
			vertical_box.extend (info_label)
			vertical_box.disable_item_expand (refresh_button)
			vertical_box.disable_item_expand (hide_button)
			vertical_box.disable_item_expand (show_button)
			vertical_box.set_minimum_width (175)
			horizontal_box.extend (tree)
			horizontal_box.extend (vertical_box)
			horizontal_box.disable_item_expand (vertical_box)
			extend (horizontal_box)

			set_title ("Layout Inspector")
			set_minimum_size (500, 300)
			update_info
			show
			set_x_position (600)
		end

	update_info is
			--
		local
			n: EV_TREE_ITEM
			env: EV_ENVIRONMENT
			window_list: LINEAR [EV_WINDOW]
		do
			tree.wipe_out

			create env
			window_list := env.application.windows
			from
				window_list.start
			until
				window_list.after
			loop
				create n.make_with_text (window_list.item.title)
				tree.extend (n)
				add_children(n, window_list.item)
				window_list.forth
			end
		end

	add_children (a_node: EV_TREE_NODE; a_container: EV_CONTAINER) is
			--
		local
			node: EV_TREE_ITEM
			splitarea: EV_SPLIT_AREA
			wlist: EV_WIDGET_LIST
			container: EV_CONTAINER
		do
			splitarea ?= a_container
			wlist ?= a_container
			if splitarea /= Void then
				-- The split area needs special treatment
				splitarea.go_to_first
				create node.make_with_text (a_container.item.generating_type)
				a_node.extend (node)
				node.select_actions.extend (agent selected (a_container.item))
				container ?= a_container.item
				if container /= Void then
					add_children(node, container)
				end
				splitarea.go_to_second
				create node.make_with_text (a_container.item.generating_type)
				a_node.extend (node)
				node.select_actions.extend (agent selected (a_container.item))
				container ?= a_container.item
				if container /= Void then
					add_children(node, container)
				end
			elseif wlist /= Void then
				-- Okay, we have a widget which can have several children
				from
					wlist.start
				until
					wlist.index > wlist.count
				loop
					create node.make_with_text (wlist.item.generating_type)
					a_node.extend (node)
					node.select_actions.extend (agent selected (wlist.item))
					container ?= wlist.item
					if container /= Void then
						add_children(node, container)
					end
					wlist.forth
				end
			elseif a_container.readable and then a_container.item /= Void then
				create node.make_with_text (a_container.item.generating_type)
				a_node.extend (node)
				node.select_actions.extend (agent selected (a_container.item))
				container ?= a_container.item
				if container /= Void then
					add_children(node, container)
				end
			end
		end

	selected (a_widget: EV_WIDGET) is
			--
		local
			any: EV_ANY_IMP
			w: EV_CARBON_WIDGET_IMP
		do
			w ?= a_widget.implementation
			selected_widget := a_widget
			info_label.set_text (
				"Relative Position: " + a_widget.x_position.out + "x" + a_widget.y_position.out + "%N" +
				"Screen Position: " + a_widget.screen_x.out + "x" + a_widget.screen_y.out + "%N" +
				"%N" +
				"Minimum Size: " + a_widget.minimum_width.out + "x" + a_widget.minimum_height.out + "%N" +
				"Actual Size: "+ a_widget.width.out + "x" + a_widget.height.out + "%N" + "Expandable: " + w.expandable.out )
		end

	selected_widget: EV_WIDGET

	show_widget is
			--
		do
			if selected_widget /= Void then
				selected_widget.show
			end
		end

	hide_widget is
			--
		do
			if selected_widget /= Void then
				selected_widget.hide
			end
		end


feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
			-- Currently do not care about this check, so we
			-- are turning it off.
		do
			Result := True
		end

	horizontal_box: EV_HORIZONTAL_BOX

	vertical_box: EV_VERTICAL_BOX

	tree: EV_TREE

	refresh_button: EV_BUTTON

	hide_button: EV_BUTTON

	show_button: EV_BUTTON

	info_label: EV_LABEL

invariant
	invariant_clause: True -- Your invariant here

end
