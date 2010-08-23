note
	description: "A specific configuration for a tool."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_TOOL_CONFIGURATION

create
	make

feature {NONE} -- Initialization

	make (a_tool: attached like tool; a_name: attached like name)
			-- Initialize tool configuration for tool `a_tool'.
		do
			tool := a_tool
			name := a_name.twin
			create description.make_empty
			create settings.make (10)
		ensure
			tool_set: tool = a_tool
			name_set: name ~ a_name
		end

feature -- Access

	tool: attached EBB_TOOL
			-- Tool associated with this configuration.

	name: attached STRING
			-- Name for this configuration.

	description: attached STRING
			-- Description for this configuration.

	settings: attached HASH_TABLE [STRING, STRING]
			-- Settings for this configuration.

	string_setting (a_key: STRING): STRING
			-- Setting for `a_key' as a string.
		do
			if settings.has (a_key) then
				Result := settings.item (a_key)
			else
				-- TODO: return default value for `a_key'
			end
		ensure
			result_attached: Result /= Void
		end

	integer_setting (a_key: STRING): INTEGER
			-- Setting for `a_key' as an integer.
		local
			l_string: STRING
		do
			l_string := string_setting (a_key)
			if l_string.is_integer then
				Result := l_string.to_integer
			end
		end

	boolean_setting (a_key: STRING): BOOLEAN
			-- Setting for `a_key' as a boolean.
		local
			l_string: STRING
		do
			l_string := string_setting (a_key)
			if l_string.is_boolean then
				Result := l_string.to_boolean
			end
		end

end
