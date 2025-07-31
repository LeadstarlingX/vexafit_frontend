# **VexaFit Frontend (Flutter Mobile App)**

This repository contains the source code for the VexaFit mobile application, a cross-platform fitness app built with Flutter. It is designed to work with the VexaFit backend, providing a seamless and engaging user experience for managing workouts, exercises, and personal fitness goals.

## **Project Structure**

The application is structured following Clean Architecture principles to create a clear separation of concerns, making the codebase scalable, maintainable, and testable. The project is primarily organized into three main layers within the /lib directory.

### **1\. Data Layer (/lib/data)**

This layer is responsible for defining the data contracts and models of the application. It is the single source of truth for all data structures.

* **Models (/models)**: Contains all the Dart classes that represent the data structures used throughout the application (e.g., WorkoutDto, ExerciseDto, UserProfileDto). These models define how data is structured when communicating with the API.  
* **Repositories (/irepositories)**: Defines the abstract interfaces (IWorkoutRepository, IAuthRepository, etc.) that act as contracts for data operations. This layer dictates *what* data operations can be performed, but not *how* they are performed.

### **2\. Infrastructure Layer (/lib/infrastructure)**

This layer provides the concrete implementation of the repository interfaces defined in the Data layer. It handles the "how" of data fetching and management.

* **Repositories (/repositories)**: Contains the concrete implementations of the repository interfaces. These classes handle the logic of fetching data from the API services and processing it for the application.  
* **Services (/services)**: Includes API service classes (e.g., WorkoutApiService) that are responsible for making the actual HTTP requests to the backend using the Dio client.

### **3\. Presentation Layer (/lib/presentation)**

This layer contains all the UI-related components and the logic that drives them. It is responsible for everything the user sees and interacts with.

* **Screens (/screens)**: Contains the individual screens or pages of the application, such as the login screen, home screen, and workout details screen.  
* **ViewModels (/viewmodels)**: Manages the state and business logic for the UI. Using the Provider package, these ViewModels connect the UI to the underlying data and services, handling user input and state changes.  
* **Widgets (/widgets)**: A collection of reusable UI components (e.g., PrimaryButton, LoadingIndicator) that are used across multiple screens to maintain a consistent look and feel.  
* **Routes (/routes)**: Manages navigation within the app using the GoRouter package, defining all the available routes and their corresponding screens.

### **Core (/lib/core)**

This directory contains cross-cutting concerns that are used throughout the application.

* **Dio (/dio)**: Configuration for the Dio HTTP client, including interceptors for adding authentication tokens to requests.  
* **Theme (/theme)**: Defines the application's visual theme, including colors, fonts, and other styling elements.  
* **Utils (/utils)**: A collection of utility classes and helper functions, such as TokenStorage for securely managing user authentication tokens.

## **Tools and Packages**

### **Mobile App (Flutter)**

* **Flutter**: The core UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.  
* **Dio**: A powerful and easy-to-use HTTP client for Dart, used for all communication with the VexaFit backend API.  
* **Provider**: A state management library used to manage the application's state in a clean and efficient way, connecting the UI to the ViewModels.  
* **GoRouter**: A declarative routing package for Flutter that simplifies navigation, making it easy to manage routes and pass data between screens.  
* **flutter\_secure\_storage**: A package used for securely storing sensitive data on the device, such as user authentication tokens.  
* **json\_serializable**: A package used to automate the process of converting JSON data from the API into strongly-typed Dart objects.

### **Testing**

* **flutter\_test**: The standard testing library provided by Flutter for writing and running widget tests to ensure the UI components behave as expected.
