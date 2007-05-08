indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_RESOLVER

inherit
	INTERNAL

create
	make

feature	 -- Initialization

	make is
			-- Create an entity resolver
		do
			create entities.make (0, 128)
			-- the Object with id 0 is defined to be Void.
			entities[0] := Void
		end

feature -- Access

	resolve_entity(entity: ENTITY): ANY
			-- Resolve `entity' to a real object. Create the
			-- object if necessary.
		require
			entity_not_void: entity /= Void
		do
			Result := entity.accept(Current)
		ensure
			only_void_entities_resolved_to_void: (Result = Void) implies represents_void(entity)
		end

	resolve_entities (arguments: LIST[ENTITY]): LIST[ANY] is
			--
		require
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			from
				create {ARRAYED_LIST[ANY]}Result.make(arguments.count)
				i := 1
			until
				i >arguments.count
			loop
				Result.put_i_th (resolve_entity(arguments @ i),i)
				i := i + 1
			end
		end


	resolve_basic_entity(basic: BASIC_ENTITY): ANY is
			-- Resolve `basic' to an object representing a basic type.
		require
			basic_not_void: basic /= Void
		do
			--hmm... do some magic ;)
			if basic.type.is_equal ("REAL_32") then
				Result := basic.value.to_real
			elseif basic.type.is_equal("INTEGER_32") then
				Result := basic.value.to_integer
			else
				check False end --not implemented yet.
			end
		ensure
			result_not_void: Result /= Void
		end

	resolve_non_basic_entity(non_basic: NON_BASIC_ENTITY): ANY is
			-- Resolve `non_basic' to an object representing a non basic type.
		require
			non_basic_not_void: non_basic /= Void
		do
			if entities.upper < non_basic.id then
				entities.resize (0, non_basic.id * 2)
			end

			if entities[non_basic.id] = Void then
				create_entity(non_basic)
			end

			Result := entities[non_basic.id]
		ensure
			non_void_entity_resolved: (non_basic.id /= 0) implies (Result /= Void)
		end

	create_entity(non_basic: NON_BASIC_ENTITY)
			-- Create an object representing `non_basic'
		require
			non_basic_not_void: non_basic /= Void
		do
			entities[non_basic.id] := new_instance_of(dynamic_type_from_string(non_basic.type))
		end

	entities: ARRAY[ANY]

	represents_void(entity: ENTITY): BOOLEAN
			-- Does `entity' represent a Void?
		require
			entity_not_void: entity /= Void
		local
			non_basic: NON_BASIC_ENTITY
		do
			non_basic ?= entity
			if non_basic /= Void then
				Result := non_basic.id = 0
			else
				Result := False
			end
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
