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
				across nodes as n some n.item.value = v end
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
			across up as p all p.item.is_wrapped end

			modify ([Current, c])
			modify_field ("value", up)
		do
			unwrap -- default: public
			c.unwrap
			unwrap_all (children_set)

			children.extend_back  (c) -- preserves parent
			set_subjects (subjects & c)
			set_observers (observers & c)
			c.set_parent (Current)
			c.set_subjects (c.subjects & Current)
			c.set_observers (c.observers & Current)
			children_set := children_set & c

			wrap_all (children_set)
			update (c)
			wrap -- default: public
		ensure
			children.has (c)
			c.value = old c.value

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
			is_open
			across observers as o all o.item.is_open end
			inv_without ("value_consistent") -- All invariant clauses except "value_consistent"
			across up as p all p.item.is_wrapped end
			is_max (value, children_set / c)

			modify_field ("value", [Current, up])
			decreases (up)
		do
			if value < c.value then
				if parent /= Void then
					check up [parent] end
					check parent.is_wrapped end
					parent.unwrap
				end
				value := c.value  -- preserves children
				if parent /= Void then
					update (parent) -- parent.update
				end
			end
			wrap
		ensure
			is_wrapped
		end

invariant
	children /= Void
	children_set = children.sequence
	across children_set as c all c.item /= Void and then c.item.parent = Current end
----	parent /= Void implies (parent.left = Current or parent.right = Current)
	parent /= Void implies (not up[parent] and up = parent.up & parent) -- implies acyclicity
	parent = Void implies up.is_empty
	value_consistent: is_max (value, children_set)
	subjects = children_set & parent  / Void
	observers = children_set & parent / Void
	owns = [children]
	across subjects as s all s.item.observers.has (Current) end -- default

note
	explicit: subjects, observers

end

