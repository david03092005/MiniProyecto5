float[] processData() {
  data = loadTable("Datos_limpios.csv", "header");
  price = new float[data.getRowCount()];
  float suma = 0;
  for (int i = 0; i < data.getRowCount(); i++) {
    float valor = data.getFloat(i, "price");
    price[i] = valor;
    suma += valor;
  }
  float promedio = suma / data.getRowCount();
  
  // Calcular medidas centrales
  float mean = calculateMean();
  float median = calculateMedian();
  float mode = calculateMode();
  
  // Imprimir los resultados
  println("Media: " + mean);
  println("Mediana: " + median);
  println("Moda: " + mode);
  sendPureData(mean, "/mean");
  sendPureData(median, "/median");
  sendPureData(mode, "/mode");
  float[] measures = {mean, median, mode};
  
  return measures;
}


float calculateMean() {
  float totalFrequency = 0;
  float weightedSum = 0;
  
  for (int i = 0; i < intervals.length - 1; i++) {
    float midpoint = (intervals[i] + intervals[i + 1]) / 2;
    weightedSum += midpoint * frequency[i];
    totalFrequency += frequency[i];
  }
  
  return weightedSum / totalFrequency;
}

float calculateMedian() {
  float totalFrequency = 0;
  for (int f : frequency) {
    totalFrequency += f;
  }
  
  float medianPosition = totalFrequency / 2;
  float cumulativeFrequency = 0;
  float lowerLimit = 0;
  float classFrequency = 0;
  float intervalWidth = 0;
  
  for (int i = 0; i < frequency.length - 1; i++) {
    cumulativeFrequency += frequency[i];
    if (cumulativeFrequency >= medianPosition) {
      lowerLimit = intervals[i];
      classFrequency = frequency[i];
      intervalWidth = intervals[i + 1] - intervals[i];
      cumulativeFrequency -= frequency[i];
      break;
    }
  }
  
  return lowerLimit + ((medianPosition - cumulativeFrequency) / classFrequency) * intervalWidth;
}

float calculateMode() {
  int maxFrequencyIndex = 0;
  for (int i = 1; i < frequency.length; i++) {
    if (frequency[i] > frequency[maxFrequencyIndex]) {
      maxFrequencyIndex = i;
    }
  }
  
  float lowerLimit = intervals[maxFrequencyIndex];
  float intervalWidth = intervals[maxFrequencyIndex + 1] - intervals[maxFrequencyIndex];
  float freq = frequency[maxFrequencyIndex];
  float frequencyBefore = (maxFrequencyIndex > 0) ? frequency[maxFrequencyIndex - 1] : 0;
  float frequencyAfter = (maxFrequencyIndex < frequency.length - 1) ? frequency[maxFrequencyIndex + 1] : 0;
  
  return lowerLimit + ((freq - frequencyBefore) / ((freq - frequencyBefore) + (freq - frequencyAfter))) * intervalWidth;
}
