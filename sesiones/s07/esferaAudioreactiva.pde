import processing.sound.*;
import peasy.*;

PImage img;
PeasyCam cam;
SoundFile sample;
AudioIn in;
Amplitude rms; 

FFT fft;

// espacio para guardar los vértices de la esfera
PVector[][] esfera;

///////////////////////////////////////////////
// valores a modificar
int resolucion = 40;
float radio = 100; // radio base de la esfera
float zoom = 0.1;
boolean record = false;
float vel = 0.01;
color fondo = #ffffff;
float smoothingFactor = 0.5; // factor de suavizado para los datos FFT
int bands = 1024; // número de bandas FFT
int scale = 2; // factor de escala para la deformación radial
////////////////////////////////////////////////

float[] sum = new float[bands]; // vector para almacenar la suma del espectro suavizado
float contador = 0;

void setup() {
  size(800, 600, P3D);
  
  // Inicialización de la cámara
  cam = new PeasyCam(this, 500);
  
  // Inicialización de la esfera
  esfera = new PVector[resolucion+1][resolucion+1];
  strokeWeight(2);
  
  // Carga de imagen de textura
  img = loadImage("imagen.jpeg"); 
  
  // Cargar y reproducir un archivo de sonido
  //sample = new SoundFile(this, "piano1.wav");
  //sample.loop();
  
  // Activar la entrada de audio de la computadora
  in = new AudioIn(this, 0);

  // Inicializar FFT y conectar la entrada del archivo de sonido
  fft = new FFT(this, bands);
  //fft.input(sample);
  fft.input(in); 
  
  rms = new Amplitude(this);
  rms.input(in);  
  
}

void draw() {
  lights();
  background(fondo);
  noStroke();
    
  // Realizar análisis FFT
  fft.analyze();
  float rmsValue = rms.analyze();
  contador += (rmsValue/50);

  // Sumar el espectro suavizado para cada banda FFT
  for (int i = 0; i < bands; i++) {
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
  }
  
  // Calcular los vértices de la esfera
  calcularEsfera();
  
  // Dibujar la esfera audioreactiva
  dibujarEsfera();

  if (record) {
    saveFrame("imagenes/##########.jpg");
  }
}

void calcularEsfera() {
  // latitud y longitud
  for (int y = 0; y < resolucion + 1; y++) {
    float lat = map(y, 0, resolucion, -PI, PI); // latitud
    for (int x = 0; x < resolucion + 1; x++) {
      float lon = map(x, 0, resolucion, -HALF_PI, HALF_PI); // longitud

      // convertir lat y lon en coordenadas de una esfera
      float baseX = sin(lat) * cos(lon);
      float baseY = sin(lat) * sin(lon);
      float baseZ = cos(lat);
      
      int loc = x + y * resolucion;

      int bandIndex = loc % 128; // Si hay más vértices que bandas, usar el operador módulo

      // Escalar el radio base con el valor FFT correspondiente
      float fftFactor = 1 + sum[bandIndex] * scale;
      float noise = noise(baseX*zoom+contador, baseY*zoom+contador, baseZ*zoom+contador)*4;

      // Calcular la posición del vértice deformado basado en el radio ajustado
      float px = baseX * radio * fftFactor * noise;
      float py = baseY * radio * fftFactor * noise;
      float pz = baseZ * radio * fftFactor * noise;

      esfera[x][y] = new PVector(px, py, pz);
    }
  }
}

void dibujarEsfera() {
 
  for (int j = 0; j < resolucion; j++) {
    
    beginShape(TRIANGLE_STRIP);
    texture(img);

    for (int i = 0; i < resolucion + 1; i++) {
      
      // Asignar coordenadas de textura y vértices
      float ax1 = map(i, 0, resolucion, 0, img.width);
      float ay1 = map(j, 0, resolucion, 0, img.height);

      PVector v1 = esfera[i][j];
      vertex(v1.x, v1.y, v1.z, ax1, ay1);

      float ax2 = map(i, 0, resolucion, 0, img.width);
      float ay2 = map(j + 1, 0, resolucion, 0, img.height);

      PVector v2 = esfera[i][j + 1];
      vertex(v2.x, v2.y, v2.z, ax2, ay2);
    }

    endShape();
  }
}

void keyPressed() {
  if (key == 'r') {
    record = true;
    println("grabando");
  }
  if (key == 's') {
    record = false;
    println("deteniendo");
  }
}