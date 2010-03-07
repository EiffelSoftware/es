package SemanticDocument;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Fieldable;
import org.apache.lucene.document.NumericField;
import org.apache.lucene.document.Field;

/*
 * Class to write a semantic document into a Lucene document.
 * 
 */

/**
 *
 * @author jasonw
 */
public class SemanticToLuceneDocumentTranslator {

    /*
     * Initialize semanticDocument with aSemanticDocument.
     */
    public SemanticToLuceneDocumentTranslator() {
    }

    /*
     * A Lucene document representation for aSemanticDocument
     */
    public Document asLuceneDocument(SemanticDocument aSemanticDocument) {

        // Create an empty document.
        Document doc = new Document();

        // Add all field in semanticDocument into doc.
        for (SemanticDocumentField field : aSemanticDocument.fields) {
            addFieldInDocument(doc, field);
        }

        return doc;
    }

    /*
     * Add a semantic document field aField into a Lucene document document aDoc.
     */
    private void addFieldInDocument (Document aDoc, SemanticDocumentField aField) {
        Fieldable field;

        // Iterate through all values in aField and add that field into aDoc
        for (String value : aField.values) {
            if(aField.type == FieldType.INTEGER) {
                NumericField nf = new NumericField(aField.name);
                nf.setIntValue(new Integer (value));
                field = nf;
            } else {
                Field nf = new Field(aField.name, value, Field.Store.NO, Field.Index.NOT_ANALYZED, Field.TermVector.NO);
                field = nf;
            }
            field.setBoost(aField.boost);
            aDoc.add(field);
        }
    }
}
