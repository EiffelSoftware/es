package SemanticDocument;

import java.io.File;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

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
     * Load semantic document files from aSourceDirectory and store them
     * as Lucene indexes in aDestDirectory.
     */
    public void createIndex (String aSourceDirectory, String aDestDirectory) {
        IndexWriter indexWriter = null;
        try {
            // Create a new Lucene index.
            StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_30);
            FSDirectory destDir = FSDirectory.open(new File (aDestDirectory));
            indexWriter = new IndexWriter (destDir, analyzer, true, IndexWriter.MaxFieldLength.LIMITED);

            // Recursively iterate through aSourceDirectory, search for semantic documents,
            // and add them into the created Lucene index.
            visitAllDirsAndFiles(new File(aSourceDirectory), indexWriter);

            // Close the Lucene index.
            indexWriter.close();
        }catch(Exception e) {
            System.err.println(e);
        }
    }

    public void visitAllDirsAndFiles(File aPath, IndexWriter aIndexWriter) {
        
        if(aPath.isDirectory()) {
            // Recursively visit directories.
            String[] children = aPath.list();
            for (int i=0; i<children.length; i++) {
                visitAllDirsAndFiles(new File(aPath, children[i]), aIndexWriter);
            }
        } else {
            // Only process semantic document ended with ".tran" extension.
            if(aPath.getName().endsWith(".tran")) {
                indexSemanticDocument(aPath.getName(), aIndexWriter);
            }
        }
    }

    /*
     * Load semantic document specified with full path aPath and store
     * it through aIndexWriter.
     */
    private void indexSemanticDocument (String aPath, IndexWriter aIndexWriter) {
        SemanticDocument doc = loader.documentFromFile(aPath);

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
