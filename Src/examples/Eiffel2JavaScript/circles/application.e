note
	description : "Circles deom root class."
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
		do
			--| Add your code here
			console.info ("Hello Eiffel World!%N")

			init
		end

	create_circle (x, y, radius: DOUBLE; color: attached STRING): attached CIRCLE
		local
			l_position: VECTOR
		do
			create l_position.make (x, y)
			create Result.make (l_position, radius, color)
		end

	init
		local
			l_circles: LINKED_LIST[attached CIRCLE]
			l_foo: JS_NODE
		do
			create l_circles.make
			l_circles.extend (create_circle ( 25,  50,  25, "#f00"))
			l_circles.extend (create_circle (390,  50,  35, "#0f0"))
			l_circles.extend (create_circle (300,  50,  50, "#00f"))
			l_circles.extend (create_circle (300, 250, 100, "#888"))
			l_circles.extend (create_circle (100,  30,  30, "#880"))
			l_circles.extend (create_circle (145,  15,  15, "#088"))
			l_circles.extend (create_circle (200,  45,  45, "#808"))

			create start_pause_button.make
			start_pause_button.type := "button"
			is_paused := true
			set_proper_start_pause_label
			start_pause_button.onclick := agent on_start_pause
			l_foo := document_body.append_child (start_pause_button)
			create last_update_time.make_current

			create decrease_friction_button.make
			decrease_friction_button.type := "button"
			decrease_friction_button.value := "-"
			decrease_friction_button.onclick := agent on_decrease_friction
			l_foo := document_body.append_child (decrease_friction_button)

			create friction_display.make
			wall_friction := 1.0
			set_proper_friction_display
			l_foo := document_body.append_child (friction_display)

			create increase_friction_button.make
			increase_friction_button.type := "button"
			increase_friction_button.value := "+"
			increase_friction_button.onclick := agent on_increase_friction
			l_foo := document_body.append_child (increase_friction_button)

			create world.make (50, 5, 450, 600, l_circles)
			l_foo := document_body.append_child (world.dom_node)

			world.wall_friction := wall_friction
			world.render
		end

feature {NONE} -- Start / Pause implementation

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

feature {NONE} -- Wall friction implementation

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

				last_update_time := current_update_time
				l_timeout_id := window.set_timeout (agent update, (1000/24).floor)
			end
		end

feature {NONE} -- Implementation

	world: attached WORLD

	document_body: attached JS_NODE
		local
			l_body_elements: JS_NODE_LIST
			l_body: JS_NODE
		do
			l_body_elements := window.document.get_elements_by_tag_name ("body")
			check l_body_elements /= Void end

			l_body := l_body_elements.item (0)
			check l_body /= Void end

			Result := l_body
		end
end
