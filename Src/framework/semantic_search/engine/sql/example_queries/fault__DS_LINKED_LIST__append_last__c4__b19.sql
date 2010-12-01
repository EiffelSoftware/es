SELECT q.qry_id, q.class, q.feature, q.fault_signature, l.equal_value as "l.obj", other.equal_value as "other.obj", q.exception_tag, pre_l_count.value as "pre: l.count", pre_other_count.value as "pre: other.count"
FROM Queryables q, PropertyBindings1 l, PropertyBindings1 other, PropertyBindings1 pre_l_count, PropertyBindings1 pre_other_count

WHERE
q.class = "DS_LINKED_LIST" AND
q.feature = "append_last"
/*AND q.fault_signature = "DS_LINKED_LIST.append_last.c4.b19"*/

/* target l */
AND
l.qry_id = q.qry_id AND
l.position = 0 AND
l.prop_kind = 2 AND
l.prop_id = (SELECT prop_id FROM Properties WHERE text = "$")

/* Argument other */
AND
other.qry_id = q.qry_id AND
other.position = 1 AND
other.prop_kind = 2 AND
other.prop_id = (SELECT prop_id FROM Properties WHERE text = "$")

/* Property: post_l_count */
/*
AND
post_l_count.qry_id = q.qry_id AND
post_l_count.prop_kind = 3 AND
post_l_count.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
post_l_count.var1 = l.var1
*/

/* Property: pre_l_count */
AND
pre_l_count.qry_id = q.qry_id AND
pre_l_count.prop_kind = 2 AND
pre_l_count.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
pre_l_count.var1 = l.var1

/* Property: pre_other_count */
AND
pre_other_count.qry_id = q.qry_id AND
pre_other_count.prop_kind = 2 AND
pre_other_count.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
pre_other_count.var1 = other.var1
