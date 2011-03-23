note
	description : "A world of circles :)"
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	WORLD

inherit
	JS_OBJECT

create
	make

feature {NONE} -- Initialization

	make (a_top, a_left, a_bottom, a_right: INTEGER; l_circles: attached LIST[attached CIRCLE])
		local
			foo: JS_NODE
		do
			create dom_node.make
			dom_node.style.top := a_top.out + "px"
			dom_node.style.left := a_left.out + "px"
			dom_node.style.height := (a_bottom - a_top).out + "px"
			dom_node.style.width := (a_right - a_left).out + "px"
			dom_node.style.border := "1px solid #000"
			dom_node.style.position := "absolute"

			circles := l_circles
			from
				circles.start
			until
				circles.after
			loop
				foo := dom_node.append_child (circles.item.dom_node)
				circles.forth
			end

			if attached window.document.get_elements_by_tag_name ("body") as body_list
				and then attached body_list.item (0) as safe_body then
				foo := safe_body.append_child (dom_node)
			end
		end

feature -- Access

	dom_node: attached JS_HTML_DIV_ELEMENT

	circles: attached LIST[attached CIRCLE]

feature -- Basic Operation

	render
		do
			from
				circles.start
			until
				circles.after
			loop
				circles.item.render
				circles.forth
			end
		end

end
