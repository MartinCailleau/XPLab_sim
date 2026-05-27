int mol_noise = 0;

void draw_cloud(){
  
    //for (int i = 0; i < exoplanets.size(); i++) {
    JSONObject planet = exoplanets.getJSONObject(choix_exoplanet);
    String name = planet.getString("name");
    String star = planet.hasKey("star") ? planet.getString("star") : "";
    JSONArray detections = planet.getJSONArray("detections");
    String notes = planet.hasKey("notes") ? planet.getString("notes") : "";
    
    // Construire la chaîne pour les molécules/éléments détectés
    String detList = "";
    for (int j = 0; j < detections.size(); j++) {
      detList += detections.getString(j);
      if (j < detections.size() - 1) detList += ", ";
    }
    
  // easing
  //println("detections.size() = " + detections.size());
  for(int h = 0 ; h<  detections.size() ; h++){
    for(int i = 0 ; i < n_particules; i++){
      dx[h][i] = targetX[h][i] - x[h][i];
      if (abs(dx[h][i]) > 3) {
        x[h][i] += dx[h][i] * easing;
      }
      dy[h][i] = targetY[h][i] - y[h][i];
      if (abs(dy[h][i]) > 3) {
        y[h][i] += dy[h][i] * easing;
      }
    }
  }
  
  if(mode_auto){
    if(frameCount % frequence == 0){    
      for(int h = 0 ; h<  detections.size() ; h++){
        for(int i = 0 ; i < n_particules; i++){
          targetX[h][i] = 0;
          targetY[h][i] = random(height);
          // H20
          if(h == 0){            
            int choix_raie = int(random(0,3));
            targetX[0][i] = map(raie_H2O[choix_raie],0,18,0,width)+random(-mol_noise,mol_noise);
            targetY[0][i] = random(height);
          }
          //CO2
          if(h == 1){            
            int choix_raie = int(random(0,3));
            targetX[1][i] = map(raie_CO2[choix_raie],0,18,0,width)+random(-mol_noise,mol_noise);
            targetY[1][i] = random(height);
          }
        }
      }   
    }
  }
  
  else{    
    for(int h = 0 ; h<  detections.size() ; h++){
      for(int i = 0 ; i < n_particules; i++){
        targetX[h][i] = random(width);
        targetY[h][i] = random(height);
      }
    }
  }
  



  // draw
  //background(20);
  //fill(255);
  //textSize(20);

    
    //// Affichage
    //text(name + (star.equals("") ? "" : " (autour de " + star + ")"), 40, y);
    //y += lineHeight;
    //text("  Détections : " + detList, 60, y);
    //y += lineHeight;
    //if (!notes.equals("")) {
    //  text("  Notes : " + notes, 60, y);
    //  y += lineHeight;
    //}
    //y += lineHeight;  // espacement entre planètes
    
    
  if(info_on){
    textAlign(LEFT);
    pushMatrix();
    translate(50,50);
    text("FPS = " + frameRate,40,30);
    
    
    //if(i == choix_exoplanet){
          // Affichage
          text(name + (star.equals("") ? "" : " (autour de " + star + ")"), 40, 50);
          text("  Détections : " + detList, 60, 70);
          if (!notes.equals("")) {
            text("  Notes : " + notes, 60, 90);
          }
          
          text("nombre éléments détectés = " + detections.size(),40,200); 
          for (int j = 0; j < detections.size(); j++) {
            text("élément # " + j + " = " + detections.getString(j),40,220+(j*20));
          }
           // text("élément # " + 0 + " = + "  + detections.getString(0),40,240);
    popMatrix();
          
    //push();
    textAlign(CENTER);
    textSize(20);
    text("name = " + name,width/2-3088,height/2);
    //pop();
    
    }// fin de infoON
         

    textSize(15);
    for(int h = 0 ; h<  detections.size() ; h++){
      //fill(mol_couleur[h]);
      fill(100,200);
      for(int i = 0 ; i < n_particules; i++){
        text(detections.getString(h),x[h][i],y[h][i]);
      }
    }
}
