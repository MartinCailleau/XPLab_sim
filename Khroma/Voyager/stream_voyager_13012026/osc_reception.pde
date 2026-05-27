/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/6kiX")==true) {
    main_gauche_X = theOscMessage.get(0).floatValue();    
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/6kiY")==true) {
    main_gauche_Y = theOscMessage.get(0).floatValue();    
    return;   
  } 
}
