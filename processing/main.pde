import oscP5.*;
import netP5.*;
import java.util.HashMap;

// Variables para la comunicación
OscP5 osc;
NetAddress pureDataAddress;

// Varaibles de datos
Table data;
float[] price;

float posX = 50;
float posY = 50;
float X = 100;
float Y = 50;
float dist = 200;

void setup() {
  fullScreen();
  //size(1000,800);
  osc = new OscP5(this, 10000);
  pureDataAddress = new NetAddress("127.0.0.1", 10001);
  
  phoneBrands = new HashMap<String, Integer>();
  String[] marcas = {"samsung", "xiaomi", "apple", "motorola", "oneplus", 
                     "google", "realme", "oppo", "nokia", "honor"};
  for (String marca : marcas) {
    phoneBrands.put(marca, 0);
  }
  
  processData();
  makeIntervals();
  calcFrequency();
  calculateAngles();
  initializeColors();
}

void draw() {
  background(255);
  if (priceButton){
    drawBarChart();
    drawBack();
  }
  else if (pieButton){
    pieChart(300);
    drawBack();
  }
  else {
    drawButtons();
  }
}

void drawBack(){
  textAlign(CENTER, CENTER);
  if (overBackButton) {
    fill(0);
    rect(800, 50, 100, 50);
    fill(255);
    text("BACK", 850, 75);
  } 
  else {
    fill(255);
    rect(800, 50, 100, 50);
    fill(0);
    text("BACK", 850, 75);
  }
}

void drawButtons(){
  textAlign(CENTER, CENTER);
  if (overPriceButton) {
    fill(0);
    rect(posX, posY, X, Y);
    fill(255);
    text("PRICE", posX + (X/2), posY + (Y/2));
  } 
  else {
    fill(255);
    rect(posX, posY, X, Y);
    fill(0);
    text("PRICE", posX + (X/2), posY + (Y/2));
  }
  textAlign(CENTER, CENTER);
  if (overPieButton) {
    fill(0);
    rect(posX + dist, posY, X, Y);
    fill(255);
    text("CAKE", posX + dist + (X/2), posY + (Y/2));
  } 
  else {
    fill(255);
    rect(posX + dist, posY, X, Y);
    fill(0);
    text("CAKE", posX + dist + (X/2), posY + (Y/2));
  }
}

void sendPureData(float value, String route) {
  OscMessage msg = new OscMessage(route); // Define la ruta de Pure Data
  msg.add(value); // Añade el valor como argumento del mensaje
  osc.send(msg, pureDataAddress);
}

void oscEvent(OscMessage msg) {
  slidersIn(msg);
}

void slidersIn(OscMessage msg) {
  for (int i = 1; i <= cant; i++) {
    if (msg.checkAddrPattern("/slider" + str(i))) {
      // Lee el valor del slider (debe estar en un rango adecuado)
      float sliderVal = msg.get(0).floatValue();
      println(sliderVal);
      println(i);
      // Mapea el valor del slider a un rango adecuado para la frecuencia de la barra
      int newFrequency = (int) map(sliderVal, 0, 99, -10, 990); // Ajusta el rango según tu necesidad
      
      // Actualiza la frecuencia de la barra específica
      frequency[i - 1] = newFrequency;
    }
  }
}