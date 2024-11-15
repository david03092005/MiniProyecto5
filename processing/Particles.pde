ArrayList<Particle> particles = new ArrayList<Particle>();
int numParticlesR = 0;
int numParticlesL = 0;
boolean particlesButton = false;
boolean overParticlesButton = false;


float lineR = 150, lineG = 150, lineB = 255;
float targetLineR = lineR, targetLineG = lineG, targetLineB = lineB;

class Particle {
  float x, y;
  float vx, vy;
  float size;
  float r, g, b;

  Particle(float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = random(10, 15);
    this.r = random(10, 255);
    this.g = random(10, 255);
    this.b = random(10, 255);
  }


  void update() {
    x += vx;
    y += vy;

    if (x > width || x < 0) vx *= -1;
    if (y > height || y < 0) vy *= -1;

    if (x < width / 2 && x + vx >= width / 2) {
      vx *= -1;
      x = width / 2 - 1;
      changeColor();
      updateLineColor();
    } else if (x > width / 2 && x + vx <= width / 2) {
      vx *= -1;
      x = width / 2 + 1;
      changeColor();
      updateLineColor();
    }
  }


  void changeColor() {
    r = (r + random(20, 50)) % 255;
    g = (g + random(20, 50)) % 255;
    b = (b + random(20, 50)) % 255;
  }


  void updateLineColor() {
    targetLineR = random(10, 255);
    targetLineG = random(10, 255);
    targetLineB = random(10, 255);
  }


  void display() {
    for (float s = size * 1.5; s > size; s -= 2) {
      noStroke();
      fill(r, g, b, 50);
      ellipse(x, y, s, s);
    }

    fill(r, g, b);
    noStroke();
    ellipse(x, y, size, size);
  }
}

void particles() {
  for (int i = 0; i < numParticlesR; i++) {
    particles.add(new Particle(random(width/2, width), random(height), random(-5, 5), random(-5, 5)));
  }
  for (int i = 0; i < numParticlesL; i++) {
    particles.add(new Particle(random(width/2), random(height), random(-5, 5), random(-5, 5)));
  }
  float total = (numParticlesR + numParticlesL);
  float pR = numParticlesR / total;
  float pL = numParticlesL / total;
  sendPureData(pR, "/Right");
  sendPureData(pL, "/Left");
}

void drawParticles() {
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  updateLineColorGradually();

  float lineWidth = 6;
  stroke(lineR, lineG, lineB);
  strokeWeight(lineWidth);
  line(width / 2, 0, width / 2, height);

  for (int offset = 10; offset <= 40; offset += 10) {
    stroke(lineR, lineG, lineB, 255 - offset * 4);
    strokeWeight(offset / 3);
    line(width / 2, 0, width / 2, height);
  }
  
  fill(255);
  rect((width/4) - 50, 50, 100, 30);
  rect((width*3/4) - 50, 50, 100, 30);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Gama Alta", (width*3/4), 65);
  text("Gama Baja", (width/4), 65);
}

void updateLineColorGradually() {
  float easing = 0.05;
  lineR += (targetLineR - lineR) * easing;
  lineG += (targetLineG - lineG) * easing;
  lineB += (targetLineB - lineB) * easing;
}

void newParticle(){
  if (mouseX >= width/2){
    particles.add(new Particle(mouseX, mouseY, random(-5, 5), random(-5, 5)));
    numParticlesR = numParticlesR + 1;
    float total = (numParticlesR + numParticlesL);
    float p = numParticlesR / total;
    sendPureData(p, "/Right");
  }
  else {
    particles.add(new Particle(mouseX, mouseY, random(-5, 5), random(-5, 5)));
    numParticlesL = numParticlesL + 1;
    float total = (numParticlesR + numParticlesL);
    float p = numParticlesL / total;
    sendPureData(p, "/Left");
  }
}
