note
	description : "A circle."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"


class
	CIRCLE

inherit
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make (a_position: attached VECTOR; a_radius: DOUBLE; a_color: attached STRING)
			-- Initialize
		do
			position := a_position
			radius := a_radius
			mass := Pi * radius * radius
			create velocity.make (0, 0.001 * mass)

			create dom_node.make
			dom_node.style.width := (2 * radius - 2).out + "px"
			dom_node.style.height := (2 * radius - 2).out + "px"
			dom_node.style.background := a_color
			set_border_radius (dom_node, radius.out + "px")
			set_moz_border_radius (dom_node, radius.out + "px")
			dom_node.style.position := "absolute"
			dom_node.style.border := "1px solid #000"
			dom_node.style.line_height := (2 * radius).out + "px"
			dom_node.style.text_align := "center"
		end

feature -- Access

	dom_node: attached JS_HTML_DIV_ELEMENT

feature -- Basic Operation

	render
		do
			dom_node.style.left := (position.x - radius).out + "px"
			dom_node.style.top := (position.y - radius).out + "px"
		end

feature {NONE} -- Implementation

	position, velocity: attached VECTOR
	radius, mass: DOUBLE

feature {NONE} -- External

	set_border_radius (elem: attached JS_HTML_ELEMENT; radiuss: attached STRING)
		external "C" alias "#$elem.style.borderRadius=$radiuss" end

	set_moz_border_radius (elem: attached JS_HTML_ELEMENT; radiuss: attached STRING)
		external "C" alias "#$elem.style.MozBorderRadius=$radiuss" end

end
