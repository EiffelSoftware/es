import server.LuceneServer;
import utility.Utility;

import java.util.logging.Logger;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 5:15:32 AM
 */
public class Main {
    private static Logger  log = Utility.getLogger();
    
    public static void main(String[] args) {
        log.info("Application started!");
        LuceneServer luceneServer = new LuceneServer();
        Thread thread = new Thread(luceneServer);
        thread.start();

    }
}
