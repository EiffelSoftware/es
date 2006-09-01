indexing
	description: "Eiffel Vision vertical progress bar. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_PROGRESS_BAR_IMP

inherit
	EV_VERTICAL_PROGRESS_BAR_I
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
					
					LayoutInfo.position.x.toView = $user_pane;
					LayoutInfo.position.x.kind = kHILayoutPositionCenter;
					LayoutInfo.position.x.offset = 0.0;
					
					LayoutInfo.scale.y.toView = $user_pane;
					LayoutInfo.scale.y.kind = kHILayoutScaleAbsolute;
					LayoutInfo.scale.y.ratio = 1.0;
					
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
			if size.width < 20 and then current_style /= {CONTROLS_ANON_ENUMS}.kcontrolsizenormal then
				set_style_small
			elseif size.width >= 20 and then current_style /= {CONTROLS_ANON_ENUMS}.kcontrolsizelarge then
				set_style_large
			end
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_VERTICAL_PROGRESS_BAR;

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




end -- class EV_VERTICAL_PROGRESS_BAR_IMP

