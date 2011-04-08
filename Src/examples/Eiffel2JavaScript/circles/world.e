note
	description : "A world of circles :)"
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	WORLD

inherit
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make (a_top, a_left, a_bottom, a_right: INTEGER; l_circles: attached LIST[attached CIRCLE])
		do
			circles := l_circles

			abs_bottom := a_bottom
			abs_top := a_top
			abs_left := a_left
			abs_right := a_right

			top := 0
			bottom := a_bottom - a_top
			left := 0
			right := a_right - a_left
		end

feature -- Access

	abs_bottom, abs_top, abs_left, abs_right: INTEGER

	circles: attached LIST[attached CIRCLE]

feature -- Basic Operation

	update (a_delta_time: DOUBLE)
		local
			l_done_time: DOUBLE
		do
			from
				l_done_time := 0
			until
				l_done_time >= a_delta_time
			loop
				l_done_time := step (l_done_time, a_delta_time)
			end
		end

	wall_friction: DOUBLE assign set_wall_friction
	set_wall_friction (a_wall_friction: DOUBLE)
		do
			wall_friction := a_wall_friction
		end

feature {NONE} -- Implementation

	bottom, top, left, right: INTEGER

	squared (a_x: DOUBLE): DOUBLE
		do
			Result := a_x * a_x
		end

	find_time_until_collide (c1, c2: attached CIRCLE; v1, v2: attached VECTOR): DOUBLE
			-- See http://www.actionscript.org/resources/articles/1000/1/Elastic-Collisions-Inspiration/Page1.html
		local
			pos_delta, v_delta: VECTOR
			a, b, c, det, t: DOUBLE
		do
			Result := -1

			pos_delta := c2.position - c1.position
			v_delta := v2 - v1

			a := squared(v_delta.x) + squared(v_delta.y)
			b := 2 * (pos_delta.x * v_delta.x + pos_delta.y * v_delta.y)
			c := squared(pos_delta.x) + squared(pos_delta.y) - squared(c1.radius + c2.radius)
			det := squared(b) - (4 * a * c)
			if a /= 0 then
				t := (-b - sqrt(det)) / (2*a)
				if t >= 0 then
					Result := t
				end
			end
		end

	do_elastic_collision (c1, c2: attached CIRCLE)
			-- See http://www.actionscript.org/resources/articles/1000/1/Elastic-Collisions-Inspiration/Page1.html
		local
			v_n, v_un, v_ut, v_v1nPrime, v_v1tPrime, v_v2nPrime, v_v2tPrime: VECTOR
			v1n, v1tPrime, v2n, v2tPrime, v1nPrime, v2nPrime: DOUBLE
		do
			v_n := c2.position - c1.position
			v_un := v_n.as_normalized
			create v_ut.make (-v_un.y, v_un.x)

			v1n := v_un.dot (c1.velocity)
			v1tPrime := v_ut.dot (c1.velocity)
			v2n := v_un.dot (c2.velocity)
			v2tprime := v_ut.dot (c2.velocity)

			v1nPrime := (v1n * (c1.mass - c2.mass) + 2 * c2.mass * v2n) / (c1.mass + c2.mass)
			v2nPrime := (v2n * (c2.mass - c1.mass) + 2 * c1.mass * v1n) / (c1.mass + c2.mass)

			v_v1nPrime := v_un * v1nPrime
			v_v1tPrime := v_ut * v1tPrime
			v_v2nPrime := v_un * v2nPrime
			v_v2tPrime := v_ut * v2tPrime

			c1.velocity := (v_v1nPrime + v_v1tPrime)
			c2.velocity := (v_v2nPrime + v_v2tPrime)
		end

	step (done_time, delta_time: DOUBLE): DOUBLE
		local
			best_time, time, step_time: DOUBLE
			l_new_position: VECTOR
			l_intersection: DOUBLE
			l_collision_response: PROCEDURE[ANY, attached TUPLE]
			i,j : INTEGER
		do
			best_time := 2

			-- Check against world limits
			from
				circles.start
			until
				circles.after
			loop
				l_new_position := circles.item.position + circles.item.velocity * ( (delta_time - done_time) / delta_time )

				l_intersection := bottom - circles.item.radius
				if l_new_position.y > l_intersection then
					time := (l_intersection - circles.item.position.y) / (l_new_position.y - circles.item.position.y)
					if time < best_time then
						best_time := time
						l_collision_response :=  agent (circle: attached CIRCLE)
							local
								l_new_velocity: VECTOR
							do
								create l_new_velocity.make (circle.velocity.x, - wall_friction * circle.velocity.y)
								circle.velocity := l_new_velocity
							end (circles.item)
					end
				end

				l_intersection := top + circles.item.radius
				if l_new_position.y < l_intersection then
					time := (l_intersection - circles.item.position.y) / (l_new_position.y - circles.item.position.y)
					if time < best_time then
						best_time := time
						l_collision_response :=  agent (circle: attached CIRCLE)
							local
								l_new_velocity: VECTOR
							do
								create l_new_velocity.make (circle.velocity.x, - wall_friction * circle.velocity.y)
								circle.velocity := l_new_velocity
							end (circles.item)
					end
				end

				l_intersection := left + circles.item.radius
				if l_new_position.x < l_intersection then
					time := (l_intersection - circles.item.position.x) / (l_new_position.x - circles.item.position.x)
					if time < best_time then
						best_time := time
						l_collision_response :=  agent (circle: attached CIRCLE)
							local
								l_new_velocity: VECTOR
							do
								create l_new_velocity.make (- wall_friction * circle.velocity.x, circle.velocity.y)
								circle.velocity := l_new_velocity
							end (circles.item)
					end
				end

				l_intersection := right - circles.item.radius
				if l_new_position.x > l_intersection then
					time := (l_intersection - circles.item.position.x) / (l_new_position.x - circles.item.position.x)
					if time < best_time then
						best_time := time
						l_collision_response :=  agent (circle: attached CIRCLE)
							local
								l_new_velocity: VECTOR
							do
								create l_new_velocity.make (- wall_friction * circle.velocity.x, circle.velocity.y)
								circle.velocity := l_new_velocity
							end (circles.item)
					end
				end

				circles.forth
			end

				-- Check against each other
			from
				i := 1
			until
				i > circles.count
			loop
				from
					j := i + 1
				until
					j > circles.count
				loop
					time := find_time_until_collide (circles[i], circles[j], circles[i].velocity * ( (delta_time - done_time) / delta_time ), circles[j].velocity * ( (delta_time - done_time) / delta_time ))
					if time >= 0 and time < best_time then
						best_time := time
						l_collision_response :=  agent (c1, c2: attached CIRCLE)
							do
								do_elastic_collision(c1, c2)
							end (circles[i], circles[j])
					end
					j := j + 1
				end
				i := i + 1
			end

			if best_time <= 1 then
				step_time := best_time * (delta_time - done_time)
			else
				step_time := delta_time - done_time
			end


			from
				circles.start
			until
				circles.after
			loop
				l_new_position := circles.item.position + circles.item.velocity * (step_time/delta_time)

					-- Account for rounding errors
				l_new_position.y := l_new_position.y.min (bottom - circles.item.radius)
				l_new_position.y := l_new_position.y.max (top + circles.item.radius)
				l_new_position.x := l_new_position.x.max (left + circles.item.radius)
				l_new_position.x := l_new_position.x.min (right - circles.item.radius)

				circles.item.position := l_new_position
				circles.forth
			end

			if attached l_collision_response as safe_collision_response then
				safe_collision_response.call([1, 2])
			end

			Result := done_time + step_time
		end

	circles_inside: BOOLEAN
		local
			i: INTEGER
			c: CIRCLE
		do
			from
				Result := true
				i := 1
			until
				i > circles.count or Result = false
			loop
				c := circles[i]

				if c.position.y > bottom - c.radius then
					Result := false
				end
				if c.position.y < top + c.radius then
					Result := false
				end
				if c.position.x < left + c.radius then
					Result := false
				end
				if c.position.x > right - c.radius then
					Result := false
				end

				i := i + 1
			end
		end

invariant
	circles_inside: circles_inside

end
