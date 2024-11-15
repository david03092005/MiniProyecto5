HashMap<String, Integer> phoneBrands;
int selectedPiece = -1;
int MIN_ANGLE = 5;
int MAX_ANGLE = 360;
color[] pastelColors;
String[] brandNames;
float[] angles;
boolean pieButton = false;
boolean overPieButton = false;


void calculateAngles() {
  int totalPhones = 0;
  for (int count : phoneBrands.values()) {
    totalPhones += count;
  }
  
  brandNames = phoneBrands.keySet().toArray(new String[0]);
  angles = new float[brandNames.length];
  
  for (int i = 0; i < brandNames.length; i++) {
    int count = phoneBrands.get(brandNames[i]);
    angles[i] = map(count, 0, totalPhones, 0, 360);
  }
}

void initializeColors() {
  pastelColors = new color[angles.length];
  for (int i = 0; i < pastelColors.length; i++) {
    pastelColors[i] = color(random(150, 255), random(150, 255), random(150, 255));
  }
}


void pieChart(float diameter) {
  drawLegend();
  float lastAngle = 0;
  selectedPiece = -1;
  float mouseAngle = atan2(mouseY - height/2, mouseX - width/2);
  if (mouseAngle < 0) mouseAngle += TWO_PI;

  for (int i = 0; i < angles.length; i++) {
    float startAngle = lastAngle;
    float stopAngle = lastAngle + radians(angles[i]);

    if (mouseAngle >= startAngle && mouseAngle < stopAngle) {
      fill(lerpColor(pastelColors[i], color(255), 0.3));
      selectedPiece = i;
    } else {
      fill(pastelColors[i]);
    }

    arc(width/2, height/2 - 20, diameter, diameter, startAngle, stopAngle);

    float midAngle = (startAngle + stopAngle) / 2;
    float labelX = width/2 + cos(midAngle) * diameter / 2.5;
    float labelY = height/2 - 20 + sin(midAngle) * diameter / 2.5;

    fill(50);
    textSize(12);
    text(phoneBrands.get(brandNames[i]), labelX, labelY);
    
    lastAngle = stopAngle;
  }
}


void adjustPieceSize(int selectedPiece, float adjustment) {
  float totalAngle = 0;
  for (float angle : angles) {
    totalAngle += angle;
  }
  
  angles[selectedPiece] += adjustment;

  if (angles[selectedPiece] < MIN_ANGLE) {
    angles[selectedPiece] = MIN_ANGLE;
  } else if (angles[selectedPiece] > MAX_ANGLE) {
    angles[selectedPiece] = MAX_ANGLE;
  }

  int prevPiece = (selectedPiece - 1 + angles.length) % angles.length;
  int nextPiece = (selectedPiece + 1) % angles.length;

  float adjustmentForAdjacent = adjustment / 2.0;

  if (angles[prevPiece] - adjustmentForAdjacent < MIN_ANGLE) {
    adjustmentForAdjacent = angles[prevPiece] - MIN_ANGLE;
  }
  if (angles[nextPiece] - adjustmentForAdjacent < MIN_ANGLE) {
    adjustmentForAdjacent = angles[nextPiece] - MIN_ANGLE;
  }

  angles[prevPiece] -= adjustmentForAdjacent;
  angles[nextPiece] -= adjustmentForAdjacent;

  if (angles[prevPiece] < MIN_ANGLE) {
    angles[prevPiece] = MIN_ANGLE;
  }
  if (angles[nextPiece] < MIN_ANGLE) {
    angles[nextPiece] = MIN_ANGLE;
  }

  totalAngle = 0;
  for (float angle : angles) {
    totalAngle += angle;
  }

  if (totalAngle > 360) {
    float excess = totalAngle - 360;
    angles[selectedPiece] -= excess;
  }

  adjustment = adjustment * 5;
  updateBrandValues(selectedPiece, adjustment);
  updateBrandValues(prevPiece, -adjustment / 2);
  updateBrandValues(nextPiece, -adjustment / 2);
}


void updateBrandValues(int pieceIndex, float adjustment) {
  String brand = brandNames[pieceIndex];
  int currentValue = phoneBrands.get(brand);
  phoneBrands.put(brand, max(0, currentValue + (int) adjustment));
}


void drawLegend() {
  float x = 50;
  float y = 40;
  float boxSize = 15;
  
  textSize(12);
  for (int i = 0; i < brandNames.length; i++) {
    fill(pastelColors[i]);
    rect(x, y + i * 20, boxSize, boxSize);
    fill(255);
    text(brandNames[i], x + boxSize + 25, y + i * 20 + boxSize / 2);
  }
}
