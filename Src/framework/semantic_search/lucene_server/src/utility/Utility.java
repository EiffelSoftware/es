package utility;

import lucene.LuceneEngine;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;


/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 5:42:43 AM
 * Simple Utility file implementing a Proxy to singletons 
 */
public class Utility {

    private static Logger myLogger;
    private static LuceneEngine luceneEngine;

    public static Logger getLogger(){
        if (myLogger == null) {
            try {
                FileHandler fh = new FileHandler("log.txt");
                SimpleFormatter sf = new SimpleFormatter();
                fh.setFormatter(sf);
                myLogger = Logger.getLogger("LuceneServer");
                myLogger.addHandler(fh);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return myLogger;
    }


    public static LuceneEngine getLuceneEngine(){
        if (luceneEngine == null){
            luceneEngine = new LuceneEngine();
        }

        return luceneEngine;
    }
    
}
