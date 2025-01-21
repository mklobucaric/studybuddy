# Educational Assistant App Study Buddy

## Introduction

Educational Assistant App is designed to support children in their learning journey, offering an interactive and engaging way to check their knowledge. This app is built using Flutter and is available for both mobile and web platforms.

## Table of Contents

1. [Introduction](#introduction)
2. [Frontend Features](#frontend-features)
3. [Backend Capabilities](#backend-capabilities)
4. [App Screenshots](#app-screenshots)
5. [User Manual](#user-manual)
6. [App Usage Highlights](#app-usage-highlights)
7. [Future Enhancements](#future-enhancements)
8. [Technology Stack](#technology-stack)

## Frontend Features (Flutter)

- **User-Friendly Design:** Specially designed for children, ensuring intuitive navigation and engaging AI tutor interactions.
- **User Roles:** Admin, Subscriber, and Guest with tailored access levels.
- **Multilingual Support:** Available in English, German, Croatian, and Hungarian.
- **Interactive Learning Tools:** User-friendly interface with 'Take Photo', 'Pick Documents', and 'Ask a Custom Question' features.
- **Efficient Navigation:** Easy access to history and features for a seamless user experience.

## Backend Capabilities (Flask/Python)

- **Robust Integration:** Supports Firebase, Google Vision, GCP Storage, Chroma vectorbase and OpenAI, ensuring a powerful and scalable platform.
- **Advanced AI Functionality:** Leveraging OpenAI for interactive Q&A sessions and educational chats.
- **Modular Design:** Structured in packages for authentication, APIs, models, and more, ensuring efficient data processing and storage.
  For more detailed information about the backend capabilities, please refer to [Backend documentation](docs/Backend.md).

## App Screenshots

<p float="left">
  <img src="screenshots/home_view.jpg" alt="App home view" width="250" />
  <img src="screenshots/qa.jpg" alt="App questions view" width="251" />
  <img src="screenshots/follow_up_questions.jpg" alt="App follow up questions view" width="245" />
</p>
<b>Apps Home, Q&A, and Follow-Up Questions View</b>

## User Manual

For a detailed guide on using the app, please refer to the [User Manual](UserManual.md).

## App Usage Highlights

- **Interactive Q&A:** Engage with the app through image/text uploads.
- **Follow Up And Custom Questions:** Direct AI tutor interaction for a comprehensive learning experience.
- **Real-Time Assistance:** Responsive and dynamic AI responses for real-time educational support.„

## Future Enhancements

- **Usage Information and Billing:** Implement a system for tracking API usage and integrating billing for premium features.
- **Asynchronous Mode:** Enhance the app with asynchronous operations and streaming responses from the OpenAI API, improving response times for Q&A interactions.
- **Tablet Optimization:** Further refine the app to provide an optimal experience on tablet devices.
- **Web Page Enhancements:** Continuously improve the web version of the app, focusing on UI adjustments and feature optimizations for a more polished presentation.
- **iPhone Version:** Extend our platform support by developing a dedicated iPhone version of the app.

## Technology Stack

The App is built on a diverse and powerful set of technologies, each serving a specific purpose:

- **Flutter:** Utilized for building the cross-platform frontend, enabling a seamless and cohesive user experience on both mobile and web platforms.
- **Flask/Python:** The core framework and programming language used for developing the backend, providing flexibility and powerful features for web application development.
- **Google Cloud Platform (GCP) Storage:** Used for storing images uploaded from the frontend.
- **Google Vision API:** Enables text extraction from images, enhancing content accessibility and interaction.
- **Firebase Authentication:** Manages user authentication processes, ensuring secure access to the application.
- **Firestore:** Acts as the primary database for storing application data.
- **Firebase Hosting:** Used for hosting the frontend web application, providing a seamless user experience.
- **OpenAI API:** Powers the Q&A generation and interactive tutoring feature, facilitating engaging educational interactions with users.
- **ChromaDB:** A vector database used for efficient data handling and retrieval.
- **GCP Compute Engine:** Hosts the backend infrastructure, offering scalable and reliable computing resources.
- **Nginx, Docker, and Gunicorn:** These technologies are combined to create a robust and secure deployment environment, with Nginx handling SSL and HTTPS as a reverse proxy, and Docker and Gunicorn managing containerization and server operations.
