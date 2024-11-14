void mousePressed() {
  if (priceButton) {
    takeBarPrice();
    if (overBackButton){
      priceButton = false;
    }
  }
  else if(pieButton){
    if (overBackButton){
      pieButton = false;
    }
  }
  else if(particlesButton){
    if (overBackButton){
      particlesButton = false;
    }
    newParticle();
  }
  else{
    if (overPriceButton){
      priceButton = true;
    }
    else if(overPieButton){
      pieButton = true;
    }
    else if(overParticlesButton){
      particlesButton = true;
    }
  }
}

void mouseDragged() {
  moveBarPrice();
}

void mouseMoved(){
  checkPrice();
  checkBack();
  checkPie();
  checkParticles();
}

void mouseReleased() {
  sendPureData(0, "/bng" + str(selectedBar + 1));
  selectedBar = -1; // Desseleccionar barra al soltar el mouse
}


void moveBarPrice() {
  float limit = 990;
  if (selectedBar != -1) {
    int margin = 100;
      
    // Ajustar frecuencia de la barra seleccionada según la posición del mouse
    float newFrequency = map(he - mouseY, 0, he - 2 * margin, 0, limit);
    newFrequency = constrain(newFrequency, 0, limit); // Limitar a valores válidos
    frequency[selectedBar] = int(newFrequency); // Actualizar frecuencia
    sendPureData(newFrequency/10, "/slider" + str(selectedBar + 1));
  }
}


void checkBack(){
  if (mouseX > 800 && mouseX < 900 && mouseY > 50 && mouseY < 100) {
    overBackButton = true; 
  }
  else {
    overBackButton = false;
  }
}


void checkPie(){
  float startX = (width / 2) - (X + dist) * 1 + X + dist - 40;
  if (mouseX > startX && mouseX < startX + X && mouseY > height / 2 && mouseY < (height / 2) + Y) {
    overPieButton = true; 
  } 
  else {
    overPieButton = false;
  }
}

void checkPrice(){
  float startX = (width / 2) - (X + dist) * 1;
  if (mouseX > startX && mouseX < startX + X && mouseY > height / 2 && mouseY < (height / 2) + Y) {
    overPriceButton = true; 
  } 
  else {
    overPriceButton = false;
  }
}


void checkParticles() {
  float startX = (width / 2) - (X + dist) * 1 + (X + dist - 40)*2;
  if (mouseX > startX && mouseX < startX + X && mouseY > height / 2 && mouseY < (height / 2) + Y) {
    overParticlesButton = true; 
  } else {
    overParticlesButton = false;
  }
}

void takeBarPrice(){
  for (int i = 0; i < intervals.length; i++) {
    float x = margin + i * barWidth + barWidth / 2;
    float barHeight = map(frequency[i], 0, maxFrequency, 0, he - 2 * margin);
    float barTop = he - margin - barHeight;
      
    // Comprobar si el clic está dentro de la barra
    if (mouseX > x - barWidth / 2 && mouseX < x + barWidth / 2 && mouseY > barTop && mouseY < he - margin + 10) {
      selectedBar = i;
      sendPureData(1, "/bng" + str(selectedBar + 1));
      break;
    }
  }
}

void keyPressed() {
  if (pieButton) {
    pressPie();
  }
}

void pressPie(){
  if (selectedPiece != -1) {
    // Usar las flechas para aumentar/disminuir el tamaño
    float adjustment = 0;

    if (key == CODED) {
      if (keyCode == UP) {
        adjustment = 1; // Aumentar tamaño del pedazo
        sendPureData(0.0, "/Piece" + (selectedPiece + 1));
        sendPureData(angles[selectedPiece], "/note" + (selectedPiece + 1));
      } else if (keyCode == DOWN) {
        adjustment = -1; // Disminuir tamaño del pedazo
        sendPureData(1.0, "/Piece" + (selectedPiece + 1));
        sendPureData(angles[selectedPiece], "/note" + (selectedPiece + 1));
      }
    }

    if (adjustment != 0) {
      adjustPieceSize(selectedPiece, adjustment);
    }
  }
}
