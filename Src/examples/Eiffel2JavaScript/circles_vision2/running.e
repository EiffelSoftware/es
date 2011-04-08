note
	description: "Summary description for {RUNNING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RUNNING

inherit
	THREAD
	DT_SHARED_SYSTEM_CLOCK

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch (a_world: attached WORLD; a_window: attached MAIN_WINDOW)
		do
			world := a_world
			window := a_window
			is_paused := true
			launch
		end

feature -- Access

	is_paused : BOOLEAN

	toggle_start_pause
		do
			if is_paused then
				last_time := system_clock.date_time_now
			end
			is_paused := not is_paused
		end

feature {NONE} -- Implementation

	last_time: DT_DATE_TIME
	world: attached WORLD
	milli: INTEGER = 1000000
	window: attached MAIN_WINDOW

	execute
		local
			pixmap: EV_PIXMAP
			c: CIRCLE
			color: EV_COLOR
			current_update_time: DT_DATE_TIME
			delta_time: DT_DATE_TIME_DURATION
		do
			from
				sleep (500 * milli)
			until
				false
			loop

				if not is_paused then
					current_update_time := system_clock.date_time_now
					delta_time := current_update_time - last_time

					world.update (delta_time.millisecond_count)
					create pixmap.make_with_size (world.abs_right-world.abs_left, world.abs_bottom-world.abs_top)

					from
						world.circles.start
					until
						world.circles.after
					loop
						c := world.circles.item

						create color.make_with_8_bit_rgb(c.color.r, c.color.g, c.color.b)
						pixmap.set_foreground_color (color)
						pixmap.fill_ellipse ((c.position.x-c.radius).rounded, (c.position.y-c.radius).rounded, 2*c.radius.rounded, 2*c.radius.rounded)

						world.circles.forth
					end
					(create {EV_ENVIRONMENT}).application.do_once_on_idle(agent (a_pixmap: attached EV_PIXMAP)
						do
							window.da.draw_pixmap (0, 0, a_pixmap)
							--window.da.redraw
						end (pixmap)
					)
				end

				sleep ((1000/24).floor * milli)

			end
		end

end
