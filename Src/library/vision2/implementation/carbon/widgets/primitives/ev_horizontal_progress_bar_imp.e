indexing
	description: "EiffelV ision horizontal progress bar. Carbonimplementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HORIZONTAL_PROGRESS_BAR_IMP

inherit
	EV_HORIZONTAL_PROGRESS_BAR_I
		redefine
			interface
		end

	EV_PROGRESS_BAR_IMP
		redefine
			interface
		end

create
	make

feature {NONE} -- Implementation

	setup_binding ( user_pane, progress_bar : POINTER ) is
			-- setup layout binding
		external
			"C inline use <Carbon/Carbon.h>"
		alias
			"[
				{
					HILayoutInfo LayoutInfo;
					LayoutInfo.version = kHILayoutInfoVersionZero;
					HIViewGetLayoutInfo ( $progress_bar, &LayoutInfo );
					
					LayoutInfo.position.y.toView = $user_pane;
					LayoutInfo.position.y.kind = kHILayoutPositionCenter;
					LayoutInfo.position.y.offset = 0.0;
					
					LayoutInfo.scale.x.toView = $user_pane;
					LayoutInfo.scale.x.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.x.ratio = 1.0;
					
					HIViewSetLayoutInfo( $progress_bar, &LayoutInfo );
					HIViewApplyLayout( $progress_bar );
				}
			]"
		end

	bounds_changed ( options : INTEGER; original_bounds, current_bounds : CGRECT_STRUCT ) is
			-- Handler for the bounds changed event
		local
			size : CGSIZE_STRUCT
		do
			create size.make_shared ( current_bounds.size )
			if size.height < 20 and then current_style /= {CONTROLS_ANON_ENUMS}.kcontrolsizenormal then
				set_style_small
			elseif size.height >= 20 and then current_style /= {CONTROLS_ANON_ENUMS}.kcontrolsizelarge then
				set_style_large
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_PROGRESS_BAR;

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




end -- class EV_HORIZONTAL_PROGRESS_BAR_IMP

