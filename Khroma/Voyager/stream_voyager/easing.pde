void easing(){
    for (int i=0; i<1; i++) {
    //dx[i] = targetX[i] - x[i];
    //if (abs(dx[i]) > 3) {
    //  x[i] += dx[i] * easing;
    //}
    //if (abs(dx[i]) <= 3) {
    //  x[i] = int(targetX[i]);
    //}

    dy[i] = targetY[i] - y[i];
    if (abs(dy[i]) > 3) {
      y[i] += dy[i] * easing;
    }    
    //if (abs(dy[i]) <= 3) {
    //  y[i] = int(targetY[i]);
    //}
  }
}
