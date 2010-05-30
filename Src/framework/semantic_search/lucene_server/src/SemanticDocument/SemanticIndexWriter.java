package SemanticDocument;

import java.io.File;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import server.Message;

/*
 * Class to load all semantic document files in a given directory and store
 * them in a Lucene index.
 */

/**
 * @author jasonw
 */
public class SemanticIndexWriter {


    public SemanticIndexWriter() {
        loader = new SemanticDocumentLoader();
        translator = new SemanticToLuceneDocumentTranslator();
    }


    /*
     * Load semantic document specified with full path aPath and store
     * it through aIndexWriter.
     */
    public void indexSemanticDocument (Message aMessage, IndexWriter aIndexWriter) {
        SemanticDocument doc = loader.documentFromMessage(aMessage);

        try{
            aIndexWriter.addDocument(translator.asLuceneDocument(doc));
        }catch (Exception e) {
            System.err.println(e);
        }
    }

    /*
     * Semantic Document loader
     */
    private SemanticDocumentLoader loader;

    /*
     * Semantic document to Lucene document translator
     */
    private SemanticToLuceneDocumentTranslator translator;

}
