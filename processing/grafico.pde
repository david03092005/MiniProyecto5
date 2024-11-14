int he = 500;
int barWidth = 50;
int wi = barWidth * 10;
int margin = 100;
int maxFrequency;
int cant = 10;
float[] intervals = new float[cant];
int[] frequency = new int[cant];
int selectedBar = -1;
float[] measures;
boolean priceButton = false;
boolean overPriceButton = false;
boolean overBackButton = false;

void drawBarChart() {
  background(255);
  if (priceButton) {
    measures = processData();
    drawMeasureBoxes(measures[0], measures[1], measures[2]); 
    // Dibujar ejes
    line(margin, he - margin, wi + margin, he - margin); // Eje X
    line(margin, he - margin, margin, margin - 30); // Eje Y
    
    // Etiquetas del eje Y
    textAlign(RIGHT, CENTER);
    float y1 = map(11, 0, 10, he - margin, margin);
    line(margin - 5, y1, margin + 5, y1);
    text(int(1000), margin - 10, y1);
    for (int i = 0; i <= 10; i++) {
      float y = map(i, 0, 10, he - margin, margin);
      line(margin - 5, y, margin + 5, y);
      text(int(i * maxFrequency / 10), margin - 10, y);
    }
    
    // Etiquetas y barras para cada intervalo
    textAlign(CENTER, CENTER);
    for (int i = 0; i < intervals.length; i++) {
      float x = margin + i * barWidth + barWidth / 2;
      float barHeight = map(frequency[i], 0, maxFrequency, 0, he - 2 * margin);
      
      // Dibujar barras
      fill(100, 150, 250);
      rect(x - barWidth / 2, he - margin - barHeight, barWidth, barHeight);
      
      // Etiquetas del eje X (intervalos)
      fill(0);
      text(int(intervals[i]), x, he - margin + 10);
    }
    
    // Etiquetas de los ejes
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Intervalos de Precios", (wi + margin) / 2, he - margin + 30);
    text("Frecuencia", margin - 65, he / 2);
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
  else {
    textAlign(CENTER, CENTER);
    if (overPriceButton) {
      fill(0);
      rect(50, 50, 100, 50);
      fill(255);
      text("PRICE", 100, 75);
    } 
    else {
      fill(255);
      rect(50, 50, 100, 50);
      fill(0);
      text("PRICE", 100, 75);
    }
  }
}


void drawMeasureBoxes(float mean, float median, float mode) {
  // Configurar posiciones de las casillas
  float boxWidth = 150;
  float boxHeight = 50;
  float startX = 100;
  float startY = height - 100;
  
  // Dibujar caja para la Media
  fill(220);
  rect(startX, startY, boxWidth, boxHeight);
  fill(0);
  text("Media", startX + boxWidth / 2, startY + 15);
  text(nf(mean, 0, 2), startX + boxWidth / 2, startY + 35);
  
  // Dibujar caja para la Mediana
  fill(220);
  rect(startX + boxWidth + 20, startY, boxWidth, boxHeight);
  fill(0);
  text("Mediana", startX + boxWidth + 20 + boxWidth / 2, startY + 15);
  text(nf(median, 0, 2), startX + boxWidth + 20 + boxWidth / 2, startY + 35);
  
  // Dibujar caja para la Moda
  fill(220);
  rect(startX + 2 * (boxWidth + 20), startY, boxWidth, boxHeight);
  fill(0);
  text("Moda", startX + 2 * (boxWidth + 20) + boxWidth / 2, startY + 15);
  text(nf(mode, 0, 2), startX + 2 * (boxWidth + 20) + boxWidth / 2, startY + 35);
}
