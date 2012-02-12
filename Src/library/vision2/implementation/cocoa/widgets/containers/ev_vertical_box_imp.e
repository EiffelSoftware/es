note
	description: "EiffelVision vertical box. Cocoa implementation."
	author:	"Daniel Furrer, Emanuele Rudel"
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
			insert_i_th,
			set_child_expandable
		end
create
	make

feature {NONE} -- Implementation

	insert_i_th (v: like item; i: INTEGER_32)
		local
			v_imp: detachable EV_WIDGET_IMP
		do
			Precursor (v, i)
			v_imp ?= v.implementation
			check v_imp /= Void end

			v_imp.set_left_padding (0)
			v_imp.set_right_padding (0)

			if i - 1 >= 1 then
				check attached {EV_WIDGET_IMP} i_th (i-1).implementation as l_prev then
					remove_constraint_ (l_prev.bottom_constraint)
					set_vertical_padding_constraints (l_prev.attached_view, v_imp.attached_view, padding)
				end

			end
			if i + 1 <= count then
				check attached {EV_WIDGET_IMP} i_th (i+1).implementation as l_next then
					remove_constraint_ (l_next.top_constraint)
					set_vertical_padding_constraints (v_imp.attached_view, l_next.attached_view, padding)
				end
			end

			if i = 1 then
				v_imp.set_top_padding (1)
			end
			if i = count then
				v_imp.set_bottom_padding (1)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Status settings

	set_child_expandable (child: EV_WIDGET; flag: BOOLEAN)
		local
			w_imp: EV_WIDGET_IMP
		do
			w_imp ?= child.implementation
			check w_imp /= Void end

			Precursor {EV_BOX_IMP} (child, flag)
--			if flag then
--				w_imp.set_minimum_height (w_imp.minimum_height)
--			else
--				w_imp.set_fixed_height (w_imp.minimum_height)
--			end
		end

	set_padding (value: INTEGER)
			-- Assign `value' to `padding'.
		do
			padding := value
			update_vertical_padding_constraints (padding)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_VERTICAL_BOX note option: stable attribute end;

end -- class EV_VERTICAL_BOX_IMP
