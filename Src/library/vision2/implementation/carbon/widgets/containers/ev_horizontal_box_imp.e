indexing
	description:
		"EiffelVision horizontal box. Carbon implementation."

class
	EV_HORIZONTAL_BOX_IMP

inherit
	EV_HORIZONTAL_BOX_I
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
			-- The minimum width of a horizontal box is the maximum of the minimum_width's of its children
	local
		a, b, i: INTEGER
	do
		a := internal_minimum_width
		from
			b := 0
			i := 1
		until
			(i = 0) or (i = count + 1)
		loop
			b := b + i_th(i).minimum_width
			i := i + 1
		end
		b := b + child_offset_left + child_offset_right + (count-1) * padding
		Result := a.max (b)
	end

	minimum_height: INTEGER is
			-- The minimum height of a horizontal box is the sum of the minimum_width's of its children
	local
		a, b, i: INTEGER
	do
		a := internal_minimum_height
		from
			b := 0
			i := 1
		until
			(i = 0) or (i = count + 1)
		loop
			b := b.max (i_th(i).minimum_height)
			i := i + 1
		end
		b := b  + child_offset_bottom + child_offset_top
		Result := a.max (b)
	end


feature -- Implementation

	dummy_control : POINTER

	carbon_arrange_children is
			-- Setup positioning constraints for all children
		local
			w1, w2 : EV_WIDGET_IMP
			j, i : INTEGER
			err : INTEGER
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			a_point : CGPOINT_STRUCT
			control_width: REAL
			old_width : INTEGER
			initial_control_width: INTEGER
			non_expandable_width : INTEGER
			expandable_width : INTEGER
			last_x : INTEGER
		do
			-- Setup
			create a_rect.make_new_unshared
			create a_size.make_shared ( a_rect.size )
			create a_point.make_shared ( a_rect.origin )

			-- Calculate height of all non-expandable controls
			from
				i := 1
			until
				(i = 0) or (i = count + 1)
			loop
				w1 ?= i_th(i).implementation
				check
					w1_not_void : w1 /= Void
				end
				if w1.expandable then
					expandable_width := expandable_width + w1.minimum_width
				else
					non_expandable_width := non_expandable_width + w1.minimum_width
				end
				--size_control_external ( w1.c_object, w1.minimum_width, height -child_offset_top - child_offset_bottom ) -- Set optimal size here, we need it later
				-- Ueli : Why?
				i := i + 1
			end

			-- Set width of userpane so that it can accomodate all widgets + padding
			old_width := width -- save old width
			size_control_external ( c_object, expandable_width + non_expandable_width + (count-1)*padding + child_offset_left + child_offset_right, height )

			if is_homogeneous then
				control_width := ( (old_width - (count-1) * padding - child_offset_left -child_offset_right)  / count ).rounded
			else
				control_width := ( (old_width - non_expandable_width - expandable_width - (count-1) * padding - child_offset_left -child_offset_right) / expandable_item_count ).rounded
			end

			from
				last_x := -padding + child_offset_right
				i := 1
				w2 ?= i_th ( 1 ).implementation
				check
					w2_not_void : w2 /= Void
				end
				setup_binding( default_pointer, w2.c_object , child_offset_left, child_offset_right, child_offset_bottom, child_offset_top, padding)
			until
				(i = 0) or (i = count + 1)
			loop
				w1 ?= i_th(i).implementation
				check
					w1_not_void : w1 /= Void
				end

				a_point.set_x ( last_x + padding )
				a_point.set_y ( child_offset_top )
				a_size.set_height ( height - child_offset_right - child_offset_left)

				if w1.expandable then
					a_size.set_width ( w1.minimum_width + control_width)
				elseif is_homogeneous then
					a_size.set_width ( control_width)
				else
					a_size.set_width ( w1.minimum_width )
				end
				err := hiview_set_frame_external ( w1.c_object, a_rect.item )
				setup_binding( w2.c_object, w1.c_object , child_offset_left, child_offset_right, child_offset_bottom, child_offset_top, padding)

				last_x := (a_point.x + a_size.width + padding).rounded
				i := i + 1
				w2 := w1
			end
			size_control_external ( c_object, old_width, height )
		end

		setup_binding ( left_control, right_control: POINTER; left_of, right_of, bottom_of, top_of, a_padding: INTEGER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo( $right_control, &LayoutInfo );
					
					
					// always allign to the box in y-direction
					LayoutInfo.position.y.toView = NULL;
					LayoutInfo.position.y.kind = kHILayoutPositionTop;
					LayoutInfo.position.y.offset = $top_of;	
					
					if ( $left_control != NULL )
					{
						// Bind to right control (maintain padding)
						LayoutInfo.binding.left.toView = $left_control;
						LayoutInfo.binding.left.kind = kHILayoutBindRight;
						LayoutInfo.binding.left.offset = 0;
					}
					else
					{
						// for leftmost control
						LayoutInfo.position.x.toView = NULL;
						LayoutInfo.position.x.kind = kHILayoutPositionLeft;
						LayoutInfo.position.x.offset = 0.0;
					}
					HIViewSetLayoutInfo( $right_control, &LayoutInfo );
					HIViewApplyLayout( $right_control );
				}
			]"
		end

feature {NONE} -- Events

	bounds_changed ( options : NATURAL_32; original_bounds, current_bounds : CGRECT_STRUCT ) is
			-- Handler for the bounds changed event
		local
			w_imp : EV_WIDGET_IMP
			control_width, control_height, i :INTEGER
			expandable_width, non_expandable_width : INTEGER
			a_size : CGSIZE_STRUCT
		do

			-- Calculate height of all controls
			from
				i := 1
			until
				(i = 0) or (i = count + 1)
			loop
				w_imp ?= i_th(i).implementation
				check
					w_imp_not_void : w_imp /= Void
				end
				if w_imp.expandable then
					expandable_width := expandable_width + w_imp.minimum_width
				else
					non_expandable_width := non_expandable_width + w_imp.minimum_width
				end
				i := i + 1
			end
			control_height := height - child_offset_top - child_offset_bottom
			if is_homogeneous then -- Make all control equally high
				control_width := ((width - child_offset_left - child_offset_right - (count - 1) * padding)/ count).rounded
				from
					i := 1
				until
					(i = 0) or (i = count + 1)
				loop
					w_imp ?= i_th(i).implementation
					check
						w_imp_not_void : w_imp /= Void
					end
					size_control_external (	w_imp.c_object, control_width, control_height )
					i := i + 1
				end
			else
				control_width := ( (width - non_expandable_width - expandable_width - child_offset_left - child_offset_right - (count - 1) * padding) / expandable_item_count ).rounded
				from
					i := 1
				until
					(i = 0) or (i = count + 1)
				loop
					w_imp ?= i_th(i).implementation
					check
						w_imp_not_void : w_imp /= Void
					end
					if w_imp.expandable then
						size_control_external ( w_imp.c_object, w_imp.minimum_width + control_width, control_height )
					else
						size_control_external ( w_imp.c_object, w_imp.minimum_width, control_height )
					end
					i := i + 1
				end
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_BOX;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_BOX_IMP

