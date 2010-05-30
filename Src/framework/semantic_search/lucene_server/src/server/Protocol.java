package server;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:43:03 AM
 * This class validates the protocol 
 */
public class Protocol {

    /*
       HEADER =  numberOfLines=N;requestId=N
       BODY =  TODO
     */

    private static String BODY_FIELD_SEPARATOR = "(=)";


    /**
     * HEADER FORMAT
     *
     * @param line is the header
     * @return true if header is valid
     */
    public static boolean validateHeader(String line){
        line = line.toLowerCase();
        String[] tokens = line.split(";");

        return tokens[0].contains("numberoflines") && tokens[1].contains("requestid") &&
                tokens[2].contains("requesttype") && tokens[3].contains("maxresult") ;
    }

    

}
