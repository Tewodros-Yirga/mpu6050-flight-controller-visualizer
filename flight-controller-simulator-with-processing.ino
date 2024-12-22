#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

void setup() {
  Serial.begin(9600);
  Wire.begin();

  mpu.initialize();

}

void loop() {
  int16_t ax_raw, ay_raw, az_raw;
  int16_t gx_raw, gy_raw, gz_raw;

  mpu.getAcceleration(&ax_raw, &ay_raw, &az_raw);
  mpu.getRotation(&gx_raw, &gy_raw, &gz_raw);

  // Convert to physical units
  float ax = ax_raw / 16384.0; // Acceleration in g
  float ay = ay_raw / 16384.0;
  float az = az_raw / 16384.0;

  float gx = gx_raw / 131.0;   // Gyroscope in degrees/second
  float gy = gy_raw / 131.0;
  float gz = gz_raw / 131.0;

  // Transmit data in CSV format
  Serial.print(ax); Serial.print(",");
  Serial.print(ay); Serial.print(",");
  Serial.print(az); Serial.print(",");
  Serial.print(gx); Serial.print(",");
  Serial.print(gy); Serial.print(",");
  Serial.println(gz);

  delay(50); // Adjust for smoother visualization
}
