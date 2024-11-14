void processData() {
  data = loadTable("Datos_limpios.csv", "header");
  price = new float[data.getRowCount()];
  float suma = 0;
  for (int i = 0; i < data.getRowCount(); i++) {
    float valor = data.getFloat(i, "price");
    price[i] = valor;
    suma += valor;
    
    String brand = data.getString(i, "phone_brand").toLowerCase();
    if (phoneBrands.containsKey(brand)) {
      phoneBrands.put(brand, phoneBrands.get(brand) + 1);
    }
    
    float ram = data.getFloat(i, "ram");
    float storage = data.getFloat(i, "storage");
    if (ram >= 16 && storage >= 512){
      numParticlesR = numParticlesR + 1;
    }
    else if (ram <= 4 && storage <= 64) {
      numParticlesL = numParticlesL + 1;
    }
  }
  float promedio = suma / data.getRowCount();
  println(promedio);
}


float[] calcMeasures(){
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
  for (int i = 1; i < frequency.length - 1; i++) {
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


void makeIntervals() {
  float minPrice = min(price);
  float maxPrice = max(price);
  int intervalL = int((maxPrice - minPrice) / cant);
  float last = minPrice;
  for (int i = 0; i < cant; i++){
    last = last + intervalL;
    intervals[i] = last;
    frequency[i] = 0;
  }
  println(intervals);
}


void calcFrequency() {
  for (int i = 0; i < price.length; i++){
    int j = 0;
    boolean found = false;
    while (j < cant && !found){
      if (price[i] < intervals[j]){
        found = true;
      }
      j++;
    }
    frequency[j-1] = frequency[j-1] + 1;
    sendPureData(frequency[j-1]/10, "/slider" + str(j));
  }
  println(frequency);
  maxFrequency = max(frequency);
}
