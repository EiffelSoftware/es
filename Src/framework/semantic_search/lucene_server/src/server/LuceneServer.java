package server;

import lucene.LuceneEngine;
import utility.Utility;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Calendar;
import java.util.Vector;
import java.util.logging.Logger;

/**
 * Created by IntelliJ IDEA.
 * User: slucas
 * Date: May 7, 2010
 * Time: 5:17:56 AM
 */

public class LuceneServer implements Runnable {

    private Logger log = Utility.getLogger();
 
    
    public void run() {

        while(true){
            try {
                log.info("Started Server at " + Calendar.getInstance().getTime().toString()+ " wating for connection!");
                ServerSocket serverSocket = new ServerSocket(10000);
                Socket socket = serverSocket.accept();
                log.info("Client connect at " + Calendar.getInstance().getTime().toString());

                try {
                    InputStream in = socket.getInputStream();
                    OutputStream out = socket.getOutputStream();
                    BufferedReader inReader = new BufferedReader(new InputStreamReader(in));
                    BufferedWriter outWriter = new BufferedWriter(new OutputStreamWriter(out));

                    LuceneEngine luceneEngine = Utility.getLuceneEngine();
                    String line;
                    while (isConnected(socket)){
                        line = inReader.readLine();
                        if (line!=null){
                            //This line should be the Header
                            //numberOfLines=10;requestID=1;

                            line = line.toLowerCase();
                            log.info("READ LINE "+ line);
                            if (Protocol.validateHeader(line)){
                                Message msg = new Message(line);

                                while (!msg.isLengthCorrect()){
                                    msg.addLineToBody(inReader.readLine());
                                }

                                Message result = luceneEngine.processMessage(msg);


                            }else{
                                throw new IllegalStateException("The header (" + line + ") of the protocol is invalid!");
                            }
                        }
                    }//END WHILE
                    log.severe("Socket disconnected!");
                    //Cleanup
                    inReader.close();
                    outWriter.close();
                    socket.close();
                    serverSocket.close();
                
                } catch (IOException e) {
                    log.severe("Could not get socket input stream!");
                    e.printStackTrace();
                }



            } catch (IOException e) {
                System.out.println("Could not listen on port: 4444");
                System.exit(-1);
            }

            log.info("Client Disconnected at " + Calendar.getInstance().getTime().toString());

        }
    }

    private boolean isConnected(Socket socket) {
     boolean result;
        try {
            socket.getOutputStream().write(0);
            result = true;
        } catch (IOException e) {
            result = false;
        }
        return result;
    }

}
