note
	description: "This class will provide the initial xml with the placeholders for the validation, algorithm type and all others."
	author: "Nikolay Kazmin"
	date: "$Date$"
	revision: "$Revision$"

class
	RM_SEED_XML_GENERATOR
inherit
	RM_CONSTANTS

create
	make
feature{NONE} -- Creation

	make (a_algorithm_name: STRING; a_validation_code: INTEGER)
			-- `a_algorithm_name' is the algorithm name representing the type of algorithm to be performed by rapid miner.
			-- `a_validation_code' is the validation which will be performed by rapid miner.L

		do
			algorithm_name := a_algorithm_name
			validation_code := a_validation_code
		end

feature -- Interface

	xml: STRING
			-- seed xml for rapidminer with the appropriate placeholders for validation and algorithms

	generate_xml
			-- generates the seed xml depending on the algorithm type and the validation type.
			-- It puts the required placeholders.
		do
			if validation_code = no_validation then
				xml := no_validation_xml
			else
				xml := x_validation_xml
			end
		ensure
			has_placeholder: xml.has_substring(placeholder_data_file)
			has_placeholder: xml.has_substring(placeholder_label_name)
			has_placeholder: xml.has_substring(placeholder_selected_attributes)
			has_placeholder: xml.has_substring(placeholder_algorithm_name)
			has_placeholder: xml.has_substring(placeholder_algorithm_parameters)
			has_placeholder: xml.has_substring(rm_environment.model_file_path)
			has_placeholder: validation_code /= no_validation implies xml.has_substring(rm_environment.performance_file_path)
			has_placeholder: validation_code /= no_validation implies xml.has_substring(placeholder_validation_name)
			has_placeholder: validation_code /= no_validation implies xml.has_substring(placeholder_validation_parameters)

		end

feature{NONE} -- Internal data holders

	algorithm_name: STRING
			-- The name of the algorithm to be used by rapidminer.

	validation_code: INTEGER
			-- The code for validation which will be used by rapidminer.

feature{NONE} -- Actual xml skeleton generation.

	no_validation_xml: STRING
			-- The initial xml if the validation code is 'no_validation'
		do
			Result := ""
			Result.append ( "[
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<process version="5.0">
  <context>
    <input/>
    <output/>
    <macros/>
  </context>
  <operator activated="true" class="process" expanded="true" name="Process">
    <process expanded="true">
      <operator activated="true" class="read_arff" expanded="true" name="Read ARFF">
        <parameter key="data_file" value="
        ]")
        	Result.append(placeholder_data_file)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="set_role" expanded="true"  name="Set Role">
        <parameter key="name" value="
     	]")
			Result.append(placeholder_label_name)
			Result.append("[
"/>
        <parameter key="target_role" value="label"/>
      </operator>
      <operator activated="true" class="select_attributes" expanded="true" name="Select Attributes">
        <parameter key="attribute_filter_type" value="subset"/>
        <parameter key="attributes" value="
        ]")
        	Result.append(placeholder_selected_attributes)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="
      ]")
			Result.append(placeholder_algorithm_name)
			Result.append("[
" expanded="true"  name="Decision Tree">
      ]")
			Result.append(placeholder_algorithm_parameters)
			Result.append("[
      </operator>
      <operator activated="true" class="write_as_text" expanded="true"  name="Output Model to File" >
        <parameter key="result_file" value="
        ]")
			Result.append(rm_environment.model_file_path)
			Result.append("[
"/>
		<parameter key="encoding" value="UTF-8"/>
      </operator>
      <connect from_op="Read ARFF" from_port="output" to_op="Set Role" to_port="example set input"/>
      <connect from_op="Set Role" from_port="example set output" to_op="Select Attributes" to_port="example set input"/>
      <connect from_op="Select Attributes" from_port="example set output" to_op="Decision Tree" to_port="training set"/>
      <connect from_op="Decision Tree" from_port="model" to_op="Output Model to File" to_port="input 1"/>
      <connect from_op="Output Model to File" from_port="input 1" to_port="result 1"/>
      <portSpacing port="source_input 1" spacing="0"/>
      <portSpacing port="sink_result 1" spacing="36"/>
      <portSpacing port="sink_result 2" spacing="0"/>
    </process>
  </operator>
</process>
			]")
		ensure
			has_placeholder: Result.has_substring(placeholder_data_file)
			has_placeholder: Result.has_substring(placeholder_label_name)
			has_placeholder: Result.has_substring(placeholder_selected_attributes)
			has_placeholder: Result.has_substring(placeholder_algorithm_name)
			has_placeholder: Result.has_substring(placeholder_algorithm_parameters)
			has_placeholder: Result.has_substring(rm_environment.model_file_path)
		end


	x_validation_xml: STRING
			-- The xml seed if the required validation is x_validation.
		do
			Result := "[
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<process version="5.0">
  <context>
    <input/>
    <output/>
    <macros/>
  </context>
  <operator activated="true" class="process" expanded="true" name="Process">
    <process expanded="true">
      <operator activated="true" class="read_arff" expanded="true" name="Read ARFF">
        <parameter key="data_file" value="
        ]"
        	Result.append(placeholder_data_file)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="select_attributes" expanded="true" name="Select Attributes">
        <parameter key="attribute_filter_type" value="subset"/>
        <parameter key="attributes" value="
        ]")
        	Result.append(placeholder_selected_attributes)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="remove_useless_attributes" expanded="true" name="Remove Useless Attributes"/>
      <operator activated="true" class="set_role" expanded="true" name="Set Role">
        <parameter key="name" value="
        ]")
			Result.append(placeholder_label_name)
			Result.append("[
"/>
        <parameter key="target_role" value="label"/>
      </operator>
      <operator activated="true" class="
		]")
			Result.append(placeholder_validation_name)
			Result.append("%"  expanded=%"true%" name=%"Validation%">")
			Result.append(placeholder_validation_parameters)
			Result.append("[
        <process expanded="true">
          <operator activated="true" class="
          ]")
			Result.append(placeholder_algorithm_name)
			Result.append("[
" expanded="true" name="Decision Tree (2)">
			]")
			Result.append(placeholder_algorithm_parameters)
			Result.append("[
            <parameter key="no_pre_pruning" value="true"/>
            <parameter key="no_pruning" value="true"/>
          </operator>
          <connect from_port="training" to_op="Decision Tree (2)" to_port="training set"/>
          <connect from_op="Decision Tree (2)" from_port="model" to_port="model"/>
          <portSpacing port="source_training" spacing="0"/>
          <portSpacing port="sink_model" spacing="0"/>
          <portSpacing port="sink_through 1" spacing="0"/>
        </process>
        <process expanded="true">
          <operator activated="true" class="apply_model" expanded="true" name="Apply Model">
            <list key="application_parameters"/>
          </operator>
          <operator activated="true" class="performance" expanded="true" name="Performance"/>
          <connect from_port="model" to_op="Apply Model" to_port="model"/>
          <connect from_port="test set" to_op="Apply Model" to_port="unlabelled data"/>
          <connect from_op="Apply Model" from_port="labelled data" to_op="Performance" to_port="labelled data"/>
          <connect from_op="Performance" from_port="performance" to_port="averagable 1"/>
          <portSpacing port="source_model" spacing="0"/>
          <portSpacing port="source_test set" spacing="0"/>
          <portSpacing port="source_through 1" spacing="0"/>
          <portSpacing port="sink_averagable 1" spacing="0"/>
          <portSpacing port="sink_averagable 2" spacing="0"/>
        </process>
      </operator>
      <operator activated="true" class="write_as_text" expanded="true" name="Output Performance To File">
        <parameter key="result_file" value="
        ]")
			Result.append(rm_environment.performance_file_path)
			Result.append("[
"/>
        <parameter key="encoding" value="UTF-8"/>
      </operator>
      <operator activated="true" class="write_as_text" expanded="true" name="Output Model To File">
        <parameter key="result_file" value="
        ]")
			Result.append(rm_environment.model_file_path)
			Result.append("[
"/>
        <parameter key="encoding" value="UTF-8"/>
      </operator>
      <connect from_op="Read ARFF" from_port="output" to_op="Select Attributes" to_port="example set input"/>
      <connect from_op="Select Attributes" from_port="example set output" to_op="Remove Useless Attributes" to_port="example set input"/>
      <connect from_op="Remove Useless Attributes" from_port="example set output" to_op="Set Role" to_port="example set input"/>
      <connect from_op="Set Role" from_port="example set output" to_op="Validation" to_port="training"/>
      <connect from_op="Validation" from_port="model" to_op="Output Model To File" to_port="input 1"/>
      <connect from_op="Validation" from_port="averagable 1" to_op="Output Performance To File" to_port="input 1"/>
      <connect from_op="Output Performance To File" from_port="input 1" to_port="result 2"/>
      <connect from_op="Output Model To File" from_port="input 1" to_port="result 1"/>
      <portSpacing port="source_input 1" spacing="0"/>
      <portSpacing port="sink_result 1" spacing="0"/>
      <portSpacing port="sink_result 2" spacing="0"/>
      <portSpacing port="sink_result 3" spacing="0"/>
    </process>
  </operator>
</process>
	]")
		ensure
			has_placeholder: Result.has_substring(placeholder_data_file)
			has_placeholder: Result.has_substring(placeholder_label_name)
			has_placeholder: Result.has_substring(placeholder_selected_attributes)
			has_placeholder: Result.has_substring(placeholder_algorithm_name)
			has_placeholder: Result.has_substring(placeholder_algorithm_parameters)
			has_placeholder: Result.has_substring(rm_environment.model_file_path)
			has_placeholder: Result.has_substring(rm_environment.performance_file_path)
			has_placeholder: Result.has_substring(placeholder_validation_name)
			has_placeholder: Result.has_substring(placeholder_validation_parameters)
		end

invariant

	algorithm_name_valid: is_valid_algorithm_name (algorithm_name)

	validation_valid: is_valid_validation_code (validation_code)

end
