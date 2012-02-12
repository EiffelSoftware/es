note
	description: "Eiffel Vision window. Cocoa implementation."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_WINDOW_IMP

inherit
	EV_WINDOW_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_SINGLE_CHILD_CONTAINER_IMP
		undefine
			x_position,
			y_position,
			screen_x,
			screen_y,
			width,
			height,
			destroy,
			client_height,
			client_width,
			show
		redefine
			interface,
			make,
			is_sensitive,
			hide,
			destroy,
			has_focus,
			minimum_width,
			minimum_height,
			set_minimum_size,
			set_top_level_window_imp,
			dispose,
			replace
		end

	EV_WINDOW_ACTION_SEQUENCES_IMP
		redefine
			interface
		end

	EV_NS_WINDOW
		undefine
			key_down_,
			key_up_,
			flags_changed_
		redefine
			make,
			window_did_become_main_,
			window_did_resize_,
			dispose,
			set_size
		end

	EV_NS_RESPONDER

create
	make

feature {NONE} -- Initialization

	make
		local
			l_flipped_view: EV_FLIPPED_VIEW
		do
			add_objc_callback ("windowDidBecomeMain:", agent window_did_become_main_)
			add_objc_callback ("windowDidResize:", agent window_did_resize_)
			add_objc_callback ("keyDown:", agent key_down_)
			add_objc_callback ("keyUp:", agent key_up_)
			add_objc_callback ("flagsChanged:", agent flags_changed_)
			Precursor {EV_NS_WINDOW}
				-- Give the window a title bar, borders, close and minimize buttons
				-- and allow the window to be resized
			set_style_mask_ (0xF)
			allow_resize

			set_accepts_mouse_moved_events_ (True)

			set_maximum_width (10000)
			set_maximum_height (10000)
			create accel_list.make (10)

			if attached {NS_VIEW} content_view as l_content_view then
				create l_flipped_view.make
				l_flipped_view.set_frame_ (l_content_view.frame)
				set_content_view_ (l_flipped_view)
				cocoa_view := l_flipped_view
			end

			initialize
			init_bars

			set_delegate_ (Current)

			app_implementation.windows_imp.extend (Current)

			internal_is_border_enabled := True
			user_can_resize := True
			set_is_initialized (True)
		end

 	init_bars
 			-- Initialize `lower_bar' and `upper_bar'.
 		local
 			ub_imp, lb_imp: detachable EV_VERTICAL_BOX_IMP
 		do
 			create upper_bar
 			create lower_bar
 			ub_imp ?= upper_bar.implementation
  			lb_imp ?= lower_bar.implementation
  			check
  				ub_imp_not_void: ub_imp /= Void
  				lb_imp_not_void: lb_imp /= Void
  			end
  			ub_imp.on_parented
  			lb_imp.on_parented
  			ub_imp.set_parent_imp (Current)
  			if attached {NS_VIEW} content_view as l_content_view then
  				l_content_view.add_subview_ (ub_imp.attached_view)
				ub_imp.set_fixed_height (0)
  				ub_imp.set_top_padding (0)
  				ub_imp.set_left_padding (0)
				ub_imp.set_right_padding (0)
  			end
  			lb_imp.set_parent_imp (Current)
  			ub_imp.set_top_level_window_imp (Current)
  			lb_imp.set_top_level_window_imp (Current)
  		end

feature {EV_ANY_I} -- Implementation

	show_relative_to_window (a_parent: EV_WINDOW)
			-- Show `Current' with respect to `a_parent'.
		do
			show
			is_relative := True
			blocking_window := a_parent
		end

	is_relative: BOOLEAN
			-- Is `Current' shown relative to another window?

	blocking_window: detachable EV_WINDOW
			-- `Result' is window `Current' is shown to if
			-- `is_modal' or `is_relative'.

feature -- Access

	minimum_width: INTEGER
		do
			Result := attached_view.fitting_size.width.rounded
		end

	minimum_height: INTEGER
		do
			-- Title bar size is 22 pixels.
			Result := attached_view.fitting_size.height.rounded + 22
		end

feature -- Measurement

	client_height: INTEGER
		do
			check attached {NS_VIEW} content_view as l_view then
				Result := l_view.frame.size.height.truncated_to_integer
			end
		end

	client_width: INTEGER
		do
			check attached {NS_VIEW} content_view as l_view then
				Result := l_view.frame.size.width.truncated_to_integer
			end
		end

	set_size (a_width, a_height: INTEGER)
			-- Set the horizontal size to `a_width'.
			-- Set the vertical size to `a_height'.
		local
			l_width, l_height: INTEGER
		do
			l_width := a_width.max (minimum_width)
			l_height := a_height.max (minimum_height)
			Precursor (l_width, l_height)
		end

	set_minimum_size (a_minimum_width, a_minimum_height: INTEGER)
			-- Set the minimum horizontal size to `a_minimum_width'.
			-- Set the minimum vertical size to `a_minimum_height'.
		local
			l_size: NS_SIZE
		do
			create l_size.make
			l_size.set_width (a_minimum_width)
			l_size.set_height (a_minimum_height)
			set_min_size_ (l_size)
			if a_minimum_width > width then
				set_width (a_minimum_width)
			end
			if a_minimum_height > height then
				set_height (a_minimum_height)
			end
		end

 	maximum_width: INTEGER
			-- Maximum width that application wishes widget
			-- instance to have.

	maximum_height: INTEGER
			-- Maximum height that application wishes widget
			-- instance to have.

	set_maximum_width (max_width: INTEGER)
			-- Set `maximum_width' to `max_width'.
		do
			maximum_width := max_width
		end

	set_maximum_height (max_height: INTEGER)
			-- Set `maximum_height' to `max_height'.
		do
			maximum_height := max_height
		end

feature -- Widget relations

	top_level_window_imp: detachable EV_WINDOW_IMP
			-- Top level window that contains `Current'.
			-- As `Current' is a window then we return `Current'
		do
			Result := Current
		end

	set_top_level_window_imp (a_window: detachable EV_WINDOW_IMP)
			-- Make `a_window' the new `top_level_window_imp'
			-- of `Current'.
		do
			-- Do nothing. Only `Current' can be its own top level window
		end

feature  -- Access

	is_sensitive: BOOLEAN
			--
		do
			Result := True
		end

	has_focus: BOOLEAN
			-- Does `Current' have the keyboard focus?
		do
			Result := is_key_window
		end

	count: INTEGER_32
			-- Number of elements in `Current'.	
		do
			if item /= Void then
				Result := 1
			end
		end

	menu_bar: detachable EV_MENU_BAR
			-- Note: a true mapping from Cocoa to EiffelVision is impossible: in
			-- Cocoa menu bars are one-per-application and not one-per-window
			-- Horizontal bar at top of client area that contains menu's.

feature -- Status setting

	disconnect_accelerator (an_accel: EV_ACCELERATOR)
			-- Disconnect key combination `an_accel' from this window.
		do
		end

	connect_accelerator (an_accel: EV_ACCELERATOR)
			-- Disconnect key combination `an_accel' from this window.
		do
		end

	internal_disable_border
			-- Ensure no border is displayed around `Current'.
		do
				-- NSBorderlessWindowMask = 0
			set_style_mask_ (0)
		end

	internal_enable_border
			-- Ensure a border is displayed around `Current'.
		do
			-- Note: this mask also add a title bar, close/minimize buttons and allows resizing.
			-- In Cocoa having just a border around `Current' can only be achieved with custom
			-- drawing in a NSWindow subclass, although this would be too cumbersome for what we
			-- are trying to achieve here.
			set_style_mask_ (0xF)
		end

	block
			-- Wait until window is closed by the user.
		local
			app: EV_APPLICATION_IMP
		do
			from
				app := app_implementation
			until
				is_destroyed or else not is_displayed
			loop
				app.process_events
			end
		end

	disable_user_resize
			-- Forbid the resize of the window.
		do
			user_can_resize := False
			forbid_resize
		end

	enable_user_resize
			-- Allow the resize of the window.
		do
			user_can_resize := True
			allow_resize
		end

	show
		do
			if not is_visible then
				is_show_requested := True
				if show_actions_internal /= Void then
					show_actions_internal.call (Void)
				end
				make_key_and_order_front_ (Void)
			end
		end

	hide
			-- Unmap the Window from the screen.
		do
			-- Note: calling order_out_ (Void) causes EIffelStudio to close
			is_show_requested := False
			blocking_window := Void
			is_relative := False
		end

feature -- Element change

	replace (v: like item)
			-- Replace `item' with `v'.
		local
			v_imp: detachable EV_WIDGET_IMP
		do
			-- Remove current item, if any
			if attached item as l_item then
				remove_item_actions.call ([l_item])
				v_imp ?= l_item.implementation
				check
					item_has_implementation: v_imp /= Void
				end
				v_imp.attached_view.remove_from_superview
				v_imp.set_parent_imp (Void)
			end
			-- Insert new item, if any
			if attached v as l_v then
				v_imp ?= l_v.implementation
				check
					v_has_implementation: v_imp /= Void
				end
				if attached {NS_VIEW} content_view as l_view then
					l_view.add_subview_ (v_imp.attached_view)
					-- Stick view to the bottom
					v_imp.set_bottom_padding (0)
					v_imp.set_left_padding (0)
					v_imp.set_right_padding (0)
					-- Flush upper_bar and content_view
					if attached {EV_NS_VIEW} upper_bar.implementation as l_upper_imp and attached {EV_NS_VIEW} v_imp as l_v_imp then
						set_vertical_padding_constraints (l_upper_imp.attached_view, l_v_imp.attached_view, 0)
					end
					-- Uncomment for layout debugging
					--visualize_constraints_ (l_view.constraints)
				end
				v_imp.set_parent_imp (Current)
			end
			item := v
		end

	set_menu_bar (a_menu_bar: EV_MENU_BAR)
			-- Set `menu_bar' to `a_menu_bar'.
		local
			mb_imp: detachable EV_MENU_BAR_IMP
			l_menu: NS_MENU
		do
			menu_bar := a_menu_bar
			mb_imp ?= a_menu_bar.implementation
			check mb_imp /= Void end
			mb_imp.set_parent_window_imp (Current)

			app_implementation.set_cocoa_menu (l_menu)
		end

	remove_menu_bar
			-- Set `menu_bar' to `Void'.
		local
			mb_imp: detachable EV_MENU_BAR_IMP
		do
			if attached menu_bar as l_menu_bar then
				mb_imp ?= l_menu_bar.implementation
				check mb_imp /= Void end
				mb_imp.remove_parent_window
					-- Removing the menu bar in Cocoa does not let e.g. the user quit the application
					-- In this case, a mapping from Cocoa to EiffelVision is not possible
			end
			menu_bar := Void
		end

feature {NONE} -- Delegate methods

	window_did_become_main_ (a_notification: NS_NOTIFICATION)
		do
				-- Set up the Cocoa menu when the window is selected
				-- since EiffelVision allows one menu per window
			if menu_bar /= Void and then attached {EV_MENU_BAR_IMP} menu_bar.implementation as l_menu then
				app_implementation.set_cocoa_menu (l_menu.menu)
			end
		end

	window_did_resize_ (a_notification: NS_NOTIFICATION)
			-- Inform `Current' that the window has been resized.
		do
				-- Call the resize actions
			--resize_actions.call ([i,j,k,l])
		end

feature {EV_ANY_IMP} -- Implementation

	destroy
			-- Destroy `Current'
		do
			disable_capture
			hide
			Precursor {EV_SINGLE_CHILD_CONTAINER_IMP}
		end

	dispose
		do
			Precursor {EV_NS_WINDOW}
			Precursor {EV_SINGLE_CHILD_CONTAINER_IMP}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_WINDOW note option: stable attribute end;
		-- Interface object of `Current'

end -- class EV_WINDOW_IMP
