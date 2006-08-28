indexing
	description:
		"Eiffel Vision container, Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "container"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_CONTAINER_IMP

inherit
	EV_CONTAINER_I
		redefine
			interface,
			propagate_foreground_color,
			propagate_background_color
		end

	EV_WIDGET_IMP
		redefine
			interface,
			initialize,
			destroy,
			set_parent_imp,
			minimum_width,
			minimum_height
		end

	EV_CONTAINER_ACTION_SEQUENCES_IMP
	CONTROLS_FUNCTIONS_EXTERNAL
	PLATFORM

feature {NONE} -- Initialization

	initialize is
			-- Create `shared_pointer' for radio groups.
		do
			Precursor {EV_WIDGET_IMP}
			create shared_pointer
		end

feature -- Access

	container_widget: POINTER is
		do
			Result := visual_widget
		end

	client_width: INTEGER is
			-- Width of the client area of container.
			-- Redefined in children.
		do
			Result := width
		end

	client_height: INTEGER is
			-- Height of the client area of container
			-- Redefined in children.
		do
			Result := height
		end

	background_pixmap: EV_PIXMAP
			-- the background pixmap

feature -- Element change

	replace (v: like item) is
			-- Replace `item' with `v'.
			--ueli: copied actual version from ev_window made by Jann
		local
			w: EV_WIDGET_IMP
			err: INTEGER
			root_control_ptr: POINTER
		do
			if not interface.is_empty then
				w ?= interface.item.implementation
				on_removed_item (w)
				check
					item_has_implementation: w /= Void
				end
				dispose_control_external( w.c_object )
			end
			if v /= Void then
				w ?= v.implementation
				err := get_root_control_external ( c_object, $root_control_ptr ) -- Get the root control of the window
				err := embed_control_external ( w.c_object, root_control_ptr )
				on_new_item (w)
			end

		end

feature -- Measurement

	minimum_width: INTEGER is
			-- If not set otherwise, the minimum width of a container is equal to the minimum width of 'item'
		do
			if internal_minimum_width /= -1 then
				Result := internal_minimum_width
			else
				if interface.count > 0 then
					Result := item.minimum_width
				end
			end
		end

	minimum_height: INTEGER is
			-- If not set otherwise, the minimum height of a container is equal to the minimum height of 'item'
		do
			if internal_minimum_height /= -1 then
				Result := internal_minimum_height
			else
				if interface.count > 0 then
					Result := item.minimum_height
				end
			end
		end

feature {EV_RADIO_BUTTON_IMP, EV_CONTAINER_IMP} -- Access

	shared_pointer: POINTER_REF
			-- Reference to `radio_group'. Used to share the
			-- pointer `radio_group' with merged containers even when
			-- its value is still `NULL'.

	set_shared_pointer (p: POINTER_REF) is
			-- Assign `p' to `shared_pointer'.
		do
			shared_pointer.set_item (p)
		end

	set_radio_group (p: POINTER) is
			-- Assign `p' to `radio_group'.
		do
			shared_pointer.set_item (p)
		end

	radio_group: POINTER is
			-- GSList with all radio items of this container.
			-- `Current' Shares reference with merged containers.
		do
			Result := shared_pointer.item
		end

feature -- Status setting

	connect_radio_grouping (a_container: EV_CONTAINER) is
			-- Join radio grouping of `a_container' to `Current'.
		do
		end

	unconnect_radio_grouping (a_container: EV_CONTAINER) is
			-- Remove Join of `a_container' to radio grouping of `Current'.
		do
		end

	add_radio_button (a_widget_imp: EV_WIDGET_IMP) is
			-- Called every time a widget is added to the container.
		require
			a_widget_imp_not_void: a_widget_imp /= Void
		do
		end

	remove_radio_button (a_widget_imp: EV_WIDGET_IMP) is
			-- Called every time a widget is removed from the container.
		require
			a_widget_imp_not_void: a_widget_imp /= Void
		do
		end

	internal_set_background_pixmap (a_pixmap: EV_PIXMAP) is
			-- Set the container background pixmap to `pixmap'.
		do
		end

	set_background_pixmap (a_pixmap: EV_PIXMAP) is
			-- Set the container background pixmap to `pixmap'.
		do
		end

	bg_pixmap (p: POINTER): POINTER is
		do
		end

	remove_background_pixmap is
			-- Make background pixmap Void.
		do
		end

feature -- Basic operations

	propagate_foreground_color is
			-- Propagate the current foreground color of the
			-- container to the children.
		do
			--precursor {EV_CONTAINER_PI}

		end

	propagate_background_color is
			-- Propagate the current background color of the
			-- container to the children.
		do
			Precursor {EV_CONTAINER_I}
			propagate_background_color_internal (background_color, c_object)
		end

feature -- Command

	destroy is
			-- Render `Current' unusable.
		do
--			if interface.prunable then
--				interface.wipe_out
--			end
			Precursor {EV_WIDGET_IMP}
		end

feature -- Event handling

	on_new_item (an_item_imp: EV_WIDGET_IMP) is
			-- Called after `an_item' is added.
		do
			an_item_imp.set_parent_imp (Current)
		end

	on_removed_item (an_item_imp: EV_WIDGET_IMP) is
			-- Called just before `an_item' is removed.
		do
			an_item_imp.set_parent_imp (Void)
		end


feature {EV_WIDGET_IMP} -- Implementation

	child_has_resized (a_widget_imp: EV_WIDGET_IMP) is
			--
		do
			-- By default do nothing
		end

	set_parent_imp (a_parent_imp: EV_CONTAINER_IMP) is
			--
		do
			Precursor {EV_WIDGET_IMP} (a_parent_imp)
			if background_pixmap /= Void and parent_imp = Void then
				-- We need to reref the background pixmap as gtk doesn't handle it properly
				-- on removal from parent of Current.
				internal_set_background_pixmap (background_pixmap)
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_CONTAINER;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_CONTAINER_IMP

