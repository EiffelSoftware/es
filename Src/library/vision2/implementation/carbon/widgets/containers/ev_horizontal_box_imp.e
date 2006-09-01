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
			event_id:=app_implementation.get_id (current)  --getting an id from the application

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
			index > count
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
			index > count
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
		do
			-- Get initial positions right
			create a_rect.make_new_unshared
			create a_size.make_shared ( a_rect.size )
			create a_point.make_shared ( a_rect.origin )
			-- Set width of userpane so that it can accomodate all widgets + padding
			old_width := width -- save old width
			initial_control_width := 20
			size_control_external ( c_object, count * initial_control_width + (count-1)*padding, height )
			err := hiview_place_in_superview_at_external ( dummy_control, 0, (count-1)*padding )
			size_control_external ( dummy_control, count * initial_control_width, height )
			setup_dummy_control ( dummy_control )

			control_width := ( width - (count-1)*padding ) / count
			from
				j := 1
			until
				j > count
			loop
					w1 := Void
					w1 ?= i_th ( j ).implementation
					check
						w1_not_void : w1 /= Void
					end

					a_point.set_x ( (control_width + padding) * (j-1) )
					a_point.set_y ( 0 )
					a_size.set_width ( control_width )
					a_size.set_height ( height )
					err := hiview_set_frame_external ( w1.c_object, a_rect.item )
					j := j + 1
			end

			-- Bind control positions
			w2 ?= i_th ( 1 ).implementation
			check
				w2_not_void : w2 /= Void
			end
			setup_binding( null, w2.c_object, dummy_control, count )

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
				setup_binding( w1.c_object, w2.c_object, dummy_control, count )

				j := j + 1
			end

			size_control_external ( c_object, old_width, height )
		end


		setup_binding ( left_control, right_control, a_dummy_control : POINTER; a_count : INTEGER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo ( $right_control, &LayoutInfo );
					
					// Always occupy full height of the box
					LayoutInfo.scale.y.toView = NULL;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.0;
					
					// always allign to the box in y-direction
					LayoutInfo.position.y.toView = NULL;
					LayoutInfo.position.y.kind = kHILayoutPositionTop;
					LayoutInfo.position.y.offset = 0.0;
					
					// Scale to dummy box which is the window size - all padding
					LayoutInfo.scale.x.toView = $a_dummy_control;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.0 / $a_count;					
					
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

setup_dummy_control ( a_control: POINTER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo ( $a_control, &LayoutInfo );
					
					// maintain same height as the real control
					LayoutInfo.scale.y.toView = NULL;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.0;
					
					// Bind to Left and Right border of the box, so it will resize accordingly
					LayoutInfo.binding.left.toView = NULL;
					LayoutInfo.binding.left.kind = kHILayoutBindLeft;
					LayoutInfo.binding.left.offset = 0;
					
					LayoutInfo.binding.right.toView = NULL;
					LayoutInfo.binding.right.kind = kHILayoutBindRight;
					LayoutInfo.binding.right.offset = 0;
					
					HIViewSetLayoutInfo( $a_control, &LayoutInfo );
					HIViewApplyLayout( $a_control );
				}
			]"
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_BOX;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_BOX_IMP

