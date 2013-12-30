note
	description: "A node in a graph structure that only has a reference to its parent and needs to maintain consistency with its children."

frozen class F_PIP_NODE

create
	make

feature {NONE} -- Initialization	

	make (v: INTEGER)
			-- Create a singleton node with initial value `v'		
		note
			status: creator
		do
			init_value := v
			value := v
			ancestors := <<Current>>
			descendants := <<Current>>
		ensure
			init_value_set: init_value = v
			value_set: value = v
			no_parent: parent = Void
			no_children: children.is_empty
			descendants_structure: descendants = <<Current>>
	end

feature -- Access

	value: INTEGER
			-- Current value.

	init_value: INTEGER
			-- Initial value at node creation.

	parent: F_PIP_NODE
			-- Parent node.

	children: MML_SEQUENCE [F_PIP_NODE]
			-- Set of nodes whose `parent' is the current node.
		note
			status: ghost
		attribute
		end

	ancestors: MML_SET [F_PIP_NODE]
			-- Set of reflexive transitive parent nodes.
		note
			status: ghost
		attribute
		end

	descendants: MML_SET [F_PIP_NODE]
			-- Set of reflexive transitive child nodes.
		note
			status: ghost
		attribute
		end

	max_child: F_PIP_NODE
			-- Node from `children' with the maximum value greater than `init_value'
			-- or Void if it does not exist.
		note
			status: ghost
		attribute
		end

	is_max (v: INTEGER; init_v: INTEGER; nodes: MML_SET [F_PIP_NODE]; max_node: F_PIP_NODE): BOOLEAN
			-- Is `v' the maximum of `init_v' and all values of `nodes'?
		note
			status: functional, ghost
		require
			nodes_exist: across nodes as n all n.item /= Void end
			reads (nodes)
		do
			Result :=
				v >= init_v and
				across nodes as n all n.item.value <= v end and
				((max_node = Void and v = init_v) or (nodes [max_node] and then max_node.value = v))
		end

	acquire (n: F_PIP_NODE)
			-- Connect `n' as a child to the current node.
		note
			explicit: wrapping
		require
			n_exists: n /= Void
			n_different: n /= Current
			n_orphan: n.parent = Void
			ancestors_wrapped: across ancestors as p all p.item.is_wrapped end
			descendants_wrapped: across descendants as c all c.item.is_wrapped end
			n_descendants_wrapped: across n.descendants as c all c.item.is_wrapped end

			modify (Current, n)
			modify_field (["value", "max_child", "descendants", "closed"], ancestors)
			modify_field (["ancestors", "closed"], n.descendants)
		do
			-- Todo: this assume is here because we do not have an exact definition of descendants yet:
			check assume: across n.children as c all not c.item.descendants [n] end end
			unwrap
			n.unwrap

			children := children & n -- preserves parent, children
			set_subjects (subjects & n)
			set_observers (observers & n)

			n.set_parent (Current)
			n.set_subjects (n.subjects & Current)
			n.set_observers (n.observers & Current)

			n.update_ancestors (Current)
			if not (n.descendants <= descendants) then
				update_descendants (n, n, {MML_SET [F_PIP_NODE]}.empty_set)
			end
			if n.value > value then
				update_value (n, n, {MML_SET [F_PIP_NODE]}.empty_set)
			else
				wrap
			end
		ensure
			n_parent_set: n.parent = Current
			children_set: children = old children & n
			max_child_set: max_child = if old (value >= n.value) then old max_child else n end
			ancestors_wrapped: across ancestors as p all p.item.is_wrapped end
			descendants_wrapped: across descendants as c all c.item.is_wrapped end
			n_value_unchanged: n.value = old n.value
			init_value_unchanged: init_value = old init_value
			ancestors_unchanged: ancestors = old ancestors
			descendants_set: descendants = old descendants + n.descendants
			n_descendants_unchanged: n.descendants = old n.descendants
			n_ancestors_set: n.ancestors = old n.ancestors + ancestors
		end

feature {F_PIP_NODE} -- Implementation

	set_parent (p: F_PIP_NODE)
			-- Set `parent' to `p'.
		require
			open: is_open
			no_parent: parent = Void
			p_exists: p /= Void
			observers = children.range
			modify_field (["parent"], Current)
		do
			parent := p
		ensure
			parent_set: parent = p
		end

	update_value (child, d: F_PIP_NODE; visited: MML_SET [F_PIP_NODE])
			-- Update `value' of this node and its ancestors taking into account an updated child `child' becuase of its new descendant `d';
			-- for all nodes in `visited' their `value' already has been fixed.			
		require
			open: is_open
			partially_holds: inv_without ("value_consistent")
			child_is_child: children.has (child)
			child_value: child.value = d.value
			value_consistency_broken: child.value > value
			c_is_new_max: is_max (child.value, init_value, children.range, child)
			visited_fixed: across visited as o all o.item.is_wrapped and o.item.value = d.value end
			direct_ancestors_wrapped: across ancestors as p all p.item /= Current implies p.item.is_wrapped end
			modify_field (["closed"], ancestors)
			modify_field (["value", "max_child"], (ancestors - visited) / d)
			decreases (ancestors - visited)
		do
			if parent /= Void then
				parent.unwrap
			end
			value := child.value
			max_child := child
			wrap
			if parent /= Void then
				if value > parent.value then
					parent.update_value (Current, d, visited & Current)
				else
					parent.wrap
				end
			end
		ensure
			value_set: value = d.value
			max_child_set: max_child = child
			d_value_unchnaged: d.value = old d.value
			ancestors_wrapped: across ancestors as p all p.item.is_wrapped end
		end

	update_ancestors (a: F_PIP_NODE)
			-- Update `ancestors' of this node and its descendants taking into account the new ancestor `a'.
			-- Todo: verifying this procedure requires precise definition of descendants.
		note
			status: ghost
			skip: true
		require
			open: is_open
			partially_holds: inv_without ("ancestors_consistent")
			ancestor_consistency_broken: not ancestors [a]
			a_open: a.is_open
			a_partially_holds: a.inv_without ("descendants_big_enough", "value_consistent")
			direct_descendatns_but_a_wrapped: across children as c all across c.item.descendants as d all d.item /= a implies d.item.is_wrapped end end
			modify_field (["ancestors", "closed"], descendants)
			decreases (descendants)
		local
			i: INTEGER
		do
			unwrap_all (children.range / a)
			ancestors := ancestors + a.ancestors -- preserves { parent } - children
			wrap
			from
				i := 1
			until
				i > children.count
			loop
				if children [i] /= a then
					children [i].update_ancestors (a)
				end
				i := i + 1
			end
		ensure
			wrapped: is_wrapped
			ancestors_set: ancestors = old ancestors + a.ancestors
			a_open: a.is_open
			a_partially_holds: a.inv_without ("descendants_big_enough", "value_consistent")
			a_ancestors_unchanged: a.ancestors = old a.ancestors
			descendants_but_a_wrapped: across descendants as o all o.item /= a implies o.item.is_wrapped end
		end

	update_descendants (child, d: F_PIP_NODE; visited: MML_SET [F_PIP_NODE])
			-- Update `descendants' of this node and its ancestors taking into account the new descendant `d';
			-- for all nodes in `visited' their `descendants' already has been fixed.
		note
			status: ghost
		require
			open: is_open
			partially_holds: inv_without ("descendants_big_enough", "value_consistent")
			child_wrapped: child.is_wrapped or child = d.parent
			child_is_child: children.has (child)
			child_descendants: d.descendants <= child.descendants
			descendant_consistency_broken: not (d.descendants <= descendants)
			descendants_almost_consistent_1: across children as c all c.item /= child implies descendants [c.item] and c.item.descendants <= descendants end
			descendants_almost_consistent_2: child /= d implies descendants [child]
			descendants_almost_consistent_3: child.descendants - d.descendants <= descendants

			d_wrapped: d.is_wrapped
			root_open: d.parent.is_open
			non_root_value_consistent: Current /= d.parent implies inv_without ("descendants_big_enough")
			root_descendants_consistent: Current /= d.parent implies d.parent.inv_without ("value_consistent")

			visited_but_root_wrapped: across visited as o all o.item /= d.parent implies o.item.is_wrapped end
			visited_fixed: across visited as o all d.descendants <= o.item.descendants end

			direct_ancestors_wrapped: across ancestors as p all p.item /= Current and p.item /= d.parent implies p.item.is_wrapped end
			modify_field (["closed"], ancestors)
			modify_field (["descendants"], (ancestors - visited) / d)
			decreases (ancestors - visited)
		do
			if parent /= Void and parent /= d.parent then
				parent.unwrap
			end
			descendants := descendants + d.descendants -- preserves `children - { parent }'
			if Current /= d.parent then
				wrap
			end
			if parent /= Void then
				if not (d.descendants <= parent.descendants) then
					parent.update_descendants (Current, d, visited & Current)
				elseif parent /= d.parent then
					parent.wrap
				end
			end
		ensure
			root_open: d.parent.is_open
			root_partially_holds: d.parent.inv_without ("value_consistent")
			descendants_set: descendants = old descendants + d.descendants
			d_descendants_unchanged: d.descendants = old d.descendants
			ancestors_wrapped: across ancestors as p all p.item /= d.parent implies p.item.is_wrapped end
		end

invariant
	value_consistent: is_max (value, init_value, children.range, max_child)
	parent_consistent: parent /= Void implies parent.children.has (Current)
	children_consistent: across children as c all c.item /= Void and then c.item.parent = Current end
	no_duplicates: across 1 |..| children.count as i all across 1 |..| children.count as j all i.item < j.item implies children [i.item] /= children [j.item] end end
	no_direct_cycles: parent /= Current
	no_direct_cucles_2: not children.has (Current)
	ancestors_consistent: ancestors = (if parent = Void then {MML_SET [F_PIP_NODE]}.empty_set else parent.ancestors & parent end) & Current
	descendants_reflexive: descendants [Current]
	descendants_big_enough: across children as c all descendants [c.item] and c.item.descendants <= descendants end
--	Todo: use this or similar invariant to define descendants exactly	
--	descendants_small_enough: across descendants as d all d.item = Current or children.has (d.item) or
--		(across children as c some c.item.descendants [d.item] end) end
	subjects_structure: subjects = if parent = Void then children.range else children.range & parent end
	observers_structure: observers = subjects

note
	explicit: subjects, observers

end
