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
			-- The minimum width of a horizontal box is the sum of the minimum_width's of its children
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
			b := b + item.minimum_width
			forth
		end
		Result := a.max (b)
	end

	minimum_height: INTEGER is
			-- The minimum height of a horizontal box is the maximum of the minimum_width's of its children
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
			b := b.max(item.minimum_height)
			forth
		end
		Result := a.max (b)
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
				start
			until
				off
			loop
				w1 ?= item.implementation
				check
					w1_not_void : w1 /= Void
				end
				if w1.expandable then
					expandable_width := expandable_width + w1.minimum_width
					size_control_external ( w1.c_object, w1.minimum_width, height ) -- Set optimal size here, we need it later
				else
					non_expandable_width := non_expandable_width + w1.minimum_width
					size_control_external ( w1.c_object, w1.minimum_width, height ) -- Set optimal size here, we need it later
				end
				forth
			end

			-- Set width of userpane so that it can accomodate all widgets + padding
			old_width := width -- save old width
			initial_control_width := 20

			if is_homogeneous then
				expandable_width := count * initial_control_width
				size_control_external ( c_object, expandable_width + (count-1)*padding, height )
			else
				size_control_external ( c_object, expandable_width + non_expandable_width + (count-1)*padding, height )
			end




			-- I don't understand why the wontrol_width calculation is different then by bounds_changed. I did it now the same way.
				control_width := ( (width - non_expandable_width - expandable_width) / expandable_item_count ).rounded
				if control_width < 0 then
					control_width := 0
				end
				from
					start
					last_x := -padding
				until
					off
				loop
					w1 ?= item.implementation
					check
						w1_not_void : w1 /= Void
					end

					a_point.set_x ( last_x + padding )
					a_point.set_y ( 0 )

					a_size.set_height ( height )
					if w1.expandable or is_homogeneous then
						a_size.set_width ( w1.minimum_width + control_width)
					else
						a_size.set_width ( w1.minimum_width )
					end

					err := hiview_set_frame_external ( w1.c_object, a_rect.item )
					last_x := (a_point.x + a_size.width).rounded


					forth
				end

--			if is_homogeneous then
--				control_width := ( width - (count-1)*padding ) / count
--			end

--			from
--				start
--				last_x := -padding
--			until
--				off
--			loop
--					w1 ?= item.implementation
--					check
--						w1_not_void : w1 /= Void
--					end

--					a_point.set_x ( last_x + padding )
--					a_point.set_y ( 0 )
--					if w1.expandable or is_homogeneous then
--						a_size.set_width ( control_width )
--					else
--						a_size.set_width ( w1.minimum_width )
--					end
--					a_size.set_height ( height )

--					err := hiview_set_frame_external ( w1.c_object, a_rect.item )
--					last_x := (a_point.x + a_size.width).rounded
--					forth
--			end

			-- Bind control positions
			w2 ?= i_th ( 1 ).implementation
			check
				w2_not_void : w2 /= Void
			end
			if is_homogeneous then
				setup_binding( default_pointer, w2.c_object )
			else
				setup_binding( default_pointer, w2.c_object )
			end


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
				if is_homogeneous then
					setup_binding( w1.c_object, w2.c_object )
				else
					setup_binding( w1.c_object, w2.c_object )
				end

				j := j + 1
			end

			size_control_external ( c_object, old_width, height )
		end


		setup_binding ( left_control, right_control : POINTER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo( $right_control, &LayoutInfo );
					
					// Always occupy full height of the box
					LayoutInfo.scale.y.toView = NULL;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.0;
					
					// always allign to the box in y-direction
					LayoutInfo.position.y.toView = NULL;
					LayoutInfo.position.y.kind = kHILayoutPositionTop;
					LayoutInfo.position.y.offset = 0.0;	
					
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
			control_width, control_height :INTEGER
			expandable_width, non_expandable_width : INTEGER
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
					expandable_width := expandable_width + w_imp.minimum_width
				else
					non_expandable_width := non_expandable_width + w_imp.minimum_width
				end
				forth
			end

			control_height := height
			if is_homogeneous then -- Make all control equally high
				control_width := (width / count).rounded
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
				control_width := ( (width - non_expandable_width - expandable_width) / expandable_item_count ).rounded
				if control_width < 0 then
					control_width := 0
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
						size_control_external ( w_imp.c_object, w_imp.minimum_width + control_width, control_height )
					else
						size_control_external ( w_imp.c_object, w_imp.minimum_width, control_height )
					end
					forth
				end
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_BOX;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_BOX_IMP

