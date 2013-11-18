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
	init_value: INTEGER

	up, children_set: MML_SET [F_COM_COMPOSITE_D]
			-- Set of transitive parents and non-transitive children
		note
			status: ghost
		attribute
		end

	is_max (v: INTEGER; init_v: INTEGER; nodes: MML_SET [F_COM_COMPOSITE_D]): BOOLEAN
		note
			status: ghost
		require
			reads (nodes)
			modify ([])
		do
			Result :=
				v >= init_v and
				across nodes as n all n.item.value <= v end and
				(v = init_v or across nodes as n some n.item.value = v end)
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
			init_value := v
			wrap -- default: creator
		ensure
			is_wrapped -- default: creator
			across observers as o all o.item.is_wrapped end -- default: creator
			value = v
			init_value = v
			parent = Void
			children.is_empty
		end

	add_child (c: F_COM_COMPOSITE_D)
		note
			explicit: wrapping
		require
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
			c.is_wrapped -- default: public
			across c.observers as o all o.item.is_wrapped end -- default: public

			c /= Void
			c /= Current
			c.parent = Void
			c.children.is_empty
			not up[c]
			across up as p all p.item.is_wrapped end

			modify ([Current, c])
			modify_field (["value", "closed"], up)
		do
			unwrap
			c.unwrap
			c.set_parent (Current)
			c.set_subjects (c.subjects & Current)
			c.set_observers (c.observers & Current)
			set_observers (observers & c)
			set_subjects (subjects & c)
			children_set := children_set & c
			children.extend_back (c)
			c.wrap
			update (c)
		ensure
			children.has (c)
			c.value = old c.value
			children_set = old children_set & c
			up = old up
			across up as p all p.item.is_wrapped end
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
			c.is_wrapped -- default: public
			across c.observers as o all o.item.is_wrapped end -- default: public
		end

feature {F_COM_COMPOSITE_D}

	set_parent (p: F_COM_COMPOSITE_D)
		require
			is_open -- default: not public
			across observers as o all o.item.is_open end -- default: not public

			parent = Void
			children_set.is_empty
			p /= Void

			modify (Current)
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
			children.is_wrapped
			across up as p all p.item.is_wrapped end

			inv_without ("value_consistent")
			is_max (value, init_value, children_set / c) or (c.value > value and across children_set as ic all ic.item.value <= c.value end)

			modify_field (["value", "closed"], [Current, up])
			modify (owns)
			decreases (up)
		do
			if value < c.value then
				if parent /= Void then
					parent.unwrap
				end
				value := c.value
				wrap
				if parent /= Void then
					parent.update (Current)
				end
			else
				wrap
			end
		ensure
			is_wrapped
			across up as p all p.item.is_wrapped end
		end

invariant
	value_consistent: is_max (value, init_value, children_set)
	init_value_relation: value >= init_value
	i1: children /= Void
	i2: children_set = children.sequence
	i3: not up[children] and not children_set[Current] and not children_set[children]
	i5: parent /= Void implies not (children_set[parent])
	i6: across children_set as ic all ic.item /= Void and then ic.item.parent = Current end
	i7: parent = Void implies up.is_empty
	i7: parent /= Void implies (not up[Current] and up = parent.up & parent) -- implies acyclicity
	i9: parent = Void implies subjects = children_set
	i9: parent /= Void implies subjects = children_set & parent
	i10: parent = Void implies observers = children_set
	i10: parent /= Void implies observers = children_set & parent
	i11: owns = [children]
	i12: across subjects as s all s.item.observers.has (Current) end -- default
	i14: across children_set as ic all ic.item.generating_type = {F_COM_COMPOSITE_D} end

note
	explicit: subjects, observers

end
