note
	description: "Summary description for {CA_RULE_OPTION}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE_OPTION [G]

inherit
	HASHABLE

feature -- Hash Code
	hash_code: INTEGER
		deferred
		end

feature -- Properties

	caption: STRING
		deferred
		end

	has_predefined_choice: BOOLEAN
		deferred
		end

	predefined_choice: detachable ARRAYED_LIST[G]
		deferred
		end

	predefined_choice_names: detachable ARRAYED_LIST[STRING]
		deferred
		end

	default_choice_index: INTEGER
		deferred
		end

	choice: G

invariant
	choice_names_correspond: has_predefined_choice implies
			(predefined_choice.count = predefined_choice_names.count)
	choice_index_valid: default_choice_index <= predefined_choice.count
	choice_valid: has_predefined_choice implies
			predefined_choice.has (choice)
end
