float bloomVal;
boolean infoMode = true;
boolean source_ON;

void keyReleased(){
  
  if(key == 'i'){
    infoMode = !infoMode;    
  }
  //if(key == 's'){
  //  save("capture.png");
  //}
  
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
    setup_source();
    println("choix_source = " + choix_source);
  }
  
  if(key == 'd'){
    source_ON = !source_ON;
  }
  
}
