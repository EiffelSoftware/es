indexing
	description:
		"EiffelVision vertical box. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "container, box, vertical"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_BOX_IMP

inherit
	EV_VERTICAL_BOX_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_BOX_IMP
		redefine
			interface,
			make,
			minimum_width,
			minimum_height
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a vertical box.
		local
			control_ptr : POINTER
			rect : RECT_STRUCT
			err : INTEGER
		do
			base_make( an_interface )
			create rect.make_new_unshared
			rect.set_top ( 0)
			rect.set_left ( 0 )
			rect.set_right ( 0 )
			rect.set_bottom ( 0 )
			err := create_user_pane_control_external ( null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )
			set_c_object ( control_ptr )

			err := create_user_pane_control_external ( null, rect.item, 0, $dummy_control )
			err := hiview_add_subview_external ( c_object, dummy_control )
		end

feature -- Measturement

	minimum_width: INTEGER is
			-- The minimum width of a vertical box is the maximum of the minimum_width's of its children
	local
		a, b: INTEGER
	do
		a := internal_minimum_width
		from
			b := 0
			start
		until
			off
		loop
			b := b.max(item.minimum_width)
			forth
		end
		Result := a.max (b)
	end

	minimum_height: INTEGER is
			-- The minimum height of a horizontal box is the sum of the minimum_width's of its children
	local
		a, b: INTEGER
	do
		a := internal_minimum_height
		from
			b := 0
			start
		until
			off
		loop
			b := b + item.minimum_height
			forth
		end
		Result := a.max (b) + 20
	end

feature -- Implementation

	dummy_control : POINTER

	carbon_arrange_children is
			-- Setup positioning constraints for all children
		local
			w1, w2 : EV_WIDGET_IMP
			j : INTEGER
			err : INTEGER
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			a_point : CGPOINT_STRUCT
			control_height : REAL
			old_height : INTEGER
			initial_control_height : INTEGER
			non_expandable_height : INTEGER
			expandable_height : INTEGER
			last_y : INTEGER
		do
			-- Setup
			create a_rect.make_new_unshared
			create a_size.make_shared ( a_rect.size )
			create a_point.make_shared ( a_rect.origin )

			-- Calculate height of all controls
			from
				start
			until
				off
			loop
				w1 ?= item.implementation
				check
					w1_not_void : w1 /= Void
				end
				if w1.expandable then
					expandable_height := expandable_height + w1.minimum_height
					size_control_external ( w1.c_object, width, w1.minimum_height ) -- Set optimal size here, we need it later
				else
					non_expandable_height := non_expandable_height + w1.minimum_height
					size_control_external ( w1.c_object, width, w1.minimum_height ) -- Set optimal size here, we need it later
				end
				forth
			end

			-- Set height of userpane so that it can accomodate all widgets + padding
			old_height := height -- save old height
			initial_control_height := 20

			if is_homogeneous then
				expandable_height := count * initial_control_height
				size_control_external ( c_object, width, expandable_height + (count-1)*padding )
			else
				size_control_external ( c_object, width, expandable_height + non_expandable_height + (count-1)*padding )
			end

			if is_homogeneous then
				control_height := ( height - (count-1)*padding ) / count
			end

			from
				start
				last_y := -padding
			until
				off
			loop
					w1 ?= item.implementation
					check
						w1_not_void : w1 /= Void
					end

					a_point.set_x ( 0 )
					a_point.set_y ( last_y + padding )
					a_size.set_width ( width )
					if w1.expandable or is_homogeneous then
						a_size.set_height ( control_height )
					else
						a_size.set_height ( w1.minimum_height )
					end

					err := hiview_set_frame_external ( w1.c_object, a_rect.item )
					last_y := (a_point.y + a_size.height).rounded
					forth
			end

			-- Bind control positions
			w2 ?= i_th ( 1 ).implementation
			check
				w2_not_void : w2 /= Void
			end

			setup_binding( default_pointer, w2.c_object )

			from
				j := 2
			until
				j > count
			loop
				w1 ?= i_th ( j - 1 ).implementation
				w2 ?= i_th ( j ).implementation
				check
					w1_not_void : w1 /= Void
					w2_not_void : w2 /= Void
				end

				setup_binding( w1.c_object, w2.c_object )

				j := j + 1
			end

			size_control_external ( c_object, width, old_height )
		end


		setup_binding ( upper_control, lower_control : POINTER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo( $lower_control, &LayoutInfo );
					
					// always allign to the box in x-direction
					LayoutInfo.position.x.toView = NULL;
					LayoutInfo.position.x.kind = kHILayoutPositionLeft;
					LayoutInfo.position.x.offset = 0.0;
					
					if ( $upper_control != NULL )
					{
						// Bind to upper control (maintain padding)
						LayoutInfo.binding.top.toView = $upper_control;
						LayoutInfo.binding.top.kind = kHILayoutBindBottom;
						LayoutInfo.binding.top.offset = 0;
					}
					else
					{
						// For topmost control
						LayoutInfo.position.y.toView = NULL;
						LayoutInfo.position.y.kind = kHILayoutPositionTop;
						LayoutInfo.position.y.offset = 0.0;
					}
					HIViewSetLayoutInfo( $lower_control, &LayoutInfo );
					HIViewApplyLayout( $lower_control );
				}
			]"
		end

feature {NONE} -- Events

	bounds_changed ( options : NATURAL_32; original_bounds, current_bounds : CGRECT_STRUCT ) is
			-- Handler for the bounds changed event
		local
			w_imp : EV_WIDGET_IMP
			control_width, control_height :INTEGER
			expandable_height, non_expandable_height : INTEGER
		do
			-- Calculate height of all controls
			from
				start
			until
				off
			loop
				w_imp ?= item.implementation
				check
					w_imp_not_void : w_imp /= Void
				end
				if w_imp.expandable then
					expandable_height := expandable_height + w_imp.minimum_height
				else
					non_expandable_height := non_expandable_height + w_imp.minimum_height
				end
				forth
			end

			control_width := width
			if is_homogeneous then -- Make all control equally high
				control_height := (height / count).rounded
				from
					start
				until
					off
				loop
					w_imp ?= item.implementation
					check
						w_imp_not_void : w_imp /= Void
					end
					size_control_external (	w_imp.c_object, control_width, control_height )
					forth
				end
			else
				control_height := ( (height - non_expandable_height - expandable_height) / expandable_item_count ).rounded
				if control_height < 0 then
					control_height := 0
				end
				from
					start
				until
					off
				loop
					w_imp ?= item.implementation
					check
						w_imp_not_void : w_imp /= Void
					end
					if w_imp.expandable then
						size_control_external ( w_imp.c_object, control_width, w_imp.minimum_height + control_height )
					else
						size_control_external ( w_imp.c_object, control_width, w_imp.minimum_height )
					end
					forth
				end
			end
		end

feature {EV_ANY_I} -- Implementation

    interface: EV_VERTICAL_BOX;

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_VERTICAL_BOX_IMP

