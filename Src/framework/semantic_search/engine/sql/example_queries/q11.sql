/*
LINKED_LIST:
l.search (v)

not there_exists i :: l.i_th (i) = v and i > l.index
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, l.var1 as "l_id", v.var1 as "v_id"
FROM
Queryables q, PropertyBindings1 l, PropertyBindings1 v, PropertyBindings1 p2
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

/* Property2: pre: l.index */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND
p2.prop_kind = 2 AND
p2.var1 = l.var1

/* */
AND
NOT EXISTS (
SELECT i.qry_id
FROM PropertyBindings1 i, PropertyBindings2 p1
WHERE 

/* integer i */
i.qry_id = q.qry_id AND
i.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND   /* Property text */
i.prop_kind = 2

/* Property p1: pre: l.i_th (i) */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.i_th ($)") AND   /* Property text */
p1.prop_kind = 2 AND
p1.var1 = l.var1 AND
p1.var2 = i.var1

/* l.i_th (i) = v */
AND
(p1.value_type_kind = v.value_type_kind AND p1.value = v.value)

/* i > l.index */
AND
i.value > p2.value)




