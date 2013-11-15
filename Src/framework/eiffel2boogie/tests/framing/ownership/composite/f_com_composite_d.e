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
			-- Set of transitive parents and non-transitive children
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
			not up[c]
			across up as p all p.item.is_wrapped end

			modify ([Current, c])
			modify_field (["value", "closed"], up)
			modify (children_set)
		do
			unwrap -- default: public
			c.unwrap
			if parent /= Void then
				parent.unwrap
			end

			check across children_set as o all o.item.is_wrapped end end
			children.extend_back  (c) -- preserves parent
			set_subjects (subjects & c)
			set_observers (observers & c)
			c.set_parent (Current)
			c.set_subjects (c.subjects & Current)
			c.set_observers (c.observers & Current)
			check across children_set as o all o.item.is_wrapped end end
			check false end
			unwrap_all (children_set)
			children_set := children_set & c

			check across children_set as o all o.item.inv_only ("i1", "i2") end end
			check false end

			wrap_all (children_set)
			if parent /= Void then
				parent.wrap
			end

			update (c)

			wrap -- default: public
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

--			not (children_set / c).is_empty implies is_max (value, children_set / c)
--			is_max (value, children_set / c) or is_max (c.value, children_set)

			modify_field (["value", "closed"], [Current, up])
			decreases (up)
		do
			if
				((children_set / c).is_empty and value /= c.value) or
				value < c.value
			then
				if parent /= Void then
					parent.unwrap
				end
				value := c.value
				wrap
				if parent /= Void then
					parent.update (Current)
				end
			else
				check value >= c.value end
				check is_max (value, children_set) end
				wrap
			end
--			check assume: false end


--			if value < c.value then
--				check assume: false end
--				if parent /= Void then
--					parent.unwrap
--				end
--				value := c.value  -- preserves children
--				wrap
--				if parent /= Void then
--					parent.update (Current)
--				end
--			elseif (children_set / c).is_empty then
--				if parent /= Void then
--					parent.unwrap
--				end
--				value := c.value
--				check is_max (value, children_set) end
--				wrap
--				if parent /= Void then
--					parent.update (Current)
--				end
--			else
--				check assume: false end
--			end
		ensure
			is_wrapped
			across up as p all p.item.is_wrapped end
--			across children_set as o all o.item.is_wrapped end
--			has_to_fail: false
		end

invariant
	value_consistent: is_max (value, children_set)

	i1: children /= Void
	i2: children_set = children.sequence
	i3: not children_set[Current]
	i3: not children_set[children] and not up[children]
	i4: parent /= Current
	i5: parent /= Void implies not (children_set[parent])
	i6: across children_set as ic all ic.item /= Void and then ic.item.parent = Current end
	i7: parent /= Void implies (not up[Current] and up = parent.up & parent) -- implies acyclicity
	i8: parent = Void implies up.is_empty
	i9: parent = Void implies subjects = children_set
	i9: parent /= Void implies subjects = children_set & parent
	i10: parent = Void implies observers = children_set
	i10: parent /= Void implies observers = children_set & parent
	i11: owns = [children]
	i12: across subjects as s all s.item.observers.has (Current) end -- default
	i13: not children_set[Void]
	i14: across children_set as ic all ic.item.generating_type = {F_COM_COMPOSITE_D} end

note
	explicit: subjects, observers

end
