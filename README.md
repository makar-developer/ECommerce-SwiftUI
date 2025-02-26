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
      <video src="https://github.com/user-attachments/assets/470ebc4f-03d9-4cd2-96c8-f40fc01cc27d" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/0febe007-27ff-4326-9339-2e6ab7f72f77" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/eb25661a-b1be-42ac-a56e-00c1a73d52ff" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/872dc390-a709-4fd4-a404-cab1709017f5" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/22ed0d45-1282-422d-abe7-124a70258e90" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/3dad5af0-3dd2-406b-aef3-869762662d68" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**, each Feature and Layer - separate modules. **30** internal libraries in total.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
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
![coordinator_graph](https://github.com/user-attachments/assets/52cceddc-df36-4f73-ba83-ade205a533e1)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/3fc70b43-5183-4fe9-bddd-759af5a8974e)

### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/8a9600ea-152a-4e6d-bf6c-8a567bfa8fc1)
- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done in Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to Core module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- Fastlane(optional)
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
      <video src="https://github.com/user-attachments/assets/470ebc4f-03d9-4cd2-96c8-f40fc01cc27d" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/0febe007-27ff-4326-9339-2e6ab7f72f77" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/eb25661a-b1be-42ac-a56e-00c1a73d52ff" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/872dc390-a709-4fd4-a404-cab1709017f5" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/22ed0d45-1282-422d-abe7-124a70258e90" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/3dad5af0-3dd2-406b-aef3-869762662d68" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**, each Feature and Layer - separate modules. **30** internal libraries in total.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
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
![coordinator_graph](https://github.com/user-attachments/assets/52cceddc-df36-4f73-ba83-ade205a533e1)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/3fc70b43-5183-4fe9-bddd-759af5a8974e)

### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/8a9600ea-152a-4e6d-bf6c-8a567bfa8fc1)
- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done in Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to Core module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- Fastlane(optional)
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
      <video src="https://github.com/user-attachments/assets/470ebc4f-03d9-4cd2-96c8-f40fc01cc27d" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/0febe007-27ff-4326-9339-2e6ab7f72f77" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/eb25661a-b1be-42ac-a56e-00c1a73d52ff" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/872dc390-a709-4fd4-a404-cab1709017f5" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/22ed0d45-1282-422d-abe7-124a70258e90" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/3dad5af0-3dd2-406b-aef3-869762662d68" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**, each Feature and Layer - separate modules. **30** internal libraries in total.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
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
![coordinator_graph](https://github.com/user-attachments/assets/52cceddc-df36-4f73-ba83-ade205a533e1)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/3fc70b43-5183-4fe9-bddd-759af5a8974e)

### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/8a9600ea-152a-4e6d-bf6c-8a567bfa8fc1)
- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done in Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to Core module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- Fastlane(optional)
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
      <video src="https://github.com/user-attachments/assets/470ebc4f-03d9-4cd2-96c8-f40fc01cc27d" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/0febe007-27ff-4326-9339-2e6ab7f72f77" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/eb25661a-b1be-42ac-a56e-00c1a73d52ff" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/872dc390-a709-4fd4-a404-cab1709017f5" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/22ed0d45-1282-422d-abe7-124a70258e90" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/3dad5af0-3dd2-406b-aef3-869762662d68" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**, each Feature and Layer - separate modules. **30** internal libraries in total.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
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
![coordinator_graph](https://github.com/user-attachments/assets/52cceddc-df36-4f73-ba83-ade205a533e1)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/3fc70b43-5183-4fe9-bddd-759af5a8974e)

### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/8a9600ea-152a-4e6d-bf6c-8a567bfa8fc1)
- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done in Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to Core module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- Fastlane(optional)
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
      <video src="https://github.com/user-attachments/assets/470ebc4f-03d9-4cd2-96c8-f40fc01cc27d" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/0febe007-27ff-4326-9339-2e6ab7f72f77" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/eb25661a-b1be-42ac-a56e-00c1a73d52ff" width="100%" controls></video>
    </td>
  </tr>
    <tr>
    <th>↓ProductSearchView↓</th>
    <th>↓ProfileView↓</th>
    <th>↓ProductHistoryView↓</th>
  </tr>
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/872dc390-a709-4fd4-a404-cab1709017f5" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/22ed0d45-1282-422d-abe7-124a70258e90" width="100%" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/3dad5af0-3dd2-406b-aef3-869762662d68" width="100%" controls></video>
    </td>
  </tr>
</table>

# Concepts/Ideas implemented

 - **Modular Architecture (SPM)**, each Feature and Layer - separate modules. **30** internal libraries in total.
 - **Clean Architecture**-like architecture/system design/codestyle, with layers: Presentation(V+VM) -> Domain <- Interface layer <- Data.
 - **Dependency Injection**:
   App-level DI container - provides Feature-level DI containers. Feature-level DI Containers provide necessary Layer dependencies (e.g. UseCases, Repositories) within boundaries of some specific Feature.
 - **Coordinator** (with pure SwiftUI):
 App-level Coordinator  - can perform navigation between each individual Feature(within the App). 
 Feature-level Coordinators - can perform navigation between each individual Screen(within the Feature).
 - **SwiftUI**, CoreData, Combine, async/await, Keychain, UserDefaults, FileManager, URLSession, Image caching.
 - CI with **GitHub Actions** and  [**Fastlane**](https://github.com/fastlane/fastlane)
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
![coordinator_graph](https://github.com/user-attachments/assets/52cceddc-df36-4f73-ba83-ade205a533e1)
🟦 - App-level, here navigations/transitions between individual Features happen.

🟩 - Feature-level, here navigations/transitions between individual Screen happen.

### Dependency Injection

![di_container_graph](https://github.com/user-attachments/assets/3fc70b43-5183-4fe9-bddd-759af5a8974e)

### How typical data flow/chain looks like?
![data_flow_graph](https://github.com/user-attachments/assets/8a9600ea-152a-4e6d-bf6c-8a567bfa8fc1)
- 🟦 - Presentation | 🟩 - Domain | 🟨 - Data
- Anyone can depend on Entities, since all inter-layer conversions(to-Data/to-Domain) are done in Repositories in current implementation, and idea/concept of DTOs is not used here for simplicity.
- If some data flow objects are used by multiple features across the app - they are simply moved to Core module, where their structure and responsibilities stay the same.
# Future Improvements

- Finish Unit Test coverage and live previews for more feature-modules, as for now only Core and WelcomeDependencies modules have them.
- Favorites (and customizable product collections in general) - Allow User to save a Product to favorites or organize them into customly created collections.
# Getting started
## Requirements
- XCode 16
- Fastlane(optional)
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
