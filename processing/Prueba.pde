import oscP5.*;
import netP5.*;
import java.util.ArrayList;

// Variables para la comunicación
OscP5 osc;
NetAddress pureDataAddress;

// Varaibles de datos
Table data;
float[] price;


void setup() {
  //fullScreen();
  size(1000,1000);
  osc = new OscP5(this, 10000);
  pureDataAddress = new NetAddress("127.0.0.1", 10001);
  processData();
  makeIntervals();
  calcFrequency();
  measures = processData();
  // graphWidth = 50 + (barWidth + space) * price.length;
}

void draw() {
  drawBarChart();
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
