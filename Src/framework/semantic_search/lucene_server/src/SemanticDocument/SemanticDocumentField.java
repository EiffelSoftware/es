package SemanticDocument;

import java.util.HashSet;
import java.util.Set;

/*
 * Class representing a field in a semantic document
 * A field consists of:
 * (1) name
 * (2) boost
 * (3) values
 * Note: the case of the strings are stored as is. Case sensitivity should be
 * handled outside of this class.
 */

/**
 *
 * @author jasonw
 */
public class SemanticDocumentField {

    /*
     * Initialize this with aName as name, aBoost as boost, type as aType and an empty values.
     */
    public SemanticDocumentField(String aName, float aBoost, FieldType aType) {
        name = new String(aName);
        boost = aBoost;
        type = aType;
        values = new HashSet<String>();
    }

    public SemanticDocumentField(String aName, float aBoost, FieldType aType, Set<String> aValues) {
        this(aName, aBoost, aType);
        boolean changed = values.addAll(aValues);
    }

    /*
     * Field name
     */
    public String name;

    /*
     * Boost of this field
     */
    public float boost;

    /*
     * Valuse of this field
     */
    public Set<String> values;

    /*
     * Type of this field.
     */

    public FieldType type;

}

enum FieldType {BOOLEAN, STRING, INTEGER}
