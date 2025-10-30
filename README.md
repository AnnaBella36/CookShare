# CookShare

CookShareHome is an iOS application built with **SwiftUI**, **Combine**, and the **MVVM** architecture.  
It allows users to search, view, and save recipes locally.  
The project demonstrates modern iOS development practices such as dependency injection, asynchronous networking, Core Data persistence, and clean modular structure.

---

### Features
- User authentication and auto-login  
- Recipe search and filtering  
- Local data storage using Core Data  
- Offline access to saved recipes  
- Smooth SwiftUI interface with reactive updates  
- Asynchronous image and data loading  
- Unit and UI tests included  
- Scalable and maintainable architecture  

---

### Architecture
- **SwiftUI** - declarative user interface  
- **Combine** - reactive state management  
- **MVVM** - clear separation between logic and UI  
- **Dependency Injection** - manages dependencies ("AuthService", "NetworkManager", "PersistenceController")  
- **URLSession (async/await)** - networking layer  
- **Core Data** - local data storage  

---

### Project Structure
CookShareHome  

App — App entry point, SceneDelegate, app configuration  
Models — Core Data and domain models (Recipe, User, Category)  
Views — SwiftUI screens (Home, Search, Favorites, Profile)  
ViewModels — MVVM logic and data management  
Services — NetworkManager, AuthService, PersistenceController, ImageLoader  
CoreData — Core Data entities and model definitions  
Helpers — Utility extensions and constants  
Tests  
  UnitTests — logic and data tests  
  UITests — interface tests  

---

### Technologies Used
- **Language:** Swift 5  
- **Frameworks:** SwiftUI, Combine  
- **Architecture:** MVVM + Dependency Injection  
- **Networking:** URLSession (async/await)  
- **Storage:** Core Data  
- **Testing:** XCTest (Unit + UI)  
- **Tools:** Xcode 15+, iOS 17 SDK  
