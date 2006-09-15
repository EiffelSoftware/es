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
		export
			{NONE} all
		end

	PLATFORM

feature {NONE} -- Initialization

	initialize is
			-- Create `shared_pointer' for radio groups.
		do
			Precursor {EV_WIDGET_IMP}
		end

feature -- Access

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
		local
			w: EV_WIDGET_IMP
			ret: INTEGER
			root_control_ptr: POINTER
			cfstring: EV_CARBON_CF_STRING
		do
			if not interface.is_empty then
				w ?= interface.item.implementation
				on_removed_item (w)
				check
					item_has_implementation: w /= Void
				end
				ret := hiview_remove_from_superview_external (w.c_object)
				check
					view_removed: ret = 0
				end
			end
			if v /= Void then
				w ?= v.implementation
				ret := hiview_add_subview_external ( c_object, w.c_object )
				check
					view_added: ret = 0
				end

--				create cfstring.make_unshared (hiview_copy_text_external (w.c_object))
--				print (cfstring.string + " " + w.generator +" attached to ")
--				create cfstring.make_unshared (hiview_copy_text_external (c_object))
--				print (cfstring.string + " " + generator + "%N")

				setup_layout (w)

				on_new_item (w)
--				print (current.height.out + " - " +  w.height.out + "%N")
			end
		end

		child_offset_top: INTEGER is
				-- The offset a child needs to have from this type of container
			do
				Result := 5
			end


		setup_layout (a_widget: EV_WIDGET_IMP) is
				-- Sets the child control's size to the container site minus some spacing
		local
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			a_point : CGPOINT_STRUCT
			ret: INTEGER
		do
			-- Get initial positions right
			create a_rect.make_new_unshared
			create a_size.make_shared ( a_rect.size )
			create a_point.make_shared ( a_rect.origin )

			a_point.set_x (5)
			a_point.set_y (child_offset_top)
			a_size.set_width (width - 10)
			a_size.set_height (height - 8 - child_offset_top)
			ret := hiview_set_frame_external (a_widget.c_object, a_rect.item)

			setup_automatic_layout (a_widget.c_object, c_object)
		end

		setup_automatic_layout (a_control, a_container: POINTER) is
				-- Make the child follow it's parent when it's reszed
			external
				"C inline use <Carbon/Carbon.h>"
			alias
				"[
					{
						HILayoutInfo LayoutInfo;
						LayoutInfo.version = kHILayoutInfoVersionZero;
						HIViewGetLayoutInfo ( $a_control, &LayoutInfo );
						
						LayoutInfo.binding.left.toView = $a_container;
						LayoutInfo.binding.left.kind = kHILayoutBindLeft;
						
						LayoutInfo.binding.right.toView = $a_container;
						LayoutInfo.binding.right.kind = kHILayoutBindRight;
						
						LayoutInfo.binding.top.toView = $a_container;
						LayoutInfo.binding.top.kind = kHILayoutBindTop;
						
						LayoutInfo.binding.bottom.toView = $a_container;
						LayoutInfo.binding.bottom.kind = kHILayoutBindBottom;
						
						HIViewSetLayoutInfo( $a_control, &LayoutInfo );
						HIViewApplyLayout( $a_control );
					}
				]"
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
			if parent_imp /= void then
				parent_imp.child_has_resized (current)
			end

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

