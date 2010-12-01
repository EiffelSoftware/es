/*
LINKED_LIST:
l.search (v)

not l.after
not there_exists i :: l.i_th (i) = v and i < l.index
*/

SELECT q.feature, q.content, q.qry_id, q.uuid, l.var1 as "l_id", v.var1 as "v_id", p2.value as "l.index", p4.value as "l.count", p6.value as "l.occurrences (v)"
FROM
Queryables q, PropertyBindings1 l, PropertyBindings1 v, PropertyBindings1 p2, PropertyBindings1 p3, PropertyBindings1 p4, PropertyBindings2 p5, PropertyBindings2 p6
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

/* Property2: p2 pre: l.index */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.index") AND
p2.prop_kind = 2 AND
p2.var1 = l.var1

/* Property p3: pre: not l.after */
AND
p3.qry_id = q.qry_id AND
p3.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.after") AND
p3.prop_kind = 2 AND
p3.var1 = l.var1 AND
p3.value = 0

/* Property p4: pre: not l.count */
AND
p4.qry_id = q.qry_id AND
p4.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p4.prop_kind = 2 AND
p4.var1 = l.var1

/* Property p5: pre: l.has (v) */
AND
p5.qry_id = q.qry_id AND
p5.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.has ($)") AND
p5.prop_kind = 2 AND
p5.var1 = l.var1 AND
p5.var2 = v.var1 AND
p5.value = 1

/* Property p6: pre: l.occurrences (v) */
AND
p6.qry_id = q.qry_id AND
p6.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.occurrences ($)") AND
p6.prop_kind = 2 AND
p6.var1 = l.var1 AND
p6.var2 = v.var1

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




