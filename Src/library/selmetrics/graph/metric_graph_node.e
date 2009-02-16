class
	METRIC_GRAPH_NODE [G]

	inherit
		COMPARABLE
		redefine
			infix "<",
			is_equal
		end

create
	make

feature -- Creation

	make (an_id : G) is
		require
			an_id_set : an_id /= Void
		do
			create {LINKED_LIST[METRIC_GRAPH_NODE[G]]}children.make
			is_marked := False
			id := an_id
		end

feature -- Marking

	is_marked : BOOLEAN

	mark (state : BOOLEAN) is
		do
			is_marked := state
		end

feature -- Comparision

	infix "<" (other: like Current): BOOLEAN is
		do
			if is_equal(other) then
				Result := False
			else
				Result := True
			end
		end

	is_equal (other: like Current): BOOLEAN is
		do
			Result := Current.id = other.id
		end

feature -- Attributes

	id : G

feature {METRIC_GRAPH} -- Friend Attributes

	children : LIST[METRIC_GRAPH_NODE[G]]
		-- the current node's children nodes

invariant
	children_set : children /= Void

end
