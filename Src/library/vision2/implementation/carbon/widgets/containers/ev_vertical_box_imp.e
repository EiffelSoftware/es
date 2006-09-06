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
			event_id := app_implementation.get_id (current)

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
				if not w1.expandable then
					err := hiview_get_optimal_bounds_external ( w1.c_object, a_rect.item, default_pointer )
					err := hiview_set_frame_external ( w1.c_object, a_rect.item )	-- Set optimal size here, we need it later
					non_expandable_height := non_expandable_height + a_size.height.rounded.max (w1.minimum_height)
				end
				forth
			end

			-- Set height of userpane so that it can accomodate all widgets + padding
			old_height := height -- save old height
			initial_control_height := 20

			if is_homogeneous then
				expandable_height := count * initial_control_height
				size_control_external ( c_object, width, expandable_height + (count-1)*padding )

				-- Setup dummy control
				err := hiview_place_in_superview_at_external ( dummy_control, 0, (count-1)*padding )
			else
				expandable_height := expandable_item_count * initial_control_height
				size_control_external ( c_object, width, expandable_height + non_expandable_height + (count-1)*padding )

				-- Setup dummy control
				err := hiview_place_in_superview_at_external ( dummy_control, 0, (count-1)*padding + non_expandable_height )
			end

			size_control_external ( dummy_control, width, expandable_height )
			setup_dummy_control ( dummy_control )

			if expandable_item_count > 0 and then not is_homogeneous then
				control_height := ( height - (count-1)*padding - non_expandable_height ) / expandable_item_count
			else
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
						a_size.set_height ( a_size.height.rounded.max ( w1.minimum_height ) )
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
			if is_homogeneous then
				setup_binding( default_pointer, w2.c_object, dummy_control, count, True )
			else
				setup_binding( default_pointer, w2.c_object, dummy_control, expandable_item_count, w2.expandable )
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
					setup_binding( w1.c_object, w2.c_object, dummy_control, count, True )
				else
					setup_binding( w1.c_object, w2.c_object, dummy_control, expandable_item_count, w2.expandable )
				end

				j := j + 1
			end

			size_control_external ( c_object, width, old_height )
		end


		setup_binding ( upper_control, lower_control, a_dummy_control : POINTER; a_count : INTEGER; is_expandable : BOOLEAN ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo( $lower_control, &LayoutInfo );
					
					// Always occupy full width of the box
					LayoutInfo.scale.x.toView = NULL;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.0;
					
					// always allign to the box in x-direction
					LayoutInfo.position.x.toView = NULL;
					LayoutInfo.position.x.kind = kHILayoutPositionLeft;
					LayoutInfo.position.x.offset = 0.0;

					// Scale to dummy box which is the window size - all padding
					LayoutInfo.scale.y.toView = $a_dummy_control;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					if ( $is_expandable )
						LayoutInfo.scale.y.ratio = 1.0 / $a_count;
					else
						LayoutInfo.scale.y.ratio = 0;
					
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

setup_dummy_control ( a_control: POINTER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo( $a_control, &LayoutInfo );
					
					LayoutInfo.scale.x.toView = NULL;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.0;
					
					LayoutInfo.binding.top.toView = NULL;
					LayoutInfo.binding.top.kind = kHILayoutBindTop;
					LayoutInfo.binding.top.offset = 0;
					
					LayoutInfo.binding.bottom.toView = NULL;
					LayoutInfo.binding.bottom.kind = kHILayoutBindBottom;
					LayoutInfo.binding.bottom.offset = 0;
					
					HIViewSetLayoutInfo( $a_control, &LayoutInfo );
					HIViewApplyLayout( $a_control );
				}
			]"
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

