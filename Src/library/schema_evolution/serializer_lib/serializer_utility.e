note
	description: "Utility class that handles some basic refactorings."
	author: "Teseo Schneider, Marco Piccioni"
	date: "08.04.2009"

class
	SERIALIZER_UTILITY

feature -- Default tuples to handle basic refactorings

	attribute_changed_name (old_name: STRING): TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]] 
			-- Agent to change the attribute name
		local
			var: ARRAYED_LIST [STRING]
		do
			create var.make (1)

			var.extend (old_name)

			Result := [var,agent change_name (?)]
		end

	attribute_constant_initialization (value: ANY): TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]]
			-- Agent to set a constant value
		local
			var: ARRAYED_LIST [STRING]
		do
			create var.make (1)
			Result := [var, agent constant_function (value,?)]
		end

	attribute_changed_type (old_name: STRING; conv_function: FUNCTION[ANY, TUPLE, ANY]): TUPLE [LIST [STRING], FUNCTION [ANY, TUPLE [LIST [ANY]], ANY]]
			-- Agent to change the type
		local
			var: ARRAYED_LIST [STRING]
		do
			create var.make (1)
			var.force (old_name)

			Result := [var, agent change_type (?, conv_function)]
		end


feature{NONE} -- Utility functions

	change_name (var: LIST [ANY]): ANY
			-- Change the name.
		do
			Result := var.i_th (1)
		end

	constant_function (value: ANY; var: LIST [ANY]): ANY
			-- Assign a constant value.
		do
			Result := value
		end

	change_type (var: LIST[ANY];conv_function: FUNCTION[ANY,TUPLE,ANY]): ANY
			-- Change the type.
		do
			Result := conv_function.item (Void)
		end

feature -- Type conversion function

	to_string (a: ANY) :STRING
			-- Perform a conversion to STRING.
		do
			Result := a.out
		end

	to_integer (s: STRING): INTEGER
			-- Perform a conversion to INTEGER.
		do
			Result := s.to_integer
		end

	to_double (s: STRING): DOUBLE
			-- Perform a conversion to DOUBLE.
		do
			Result := s.to_double
		end

	to_boolan (s: STRING): BOOLEAN
			-- Perform a conversion to BOOLEAN.
		do
			Result := s.to_boolean
		end
end
