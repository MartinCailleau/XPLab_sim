int userY2;
int userY;
float userY2_remap;
//int map_height = 275;// petit rectangle
int map_height = 1080;// plein écran
boolean pauseON;

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/zoom_val")==true) {
    zoom_val = theOscMessage.get(0).floatValue();    
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/userY2")==true) {
    userY2 = theOscMessage.get(0).intValue();
    userY2_remap = map(userY2,0,map_height,0,height);
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/userY")==true) {
    userY = theOscMessage.get(0).intValue();
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/rewind")==true) {  
    pauseON = false;  
    for (int h = 0; h<width; h+=intervalleX) {
      for (int i = 0; i<height; i+=intervalleY) {
        scanX[h][i] = 0;
      }
    }
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/go")==true) {    
    pauseON = true;
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/source")==true) {

    choix_source++;
    if(choix_source>n_sources-1){
      choix_source = 0;      
    }
    setup_source();
    println("choix_source = " + choix_source);
    return;   
  } 
  
}
