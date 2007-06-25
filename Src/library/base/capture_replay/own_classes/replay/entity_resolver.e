indexing
	description: "Object that's responsible for resolving entities to objects"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_RESOLVER

inherit
	INTERNAL

	ENTITY_VISITOR

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

	has_error: BOOLEAN

	error_message: STRING

	resolve_entity (entity: ENTITY): ANY
			-- Resolve `entity' to a real object. Create the
			-- object if necessary.
		require
			entity_not_void: entity /= Void
		do
			Result := entity.resolve (Current)
		ensure
			only_void_entities_resolved_to_void: (Result = Void) implies entity.represents_void
		end

	resolve_entities (arguments: DS_LIST[ENTITY]): DS_LIST[ANY] is
			-- Resolve all entities from `arguments'.
		require
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			from
				create {DS_ARRAYED_LIST[ANY]}Result.make (arguments.count)
				i := 1
			until
				i >arguments.count or has_error
			loop
				Result.put_last (resolve_entity(arguments @ i))
				i := i + 1
			end
		end

	register_object (object: ANY; entity: NON_BASIC_ENTITY) is
			-- Register `object' in the object lookup table.
		require
			object_not_void: object /= Void
			entity_not_void: entity /= Void
			no_different_object_for_same_id: entities[entity.id] /= Void implies object = entities[entity.id]
		do
			if entities[entity.id] = Void then
				entities[entity.id] := object
				object.cr_set_object_id (entity.id)
			end
		ensure
			entity_registered: entities[entity.id] = object
		end

	visit_basic_entity (basic: BASIC_ENTITY): ANY is
				-- Resolve `basic' to an object representing a basic type.
			local
				manifest_special: MANIFEST_SPECIAL [ANY]

			do
				if basic.type.is_equal ("REAL_32") then
					Result := basic.value.to_real
				elseif basic.type.is_equal ("INTEGER_32") then
					Result := basic.value.to_integer
				elseif basic.type.is_equal ("BOOLEAN") then
					Result := basic.value.to_boolean
				elseif basic.type.is_equal ("CHARACTER_8") then
					-- XXX add escaping logic --> as this is needed by MANIFEST_SPECIAL, too,
					--     it should be a part that can be shared.
					Result := basic.value.item (1)
				elseif basic.type.substring_index ("MANIFEST_SPECIAL",1) = 1 then
					-- Although this is no basic type, there's no need to register this object, because
					-- it's only used as manifest type --> no references will be passed beyond the border.
					manifest_special ?= new_instance_of (dynamic_type_from_string(basic.type))
					check
						instance_of_manifest_special_created: manifest_special /= Void
					end
					manifest_special.restore (basic.value)
					Result := manifest_special
				else
					report_and_set_error ("unable to instanciate basic entity of type " + basic.type)
				end
			ensure then
				result_not_void: not has_error implies Result /= Void
			end

	visit_non_basic_entity (non_basic: NON_BASIC_ENTITY): ANY is
			-- Resolve `non_basic' to an object representing a non basic type.
			do
				if entities.upper < non_basic.id then
					entities.resize (0, non_basic.id * 2)
				end

				if entities[non_basic.id] = Void then
					create_and_register_entity (non_basic)
				end

				Result := entities[non_basic.id]
			ensure then
				non_void_entity_resolved: not has_error implies ((non_basic.id /= 0) implies (Result /= Void))
				object_id_matches: not has_error implies non_basic.id = Result.cr_object_id
			end

	create_and_register_entity (non_basic: NON_BASIC_ENTITY)
			-- Create an object representing `non_basic'
		require
			non_basic_not_void: non_basic /= Void
		local
			new_object: ANY
			dtype: INTEGER
			special_element_count: INTEGER
		do
			dtype := dynamic_type_from_string (non_basic.type)
			if not is_special_type (dtype) then
				new_object := new_instance_of (dtype)

				register_object (new_object, non_basic)
			else
				report_and_set_error("creation of SPECIALs not implemented yet.")
				-- XXX not implemented yet. how can the size of the special
				-- be determined???
				-- > new_special_any_instance (dtype, count: INTEGER_32)
			end
		ensure
			entity_created: not has_error implies entities[non_basic.id] /= Void
			correct_type_created: not has_error implies entities[non_basic.id].generating_type.is_equal (non_basic.type)
		end

	entities: ARRAY[ANY]

feature -- Implementation

	report_and_set_error(message: STRING) is
			-- Report an error and activate the 'has_error' attribute.
		do
			has_error := True
			error_message := message
		end

invariant
	invariant_clause: True -- Your invariant here

end
