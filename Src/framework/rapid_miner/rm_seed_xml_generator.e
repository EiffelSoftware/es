note
	description: "This class will provide the initial xml with the placeholders for the validation and algorithm type."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_SEED_XML_GENERATOR

create
	make
feature{NONE} -- Creation

	make(a_algorithm_code: INTEGER; a_validation_code: INTEGER)
		local
			rm_consts: RM_CONSTANTS
		do
			create rm_consts
			rm_env := rm_consts.rm_environment
			algorithm_code := a_algorithm_code
			validation_code := a_validation_code
		end

feature -- Interface

	xml: STRING
			-- seed xml for rapidminer with the appropriate placeholders for validation and algorithms

	generate_xml
			-- generates the seed xml depending on the algorithm type and the validation type.
			-- It puts the required placeholders.
		do
			if validation_code = {RM_CONSTANTS}.no_validation then
				xml := no_validation_xml
			else
				xml := x_validation_xml
			end
		end

feature{NONE} -- Internal data holders

	algorithm_code: INTEGER

	validation_code: INTEGER

	rm_env: RM_ENVIRONMENT

feature{NONE} -- actual xml

	no_validation_xml: STRING
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
        	Result.append({RM_CONSTANTS}.data_file_placeholder)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="set_role" expanded="true"  name="Set Role">
        <parameter key="name" value="
     	]")
			Result.append({RM_CONSTANTS}.label_name_placeholder)
			Result.append("[
"/>
        <parameter key="target_role" value="label"/>
      </operator>
      <operator activated="true" class="select_attributes" expanded="true" name="Select Attributes">
        <parameter key="attribute_filter_type" value="subset"/>
        <parameter key="attributes" value="
        ]")
        	Result.append({RM_CONSTANTS}.selected_attributes_placeholder)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="
      ]")
			Result.append({RM_CONSTANTS}.algorithm_name_placeholder)
			Result.append("[
" expanded="true"  name="Decision Tree">
      ]")
			Result.append({RM_CONSTANTS}.algorithm_parameters_placeholder)
			Result.append("[
      </operator>
      <operator activated="true" class="write_as_text" expanded="true"  name="Write as Text" >
        <parameter key="result_file" value="
        ]")
			Result.append(rm_env.model_file_path)
			Result.append("[
"/>
		<parameter key="encoding" value="UTF-8"/>
      </operator>
      <connect from_op="Read ARFF" from_port="output" to_op="Set Role" to_port="example set input"/>
      <connect from_op="Set Role" from_port="example set output" to_op="Select Attributes" to_port="example set input"/>
      <connect from_op="Select Attributes" from_port="example set output" to_op="Decision Tree" to_port="training set"/>
      <connect from_op="Decision Tree" from_port="model" to_op="Write as Text" to_port="input 1"/>
      <connect from_op="Write as Text" from_port="input 1" to_port="result 1"/>
      <portSpacing port="source_input 1" spacing="0"/>
      <portSpacing port="sink_result 1" spacing="36"/>
      <portSpacing port="sink_result 2" spacing="0"/>
    </process>
  </operator>
</process>
			]")
		end


	x_validation_xml: STRING
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
        	Result.append({RM_CONSTANTS}.data_file_placeholder)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="select_attributes" expanded="true" name="Select Attributes">
        <parameter key="attribute_filter_type" value="subset"/>
        <parameter key="attributes" value="
        ]")
        	Result.append({RM_CONSTANTS}.selected_attributes_placeholder)
			Result.append("[
"/>
      </operator>
      <operator activated="true" class="remove_useless_attributes" expanded="true" name="Remove Useless Attributes"/>
      <operator activated="true" class="set_role" expanded="true" name="Set Role">
        <parameter key="name" value="
        ]")
			Result.append({RM_CONSTANTS}.label_name_placeholder)
			Result.append("[
"/>
        <parameter key="target_role" value="label"/>
      </operator>
      <operator activated="true" class="
		]")
			Result.append({RM_CONSTANTS}.validation_name_placeholder)
			Result.append("[
" expanded="true" name="Validation">
]")
			Result.append({RM_CONSTANTS}.validation_parameters_placeholder)
			Result.append("[
        <process expanded="true">
          <operator activated="true" class="
          ]")
			Result.append({RM_CONSTANTS}.algorithm_name_placeholder)
			Result.append("[
" expanded="true" name="Decision Tree (2)">
			]")
			Result.append({RM_CONSTANTS}.algorithm_parameters_placeholder)
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
      <operator activated="true" class="write_as_text" expanded="true" name="Write as Text (3)">
        <parameter key="result_file" value="
        ]")
			Result.append(rm_env.performance_file_path)
			Result.append("[
"/>
        <parameter key="encoding" value="UTF-8"/>
      </operator>
      <operator activated="true" class="write_as_text" expanded="true" name="Write as Text">
        <parameter key="result_file" value="
        ]")
			Result.append(rm_env.model_file_path)
			Result.append("[
"/>
        <parameter key="encoding" value="UTF-8"/>
      </operator>
      <connect from_op="Read ARFF" from_port="output" to_op="Select Attributes" to_port="example set input"/>
      <connect from_op="Select Attributes" from_port="example set output" to_op="Remove Useless Attributes" to_port="example set input"/>
      <connect from_op="Remove Useless Attributes" from_port="example set output" to_op="Set Role" to_port="example set input"/>
      <connect from_op="Set Role" from_port="example set output" to_op="Validation" to_port="training"/>
      <connect from_op="Validation" from_port="model" to_op="Write as Text" to_port="input 1"/>
      <connect from_op="Validation" from_port="averagable 1" to_op="Write as Text (3)" to_port="input 1"/>
      <connect from_op="Write as Text (3)" from_port="input 1" to_port="result 2"/>
      <connect from_op="Write as Text" from_port="input 1" to_port="result 1"/>
      <portSpacing port="source_input 1" spacing="0"/>
      <portSpacing port="sink_result 1" spacing="0"/>
      <portSpacing port="sink_result 2" spacing="0"/>
      <portSpacing port="sink_result 3" spacing="0"/>
    </process>
  </operator>
</process>
	]")
		end
end
