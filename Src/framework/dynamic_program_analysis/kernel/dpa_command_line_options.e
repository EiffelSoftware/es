note
	description: "Command line options for dynamic program analyses."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND_LINE_OPTIONS

feature -- Access

	Option_class: STRING = "class"
			-- Name of option to specify the context class of the feature under analysis.

	Option_feature: STRING = "feature"
			-- Name of option to specify the feature under analysis.

	Option_program_location_search: STRING	= "program-location-search"
			-- Name of option to enable program location search.

	Option_expression_search: STRING = "expression-search"
			-- Name of option to enable expression search.

	Option_all_program_locations: STRING = "all-program-locations"
			-- Name of option to use all program locations.

	Option_variables: STRING = "variables"
			-- Name of option to specify variables.

	Option_expressions: STRING = "expressions"
			-- Name of option to specify expressions.

	Option_program_locations: STRING = "program-locations"
			-- Name of option to specify program locations.

	Option_localized_variables: STRING = "localized-variables"
			-- Name of option to specifiy localized variables.

	Option_localized_expressions: STRING = "localized-expressions"
			-- Name of option to specify localized expressions.

	Option_json_file_writer: STRING = "json-file-writer"
			-- Name of option to specify JSON file writer options.

	Option_mysql_writer: STRING = "mysql-writer"
			-- Name of option to specify MYSQL writer options.

end
