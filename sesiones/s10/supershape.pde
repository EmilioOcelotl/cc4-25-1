// Capas > cálculo > render > Interfaz gráfica 

import peasy.*; // cámara 
// import nervoussystem.obj.*; // exportar en obj 
import controlP5.*; // importar librería p5

ControlP5 cp5; // declarar el objeto > programación orientada a objetos 

PeasyCam cam;
int tam = 100; // 20x20 vertices
float profundidad = 200;
float contador = 0;
boolean record = false; // false / true 
PVector[][] esfera;
float r = 200;
float offset = 0;
//float m = 0; 
//float mchange = 0;

////////////////////////////
// Variables que pueden cambiar 
float m1 = 7; 
float r1_n1 = 0.2; 
float r1_n2 = 1.7; 
float r1_n3 = 1.7;

float m2 = 7; 
float r2_n1 = 0.2; 
float r2_n2 = 1.7; 
float r2_n3 = 1.7;
////////////////////////////

void setup() {
  size(1000, 600, P3D);
  // cam = new PeasyCam(this, 1000);
  esfera = new PVector[tam+1][tam+1];
  colorMode(HSB); // RGB
  cp5 = new ControlP5(this); 
  controles(); 
}

void draw() { // 60 fps 44100 m/s

  lights();
  background(0);

  noStroke();

  // noFill();
  // vertices();
  /*
  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "filename.obj");
  }
  */

  //offset += 5;
  vert();
  
  push();
  //rotateX(radians(45));
  translate(width/2, height/2);
  rotateX(radians(45)); 
  figura(); // dibujar el mesh
  pop(); 

  /*
  if (record) {
    endRecord();
    record = false;
  }
  */

  offset = offset + 2; 
  //mchange = mchange + 0.02; // 0, 0.02, 0.04, 0.06...inf
  //float msin = sin(mchange); 
  //m = map(msin, -1, 1, 0, 10); 

}

void keyPressed() {
  if (key=='r') {
    record = true;
  }
}

// funcion 

void vert() {
  for (int x = 0; x < tam+1; x++ ) {
    float lat = map(x, 0, tam, -HALF_PI, HALF_PI);
    // supershape > lat, m, n1, n2, n3
    float r2 = supershape(lat, m2, r2_n1, r2_n2, r2_n3); 
    for (int y = 0; y < tam+1; y++ ) {
      float lon = map(y, 0, tam, -PI, PI);
      float r1 = supershape(lon, m1, r1_n1, r1_n2, r1_n3); 

      float px = r * r1*cos(lon) * r2*cos(lat);
      float py = r * r1*sin(lon) * r2*cos(lat);
      float pz = r * r2*sin(lat);

      esfera[x][y] = new PVector(px, py, pz);
      // esfera[x][y] = new PVector(px, py, pz);
    }
  }
  
  
}

void figura() {
  // fill(255, 100, 100);
  for (int x = 0; x < tam; x++ ) {
    
    float hu = map(x, 0, tam, 0, 255*6);
    fill((hu + offset) % 255, 255, 255);
    
    beginShape(TRIANGLE_STRIP);
    for (int y = 0; y < tam+1; y++ ) {

      PVector v1 = esfera[x][y];
      vertex(v1.x, v1.y, v1.z);

      PVector v2 = esfera[x+1][y];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}



float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs(cos(m * theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs(sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}

void controles(){
  // botones y sliders 
  
  // record > botón 
  // m1, r1_n1, r1_n2, r1_n3 > sliders
  // m2, r2_n1, r2_n2, r2_n3 > sliders
  
  cp5.addButton("record")
  .setSize(150, 20)
  .setPosition(20, 20); 
  
  // Primer radio 
  
  cp5.addSlider("m1")
  .setSize(150, 20)
  .setPosition(20, 50)
  .setRange(0, 10); 
  
  cp5.addSlider("r1_n1")
  .setSize(150, 20)
  .setPosition(20, 80)
  .setRange(0, 4); 
  
  cp5.addSlider("r1_n2")
  .setSize(150, 20)
  .setPosition(20, 110)
  .setRange(0, 4); 
  
  cp5.addSlider("r1_n3")
  .setSize(150, 20)
  .setPosition(20, 140)
  .setRange(0, 4);
  
  // Segundo radio
  
  cp5.addSlider("m2")
  .setSize(150, 20)
  .setPosition(20, 170)
  .setRange(0, 10); 
  
  cp5.addSlider("r2_n1")
  .setSize(150, 20)
  .setPosition(20, 200)
  .setRange(0, 4); 
  
  cp5.addSlider("r2_n2")
  .setSize(150, 20)
  .setPosition(20, 230)
  .setRange(0, 4); 
  
  cp5.addSlider("r2_n3")
  .setSize(150, 20)
  .setPosition(20, 260)
  .setRange(0, 4);

}