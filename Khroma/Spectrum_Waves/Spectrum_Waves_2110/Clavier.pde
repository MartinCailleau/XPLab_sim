float bloomVal;
boolean infoMode = true;

void keyReleased(){
  
  if(key == 'i'){
    infoMode = !infoMode;    
  }
  if(key == 's'){
    save("capture.png");
  }
  
  if(key == '/' && bloomVal>0){
    bloomVal -= 1;
  }  
  if(key == TAB && bloomVal<10){
    bloomVal += 1;
  }
  
}
