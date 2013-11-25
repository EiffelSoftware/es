class F_DLL_NODE

create
	make

feature

	left: F_DLL_NODE
	right: F_DLL_NODE

	make
		note
			status: creator
		do
			left := Current
			right := Current
			set_subjects ([left, right])
			set_observers ([left, right])
		ensure
			singleton: left = Current
		end

	insert_right (n: F_DLL_NODE)
		note
			explicit: wrapping
		require
			n /= Void
			n_singleton: n.left = n
			right.right.is_wrapped

			modify ([Current, left, right, right.right, n])
		local
			r: F_DLL_NODE
		do
			unwrap_all ([Current, left, right, right.right, n])

			r := right

			n.set_right (r)
			n.set_left (Current)
			r.set_left (n)
			set_right (n)

			Current.set_subjects ([Current.left, Current.right])
			Current.set_observers ([Current.left, Current.right])
			r.set_subjects ([r.left, r.right])
			r.set_observers ([r.left, r.right])
			n.set_subjects ([n.left, n.right])
			n.set_observers ([n.left, n.right])

			wrap_all ([Current, left, right, r, r.right])
		ensure
			right = n
			n.right = old right
			right.right.is_wrapped
		end

	remove_right
		note
			explicit: wrapping
		require
			not_singleton: right /= Current
			right.right.is_wrapped
			right.right.right.is_wrapped

			modify ([Current, left, right, right.right])
			modify (right.right.right)
		local
			r: F_DLL_NODE
		do
			unwrap_all ([Current, left, right, right.right, right.right.right])

			r := right

			set_right (r.right)
			r.right.set_left (Current)
			r.set_right (r)
			r.set_left (r)

			Current.set_subjects ([Current.left, Current.right])
			Current.set_observers ([Current.left, Current.right])
			right.set_subjects ([right.left, right.right])
			right.set_observers ([right.left, right.right])
			r.set_subjects ([r.left, r.right])
			r.set_observers ([r.left, r.right])

			wrap_all ([Current, left, right, right.right, r])
		ensure
		  right = old right.right
		  old_right_singleton: (old right).right = old right
		end

feature {F_DLL_NODE}

	set_left (n: F_DLL_NODE)
		require
			is_open
			across observers as sc all sc.item.is_open end

			modify_field ("left", Current)
		do
			left := n -- preserves right
		ensure
			left = n
		end

	set_right (n: F_DLL_NODE)
		require
			is_open
			across observers as sc all sc.item.is_open end

			modify_field ("right", Current)
		do
			right := n -- preserves left
		ensure
			right = n
		end

invariant
	left /= Void
	right /= Void
	left.right = Current
	right.left = Current
	subjects = [ left, right ]
	observers = [ left, right ]

end
