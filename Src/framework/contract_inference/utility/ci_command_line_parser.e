note
	description: "Command line parser for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_COMMAND_LINE_PARSER

create
	make_with_arguments

feature{NONE} -- Initialization

	make_with_arguments (a_args: LINKED_LIST [STRING]; a_system: SYSTEM_I)
			-- Initialize Current with arguments `a_args'.
		do
			create config.make (a_system)
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
			options_set: config.eiffel_system = a_system
		end

feature -- Access

	config: CI_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_build_project_option: AP_STRING_OPTION
			l_feature_name_option: AP_STRING_OPTION
			l_class_name_option: AP_STRING_OPTION
			l_infer_option: AP_FLAG
			l_generate_weka_option: AP_FLAG
			l_weka_assertion_option: AP_STRING_OPTION
			l_max_tc_option: AP_INTEGER_OPTION
			l_premise_number_option: AP_STRING_OPTION
			l_composite_property_option: AP_STRING_OPTION
			l_composite_boolean_premise_connector_option: AP_STRING_OPTION
			l_composite_boolean_connector_option: AP_STRING_OPTION
			l_composite_integer_premise_connector_option: AP_STRING_OPTION
			l_composite_integer_connector_option: AP_STRING_OPTION
			l_sequence_property_option: AP_STRING_OPTION
			l_simple_property_option: AP_STRING_OPTION
			l_daikon_option: AP_STRING_OPTION
			l_dnf_option: AP_STRING_OPTION
			l_max_dnf_clause_option: AP_INTEGER_OPTION
			l_tilda_option: AP_FLAG
			l_implication_flag: AP_STRING_OPTION
			l_linear_flag: AP_STRING_OPTION
			l_simple_equality_flag: AP_STRING_OPTION
			l_dummy_flag: AP_STRING_OPTION
			l_verbose_option: AP_STRING_OPTION
			l_freeze_option: AP_FLAG
			l_generate_mock_option: AP_FLAG
			l_use_mock_option: AP_FLAG
			l_solr_option: AP_STRING_OPTION
			l_breakpoint_monitoring_flag: AP_FLAG
			l_sql_option: AP_STRING_OPTION
			l_test_case_range: AP_STRING_OPTION
			l_use_ssql_option: AP_FLAG
			l_timeout: AP_INTEGER_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_build_project_option.make_with_long_form ("build-from")
			l_build_project_option.set_description ("Transform current project into a project containing infrastructure to support contract inference. Format: --build-from <test case directory>. <test case directory> contains test cases from which contract inference should be performed. The directory is recursively searched to find test cases. <test case directory> should contain test cases for only one class.")
			l_parser.options.force_last (l_build_project_option)

			create l_feature_name_option.make_with_long_form ("feature")
			l_feature_name_option.set_description ("Format: feature <feature_name[,feature_name]+>. Specify that when building project for contract inference, only test cases for <feature_name> is used. When this option is not present, test cases for all features in the class are used. Only have effect when used with option %"build-from%" or %"infer%".")
			l_parser.options.force_last (l_feature_name_option)

			create l_class_name_option.make_with_long_form ("class")
			l_class_name_option.set_description ("Specify name of class whose contracts are to be inferred.")
			l_parser.options.force_last (l_class_name_option)

			create l_infer_option.make_with_long_form ("infer")
			l_infer_option.set_description ("Infer contracts for feature specified with %"feature%" option in class specified in %"class%" option.")
			l_parser.options.force_last (l_infer_option)

			create l_generate_weka_option.make_with_long_form ("generate-weka")
			l_generate_weka_option.set_description (
				"Generate Weka relations from test cases. %N%
				%Format --class <CLASS_NAME> --generate-weka <test case directory> <weka relation output directory>. %N%
				%<test case directory> can be a directory for a single feature or a directory  for a class. In the first case, a single Weka%
				%relation will be generated; in the second case, multiple Weka relations will be generated, one for each feature in the same class.%N%
				%<CLASS_NAME> specifies the class whose Weka relations are to be generated.")
			l_parser.options.force_last (l_generate_weka_option)

			create l_weka_assertion_option.make_with_long_form ("weka-assertion-selection")
			l_weka_assertion_option.set_description ("Mode to select assertions as Weka attributes in the relations. Valid values are %"union%" and %"intersection%". If this option is not specified, the default is %"intersection%".")
			l_parser.options.force_last (l_weka_assertion_option)

			create l_max_tc_option.make_with_long_form ("max-tc-number")
			l_max_tc_option.set_description ("Set the maximal number of test cases to execute. Format --max-tc-number <number>. <number> must be a non-negative integer. Default is 0. 0 means execute all test cases.")
			l_parser.options.force_last (l_max_tc_option)

			create l_premise_number_option.make_with_long_form ("composite-premise-number")
			l_premise_number_option.set_description (
				"Set the minimal and maximal number of premises in a implication frame property. Format --max-premise-number min_value,max_value%
				%min_value is the minimal number of premise, max_value is the maximal number of premise.%
				%0 means no limit. Default is 1,2.")
			l_parser.options.force_last (l_premise_number_option)

			create l_composite_property_option.make_with_long_form ("composite-property")
			l_composite_property_option.set_description ("Should composite frame properties by inferred? Foramt: --composite-property [on|off]%NDefault: on.")
			l_parser.options.force_last (l_composite_property_option)

			create l_composite_boolean_connector_option.make_with_long_form ("boolean-composite-connector")
			l_composite_boolean_connector_option.set_description (
				"Connectors between the premises and consequent of a boolean composite property.%N%
				%Format: --boolean-composite-premise-connector connector[,connector]+%N%
				%Valid connectors are: %"=%", %"implies%"%N%
				%Default: =%N.%
				%Only have effect when the composite-property option is on.")
			l_parser.options.force_last (l_composite_boolean_connector_option)

			create l_composite_boolean_premise_connector_option.make_with_long_form ("boolean-composite-premise-connector")
			l_composite_boolean_connector_option.set_description (
				"Connectors between premises of a boolean composite property.%N%
				%Format: --boolean-composite-premise-connector connector[,connector]+%N%
				%Valid connectors are: %"and%", %"or%"%N%
				%Default: and,or%N.%
				%Only have effect when the composite-property option is on.")
			l_parser.options.force_last (l_composite_boolean_premise_connector_option)

			create l_composite_integer_connector_option.make_with_long_form ("integer-composite-connector")
			l_composite_integer_connector_option.set_description (
				"Connectors between the premises and consequent of an integer composite property.%N%
				%Format: --integer-composite-premise-connector connector[,connector]+%N%
				%Valid connectors are: %"=%", %"/=%", %">%", %">=%", %"<%", %"<=%"%N%
				%Default: =%N.%
				%Only have effect when the composite-property option is on.")
			l_parser.options.force_last (l_composite_integer_connector_option)

			create l_composite_integer_premise_connector_option.make_with_long_form ("integer-composite-premise-connector")
			l_composite_integer_connector_option.set_description (
				"Connectors between premises of an integer composite property.%N%
				%Format: --integer-composite-premise-connector connector[,connector]+%N%
				%Valid connectors are: %"+%", %"-%"%N%
				%Default: +%N.%
				%Only have effect when the composite-property option is on.")
			l_parser.options.force_last (l_composite_integer_premise_connector_option)

			create l_sequence_property_option.make_with_long_form ("sequence-property")
			l_sequence_property_option.set_description ("Should sequence-based frame properties be inferred?%N Format: --sequence-property [on|off].%NDefault: on.")
			l_parser.options.force_last (l_sequence_property_option)

			create l_simple_property_option.make_with_long_form ("simple-property")
			l_simple_property_option.set_description ("Should simple-based frame properties be inferred?%N Format: --simple-property [on|off].%NDefault: on.")
			l_parser.options.force_last (l_simple_property_option)

			create l_daikon_option.make_with_long_form ("daikon")
			l_daikon_option.set_description ("Should Daikon be used as an inferrer?%N Format: --daikon [on|off].%NDefault: on.")
			l_parser.options.force_last (l_daikon_option)

			create l_dnf_option.make_with_long_form ("dnf-property")
			l_dnf_option.set_description ("Should properties in DNF format be inferred?%N Format: --daikon [on|off].%NDefault: on.")
			l_parser.options.force_last (l_dnf_option)

			create l_max_dnf_clause_option.make_with_long_form ("max-dfn-clause")
			l_max_dnf_clause_option.set_description ("Set maximal number of clauses for properties in DNF format.%NFormat: --max-dnf-clause <integer>, <integer> must be a positive integer. Default: 2")
			l_parser.options.force_last (l_max_dnf_clause_option)

			create l_tilda_option.make_with_long_form ("tilda")
			l_tilda_option.set_description ("Is contract mentioning %"~%" enabled? Default: False")
			l_parser.options.force_last (l_tilda_option)

			create l_implication_flag.make_with_long_form ("implication-property")
			l_implication_flag.set_description ("Should implications be inferred?%NFormat: --implication-property [on|off].%NDefault: on.")
			l_parser.options.force_last (l_implication_flag)

			create l_linear_flag.make_with_long_form ("linear-property")
			l_linear_flag.set_description ("Should linear properties be inferred?%NFormat: --linear-property [on|off].%NDefault: on.")
			l_parser.options.force_last (l_linear_flag)

			create l_simple_equality_flag.make_with_long_form ("simple-equality-property")
			l_simple_equality_flag.set_description ("Should simple equality properties in form of p = q be inferred?%NFormat: --simple-equality-property [on|off].%NDefault: on.")
			l_parser.options.force_last (l_simple_equality_flag)

			create l_dummy_flag.make_with_long_form ("dummy-property")
			l_dummy_flag.set_description ("Should dummy properties be inferred?%NFormat: --dummy-property [on|off].%NDefault: off.")
			l_parser.options.force_last (l_dummy_flag)

			create l_verbose_option.make_with_long_form ("verbose")
			l_verbose_option.set_description ("Set verbose level.%NFormat: --verbose [info|fine].%N%"info%" will provide basic information. %"fine%" will produce detailed information, suitable for debugging.%NDefault: info. ")
			l_parser.options.force_last (l_verbose_option)

			create l_freeze_option.make_with_long_form ("freeze")
			l_freeze_option.set_description ("Should the project be frozen before contract inference starts? Default: False.")
			l_parser.options.force_last (l_freeze_option)

			create l_generate_mock_option.make_with_long_form ("generate-mock")
			l_generate_mock_option.set_description ("Generate mocking information.")
			l_parser.options.force_last (l_generate_mock_option)

			create l_use_mock_option.make_with_long_form ("use-mock")
			l_use_mock_option.set_description ("Enable using mocking information. Default: False")
			l_parser.options.force_last (l_use_mock_option)

			create l_solr_option.make_with_long_form ("generate-solr")
			l_solr_option.set_description ("Enable generating solr files. Format: --generate-solr [on|off]. Default: off")
			l_parser.options.force_last (l_solr_option)

			create l_sql_option.make_with_long_form ("generate-ssql")
			l_sql_option.set_description ("Enable generating sql files. Format: --generate-ssql [on|off]. Default: off")
			l_parser.options.force_last (l_sql_option)

			create l_breakpoint_monitoring_flag.make_with_long_form ("monitor-breakpoint")
			l_breakpoint_monitoring_flag.set_description ("Should breakpoint visit status of feature under analysis be monitored? Default: False")
			l_parser.options.force_last (l_breakpoint_monitoring_flag)

			create l_test_case_range.make_with_long_form ("test-case-range")
			l_test_case_range.set_description ("Specify the range of test cases to run. Format: --test-case-range start,end. start and end are two integer numbers. 0,0 means to run all test cases. Default: 0,0")
			l_parser.options.force_last (l_test_case_range)

			create l_use_ssql_option.make_with_long_form ("use-ssql")
			l_use_ssql_option.set_description ("Enable using ssql information. Default: False")
			l_parser.options.force_last (l_use_ssql_option)

			create l_timeout.make_with_long_form ("time-out")
			l_timeout.set_description ("Specify maximal time (in seconds) for a test case to run. Format: --time-out integer. Default: 120")
			l_parser.options.force_last (l_timeout)

			l_parser.parse_list (l_args)
			if l_build_project_option.was_found then
				config.set_should_build_project (True)
				config.set_test_case_directory (l_build_project_option.parameter)
			end

			if l_feature_name_option.was_found then
				config.set_feature_name_for_test_cases (l_feature_name_option.parameter)
			end

			if l_class_name_option.was_found then
				config.set_class_name (l_class_name_option.parameter)
			end

			config.set_should_infer_contracts (l_infer_option.was_found)

			if l_generate_weka_option.was_found then
				setup_generate_weka (config, l_parser.parameters)
			end

			if l_weka_assertion_option.was_found then
				setup_weka_assertion_selection (config, l_weka_assertion_option.parameter)
			else
				setup_weka_assertion_selection (config, Void)
			end

			if l_max_tc_option.was_found then
				if l_max_tc_option.parameter > 0 then
					config.set_max_test_case_to_execute (l_max_tc_option.parameter)
				else
					config.set_max_test_case_to_execute (0)
				end
			end

			if l_premise_number_option.was_found then
				setup_composite_premise_number (config, l_premise_number_option.parameter)
			else
				setup_composite_premise_number (config, Void)
			end

			if l_composite_property_option.was_found then
				setup_composite_property (config, l_composite_property_option.parameter)
			else
				setup_composite_property (config, Void)
			end

			if l_composite_boolean_connector_option.was_found then
				setup_composite_boolean_connectors (config, l_composite_boolean_connector_option.parameter)
			else
				setup_composite_boolean_connectors (config, Void)
			end

			if l_composite_integer_connector_option.was_found then
				setup_composite_integer_connectors (config, l_composite_integer_connector_option.parameter)
			else
				setup_composite_integer_connectors (config, Void)
			end

			if l_composite_boolean_premise_connector_option.was_found then
				setup_composite_boolean_premise_connectors (config, l_composite_boolean_premise_connector_option.parameter)
			else
				setup_composite_boolean_premise_connectors (config, Void)
			end

			if l_composite_integer_premise_connector_option.was_found then
				setup_composite_integer_premise_connectors (config, l_composite_integer_premise_connector_option.parameter)
			else
				setup_composite_integer_premise_connectors (config, Void)
			end

			if l_sequence_property_option.was_found then
				setup_sequence_property (config, l_sequence_property_option.parameter)
			else
				setup_sequence_property (config, Void)
			end

			if l_simple_property_option.was_found then
				setup_simple_property (config, l_simple_property_option.parameter)
			else
				setup_simple_property (config, Void)
			end

			if l_daikon_option.was_found then
				setup_daikon_property (config, l_daikon_option.parameter)
			else
				setup_daikon_property (config, Void)
			end

			if l_dnf_option.was_found then
				setup_dnf_property (config, l_dnf_option.parameter)
			else
				setup_dnf_property (config, Void)
			end

			if l_max_dnf_clause_option.was_found and then l_max_dnf_clause_option.parameter > 0 then
				config.set_max_dnf_clause (l_max_dnf_clause_option.parameter)
			else
				config.set_max_dnf_clause (2)
			end

			if l_implication_flag.was_found then
				setup_implication_property (config, l_implication_flag.parameter)
			else
				setup_implication_property (config, Void)
			end

			if l_linear_flag.was_found then
				setup_linear_property (config, l_linear_flag.parameter)
			else
				setup_linear_property (config, Void)
			end

			if l_simple_equality_flag.was_found then
				setup_simple_equality_property (config, l_simple_equality_flag.parameter)
			else
				setup_simple_equality_property (config, Void)
			end

			if l_dummy_flag.was_found then
				setup_dummy_property (config, l_dummy_flag.parameter)
			else
				setup_dummy_property (config, Void)
			end

			if l_verbose_option.was_found then
				setup_verbose_level (config, l_verbose_option.parameter)
			else
				setup_verbose_level (config, Void)
			end

			if l_solr_option.was_found then
				setup_generate_solr_property (config, l_solr_option.parameter)
			else
				setup_generate_solr_property (config, Void)
			end

			if l_sql_option.was_found then
				setup_generate_sql_property (config, l_sql_option.parameter)
			else
				setup_generate_sql_property (config, Void)
			end

			if l_breakpoint_monitoring_flag.was_found then
				config.set_is_breakpoint_monitoring_enabled (True)
			end

			config.set_should_use_mocking (l_use_mock_option.was_found)
			config.set_should_use_ssql (l_use_ssql_option.was_found)
			config.set_should_generate_mocking (l_generate_mock_option.was_found)

			config.set_should_freeze (l_freeze_option.was_found)
			config.set_is_tilda_enabled ( l_tilda_option.was_found)

			if l_timeout.was_found then
				config.set_test_case_execution_timeout (l_timeout.parameter)
			else
				config.set_test_case_execution_timeout (120)
			end

			if l_test_case_range.was_found then
				setup_test_case_range (config, l_test_case_range.parameter)
			else
				setup_test_case_range (config, "0,0")
			end
		end

feature{NONE} -- Implementation

	setup_test_case_range (a_config: CI_CONFIG; a_value: STRING)
			-- Setup test case range.
		local
			l_parts: LIST [STRING]
		do
			l_parts := a_value.split (',')
			if l_parts.count = 2 then
				l_parts.first.left_adjust
				l_parts.first.right_justify
				l_parts.last.left_adjust
				l_parts.last.right_adjust
				config.set_test_case_range (l_parts.first.to_integer, l_parts.last.to_integer)
			else
				config.set_test_case_range (0, 0)
			end
		end

	setup_generate_solr_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup solr property
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("off") then
				config.set_should_generate_solr (False)
			elseif a_parameter.is_case_insensitive_equal ("on") then
				config.set_should_generate_solr (True)
			end
		end

	setup_generate_sql_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup sql property
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("off") then
				config.set_should_generate_sql (False)
			elseif a_parameter.is_case_insensitive_equal ("on") then
				config.set_should_generate_sql (True)
			end
		end

	setup_verbose_level (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup verbose level.
		do
			a_config.set_verbose_level ({EPA_LOG_MANAGER}.info_level)
			if a_parameter /= Void then
				if a_parameter.is_case_insensitive_equal ("info") then
					a_config.set_verbose_level ({EPA_LOG_MANAGER}.info_level)
				elseif a_parameter.is_case_insensitive_equal ("fine") then
					a_config.set_verbose_level ({EPA_LOG_MANAGER}.fine_level)
				end
			end
		end

	setup_dummy_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if dummy properties are to be inferred.
		do
			if a_parameter /= Void and then a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_dummy_property_enabled (True)
			elseif a_parameter = Void or else a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_dummy_property_enabled (False)
			end
		end

	setup_simple_equality_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if simple_equality properties are to be inferred.
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_simple_equality_property_enabled (True)
				config.set_is_constant_change_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_simple_equality_property_enabled (False)
				config.set_is_constant_change_property_enabled (False)
			end
		end

	setup_linear_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if linear properties are to be inferred.
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_linear_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_linear_property_enabled (False)
			end
		end

	setup_implication_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if implication properties are to be inferred.
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_implication_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_implication_property_enabled (False)
			end
		end

	setup_dnf_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if properties in DNF format are to be inferred.
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_dnf_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_dnf_property_enabled (False)
			end
		end

	setup_daikon_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if Daikon is used?
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_daikon_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_daikon_enabled (False)
			end
		end

	setup_simple_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if simple frame property are to be inferred?
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_simple_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_simple_property_enabled (False)
			end
		end

	setup_sequence_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if sequence frame property are to be inferred?
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_sequence_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_sequence_property_enabled (False)
			end
		end

	setup_composite_boolean_premise_connectors (a_config: CI_CONFIG; a_parameter: detachable STRING)
		local
			l_connector: STRING
		do
			if a_parameter = Void then
				config.composite_boolean_premise_connectors.extend ("and")
				config.composite_boolean_premise_connectors.extend ("or")
			else
				across a_parameter.split (',') as l_connectors loop
					l_connector := l_connectors.item.as_lower
					if
						(l_connector ~ "and") or else
						(l_connector ~ "or")
					then
						config.composite_boolean_premise_connectors.extend (l_connector)
					end
				end
			end
		end

	setup_composite_boolean_connectors (a_config: CI_CONFIG; a_parameter: detachable STRING)
		local
			l_connector: STRING
		do
			if a_parameter = Void then
				config.composite_boolean_connectors.extend ("=")
			else
				across a_parameter.split (',') as l_connectors loop
					l_connector := l_connectors.item.as_lower
					if
						(l_connector ~ "=") or else
						(l_connector ~ "implies")
					then
						config.composite_boolean_connectors.extend (l_connector)
					end
				end
			end
		end

	setup_composite_integer_premise_connectors (a_config: CI_CONFIG; a_parameter: detachable STRING)
		local
			l_connector: STRING
		do
			if a_parameter = Void then
				config.composite_integer_premise_connectors.extend ("+")
			else
				across a_parameter.split (',') as l_connectors loop
					l_connector := l_connectors.item.as_lower
					if
						(l_connector ~ "+") or else
						(l_connector ~ "-")
					then
						config.composite_integer_premise_connectors.extend (l_connector)
					end
				end
			end
		end

	setup_composite_integer_connectors (a_config: CI_CONFIG; a_parameter: detachable STRING)
		local
			l_connector: STRING
		do
			if a_parameter = Void then
				config.composite_integer_connectors.extend ("=")
			else
				across a_parameter.split (',') as l_connectors loop
					l_connector := l_connectors.item.as_lower
					if
						(l_connector ~ "=") or else
						(l_connector ~ "/=") or else
						(l_connector ~ ">") or else
						(l_connector ~ ">=") or else
						(l_connector ~ "<") or else
						(l_connector ~ "<=")
					then
						config.composite_integer_connectors.extend (l_connector)
					end
				end
			end
		end

	setup_composite_property (a_config: CI_CONFIG; a_parameter: detachable STRING)
			-- Setup if composite frame property are to be inferred?
		do
			if a_parameter = Void or else a_parameter.is_case_insensitive_equal ("on") then
				config.set_is_composite_property_enabled (True)
			elseif a_parameter.is_case_insensitive_equal ("off") then
				config.set_is_composite_property_enabled (False)
			end
		end

	setup_generate_weka (a_config: CI_CONFIG; a_parameters: DS_LIST [STRING])
			-- Setup `a_config' using data given in `a_parser' for Weka relation generation.
		do
			a_config.set_should_generate_weka_relations (True)
			check a_parameters.count = 2 end
			config.set_test_case_directory (a_parameters.first)
			config.set_output_directory (a_parameters.last)
		end

	setup_weka_assertion_selection (a_config: CI_CONFIG; a_mode: detachable STRING)
			-- Setup `a_cnofig' using `a_mode' for weka assertion selection mode.
		do
			if a_mode /= Void and then a_mode.is_case_insensitive_equal ("union") then
				a_config.set_weka_assertion_selection_mode ({CI_CONFIG}.weka_assertion_union_selection_mode)
			else
				a_config.set_weka_assertion_selection_mode ({CI_CONFIG}.weka_assertion_intersection_selection_mode)
			end
		end

	setup_composite_premise_number (a_config: CI_CONFIG; a_bounds: detachable STRING)
			-- Set `aconfig' using `a_bounds' for min and max number of premises used in
			-- composite frame property inference.
		local
			l_parts: LIST [STRING]
			l_min, l_max: INTEGER
			l_ok: BOOLEAN
		do
			if a_bounds /= Void then
				l_parts := a_bounds.split (',')
				if l_parts.count = 2 and then l_parts.first.is_integer and then l_parts.last.is_integer then
					l_min := l_parts.first.to_integer
					l_max := l_parts.last.to_integer
					if l_min > 0 and then l_max >= 0 then
						l_ok := True
						a_config.set_composite_min_premise_number (l_min)
						a_config.set_composite_max_premise_number (l_max)
					end
				end
			end
			if not l_ok then
				a_config.set_composite_min_premise_number (1)
				a_config.set_composite_max_premise_number (2)
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
