package server;

import java.io.BufferedOutputStream;
import java.util.Vector;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 6:24:06 AM
  */
public class Message {
    private String header;
    private int headerLength;
    private int headerId;
    private Vector<String> body;

    /**
     * @param header for the message
     */
    public Message(String header) {
        body = new Vector<String>();
        String tokes[] = header.split(";");
        headerLength = Integer.parseInt(tokes[0].split("=")[1]);
        headerId = Integer.parseInt(tokes[1].split("=")[1]);

        this.header = header;
    }

    /**
     * @param line to be added to the message
     */
    public void addLineToBody (String line){
        //Future do some validity check here
        body.add(line);
    }


    public int getBodyLength(){
        return body.size();
    }

    @Override
    //TODO implement this method
    public boolean equals(Object obj) {
        return false;
    }

    @Override
    public String toString() {
        String result = header +"\n" ;
        for (String s : body){
            result = result + s + "\n";
        }
        return result;
    }

    public boolean isLengthCorrect() {
        return (getBodyLength() == headerLength);
    }
}
