void mousePressed() {
  if (priceButton) {
    takeBarPrice();
    if (overBackButton){
      priceButton = false;
    }
  }
  else{
    if (overPriceButton){
      priceButton = true;
    }
  }
}

void mouseDragged() {
  moveBarPrice();
}

void mouseMoved(){
  checkButtons();
  checkBack();
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


void checkButtons(){
  if (mouseX > 50 && mouseX < 150 && mouseY > 50 && mouseY < 100) {
    overPriceButton = true; 
  }
  else {
    overPriceButton = false;
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
