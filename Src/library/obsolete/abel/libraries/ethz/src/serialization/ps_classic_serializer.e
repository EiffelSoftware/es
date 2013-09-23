note
	description: "[
		Objects used to serialize other objects into binary format. 
		This is the oldest Eiffel serialization mechanism.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CLASSIC_SERIALIZER

inherit

	PS_SERIALIZER
	redefine
			make
	end

create
	make

feature -- Initialization

	make (a_file: RAW_FILE)
			-- Set the serializer for binary serialization on file.
		do
			precursor (a_file)
			medium := a_file
			create {PS_INDEPENDENT_BINARY_FORMAT} format
			create retrieved_items.make (Default_dimension)
			create last_retrieval_information.make_empty
		end

feature -- Basic Operations

	store (an_object: ANY)
			--	Serialize an_object using the format and medium set for current object.
		local
			storable_object_wrapper: detachable PS_STORABLE_WRAPPER
		do
			if attached {STRING} medium.name as name then
				if attached {STORABLE} an_object as obj then
					obj.store_by_name (name)
				else
					create storable_object_wrapper.set_wrapped_object (an_object)
					storable_object_wrapper.store_by_name (name)
				end
				last_store_successful := True
			else
				fixme ("Replace with log message")
				print ("%NMedium name is Void!")
			end
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.		
		do
			fixme ("To be implemented")
		end

	retrieve
			-- Retrieve an_object using the medium and format set for current object.
			-- Put the result in 'retrieved_item'.
		local
			l_retrieved_item: detachable ANY
			l_storable: STORABLE
		do
			if attached {STRING} medium.name as name then
				create l_storable
				l_retrieved_item := l_storable.retrieve_by_name (name)
				if attached {STORABLE} l_retrieved_item then
					if attached {PS_STORABLE_WRAPPER} l_retrieved_item as obj then
						retrieved_items.extend (obj.wrapped_object)
					else
						retrieved_items.extend (l_retrieved_item)
					end
					last_retrieval_information.append ("%NRetrieval successful. ")
					retrieved_items.forth
				else
					retrieved_items.extend (Void)
					fixme ("Replace print with log message")
					print ("%NUnexpected type at retrieval. It does not inherit from STORABLE. ")
					last_retrieval_information.append ("%NUnexpected type at retrieval. It does not inherit from STORABLE. ")
					retrieved_items.forth
				end
			else
				fixme ("Replace with log message")
				print ("%NMedium name is Void!")
			end
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		do
			fixme ("To be implemented")
		end

invariant
	format_is_independent_binary_format: format.generating_type.name.is_equal ("PS_INDEPENDENT_BINARY_FORMAT")

end
