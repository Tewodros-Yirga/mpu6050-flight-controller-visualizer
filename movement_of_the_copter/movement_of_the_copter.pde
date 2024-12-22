import processing.serial.*;

Serial myPort;  // Serial port object
float ax, ay, az, gx, gy, gz;  // Sensor data
float propellerAngle = 0;  // Angle for spinning propellers

void setup() {
  size(800, 800, P3D);  // 3D canvas
  myPort = new Serial(this, "COM9", 9600);  // Adjust port if needed
  myPort.bufferUntil('\n');  // Read until newline
}

void draw() {
  background(30);
  lights();

  // Update propeller rotation
  propellerAngle += 10; // Spin the propellers
  
  // Convert accelerometer and gyroscope data to rotation angles
  float pitch = atan2(-ax, sqrt(ay * ay + az * az)); // X-axis rotation
  float roll = atan2(ay, az);                        // Z-axis rotation
  float yaw = radians(gz);                           // Y-axis rotation (integrated over time for smoother motion)

  // Translate and rotate based on MPU6050 data
  pushMatrix();
  translate(width / 2, height / 2, -200); // Center the quadcopter
  rotateZ(yaw);   // Apply yaw (vertical axis)
  rotateX(pitch); // Apply pitch (side-to-side tilt)
  rotateY(roll);  // Apply roll (forward-backward tilt)

  // Draw central body
  fill(50, 50, 200);  // Blue color for body
  noStroke();
  box(150, 30, 150); // Main body (larger for better visibility)
  
  // Draw legs
  stroke(100);
  strokeWeight(5);
  line(-50, 15, -50, -50, -60, -50); // Leg 1
  line(50, 15, -50, 50, -60, -50);  // Leg 2
  line(-50, 15, 50, -50, -60, 50);  // Leg 3
  line(50, 15, 50, 50, -60, 50);    // Leg 4

  // Draw camera
  fill(0, 100, 255);
  pushMatrix();
  translate(0, 20, 75); // Position below the quadcopter body
  box(30, 20, 20);      // Camera shape
  popMatrix();

  // Draw front direction indicator
  fill(255, 0, 0); // Red cone for front direction
  pushMatrix();
  translate(0, -15, 75);
  rotateX(PI / 2); // Rotate the cone to point forward
  cone(10, 30);    // Create a cone
  popMatrix();

  // Draw spinning propellers
  fill(255, 0, 0); // Red for propellers

  // Propeller 1 (front-left)
  pushMatrix();
  translate(-100, 0, -100);
  rotateY(radians(propellerAngle));
  ellipse(0, 0, 50, 50);
  popMatrix();

  // Propeller 2 (front-right)
  pushMatrix();
  translate(100, 0, -100);
  rotateY(radians(propellerAngle));
  ellipse(0, 0, 50, 50);
  popMatrix();

  // Propeller 3 (back-left)
  pushMatrix();
  translate(-100, 0, 100);
  rotateY(radians(propellerAngle));
  ellipse(0, 0, 50, 50);
  popMatrix();

  // Propeller 4 (back-right)
  pushMatrix();
  translate(100, 0, 100);
  rotateY(radians(propellerAngle));
  ellipse(0, 0, 50, 50);
  popMatrix();
  
  popMatrix();
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);  // Remove whitespace
    String[] values = split(data, ',');
    if (values.length == 6) {
      ax = float(values[0]);
      ay = float(values[1]);
      az = float(values[2]);
      gx = float(values[3]);
      gy = float(values[4]);
      gz = float(values[5]);
    }
  }
}

// Custom cone function
void cone(float radius, float height) {
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0); // Cone tip
  for (float angle = 0; angle <= TWO_PI; angle += PI / 20) {
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, height, y);
  }
  endShape();
}
