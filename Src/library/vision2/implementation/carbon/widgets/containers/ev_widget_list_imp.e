indexing
	description: "Eiffel Vision widget list. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "widget list, container"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_WIDGET_LIST_IMP

inherit
	EV_WIDGET_LIST_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CONTAINER_IMP
		undefine
			replace
		redefine
			interface,
			initialize
		end

	EV_DYNAMIC_LIST_IMP [EV_WIDGET]
		redefine
			interface,
			initialize
		end

feature {NONE} -- Initialization

	initialize is
			-- Initialize `Current'
		do

			Precursor {EV_CONTAINER_IMP}
			Precursor {EV_DYNAMIC_LIST_IMP}
		end

feature {NONE} -- Implementation



	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		local
			v_imp : EV_WIDGET_IMP
			err : INTEGER
			a_fixe: EV_FIXED_IMP
		do
			if v /= Void then
				v_imp ?= v.implementation
				check
					v_imp_not_void : v_imp /= Void
				end
				err := embed_control_external (v_imp.c_object, c_object  )
				child_array.go_i_th (i)
				child_array.put_left (v)
			end
			a_fixe?=v.implementation
				if a_fixe/=void then
					a_fixe.embed_all
				end
			on_new_item (v_imp)
		end

	remove_i_th (i: INTEGER) is
			-- Remove item at `i'-th position.
		do
		end

feature {NONE} -- Implementation

	list_widget: POINTER is
			-- Pointer to the actual widget list container.
		do
		end

	interface: EV_WIDGET_LIST;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'
feature
	--set
		embed_all is
			local
				i:INTEGER
				a_imp: EV_WIDGET_IMP
				err:INTEGER
				a_list: EV_WIDGET_LIST_IMP
			do
				from i:=1
				until i> child_array.count
				loop
					a_imp?=child_array.i_th(i).implementation
					if a_imp/=void then
						err := embed_control_external (a_imp.c_object, c_object)

						a_list?=a_imp
						if a_list/=void then
							a_list.embed_all
						end
					end
					i:=i+1
				end


			end

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




end -- class EV_WIDGET_LIST_IMP

