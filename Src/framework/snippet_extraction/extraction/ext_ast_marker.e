note
	description: "Iterator to mark information relevant AST nodes for further snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_MARKER

inherit
	AST_ITERATOR

	REFACTORING_HELPER

create
	make_from_variable_information

feature {NONE} -- Initialization

	make_from_variable_information (a_variable_type: TYPE_A; a_variable_name: STRING; a_interface_variables: HASH_TABLE [TYPE_A, STRING])
			-- Initialization with variable type and name.
		require
			attached a_variable_type
			attached a_variable_name
			attached a_interface_variables
			target_variable_is_not_an_interface_variable: not a_interface_variables.has (a_variable_name)
		do
			variable_type := a_variable_type
			variable_name := a_variable_name
			interface_variables := a_interface_variables

			create annotations.make (20)
			annotations.compare_objects
		ensure
			attached variable_type
			attached variable_name
			attached interface_variables
			attached annotations
			annotations_comparing_objects: annotations.object_comparison
		end

feature -- Access

	annotations: HASH_TABLE [LINKED_LIST [EXT_ANNOTATION], AST_PATH]
		-- Annotations associated to ast path nodes.

feature {NONE} -- Implementation

	variable_type: TYPE_A
		-- Type of the variable at which we are looking at.

	variable_name: STRING
		-- Name of the variable at which we are looking at.

	interface_variables: HASH_TABLE [TYPE_A, STRING]
		-- Interface variables are mentioned in control flow statements solely witout a feature call.

	annotation_factory: EXT_ANNOTATION_FACTORY
		once
			create Result
		end

feature {NONE} -- Annotation

	is_target_variable (a_variable_name: like variable_name): BOOLEAN
			-- Query if `variable_name' is equal to the target variable.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			Result := variable_name = a_variable_name
		end

	is_interface_variable (a_variable_name: like variable_name): BOOLEAN
			-- Query if `variable_name' is one of the interface variables.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			Result := interface_variables.has (a_variable_name)
		end

	is_variable_of_interest (a_variable_name: like variable_name): BOOLEAN
			-- Query if `variable_name' is either the target or one of the interface variables.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			-- Result := variable_name = a_variable_name or interface_variables.has (a_variable_name)
			Result := is_target_variable (a_variable_name) or is_interface_variable (a_variable_name)
		end

	add_annotation (location: AST_PATH; annotation: EXT_ANNOTATION)
			-- Add an AST annotation for the given path `location'.
		local
			l_location_marks: LINKED_LIST [EXT_ANNOTATION]
		do
			if not annotations.has (location) then
				create l_location_marks.make
				annotations.force (l_location_marks, location)
			else
				l_location_marks := annotations.at (location)
			end

			check annotations.has (location) and attached l_location_marks and annotations.at (location) = l_location_marks end
			l_location_marks.force (annotation)
		end

end
