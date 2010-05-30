/*
 * Class to load a semantic document from a stream.
 * 
 */

package SemanticDocument;
import server.Message;

import java.io.*;
/**
 *
 * @author jasonw
 */
public class SemanticDocumentLoader {

    /*
     * Load and return the semantic document stored in file inicated by
     * its full path in aPath.
     */
    public SemanticDocument documentFromMessage (Message message) {
      SemanticDocument doc = new SemanticDocument();
      
      try{
            FieldPosition pos = FieldPosition.NO;
            String fieldName = null;
            String fieldBoost = null;
            String fieldType = null;
            String fieldValues = null;            

            // Iterate through all lines in the file.


          for(String strLine: message.getBody()){
              if(strLine.isEmpty()) {
                  if(pos==FieldPosition.VALUE) {
                    doc.addField(fieldFromStrings (fieldName, fieldBoost, fieldType, fieldValues));
                  }
                  pos = FieldPosition.NO;
              } else {
                  switch(pos) {
                      case NO:
                          fieldName = new String(strLine);
                          pos = FieldPosition.NAME;
                          break;
                      case NAME:
                          fieldBoost = new String(strLine);
                          pos = FieldPosition.BOOST;
                          break;
                      case BOOST:
                          fieldType = new String(strLine);
                          pos = FieldPosition.TYPE;
                          break;
                      case TYPE:
                          fieldValues = new String (strLine);
                          pos = FieldPosition.VALUE;
                          break;
                  }
              }
            }

        }catch (Exception e){
            System.err.println(e);
        }
        return doc;
    }

    /*
     * State in line when reading a file representing a semantic document
     */
    public enum FieldPosition {NO, NAME, BOOST, TYPE, VALUE}


    /*
     * Semantic document field from strings.
     */
    private SemanticDocumentField fieldFromStrings(String aName, String aBoost, String aType, String aValues) {

        // Decide the type of this field.
        FieldType type = FieldType.STRING;
        if(aType.equals("BOOLEAN")) {
            type = FieldType.BOOLEAN;
        } else if (aType.equals("INTEGER")) {
            type = FieldType.INTEGER;
        } else if (aType.equals("STRING")) {
            type = FieldType.STRING;
        }else {
        }

        // Separate values.
        String [] values = aValues.split(";;;");

        SemanticDocumentField field = new SemanticDocumentField (aName, new Float(aBoost), type);
        for (String str : values) {
            field.values.add(str);
        }

        return field;
    }
}
