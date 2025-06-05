# System Identification with Neural Networks in MATLAB

This repository contains system modeling and neural network-based identification of dynamic systems using MATLAB.

## Requirements

- MATLAB R202x or newer
- Deep Learning Toolbox

---

## System Modeling (Modellbildung)

This project includes two main modeling areas: a PT2 (second-order) system and a nonlinear three-tank system.

---

### PT2 System

1. Navigate to the `TestSimulink` directory.
2. Run `TestNN_Simulink.m` to simulate both open-loop and closed-loop forecasting using three different input types:
   - Step input
   - Ramp input
   - Sinusoidal input
3. For error analysis and performance evaluation, go to the `Training_Und_FehlerRechnung` directory.

---

### 3-Tank System

This system is modeled in two configurations based on the availability of measurable variables.

#### `h1_h2_h3_NN` Directory

- All tank levels `h1`, `h2`, and `h3` are used as measurable variables.
- Run `Test_NN.m` to simulate the system using a trained neural network model.

#### `h3_NN` Directory

- Only the third tank level `h3` is measured.
- Run `Test_NN.m` to simulate the prediction.
- This file also includes error calculation to quantitatively assess neural network prediction performance.

---

## Notes

- All scripts and models rely on MATLAB and the Deep Learning Toolbox.
- Neural network training was performed offline and the models are available for testing and evaluation.

