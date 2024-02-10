import tensorflow as tf

# Step 1: Load the pre-trained MobileNetV2 model
model = tf.keras.applications.MobileNetV2(weights='imagenet', input_shape=(224, 224, 3))

# Optional: Save the model
model.save("mobilenet_v2.h5")

# Step 2: Convert the model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Step 3: Save the TFLite model to a file
with open('mobilenet_v2.tflite', 'wb') as f:
    f.write(tflite_model)

print("TFLite model is successfully created.")
