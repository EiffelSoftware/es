CREATE TABLE  `semantic_search`.`Documents` (
  `doc_id` int(10) unsigned NOT NULL,
  `doc_type` tinyint(3) unsigned NOT NULL,
  `class` varchar(128) DEFAULT NULL,
  `feature` varchar(128) DEFAULT NULL,
  `library` varchar(128) DEFAULT NULL,
  `transition_status` tinyint(3) unsigned DEFAULT NULL,
  `hit_breakpoints` text,
  `timestamp` varchar(128) DEFAULT NULL,
  `uuid` char(32) NOT NULL,
  `is_creation` tinyint(3) unsigned DEFAULT NULL,
  `is_query` tinyint(3) unsigned DEFAULT NULL,
  `argument_count` tinyint(3) unsigned DEFAULT NULL,
  `pre_serialization` longtext,
  `pre_serialization_info` text,
  `post_serialization` longtext,
  `post_serialization_info` text,
  PRIMARY KEY (`doc_id`),
  KEY `doc_type_index` (`doc_type`),
  KEY `class_index` (`class`),
  KEY `feature_index` (`feature`),
  KEY `library_index` (`library`),
  KEY `transition_status_index` (`transition_status`),
  KEY `timestamp_index` (`timestamp`),
  KEY `uuid_index` (`uuid`),
  KEY `is_creation_index` (`is_creation`),
  KEY `is_query_index` (`is_query`),
  KEY `argument_count_index` (`argument_count`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`Properties` (
  `prop_id` int(10) unsigned NOT NULL,
  `text` varchar(256) NOT NULL,
  `operand_count` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`prop_id`),
  KEY `text_index` (`text`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`Types` (
  `type_id` int(10) unsigned NOT NULL,
  `type_name` varchar(128) NOT NULL,
  PRIMARY KEY (`type_id`),
  KEY `type_name_index` (`type_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`Conformance` (
  `type_id` int(10) unsigned NOT NULL,
  `conf_type_id` int(10) unsigned NOT NULL,
  KEY `type_id_index` (`type_id`),
  KEY `conf_type_id_fk` (`conf_type_id`),
  CONSTRAINT `conf_type_id_fk` FOREIGN KEY (`conf_type_id`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`PropertySpec1` (
  `prop_id` int(10) unsigned NOT NULL,
  `prop_type` int(5) unsigned NOT NULL,
  `doc_id` int(10) unsigned NOT NULL,
  `var1` smallint(5) unsigned NOT NULL,
  `type1` int(10) unsigned NOT NULL,
  `value` int(11) NOT NULL,
  `equal_value` int(11) NOT NULL,
  `boost` double unsigned NOT NULL,
  KEY `sp1_doc_id_fk` (`doc_id`),
  KEY `sp1_type1_fk` (`type1`),
  KEY `sp1_index` (`prop_id`,`type1`,`value`,`equal_value`,`var1`),
  CONSTRAINT `sp1_doc_id_fk` FOREIGN KEY (`doc_id`) REFERENCES `Documents` (`doc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp1_prop_id_fk` FOREIGN KEY (`prop_id`) REFERENCES `Properties` (`prop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp1_type1_fk` FOREIGN KEY (`type1`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`PropertySpec2` (
  `prop_id` int(10) unsigned NOT NULL,
  `prop_type` int(5) unsigned NOT NULL,
  `doc_id` int(10) unsigned NOT NULL,
  `var1` smallint(5) unsigned NOT NULL,
  `type1` int(10) unsigned NOT NULL,
  `var2` smallint(5) unsigned NOT NULL,
  `type2` int(10) unsigned NOT NULL,
  `value` int(11) NOT NULL,
  `equal_value` int(11) NOT NULL,
  `boost` double unsigned NOT NULL,
  KEY `sp2_doc_id_fk` (`doc_id`) USING BTREE,
  KEY `sp2_type2_fk` (`type2`) USING BTREE,
  KEY `sp2_prop_index` (`prop_id`,`type1`,`type2`,`value`,`equal_value`,`var1`,`var2`,`doc_id`) USING BTREE,
  KEY `sp2_type1_fk` (`type1`) USING BTREE,
  CONSTRAINT `doc_id_fk` FOREIGN KEY (`doc_id`) REFERENCES `Documents` (`doc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prop_id_fk` FOREIGN KEY (`prop_id`) REFERENCES `Properties` (`prop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `type1_fk` FOREIGN KEY (`type1`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `type2_fk` FOREIGN KEY (`type2`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`PropertySpec3` (
  `prop_id` int(10) unsigned NOT NULL,
  `prop_type` int(5) unsigned NOT NULL,
  `doc_id` int(10) unsigned NOT NULL,
  `var1` smallint(5) unsigned NOT NULL,
  `type1` int(10) unsigned NOT NULL,
  `var2` smallint(5) unsigned NOT NULL,
  `type2` int(10) unsigned NOT NULL,
  `var3` smallint(5) unsigned NOT NULL,
  `type3` int(10) unsigned NOT NULL,
  `value` int(11) NOT NULL,
  `equal_value` int(11) NOT NULL,
  `boost` double unsigned NOT NULL,
  KEY `sp3_doc_id_fk` (`doc_id`) USING BTREE,
  KEY `sp2_type1_fk` (`type1`) USING BTREE,
  KEY `sp3_type2_fk` (`type2`) USING BTREE,
  KEY `sp3_type3_fk` (`type3`) USING BTREE,
  KEY `sp3_prop_index` (`prop_id`,`type1`,`type2`,`type3`,`value`,`equal_value`,`var1`,`var2`,`var3`,`doc_id`) USING BTREE,
  CONSTRAINT `sp3_doc_id_fk` FOREIGN KEY (`doc_id`) REFERENCES `Documents` (`doc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp3_prop_id_fk` FOREIGN KEY (`prop_id`) REFERENCES `Properties` (`prop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp3_type1_fk` FOREIGN KEY (`type1`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp3_type2_fk` FOREIGN KEY (`type2`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp3_type3_fk` FOREIGN KEY (`type3`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE  `semantic_search`.`PropertySpec4` (
  `prop_id` int(10) unsigned NOT NULL,
  `prop_type` int(5) unsigned NOT NULL,
  `doc_id` int(10) unsigned NOT NULL,
  `var1` smallint(5) unsigned NOT NULL,
  `type1` int(10) unsigned NOT NULL,
  `var2` smallint(5) unsigned NOT NULL,
  `type2` int(10) unsigned NOT NULL,
  `var3` smallint(5) unsigned NOT NULL,
  `type3` int(10) unsigned NOT NULL,
  `var4` smallint(5) unsigned NOT NULL,
  `type4` int(10) unsigned NOT NULL,
  `value` int(11) NOT NULL,
  `equal_value` int(11) NOT NULL,
  `boost` double unsigned NOT NULL,
  KEY `sp4_doc_id_fk` (`doc_id`) USING BTREE,
  KEY `sp4_type1_fk` (`type1`) USING BTREE,
  KEY `sp4_type2_fk` (`type2`) USING BTREE,
  KEY `sp4_type3_fk` (`type3`) USING BTREE,
  KEY `sp4_type4_fk` (`type4`) USING BTREE,
  KEY `sp4_prop_index` (`prop_id`,`type1`,`type2`,`type3`,`type4`,`value`,`equal_value`,`var1`,`var2`,`var3`,`var4`,`doc_id`) USING BTREE,
  CONSTRAINT `sp4_doc_id_fk` FOREIGN KEY (`doc_id`) REFERENCES `Documents` (`doc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp4_prop_id_fk` FOREIGN KEY (`prop_id`) REFERENCES `Properties` (`prop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp4_type1_fk` FOREIGN KEY (`type1`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp4_type2_fk` FOREIGN KEY (`type2`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp4_type3_fk` FOREIGN KEY (`type3`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sp4_type4_fk` FOREIGN KEY (`type4`) REFERENCES `Types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1





