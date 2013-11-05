class F_DLL_NODE

create
	make
  
feature
	left: F_DLL_NODE
	right: F_DLL_NODE    
  
	make
		note
			status: creator
		require
			is_open -- default: creator
		do
			left := Current
			right := Current
			set_subjects ([left, right]) -- default: implicit
			set_observers ([left, right]) -- default: implicit
			wrap -- default: creator
		ensure
			singleton: left = Current
			is_wrapped -- default: creator
		end
    
	insert_right (n: F_DLL_NODE)
		note
			explicit: wrapping
		require
			n /= Void
			n_singleton: n.left = n
			is_wrapped -- default: ?
			across observers as o all o.item.is_wrapped end -- default: ?
			n.is_wrapped -- default: ?
			
			modify ([Current, right, n])
		local
			r: F_DLL_NODE
		do
			r := right
			across << Current, r, n >> as o loop o.item.unwrap end
			n.set_right (r)
			n.set_left (Current)
			r.set_left (n)
			set_right (n)      
			across << Current, r, n >> as o loop
				o.item.set_subjects ([o.item.left, o.item.right]) -- default: implicit?
				o.item.set_observers ([o.item.left, o.item.right]) -- default: implicit?
				o.item.wrap
			end
		ensure
			right = n
			n.right = old right

			is_wrapped
			right.is_wrapped
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
		local
			r: F_DLL_NODE      
		do
			r := right
			across << Current, r, r.right >> as o loop o.item.unwrap end
			set_right (r.right)
			r.right.set_left (Current)
			r.set_right (r)
			r.set_left (r)
			across << Current, r, r.right >> as o loop
				o.item.set_subjects ([o.item.left, o.item.right]) -- default: implicit subjects
				o.item.set_observers ([o.item.left, o.item.right]) -- default: implicit observers
				o.item.wrap
			end
		ensure
		  right = old right.right
		  old_right_singleton: (old right).right = old right

		  is_wrapped
		  right.is_wrapped
		end
    
feature {F_DLL_NODE}

	set_left (n: F_DLL_NODE)
		note
			explicit: contracts
		require
			is_open
			left.is_open
			
--			modify ([Current, "left"])
			modify (Current)
		do
			left := n -- preserves right
		ensure
			left = n
			
			right = old right -- TODO: fine-grained modifies
			observers = old observers
			subjects = old subjects
		end

	set_right (n: F_DLL_NODE)
		note
			explicit: contracts  
		require
			is_open
			right.is_open

--			modify ([Current, "right"])
			modify (Current)
		do
			right := n -- preserves left
		ensure
			right = n
			
			left = old left -- TODO: fine-grained modifies
			observers = old observers
			subjects = old subjects
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
