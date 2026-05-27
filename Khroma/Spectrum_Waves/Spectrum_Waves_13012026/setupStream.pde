int compteur_couleur;

void setup_stream(){
  
  gap_param = height/n_param;
  println("gap_param = " + gap_param);
  molecule[0] = "O <1 micron";
  molecule[1] = "O3 < 1 micron";
  molecule[2] = "H2O r1 1-2 microns";
  molecule[3] = "H2O r2 1-2 microns";
  molecule[4] = "CH4 r1 2-4 microns";
  molecule[5] = "CO2 r1 2-4 microns";
  molecule[6] = "CH4 r2 2-4 microns";
  molecule[7] = "CO2 r2 4-8 microns";
  molecule[8] = "O3 r1 4-8 microns";
  molecule[9] = "H2O r3 4-8 microns";
  molecule[10] = "CH4 r3 4-8 microns";
  molecule[11] = "O3 r2 8-16 microns";
  molecule[12] = "CO2 r3 8-16 microns";
  
 if(cast == 1){
      // Create syhpon server to send frames out.
      server = new SyphonServer(this, "Processing Syphon");
  }
 if(cast == 2){
    // CREATE A NEW SPOUT OBJECT
    spout = new Spout(this);
    spout.setSenderName("Spectrum waves 1301");
  }

  // Pixelflow
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();
  filter = new DwFilter(context);

  pg_render = (PGraphics3D) createGraphics(width, height, P3D);
  pg_render.smooth(8);

  pg_luminance = (PGraphics3D) createGraphics(width, height, P3D);
  pg_luminance.smooth(8);

  pg_bloom = (PGraphics3D) createGraphics(width, height, P3D);
  pg_bloom.smooth(0);

  //img_source = loadImage("/Users/mike/Documents/Processing/P5images:video/Feu/fire_texture1080.jpg");
  //img_source = loadImage("/Users/mike/Documents/Processing/P5images:video/SolidBackground/blanc1920x1200.jpg");
  //img_source = loadImage("../../Medias/Light/spectrum1.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bar_vertical.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bar_1920x1920.png");
  //img_source = loadImage("../../Medias/Light/spectrum_1920x1920.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bleu-orange_1920x1920.png");
  
  //img_source2[0] = loadImage("../../Medias/Light/spectrum_1920x1920.png");
  img_source2[0] = loadImage("/Users/mike/Documents/Processing/2025/Khroma/Medias/Jupiter/hubble_zoom.png");
  //img_source2[1] = loadImage("../../Medias/Light/spectrum_3840x2160.png");
  img_source2[1] = loadImage("../../Medias/Light/spectrum_2160x2160.png");
  
  
  setup_source();
  



  for(int h = 0 ; h<width ; h+=intervalleX){
  for(int i = 0 ; i<height ; i+=intervalleY){
      if(i<=1*gap_param){
        data[h][i] = molecule[0];
        //println("molecule[0] détectée");
      }
      if(i>=1*gap_param && i<=2*gap_param){
        data[h][i] = molecule[1];
        //println("molecule[1] détectée");
      }
      if(i>=2*gap_param && i<=3*gap_param){
        data[h][i] = molecule[2];
      }
      if(i>=3*gap_param && i<=4*gap_param){
        data[h][i] = molecule[3];
      }
      if(i>=4*gap_param && i<=5*gap_param){
        data[h][i] = molecule[4];
      }
      if(i>=5*gap_param && i<=6*gap_param){
        data[h][i] = molecule[5];
      }
      if(i>=6*gap_param && i<=7*gap_param){
        data[h][i] = molecule[6];
      }
      if(i>=7*gap_param && i<=8*gap_param){
        data[h][i] = molecule[7];
      }
      if(i>=8*gap_param && i<=9*gap_param){
        data[h][i] = molecule[8];
      }
      if(i>=9*gap_param && i<=10*gap_param){
        data[h][i] = molecule[9];
      }
      if(i>=10*gap_param && i<=11*gap_param){
        data[h][i] = molecule[10];
      }
      if(i>=11*gap_param && i<=12*gap_param){
        data[h][i] = molecule[11];
      }
      if(i>=12*gap_param && i<=13*gap_param){
        data[h][i] = molecule[12];
      }
      if(i>=13*gap_param){
        data[h][i] = "data unknown";
        //println("data unknown");
      }
  }
  }
  
  for (int h = 0; h<width; h+=intervalleX) {
    for (int i = 0; i<intervalleY*85; i+=intervalleY) {
      //scanX[i] = int(random(-100, 100)-width);
      //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));//4-10
      //stream_speed[i] = map(i,0,intervalleY*85,15,20);
      stream_speed[h][i] = round(random(3,10));//10-15
      stream_w[h][i] = round(random(intervalleX*.9,intervalleX));
 
      
      toss[h][i] = round(random(0,5));
    }
    for (int i = intervalleY*85; i<height; i+=intervalleY) {
      //scanX[i] = int(map(i,0,width,0,width/2));
      //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));// 4-10
      //stream_speed[i] = map(i,intervalleY*85,height,20,15);
      stream_speed[h][i] = round(random(3,10));
      stream_w[h][i] = round(random(intervalleX*.9,intervalleX));

      toss[h][i] = round(random(0,5));
    }
  }
}
