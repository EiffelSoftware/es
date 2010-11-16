/* 
Check if for HASH_TABLE.forth: t.forth there is a test case such that:
pre:
t.count = 2

post:
t.after

Result: There are test cases satisfying such criteria.
In an earlier experiment, AutoInfer reported old (t.count = 2) implies not t.after as a postcondition, which is wrong.
The reason is that some test cases (such as the ones reported by this query) were not included in the experiment.

*/

SELECT q.feature, q.content, q.qry_id, q.uuid, t.var1 as "t_id", p1.value as "pre: t.count", p2.value as "post: t.after"
FROM
Queryables q, PropertyBindings1 t, PropertyBindings1 p1, PropertyBindings1 p2
WHERE

/* feature = merge */
q.feature = "forth" AND
q.class = "HASH_TABLE"

/* target t */
AND
t.qry_id = q.qry_id AND
t.prop_id = (SELECT prop_id FROM Properties WHERE text = "$") AND
t.position = 0 AND
t.prop_kind = 2 

/* Property p1: pre: t.count */
AND
p1.qry_id = q.qry_id AND
p1.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.count") AND
p1.prop_kind = 2 AND
p1.var1 = t.var1

/* t.count = 2 */
AND
p1.value = 2

/* Property p2: post: t.after */
AND
p2.qry_id = q.qry_id AND
p2.prop_id = (SELECT prop_id FROM Properties WHERE text = "$.after") AND
p2.prop_kind = 3 AND
p2.var1 = t.var1 AND
p2.value = 1


