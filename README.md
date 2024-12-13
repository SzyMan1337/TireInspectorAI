# TireInspectorAI - Master’s Thesis Project

This repository contains the complete implementation of the **Master’s Thesis Project: "Automatic Classification of Car Tire Condition Using Deep Learning Techniques"**. The project focuses on developing solutions for the automated inspection of car tires to detect potential defects, contributing to road safety, cost efficiency, and environmental sustainability.

## Repository Structure
- **`cloud_run_model_service`**: A web application designed with Flask and Docker, deployed on Google Cloud Run, which processes tire images using deep learning models hosted in the cloud.
- **`mobile_app`**: A Flutter-based mobile application available for both Android and iOS platforms. The app allows users to upload tire images and receive an analysis of their condition.
- **`research`**: Notebooks and scripts for data preprocessing, model training, and evaluation. These include the experiments conducted during the research phase of the thesis.

## Project Highlights
- **Mobile App**: A user-friendly interface enabling drivers to inspect tire conditions using their smartphones.
- **Cloud Integration**: Scalable model processing via Google Cloud Run and Firebase Cloud Storage for hosting deep learning models.
- **Deep Learning Models**: State-of-the-art techniques, including convolutional neural networks, trained to classify tire conditions based on images.

## Requirements
- **Mobile App**:
  - Available on [Google Play](#) and [App Store](#).

- **Research**:
  - Google Colab is recommended for running the Jupyter notebooks.
  - Prepare datasets:
    - [Kaggle Tyre Quality Classification](https://www.kaggle.com/datasets/warcoder/tyre-quality-classification/code)
    - [Mendeley Data Tyre Dataset](https://data.mendeley.com/datasets/32b5vfj6tc/)
  - Update paths in the scripts if datasets are stored in a different directory structure.

## Support
For more details, visit the [Support Page](#). You can also contact us at: **tireinspectorai.support@gmail.com**.

---
This repository demonstrates the potential of AI-based solutions in addressing real-world safety challenges and provides a robust foundation for further research and development.
