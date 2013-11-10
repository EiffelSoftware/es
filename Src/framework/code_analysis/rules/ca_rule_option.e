note
	description: "Summary description for {CA_RULE_OPTION}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_RULE_OPTION [G]

inherit
	HASHABLE
create
	make_with_caption

feature {NONE} -- Initialization

	make_with_caption (a_caption: STRING)
		do
			caption := a_caption
			has_predefined_choice := False
		end

feature -- Hash Code
	hash_code: INTEGER
		do
			Result := caption.hash_code
			if has_predefined_choice then
				Result := Result + predefined_choice_names.first.hash_code
			end
		end

feature -- Properties

	caption: STRING

	has_predefined_choice: BOOLEAN

	predefined_choice: detachable ARRAYED_LIST[G]

	predefined_choice_names: detachable ARRAYED_LIST[STRING]

	default_choice_index: INTEGER

	choice: detachable G

	n_choices: INTEGER
		do
			Result := predefined_choice.count
		end

	is_valid_choice (a_choice: G): BOOLEAN
		do
			valid_choice_agent.call ([a_choice])
			Result := valid_choice_agent.last_result
		end

feature {CA_RULE} -- Properties

	set_predefined_choice
		do
			has_predefined_choice := True
			create predefined_choice.make (0)
			create predefined_choice_names.make (0)
		end

	set_no_predefined_choice
		do
			has_predefined_choice := False
			predefined_choice := Void
			predefined_choice_names := Void
			valid_choice_agent := Void
		end

	add_choice (a_choice: G; a_name: STRING)
		require
			has_predefined_choice
		do
			predefined_choice.extend (a_choice)
			predefined_choice_names.extend (a_name)
		end

	set_default_choice_index (a_index: INTEGER)
		do
			default_choice_index := a_index
		end

	set_choice_index (a_index: INTEGER)
		require
			has_predefined_choice
			within_bounds: a_index > 0 and a_index < predefined_choice.count
		do
			choice := predefined_choice.at (a_index)
		end

	set_choice (a_choice: G)
		require
			(not has_predefined_choice) or predefined_choice.has (a_choice)
			is_valid_choice (a_choice)
		do
			choice := a_choice
		end

	set_valid_choice_agent (a_agent: FUNCTION[ANY, TUPLE[G], BOOLEAN])
		require
			not has_predefined_choice
		do
			valid_choice_agent := a_agent
		end

feature {NONE} -- Validation

	valid_choice_agent: detachable FUNCTION[ANY, TUPLE[G], BOOLEAN]

invariant
	choice_names_correspond: has_predefined_choice implies
			(predefined_choice.count = predefined_choice_names.count)
	choice_index_valid: default_choice_index <= predefined_choice.count
	choice_valid: has_predefined_choice implies
			predefined_choice.has (choice)
end
