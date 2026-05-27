boolean mode_auto = true;
boolean full_data = false;
boolean syphon_on = true;
boolean info_on = true;

void keyReleased(){
  if(key == 'i'){
    println(mouseX + " ' " + mouseY);
  }
  if(key == 'a'){
    mode_auto = !mode_auto;
  }
  if(key == TAB){
    choix_exoplanet++;
    if(choix_exoplanet>=exoplanets.size()){
      choix_exoplanet = 0;
    }
  }
}
