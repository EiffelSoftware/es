note
	description : "Circles demo root class."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	JS_OBJECT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			setup: SETUP
		do
			wall_friction := 1.0

			create setup.make
			world := setup.create_world
			world.wall_friction := wall_friction

			init_controls
			init_rendering
			render
		end

	init_controls
		local
			l_foo: JS_NODE
		do
			create start_pause_button.make
			start_pause_button.type := "button"
			is_paused := true
			set_proper_start_pause_label
			start_pause_button.onclick := agent on_start_pause
			l_foo := body.append_child (start_pause_button)
			create last_update_time.make_current

			create decrease_friction_button.make
			decrease_friction_button.type := "button"
			decrease_friction_button.value := "-"
			decrease_friction_button.onclick := agent on_decrease_friction
			l_foo := body.append_child (decrease_friction_button)

			create friction_display.make
			set_proper_friction_display
			l_foo := body.append_child (friction_display)

			create increase_friction_button.make
			increase_friction_button.type := "button"
			increase_friction_button.value := "+"
			increase_friction_button.onclick := agent on_increase_friction
			l_foo := body.append_child (increase_friction_button)
		end

	init_rendering
		local
			dom_node: JS_HTML_DIV_ELEMENT
			l_foo: JS_NODE
			c: CIRCLE
		do
			create world_dom_node.make
			world_dom_node.style.top := world.abs_top.out + "px"
			world_dom_node.style.left := world.abs_left.out + "px"
			world_dom_node.style.height := (world.abs_bottom - world.abs_top).out + "px"
			world_dom_node.style.width := (world.abs_right - world.abs_left).out + "px"
			world_dom_node.style.border := "1px solid #000"
			world_dom_node.style.position := "absolute"

			from
				create {LINKED_LIST[attached JS_HTML_DIV_ELEMENT]}circles_dom_node.make
				world.circles.start
			until
				world.circles.after
			loop
				c := world.circles.item

				create dom_node.make
				dom_node.style.width := (2 * c.radius - 2).out + "px"
				dom_node.style.height := (2 * c.radius - 2).out + "px"
				dom_node.style.background := c.color.html
				set_border_radius (dom_node, c.radius.out + "px")
				set_moz_border_radius (dom_node, c.radius.out + "px")
				dom_node.style.position := "absolute"
				dom_node.style.border := "1px solid #000"
				dom_node.style.line_height := (2 * c.radius).out + "px"
				dom_node.style.text_align := "center"

				l_foo := world_dom_node.append_child (dom_node)
				circles_dom_node.extend (dom_node)

				world.circles.forth
			end

			l_foo := body.append_child (world_dom_node)
		end

feature {NONE} -- Start / Pause controls implementation

	is_paused: BOOLEAN

	start_pause_button: attached JS_HTML_INPUT_ELEMENT

	set_proper_start_pause_label
		do
			if is_paused then
				start_pause_button.value := "Start"
			else
				start_pause_button.value := "Pause"
			end
		end

	on_start_pause (a_event: attached JS_MOUSE_EVENT): BOOLEAN
		local
			l_timeout_id: INTEGER
		do
			if is_paused then
				create last_update_time.make_current
				l_timeout_id := window.set_timeout (agent update, (1000/24).floor)
			end
			is_paused := not is_paused
			set_proper_start_pause_label
			Result := false
		end

feature {NONE} -- Wall friction controls implementation

	wall_friction: DOUBLE
	decrease_friction_button: attached JS_HTML_INPUT_ELEMENT
	increase_friction_button: attached JS_HTML_INPUT_ELEMENT
	friction_display: attached JS_HTML_SPAN_ELEMENT

	set_proper_friction_display
		do
			friction_display.inner_html := "Wall friction: " + wall_friction.out
		end

	on_decrease_friction (a_event: attached JS_MOUSE_EVENT): BOOLEAN
		do
			wall_friction := (wall_friction - 0.1).max (0.0)
			world.wall_friction := wall_friction
			set_proper_friction_display
			Result := false
		end

	on_increase_friction (a_event: attached JS_MOUSE_EVENT): BOOLEAN
		do
			wall_friction := (wall_friction + 0.1).min (1.0)
			world.wall_friction := wall_friction
			set_proper_friction_display
			Result := false
		end

feature {NONE} -- Running

	last_update_time: attached JS_DATE

	update
		local
			current_update_time: JS_DATE
			l_delta_time_s : DOUBLE
			l_timeout_id: INTEGER
		do
			if not is_paused then
				create current_update_time.make_current
				l_delta_time_s := (current_update_time.value_of - last_update_time.value_of) / 1000

				world.update (l_delta_time_s)
				render

				last_update_time := current_update_time
				l_timeout_id := window.set_timeout (agent update, (1000/24).floor)
			end
		end

feature {NONE} -- Implementation

	world: attached WORLD

feature {NONE} -- Rendering

	circles_dom_node: attached LIST[attached JS_HTML_DIV_ELEMENT]
	world_dom_node: attached JS_HTML_DIV_ELEMENT

	render
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > world.circles.count
			loop
				render_circle (i)
				i := i + 1
			end
		end


	render_circle (index: INTEGER)
		do
			circles_dom_node[index].style.left := (world.circles[index].position.x - world.circles[index].radius).out + "px"
			circles_dom_node[index].style.top := (world.circles[index].position.y - world.circles[index].radius).out + "px"
		end

feature {NONE} -- External

	set_border_radius (elem: attached JS_HTML_ELEMENT; radiuss: attached STRING)
		external "C" alias "#$elem.style.borderRadius=$radiuss" end

	set_moz_border_radius (elem: attached JS_HTML_ELEMENT; radiuss: attached STRING)
		external "C" alias "#$elem.style.MozBorderRadius=$radiuss" end

end
