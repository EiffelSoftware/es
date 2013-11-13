note
	description: "Composite with no-orphans and acyclicity invariants, and optimized update."
	explicit: "all"

class F_COM_COMPOSITE_D

create
	make

feature

	children: F_COM_LIST [F_COM_COMPOSITE_D]

	parent: F_COM_COMPOSITE_D

	value: INTEGER

	up, children_set: MML_SET [F_COM_COMPOSITE_D]
			-- Set of transitive parents and children
		note
			status: ghost
		attribute
		end

	is_max (v: INTEGER; nodes: MML_SET [F_COM_COMPOSITE_D]): BOOLEAN
		note
			status: ghost
		require
			reads (nodes)
			modify ([])
		do
			Result :=
				across nodes as n all n.item.value <= v end and
				(nodes.is_empty or across nodes as n some n.item.value = v end)
		end

	make (v: INTEGER)
		note
			status: creator
		require
			is_open -- default: creator

			modify (Current) -- default: creator
		do
			up := {MML_SET [F_COM_COMPOSITE_D]}.empty_set
			children_set := {MML_SET [F_COM_COMPOSITE_D]}.empty_set
			create children.make
			set_owns ([children])
			value := v
			wrap -- default: creator
		ensure
			is_wrapped -- default: creator
			across observers as o all o.item.is_wrapped end -- default: creator
			value = v
			parent = Void
			children.is_empty
		end

	add_child (c: F_COM_COMPOSITE_D)
		require
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
			c.is_wrapped -- default: public
			across c.observers as o all o.item.is_wrapped end -- default: public

			c /= Void
			c /= Current
			c.parent = Void
			c.children.is_empty
			not children_set[c]
			not up[c]
			across up as p all p.item.is_wrapped end

			modify ([Current, c])
			modify_field ("value", up)
			modify (children_set)
		do
			unwrap -- default: public
			c.unwrap
			unwrap_all (children_set)
			if parent /= Void then
				parent.unwrap
			end

			children.extend_back  (c) -- preserves parent
			set_subjects (subjects & c)
			set_observers (observers & c)
			c.set_parent (Current)
			c.set_subjects (c.subjects & Current)
			c.set_observers (c.observers & Current)

			check across children_set as o all o.item.inv_only ("value_consistent") end end
			check c.inv_only ("value_consistent") end
			children_set := children_set & c
			check assume: across children_set as o all o.item.inv_only ("value_consistent") end end

			wrap_all (children_set)
			update (c)

			if parent /= Void then
				parent.wrap
			end

			wrap -- default: public
		ensure
			children.has (c)
			c.value = old c.value

			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
			c.is_wrapped -- default: public
			across c.observers as o all o.item.is_wrapped end -- default: public

			false
		end

feature {F_COM_COMPOSITE_D}

	set_parent (p: F_COM_COMPOSITE_D)
		require
			is_open -- default: not public
			across observers as o all o.item.is_open end -- default: not public

			parent = Void
			children.is_empty
			p /= Void

			modify_field (["parent", "up"], Current)
		do
			parent := p
			up := p.up & p
		ensure
			parent = p
			up = p.up & p

			is_open -- default: not public
			across observers as o all o.item.is_open end -- default: not public
		end

	update (c: F_COM_COMPOSITE_D)
			-- Update values of Current and transitive parents taking into account new child `c'.
		note
			explicit: contracts
		require
			c /= Void
			children_set[c]
			is_open
			owns = [children]
			children.is_wrapped
			across children_set as o all o.item.is_wrapped end

			inv_without ("value_consistent") -- All invariant clauses except "value_consistent"
			across up as p all p.item.is_wrapped end
			is_max (value, children_set / c)

			modify_field ("value", [Current, up])
			modify_field ("closed", children_set)
			modify (children)
			decreases (up)
		do
			if value < c.value then
				if parent /= Void then
					check up [parent] end
					check parent.is_wrapped end
					parent.unwrap
				end
				unwrap_all (children_set)
				value := c.value  -- preserves children
				check is_max (value, children_set) end
				wrap_all (children_set)
				if parent /= Void then
					parent.update (Current)
				end
			end
			wrap
		ensure
			is_wrapped
		end

invariant
	i1: children /= Void
	i2: children_set = children.sequence
	i3: not children_set[Current]
	i4: not children_set[children]
	i5: parent /= Void implies not (children_set[parent])
	i6: across children_set as c all c.item /= Void and then c.item.parent = Current end
	i7: parent /= Void implies (not up[Current] and up = parent.up & parent) -- implies acyclicity
	i8: parent = Void implies up.is_empty
	value_consistent: is_max (value, children_set)
	i9: subjects = children_set & parent  / Void
	i10: observers = children_set & parent / Void
	i11: owns = [children]
	i12: across subjects as s all s.item.observers.has (Current) end -- default

note
	explicit: subjects, observers

end
