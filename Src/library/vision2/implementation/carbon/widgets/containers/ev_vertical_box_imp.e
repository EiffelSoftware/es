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
			insert_i_th
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
			res : INTEGER
			a_null:POINTER
		do
			base_make( an_interface )
			create rect.make_new_unshared
			rect.set_top ( 0)
			rect.set_left ( 0 )
			rect.set_right ( 0 )
			rect.set_bottom ( 0 )
			res := create_user_pane_control_external ( a_null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )

			set_c_object ( control_ptr )
			id:=app_implementation.get_id (current)  --getting an id from the application
		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			w1, w2 : EV_WIDGET_IMP
			j : INTEGER
			err : INTEGER
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			a_point : CGPOINT_STRUCT
			control_height : REAL_32
		do
			Precursor (v, i)

			-- Get initial positions right
			create a_rect.make_new_unshared
			create a_size.make_new_unshared
			create a_point.make_new_unshared
			control_height := ( height - (count-1)*padding ) / count
			from
				j := 1
			until
				j > count
			loop
					w1 ?= i_th ( j ).implementation
					check
						w1_not_void : w1 /= Void
					end
					a_point.set_x ( 0 )
					a_point.set_y ( (j-1) * height / count )
					a_size.set_width ( width )
					a_size.set_height ( control_height )
					a_rect.set_origin ( a_point.item )
					a_rect.set_size ( a_size.item )
					err := hiview_set_frame_external ( w1.c_object, a_rect.item )

					j := j + 1
			end

			-- Bind control positions
			from
				j := 1
			until
				j > count
			loop
				if j = 1 then
					--w1 := Void
					w2 ?= i_th ( j ).implementation
					check
						w2_not_void : w2 /= Void
					end
					--setup_binding( null, w2.c_object, count, padding )
				else
					w1 ?= i_th ( j - 1 ).implementation
					w2 ?= i_th ( j ).implementation
					check
						w1_not_void : w1 /= Void
						w2_not_void : w2 /= Void
					end
					--setup_binding( w1.c_object, w2.c_object, count, padding )
				end
				j := j + 1
			end
		end

		setup_binding ( upper_control, lower_control : POINTER; a_count, a_padding : INTEGER ) is
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo ( $lower_control, &LayoutInfo );
					
					// Always occupy full width of the box
					LayoutInfo.scale.x.toView = NULL;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.0;
					
					LayoutInfo.scale.y.toView = NULL;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.0 / $a_count;
					
					// always allign to the box in x-direction
					LayoutInfo.position.x.toView = NULL;
					LayoutInfo.position.x.kind = kHILayoutPositionLeft;
					LayoutInfo.position.x.offset = 0.0;
					
					if ( $upper_control != NULL )
					{
						LayoutInfo.position.y.toView = $upper_control;
						LayoutInfo.position.y.kind = kHILayoutPositionBottom;
						LayoutInfo.position.y.offset = 100;
					}
					else
					{
						LayoutInfo.position.y.toView = NULL;
						LayoutInfo.position.y.kind = kHILayoutPositionTop;
						LayoutInfo.position.y.offset = 0.0;
					}
					HIViewSetLayoutInfo( $lower_control, &LayoutInfo );
					HIViewApplyLayout( $lower_control );
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

