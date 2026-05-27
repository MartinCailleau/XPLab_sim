float bloomVal;
boolean infoMode = true;
boolean source_ON;

void keyReleased(){
  
  if(key == 'i'){
    infoMode = !infoMode;    
  }
  if(key == 'r'){
    OscMessage myMessage = new OscMessage("/rewind"); 
    myMessage.add(true); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);   
  }
  if(key == ENTER){
    OscMessage myMessage = new OscMessage("/go"); 
    myMessage.add(true); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);   
  }
  if(key == TAB){
    OscMessage myMessage = new OscMessage("/source"); 
    myMessage.add(true); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation);   
  }
  
  if(key == '/' && bloomVal>0){
    bloomVal -= 1;
  }  
  if(key == TAB && bloomVal<10){
    bloomVal += 1;
  }
  
  if(key == 's'){
    choix_source++;
    if(choix_source>n_sources-1){
      choix_source = 0;      
    }
    println("choix_source = " + choix_source);
  }
  
  if(key == 'd'){
    source_ON = !source_ON;
  }
  
}
