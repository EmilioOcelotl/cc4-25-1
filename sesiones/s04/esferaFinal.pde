import peasy.*;
import nervoussystem.obj.*;

PeasyCam cam;

// espacio para guardar los vèrtices de la esfera
PVector[][] esfera; 

int resolucion = 40;
float w = 20; // Ancho de cada celda
float zeta = 100;
float zoomX = 1;
float zoomY = 1;
boolean record = false;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 500);
  esfera = new PVector[resolucion+1][resolucion+1];
  strokeWeight(4);
}

void draw() {
  background(255);


  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "meshYNoise.obj");
  }

  calcularEsfera(); 
  dibujarEsfera();

  if (record) {
    endRecord();
    record = false;
  }
}

void calcularEsfera(){
  // latitud y longitud 
  for(int y = 0; y < resolucion + 1; y++){ // iteracion en x
    float lat = map(y, 0, resolucion, -PI, PI); 
    for(int x = 0; x < resolucion +1; x++){
      float lon = map(x, 0, resolucion, -HALF_PI, HALF_PI); 
      
      // convertir lat y lon en una esfera
      float px = 100 * sin(lat) * cos(lon);
      float py = 100 * sin(lat) * sin(lon);
      float pz = 100 * cos(lat);
      
      //point(px, py, pz);
      esfera[x][y] = new PVector(px, py, pz);
      
    }
  }
}

void dibujarEsfera() {
  
  for (int j = 0; j < resolucion; j++) {
    
    beginShape(TRIANGLE_STRIP);
    
    for (int i = 0; i < resolucion+1; i++) {

      float noise = noise(i*zoomX, j*zoomY);
      float nMap = map(noise, 0, 1, -zeta, zeta);

      float noise2 = noise(i*zoomX, (j+1)*zoomY);
      float nMap2 = map(noise2, 0, 1, -zeta, zeta);

      // vertices
      PVector v1 = esfera[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = esfera[i][j+1];
      vertex(v2.x, v2.y, v2.z);      
    }
    
    endShape();   
  }
  
}

void keyPressed() {
  if (key=='r') {
    record = true;
    println("objeto exportado!");
  }
}