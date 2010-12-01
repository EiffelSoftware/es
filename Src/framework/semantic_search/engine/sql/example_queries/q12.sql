/*
In pre-state:
LINKED_LIST:
l.search (v)

i > l.index
j > l.index
i > j
l.i_th (i) = v
l.i_th (j) = v

Yes, there are some test cases satisfying such criteria.
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, l.var1 as "l_id", v.var1 as "v_id", i.value as "i", j.value as "j", i.var1 as "i_id", j.var1 as "j_id", p3.value as "l.index", p4.value as "l.count"
FROM
Queryables q, PropertyBindings1 l, PropertyBindings1 v, PropertyBindings1 i, PropertyBindings1 j, PropertyBindings2 p1, PropertyBindings2 p2, PropertyBindings1 p3, PropertyBindings1 p4
WHERE

/* LINKED_LIST.search */
q.feature = "search" AND
q.class = "LINKED_LIST"

/* target list l */
AND
l.qry_id = q.qry_id AND
l.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
l.prop_kind = 2 AND   /* Precondition */
l.position = 0    

/* argument v */
AND
v.qry_id = q.qry_id AND
v.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
v.prop_kind = 2 AND
v.position = 1

/* integer i */
AND
i.qry_id = q.qry_id AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
i.prop_kind = 2 AND
i.value_type_kind = 2 /* Integer */

/* integer j */
AND
j.qry_id = q.qry_id AND
j.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
j.prop_kind = 2 AND
j.value_type_kind = 2 /* Integer */

/* Property p1: pre: l.i_th (i) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.i_th ($)") AND   /* Property text */
p1.prop_kind = 2 AND
p1.var1 = l.var1 AND
p1.var2 = i.var1

/* Property l_i_th (i) = v */
AND
(p1.value_type_kind = v.value_type_kind AND p1.value = v.value)

/* Property p2: pre: l.i_th (j) */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.i_th ($)") AND   /* Property text */
p2.prop_kind = 2 AND
p2.var1 = l.var1 AND
p2.var2 = j.var1

/* Property l_i_th (j) = v */
AND
(p2.value_type_kind = v.value_type_kind AND p2.value = v.value)

/* Property p3: pre: l.index */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND   /* Property text */
p3.prop_kind = 2 AND
p3.var1 = l.var1

/* i > l.index */
AND
i.value > p3.value

/* j > l.index */
AND
j.value > p3.value

/* i > j */
AND
i.value > j.value

/* Property p4: pre: l.count */
AND
p4.qry_id = q.qry_id AND
p4.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND   /* Property text */
p4.prop_kind = 2 AND
p4.var1 = l.var1