note
	explicit: "all"

class F_DLL_NODE_D

create
	make

feature
	left: F_DLL_NODE_D
	right: F_DLL_NODE_D

	make
		note
			status: creator
		require
			is_open -- default: creator

			modify (Current) -- default: creator
		do
			left := Current
			right := Current
			set_subjects ([left, right]) -- default: implicit?
			set_observers ([left, right]) -- default: implicit?
			wrap -- default: creator
		ensure
			singleton: left = Current
			is_wrapped -- default: creator
		end

	insert_right (n: F_DLL_NODE_D)
		note
			explicit: wrapping
		require
			n /= Void
			n_singleton: n.left = n
			is_wrapped -- default: ?
			across observers as o all o.item.is_wrapped end -- default: ?
			n.is_wrapped -- default: ?

			left.is_wrapped
			right.is_wrapped
			right.right.is_wrapped

			modify ([Current, left, right, right.right, n])
		local
			r: F_DLL_NODE_D
		do
			r := right

--			unwrap_all ([Current, left, r, r.right, n])
--			across << Current, r, n >> as o loop o.item.unwrap end
			Current.unwrap
			if r /= Current then
				r.unwrap
			end
			if n /= Current then
				n.unwrap
			end
			if r.right.is_wrapped then
				r.right.unwrap
			end
			if left.is_wrapped then
				left.unwrap
			end

			n.set_right (r)
			n.set_left (Current)
			r.set_left (n)
			set_right (n)

--			across << Current, r, n >> as o loop
--				o.item.set_subjects ([o.item.left, o.item.right]) -- default: implicit?
--				o.item.set_observers ([o.item.left, o.item.right]) -- default: implicit?
--				o.item.wrap
--			end
			Current.set_subjects ([Current.left, Current.right])
			Current.set_observers ([Current.left, Current.right])
			r.set_subjects ([r.left, r.right])
			r.set_observers ([r.left, r.right])
			n.set_subjects ([n.left, n.right])
			n.set_observers ([n.left, n.right])

			Current.wrap
			if not left.is_wrapped then
				left.wrap
			end
			if not n.is_wrapped then
				n.wrap
			end
			if not r.is_wrapped then
				r.wrap
			end
			if not r.right.is_wrapped then
				r.right.wrap
			end

--			wrap_all ([Current, left, r, r.right, n])
		ensure
			right = n
			n.right = old right

			is_wrapped
			left.is_wrapped
			right.is_wrapped
			right.right.is_wrapped
		end

	remove_right
		note
			explicit: wrapping
		require
			not_singleton: right /= Current
			right.right.is_wrapped
			is_wrapped -- default: ?
			across observers as o all o.item.is_wrapped end -- default: ?

			modify ([Current, right, right.right])

			modify (right.right.right)
			modify (left)
		local
			r: F_DLL_NODE_D
		do
			r := right

--			across << Current, r, r.right >> as o loop o.item.unwrap end
			Current.unwrap
			r.unwrap
			if r.right.is_wrapped then
				r.right.unwrap
			end
			if r.right.right.is_wrapped then
				r.right.right.unwrap
			end
			if left.is_wrapped then
				left.unwrap
			end

			set_right (r.right)
			r.right.set_left (Current)
			r.set_right (r)
			r.set_left (r)

--			across << Current, r, r.right >> as o loop
--				o.item.set_subjects ([o.item.left, o.item.right]) -- default: implicit subjects
--				o.item.set_observers ([o.item.left, o.item.right]) -- default: implicit observers
--				o.item.wrap
--			end
			Current.set_subjects ([Current.left, Current.right])
			Current.set_observers ([Current.left, Current.right])
			right.set_subjects ([right.left, right.right])
			right.set_observers ([right.left, right.right])
			r.set_subjects ([r.left, r.right])
			r.set_observers ([r.left, r.right])

			Current.wrap
			if not left.is_wrapped then
				left.wrap
			end
			if not right.is_wrapped then
				right.wrap
			end
			r.wrap
		ensure
		  right = old right.right
		  old_right_singleton: (old right).right = old right

		  is_wrapped
		  right.is_wrapped
		end

feature {F_DLL_NODE_D}

	set_left (n: F_DLL_NODE_D)
		note
			explicit: contracts
		require
			is_open
			left.is_open
			across observers as sc all sc.item.is_open end

			modify_field ("left", Current)
		do
			left := n -- preserves right
		ensure
			left = n
		end

	set_right (n: F_DLL_NODE_D)
		note
			explicit: contracts
		require
			is_open
			right.is_open
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
	owns = [] -- default: ?
	across subjects as s all s.item.observers.has (Current) end -- default: ?

end
