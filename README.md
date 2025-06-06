# ECommerce-SwiftUI
- [Overview](#overview)
- [Concepts/Ideas implemented](#conceptsideas-implemented)
- [Architecture Overview](#architecture-overview)
- [Getting Started](#getting-started)
- [Future Improvements](#future-improvements)
- [Author & License](#author)


# Overview
<table>
  <tr>
    <th>↓WelcomeView↓</th>
    <th>↓AuthenticationView↓</th>
    <th>ProductDiscoverView &<br>ProductDetailsView &<br>↓ProductCartView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/990c6843-528b-460f-8f89-e7a6e5e3ecb7" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/c04ed319-5b58-47b5-8e92-72c31433b2ff" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/a4020a71-07a5-4839-b2df-e36f3d74a86f" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/c307a979-4194-4625-adbc-ee9d1422bf53" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/a82576e0-cef2-4279-980a-a7b220c4a3d1" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/6ca86578-0648-4714-8b51-b2fe5b63518c" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**. App has **30** internal libraries in total, App is separated both by Feature, and by Layer. Each Feature and Layer - separate modules. App owns Features, Features own Layers.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) bounded to some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
 - [**SwiftLint**](https://github.com/realm/SwiftLint) and [**SwiftFormat**](https://github.com/nicklockwood/SwiftFormat/)
 - **Unit testing** with XCTest
 - **Localized** in French & English
 - Entities design according to[ Type-Driven Design (by Alex Ozun)]( https://swiftology.io/collections/type-driven-design/)
 - SwiftUI **live previews**
 - **Animations**
 - Pagination logic
 - Dark Mode
# Architecture Overview
### Here are some graphs which **briefly** overview the app architecture/system design. 
### Coordinators.
![coordinator_graph](https://github.com/user-attachments/assets/99ae12d5-c108-4fb8-b6b3-b3c9e1854858)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/c247d129-a889-4533-a2ae-3d486ce12396)


### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/b4fdbe42-60bb-4564-8323-0217f91b94de)

- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done inside Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to [Core](https://github.com/makar-developer/ECommerce-SwiftUI/tree/main/Core/Sources) module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- iOS 16
- Optional: Fastlane, SwiftFormat, SwiftLint
## Run locally
```
git clone git@github.com:makar-developer/ECommerce-SwiftUI.git
cd ECommerce-SwiftUI
open ECommerce.xcodeproj
```
#### Optionally
```
fastlane run_tests
```
## Author
Makar Koblia - makar.coder@gmail.com
## License
This project is licensed under the MIT License - see the LICENSE file for details
