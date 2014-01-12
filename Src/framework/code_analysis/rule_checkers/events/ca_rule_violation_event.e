note
	description: "Event representing a rule violation detected by the Code Analyzer."
	date: "$Date$"
	revision: "$Revision$"

class
	CA_RULE_VIOLATION_EVENT

inherit

	EVENT_LIST_ITEM_I
		redefine
			data
		end

create
	make

feature {NONE} -- Initialization

	make (a_violation: CA_RULE_VIOLATION)
			-- Initialize event item.
		do
			data := a_violation
			category := {ENVIRONMENT_CATEGORIES}.none
			priority := {PRIORITY_LEVELS}.normal
		ensure
			data_set: data = a_violation
		end

feature -- Access

	data: CA_RULE_VIOLATION
			-- <Precursor>

	description: STRING_32
			-- <Precursor>
		local
			l_string_formatter: YANK_STRING_WINDOW
		do
			if not attached internal_description then
				create l_string_formatter.make
--				single_line_message (l_string_formatter)
				internal_description := l_string_formatter.stored_output
			end
			Result := internal_description
		end

	frozen is_error_event: BOOLEAN
		do
			Result := attached {CA_ERROR} data.rule.severity
		end

	frozen is_warning_event: BOOLEAN
		do
			Result := attached {CA_WARNING} data.rule.severity
		end

	frozen is_suggestion_event: BOOLEAN
		do
			Result := attached {CA_SUGGESTION} data.rule.severity
		end

	frozen is_hint_event: BOOLEAN
		do
			Result := attached {CA_HINT} data.rule.severity
		end

	affected_class: CLASS_C
		do
			Result := data.affected_class
		end

	format_description (a_formatter: TEXT_FORMATTER)
		do
			data.format_violation_description (a_formatter)
		end

	location: LOCATION_AS
		do
			Result := data.location
		end

	title: STRING_32
		do
			Result := data.rule.title
		end

	rule_id: STRING_32
		do
			Result := data.rule.id
		end

	severity_score: INTEGER
		do
			Result := data.rule.severity_score.value
		end

	violation_description: STRING_32
		do
			Result := data.rule.description
		end

	frozen type: NATURAL_8
			-- <Precursor>
		once
			Result := {EVENT_LIST_ITEM_TYPES}.unknown
		end

	frozen category: NATURAL_8
			-- <Precursor>

	frozen priority: INTEGER_8
			-- <Precursor>

feature -- Status report

	is_invalidated: BOOLEAN
			-- <Precursor>

	is_valid_data (a_data: ANY): BOOLEAN
			-- <Precursor>
		do
			Result := data /= Void
		end

feature -- Element change

	set_category (a_category: like category)
			-- <Precursor>
		do
			category := a_category
		end

	set_priority (a_priority: like priority)
			-- <Precursor>
		do
			priority := a_priority
		end

feature -- Basic operations

	invalidate
			-- <Precursor>
		do
			is_invalidated := True
		end

feature {NONE} -- Implementation

	internal_description: detachable STRING_32
			-- Internal buffer for description.

end
