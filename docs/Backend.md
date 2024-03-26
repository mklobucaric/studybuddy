# Study Buddy Backend

## Introduction
The backend for the Educational Assistant App, Study Buddy, supports the app's interactive and educational features. Built using Flask/Python, it integrates with services like Firebase, Google Vision, and OpenAI, providing a robust and scalable platform for educational assistance. For access to the backend code or further inquiries, please reach out to me at mario.klobucaric@gmail.com.

## Table of Contents
- [Overview](#overview)
- [Backend Structure](#backend-structure)
  - [Auth Package](#auth-package)
  - [API Package](#api-package)
  - [Models Package](#models-package)
  - [Schemas Package](#schemas-package)
  - [Services Package](#services-package)
  - [Storage Package](#storage-package)
  - [Utilities Package](#utilities-package)
- [App Integration](#app-integration)
- [Technology Stack](#technology-stack)
- [Future Enhancements](#future-enhancements)
- [Links](#links)

## Overview
The backend is structured in packages and modules to handle various functionalities ranging from authentication to data processing and storage.

## Backend Structure
### Auth Package
- **auth:** Verifies Firebase user tokens and retrieves user roles (admin, subscriber, guest).
- **auth_JWT:** Handles JWT token validation (currently not used in the frontend app).

### API Package
- **routes:** Defines API endpoints for app interaction.
  - `/upload` (POST): For photo uploads and QA generation.
  - `/question` (POST): For receiving QA pair and generating answers, based on texts in vectorbase, to follow-up questions.
  - `/custom_question` (POST): For processing custom questions and interaction with AI tutor.

### Models Package
- Contains optional models for Firestore, PostgreSQL, Pydantic, SQLite, and `chat_history` for chat interactions. The current Study Buddy app uses JSON for message exchange and firebase for user authentication.

### Schemas Package
- Holds JSON schemas for question and answer validation before Firestore storage.

### Services Package
- **client_manager:** Provides clients for Firestore, Google Vision, OpenAI, GCP Storage.
- **OCR:** Offers OCR services using Google Vision and Tesseract (currently not used in the frontend app).
- **upload_get_qa:** Manages the upload route's needs and calls other services.
- **openai_integration:** 
  - This module/service is central to the app's AI functionality. It includes methods for Q&A generation and rag (retrieve-and-generate) conversation using OpenAI's API. 
  - The module operates in key modes (particularly designed to be kid-friendly and engaging):
    - **Direct Q&A Generation:** Generates answers directly without using vector storage tools, since new LLM  models have large context window.
    - **Retrieval from Vector Storage:** Utilizes OpenAI tools/functions to retrieve relevant text from vector storage for question-answering.
    - **Kids Tutor Chat:** A specialized method, `kids_tutor_chat`, handles custom questions from users and facilitates conversations on chosen topics. 
  - **Multilingual Support:** Tailored system and user prompts are available in four languages (English, German, Croatian, Hungarian). The language code received from the frontend app determines the language of the prompts.
  - **Integration with LangChain and OpenAI Assistants:** 
    - The backend also includes additional modules like `openai_integration_langchain.py` and `openai_integration_assistants.py`. These modules extend the AI functionalities using the LangChain framework and OpenAI assistants, leveraging threads and advanced tools for more integrated interactions (currently not used in the frontend app).

### Storage Package
- Includes modules for Firestore and GCP Storage, as well as Chroma vectorbase for text retrieval.

### Utilities Package
- Features modules like `error_handling`, `firebase_admin_utils`, and `security`. The `security` module complements the `auth_JWT` module.

## App Integration
- **Global Error Handler:** Manages application-wide error handling, ensuring a consistent response format and logging strategy across the backend.
- **Initialization:** Creates and configures the Flask application instance, setting up the fundamental building blocks of the application.
- **Configuration:** Contains necessary configurations for different environments (development, testing, production), ensuring smooth operation and easy maintenance.

## Technology Stack
The backend is built on a diverse and powerful set of technologies, each serving a specific purpose:
- **Flask/Python** The core framework and programming language used for developing the backend, providing flexibility and powerful features for web application development.
- **Google Cloud Platform (GCP) Storage:** Used for storing images uploaded from the frontend.
- **Google Vision API:** Enables text extraction from images, enhancing content accessibility and interaction.
- **Firebase Authentication:** Manages user authentication processes, ensuring secure access to the application.
- **Firestore:** Acts as the primary database for storing application data.
- **OpenAI API:** Powers the Q&A generation and interactive tutoring feature, facilitating engaging educational interactions with users.
- **ChromaDB:** A vector database used for efficient data handling and retrieval.
- **GCP Compute Engine:** Hosts the backend infrastructure, offering scalable and reliable computing resources.
- **Nginx, Docker, and Gunicorn:** These technologies are combined to create a robust and secure deployment environment, with Nginx handling SSL and HTTPS as a reverse proxy, and Docker and Gunicorn managing containerization and server operations.


## Future Enhancements
- Implement token counting and billing for API usage.
- Implement async mode and steaming response from OpenAI API, since Q&A response needs many seconds

## Links
- [Frontend Repository](https://github.com/mklobucaric/studybuddy)

---
For a detailed description of the app's features and usage, refer to the [User Manual](https://github.com/mklobucaric/studybuddy/blob/master/UserManual.md).
