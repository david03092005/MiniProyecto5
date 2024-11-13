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
  /*
  background(200);

  // Dibujar los círculos para cada dato
  fill(150, 0, 0);
  ellipse(freqX, freqY, freqSize, freqSize);
  fill(0, 150, 0);
  ellipse(ampX, ampY, ampSize, ampSize);
  fill(0, 0, 150);
  ellipse(intX, intY, intSize, intSize);

  // Mostrar los valores actuales
  fill(0);
  text("Frecuencia: " + frecuencia, 20, 20);
  enviarPureData(frecuencia, "/promedio");
  text("Amplitud: " + amplitud, 20, 40);
  text("Intervalo: " + intervalo, 20, 60);

  // Agregar los valores actuales al historial
  frecuenciaHist.add(frecuencia);
  amplitudHist.add(amplitud);
  intervaloHist.add(intervalo);

  // Limitar el historial a 100 puntos (ajustable según el ancho de la ventana)
  if (frecuenciaHist.size() > 100) {
    frecuenciaHist.remove(0);
    amplitudHist.remove(0);
    intervaloHist.remove(0);
  }

  // Dibujar el gráfico en la parte inferior
  drawGraph();
  */
}

/*
void drawGraph() {
  int graphHeight = 150;
  int startY = height - graphHeight - 20;
  
  // Escalas de gráficos para normalizar los valores
  float maxFreq = 1000;  // Ajusta según el rango de tu frecuencia
  float maxAmp = 1;      // Amplitud máxima es 1
  float maxInt = 1000;   // Ajusta según el rango de tu intervalo

  strokeWeight(2);

  // Dibujar líneas de frecuencia (rojo)
  stroke(255, 0, 0);
  for (int i = 1; i < frecuenciaHist.size(); i++) {
    float x1 = map(i - 1, 0, frecuenciaHist.size(), 0, width);
    float y1 = map(frecuenciaHist.get(i - 1), 0, maxFreq, startY + graphHeight, startY);
    float x2 = map(i, 0, frecuenciaHist.size(), 0, width);
    float y2 = map(frecuenciaHist.get(i), 0, maxFreq, startY + graphHeight, startY);
    line(x1, y1, x2, y2);
  }

  // Dibujar líneas de amplitud (verde)
  stroke(0, 255, 0);
  for (int i = 1; i < amplitudHist.size(); i++) {
    float x1 = map(i - 1, 0, amplitudHist.size(), 0, width);
    float y1 = map(amplitudHist.get(i - 1), 0, maxAmp, startY + graphHeight, startY);
    float x2 = map(i, 0, amplitudHist.size(), 0, width);
    float y2 = map(amplitudHist.get(i), 0, maxAmp, startY + graphHeight, startY);
    line(x1, y1, x2, y2);
  }

  // Dibujar líneas de intervalo (azul)
  stroke(0, 0, 255);
  for (int i = 1; i < intervaloHist.size(); i++) {
    float x1 = map(i - 1, 0, intervaloHist.size(), 0, width);
    float y1 = map(intervaloHist.get(i - 1), 0, maxInt, startY + graphHeight, startY);
    float x2 = map(i, 0, intervaloHist.size(), 0, width);
    float y2 = map(intervaloHist.get(i), 0, maxInt, startY + graphHeight, startY);
    line(x1, y1, x2, y2);
  }
}

void mousePressed() {
  // Detectar si se ha hecho clic en algún círculo
  if (dist(mouseX, mouseY, freqX, freqY) < freqSize / 2) draggingFreq = true;
  if (dist(mouseX, mouseY, ampX, ampY) < ampSize / 2) draggingAmp = true;
  if (dist(mouseX, mouseY, intX, intY) < intSize / 2) draggingInt = true;
}

void mouseDragged() {
  // Cambiar el tamaño del círculo según el arrastre del mouse y enviar a Pure Data
  if (draggingFreq) {
    frecuencia = constrain(map(mouseX, 0, width, 100, 1000), 100, 1000);
    freqSize = frecuencia / 5;
    enviarFrecuencia(frecuencia);
  } else if (draggingAmp) {
    amplitud = constrain(map(mouseX, 0, width, 0, 1), 0, 1);
    ampSize = amplitud * 100;
    enviarAmplitud(amplitud);
  } else if (draggingInt) {
    intervalo = constrain(map(mouseX, 0, width, 100, 1000), 100, 1000);
    intSize = intervalo / 5;
    enviarIntervalo(intervalo);
  }
}

void mouseReleased() {
  // Detener el arrastre cuando se suelta el mouse
  draggingFreq = false;
  draggingAmp = false;
  draggingInt = false;
}
*/

void sendPureData(float value, String route) {
  OscMessage msg = new OscMessage(route); // Define la ruta de Pure Data
  msg.add(value); // Añade el valor como argumento del mensaje
  osc.send(msg, pureDataAddress);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/slider")) {
    // Lee el valor del slider (debe estar en un rango adecuado)
    float sliderVal = msg.get(0).floatValue();
    println(sliderVal);
    // Mapea el valor del slider a un rango adecuado para la frecuencia de la barra
    int newFrequency = (int) map(sliderVal, 0, 100, -10, 990); // Ajusta el rango según tu necesidad
    
    // Actualiza la frecuencia de la barra específica
    frequency[0] = newFrequency;
  }
}
