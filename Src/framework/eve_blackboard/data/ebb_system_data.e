note
	description: "Summary description for {EBB_SYSTEM_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SYSTEM_DATA

inherit

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_HELPER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty system data.
		do
			create cluster_data_table.make (10)
			create class_data_table.make (100)
			create feature_data_table.make (1000)
		end

feature -- Access

	cluster_data (a_cluster: CONF_GROUP): EBB_CLUSTER_DATA
			-- Cluster data for cluster `a_cluster'.
		do
			check cluster_data_table.has_key (a_cluster) end
			Result := cluster_data_table.item (a_cluster)
		end

	class_data (a_class: CLASS_C): attached EBB_CLASS_DATA
			-- Blackboard data for class `a_class'.
		do
			check class_data_table.has_key (a_class.class_id) end
			Result := class_data_table.item (a_class.class_id)
		end

	feature_data (a_feature: FEATURE_I): attached EBB_FEATURE_DATA
			-- Blackboard data for feature `a_feature'.
		do
			check feature_data_table.has_key (a_feature.rout_id_set.first) end
			Result := feature_data_table.item (a_feature.rout_id_set.first)
		end

	clusters: LIST [EBB_CLUSTER_DATA]
			-- List of clusters.
		do
			Result := cluster_data_table.linear_representation
		end

	classes: LIST [EBB_CLASS_DATA]
			-- List of classes.
		do
			Result := class_data_table.linear_representation
		end

	features: LIST [EBB_FEATURE_DATA]
			-- List of features.
		do
			Result := feature_data_table.linear_representation
		end

feature -- Update

	update_from_universe
			-- Update blackboard using current data from universe.
		local
			l_groups: ARRAYED_LIST [CONF_GROUP]
			l_group: CONF_GROUP
		do
			from
				l_groups := universe.groups
				l_groups.start
			until
				l_groups.after
			loop
				l_group := l_groups.item
				if l_group.is_cluster and not l_group.is_internal then
					update_cluster (l_group)
				end
				l_groups.forth
			end
		end

feature {NONE} -- Implementation

	cluster_data_table: HASH_TABLE [EBB_CLUSTER_DATA, CONF_GROUP]
			-- Hashtable storing cluster data, indexed by cluster.

	class_data_table: HASH_TABLE [EBB_CLASS_DATA, INTEGER]
			-- Hashtable storing class data, indexed by class id.

	feature_data_table: HASH_TABLE [EBB_FEATURE_DATA, INTEGER]
			-- Hashtable storing feature data, indexed by ???.

	update_cluster (a_cluster: CONF_GROUP)
			-- Update data from `a_cluster'.
		require
			is_cluster: a_cluster.is_cluster
			not_internal: not a_cluster.is_internal
		local
			l_class: CONF_CLASS
		do
				-- Update cluster data
			if not cluster_data_table.has_key (a_cluster) then

			end
			-- TODO:

				-- Update classes of this cluster
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_class := a_cluster.classes.item_for_iteration
				if l_class.is_compiled then
					update_class (universe.class_named (l_class.name, a_cluster).compiled_class)
				end
				a_cluster.classes.forth
			end
		end

	update_class (a_class: CLASS_C)
			-- Update data from `a_class'.
		local
			l_class_data: EBB_CLASS_DATA
			l_features: LIST [FEATURE_I]
		do
			if not class_data_table.has_key (a_class.class_id) then
				create l_class_data.make (a_class)
				class_data_table.extend (l_class_data, a_class.class_id)
			else
				l_class_data := class_data_table.item (a_class.class_id)
			end

				-- Update features of this class
			from
				l_features := features_written_in_class (a_class)
				l_features.start
			until
				l_features.after
			loop
				update_feature (l_features.item)
				l_features.forth
			end

			--l_class_data.verification_state.calculate_confidence
		end

	update_feature (a_feature: FEATURE_I)
			-- Update data from feature `a_feature'.
		local
			l_feature_data: EBB_FEATURE_DATA
		do
			if not feature_data_table.has_key (a_feature.rout_id_set.first) then
				create l_feature_data.make (a_feature)
				feature_data_table.extend (l_feature_data, a_feature.rout_id_set.first)
			else
				l_feature_data := feature_data_table.item (a_feature.rout_id_set.first)
			end
		end

end
