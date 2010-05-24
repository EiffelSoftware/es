package SemanticDocument;


import java.util.LinkedList;

/*
 * Class representing a semantic document.
 * A semantic document consists of a list of fields.
 * Note: fields with the same name can appear multiple times.
 */

/**
 *
 * @author jasonw
 */
public class SemanticDocument {
   
    /*
     * Initialize this with an empty list of fields.
     */
    public SemanticDocument() {
        fields = new LinkedList<SemanticDocumentField>();
    }

    /*
     * Fields in this document
     */
    public LinkedList<SemanticDocumentField> fields;

    /*
     * Add aField in this document.
     */
    public void addField (SemanticDocumentField aField) {
        fields.add(aField);
    }
}
