note
	description: "Uses up set and preservation semantics of updates."

class NODE

create
	make

feature

	value: INTEGER
	init_value: INTEGER
	parent: NODE

	children, up, down: MML_SET [NODE]
		note
			status: ghost
		attribute
		end

	is_max (v: INTEGER; init_v: INTEGER; nodes: MML_SET [NODE]): BOOLEAN
		note
			status: ghost
		require
			reads (nodes)
		do
			Result :=
				(v >= init_v and across nodes as n all n.item.value <= v end) and
				(v = init_v or across nodes as n some n.item.value = v end)
		end

	make (init_val: INTEGER)
		require
			is_open -- default: creator
		do
			children := {MML_SET [NODE]}.empty_set
			up := {MML_SET [NODE]}.empty_set
			init_value := init_val
			value := init_val
			wrap -- default: creator
		ensure
			init_value = init_val
			parent = Void
			children.is_empty
			is_wrapped -- default: creator
		end

	acquire (n: NODE)
		note
			explicit: wrapping
		require
			n /= Void
			n /= Current -- needed to assume that Current's up is consistent; can be relaxed but seems okay
			n.parent = Void
			across up as p all p.item.is_wrapped end
			across down as c all c.item.is_wrapped end
			is_wrapped -- default
			n.is_wrapped -- default
			across n.observers as o all o.item.is_wrapped end

			modify ([n, Current])
			modify_field (["value", "down"], up)
			modify_field ("up", down)
		do
			unwrap
			n.unwrap
			children := children & n -- preserves parent, children
			set_subjects (subjects + [n]) ; set_observers (observers + [n])
			n.set_parent (Current)
			n.set_subjects (n.subjects + [Current]) ; n.set_observers (n.observers + [Current])
			n.update_up (Current, <<n>>, {MML_SET [NODE]}.empty_set)
			update_down (n, n, <<Current>>, {MML_SET [NODE]}.empty_set)
			if n.value > value then
				update_value (n, {MML_SET [NODE]}.empty_set)
			end
		ensure
			is_wrapped -- default
			n.is_wrapped -- default
			across n.observers as o all o.item.is_wrapped end
			n.parent = Current
		end

feature { NODE }

	set_parent (p: NODE)
		note
			explicit: contracts
		require
			parent = Void
			is_open
			modify_field ("parent", Current)
		do
			parent := p -- preserves children?
		ensure
			parent = p
		end

	update_value (child: NODE; visited: MML_SET [NODE])
		-- Update `value' of the Current node so that it is greater than `value' of `child';
		-- for all nodes in `visited' their `value' already has been fixed.
	require
		is_open -- default: private
--TODO		inv_without ("value_consistent")
		children [child]
		child.value > value
		is_max (value, init_value, children / child)

		across visited as o all o.item.is_wrapped end
		across visited as o all o.item.value <= child.value end

		across (up - <<Current>>) as o all o.item.is_wrapped end

		modify_field (["value", "closed"], up)
--TODO		variant up - visited
	do
		if parent /= Void and parent /= Current then
			parent.unwrap -- wrapped since (up - { Current })[parent]
		end
		value := child.value -- preserves children / parent
		wrap
		if parent /= Void then
			if value > parent.value then
				check not visited [parent] end -- since all visited have their value <= child.value
				parent.update_value (Current, visited & Current)
			elseif parent /= Current then
				parent.wrap
			end
		end
	ensure
		across up as o all o.item.is_wrapped end
	end

	update_up (root: NODE; front, visited: MML_SET [NODE])
			-- Add `root' to the `up' set of `Current' and all its transitive children;
			-- `front' is the set of nodes whose `up' set is currently inconsistent with their parent,
			-- and for all nodes in `visited' their `up' set already has been fixed.
		note
			explicit: contracts
			status: ghost
		require
			front [Current]
			across front as o all
				o.item.is_open and
--TODO				o.item.inv_without ("up_consistent") -- all invariant clauses hold but the listed
				o.item.parent /= Void and
				root.up <= o.item.parent.up and
				not o.item.up [root] and
				o.item.parent.up - root.up <= o.item.up
			end
			across visited / root as o all o.item.is_wrapped end
			across visited as o all o.item.up [root] end

			root.is_open
--TODO			root.inv_without ("down_consistent", "value_consistent") -- so it's up-consistent and not in `front'

			across down - (front & root) as o all o.item.is_wrapped end

			modify_field (["up", "closed"], down)
--TODO			variant down - visited
		local
			fixed: MML_SET [NODE]
		do
			across children as c loop
				if not front[c.item] or c.item = root then
				  c.item.unwrap
				end
			end
			up := up + root.up -- preserves { parent } - children
			if Current /= root then
				wrap
				fixed := <<Current>>
			end
			across children as c loop
				if c.item /= root and c.item /= Current and root.up <= c.item.up then
					c.item.wrap -- wrap those children that are already fine, to keep the front up-inconsistent
					fixed := fixed & c.item
				end
			end
			across children as c
			invariant
				across fixed as o all o.item.is_wrapped and o.item.up [root] end
				across front + children - fixed as o all
					o.item.is_open and
--TODO					o.item.inv_without ("up_consistent")
					o.item.parent /= Void and
					root.up <= o.item.parent.up and
					not o.item.up [root] and
					o.item.parent.up - root.up <= o.item.up
				end
--TODO				across 1 |..| c.cursor_index as i all children [i.item] /= root implies fixed [children [i.item].down] end
				Current /= root implies fixed [Current]
			loop
			if c.item.is_open and c.item /= root then
				c.item.update_up (root, front + children - fixed, visited + fixed)
				fixed := fixed + c.item.down / root
			end
			end
		ensure
			root.is_open
--TODO			root.inv_without ("down_consistent", "value_consistent") -- so it's up-consistent and not in `front'
			across down / root as o all o.item.is_wrapped end
			across down as o all o.item.up [root] end
		end

	update_down (child, root: NODE; new_nodes, visited: MML_SET [NODE])
			-- Add `new_nodes' to the `down' set of `Current' and all its transitive parents;
			-- `root' is the node that acquired a new child and for all nodes in `visited' their `down' set already has been fixed.
		note
			status: ghost
		require
			is_open
--TODO			Current /= root implies inv_without ("down_consistent") -- all invariant clauses hold but the listed
--TODO			Current = root implies inv_without ("down_consistent", "value_consistent")
			children [child]
			new_nodes <= child.down
			not (new_nodes <= down)
			across children as c all (c.item.down - new_nodes) <= down end -- new_nodes are the only extra nodes in my children's down sets

			root.is_open
--TODO			root /= Current implies root.inv_without ("value_consistent")

			across visited / root as o all o.item.is_wrapped end
			across visited as o all new_nodes <= o.item.down end

			across up - << Current, root >> as o all o.item.is_wrapped end

			modify_field (["down", "closed"], up)

--TODO			variant up - visited
		do
			check not visited [Current] end -- since all visited have `new_nodes' in their `down'
			if not ((<<Void, Current, root>>).to_mml_set [parent]) then
				parent.unwrap -- wrapped since (up - { Current, root })[parent]
			end
			down := down + new_nodes -- preserves `children - { parent }'
			if Current /= root then
				wrap
			end
			if parent /= Void then
				if not (new_nodes <= parent.down) then
					check not visited [parent] end -- since all visited have `new_nodes' in their `down'
					parent.update_down (Current, root, new_nodes, visited & Current)
				elseif parent /= Current and parent /= root then
					parent.wrap
				end
			end
		ensure
			root.is_open
--TODO			root.inv_without ("value_consistent")
			across up - << root >> as o all o.item.is_wrapped end
		end

invariant
	across children as c all c.item /= Void and then c.item.parent = Current end
	parent /= Void implies parent.children [Current]
	up_consistent: up [Current] and (parent /= Void implies parent.up <= up)
	down_consistent: down [Current] and across children as c all c.item.down <= down end
	value_consistent: is_max (value, init_value, children)
	subjects = children & parent / Void
	observers = children & parent / Void
	across subjects as s all s.item.observers.has (Current) end -- default
	owns = [] -- default

note
	explicit: subjects, observers

end
