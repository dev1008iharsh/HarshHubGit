# HarshHubGit

## 📱 iOS GitHub Followers App (UIKit • MVC • Programmatic UI)

A fully programmatic iOS application built from scratch using UIKit and MVC architecture.  
This app allows users to search GitHub profiles, view followers, explore user details, and manage favorites with a clean and performant UI.
 
---

<img width="1190" height="649" alt="Gemini_Generated_Image_8cdjg58cdjg58cdj_65_1_65" src="https://github.com/user-attachments/assets/498c2dae-e7b5-44f5-8c12-5a3e4a02ab12" />


## ✨ Features

- 🔍 Search GitHub users by username
- 👥 View followers with pagination (infinite scrolling)
- 📄 Detailed user profile screen
- ⭐ Add/remove users from favorites
- 🔎 Real-time search filtering
- 🌐 Async/await based networking
- ⚡ Smooth and optimized UI rendering
- 🧠 Intelligent image caching
- 🚫 Empty state handling (modern UIKit API)
- 🔐 Safe error handling with user-friendly messages

---

## 🏠 App Flow

### 🔍 Search Screen (`HDSearchViewController`)

- User enters GitHub username
- Input validation handled
- Keyboard management (dismiss on tap)
- Navigation to followers screen

---

### 👥 Followers Screen (`FollowerListVC`)

- Displays followers using **UICollectionView**
- Infinite scrolling with pagination
- Diffable Data Source for smooth UI updates
- Integrated search using `UISearchController`
- Add to favorites functionality

---

### 📄 User Info Screen (`UserInfoVC`)

- Detailed user profile view
- Modular UI using child view controllers:
  - Header View
  - Repo Info
  - Followers Info
- Delegate pattern for communication
- Safari integration for GitHub profile

---

### ⭐ Favorites Screen (`HDFavoritesListViewController`)

- Stored locally using persistence layer
- UITableView implementation
- Swipe-to-delete support
- Empty state UI handling

---

## 🧠 Architecture

- UIKit-based application
- **MVC (Model-View-Controller)** architecture
- 100% programmatic UI (No Storyboards)

### Key Design Principles:

- Separation of concerns
- Reusable UI components
- Clean and maintainable code structure

---

## 🌐 Networking Layer

- Centralized `NetworkManager`
- Built using **async/await (URLSession)**
- Codable-based JSON parsing
- Custom error handling (`HDError`)
- Image downloading with caching (NSCache)

---

## ⚡ Performance Optimizations

- NSCache for image caching
- Diffable Data Source for efficient UI updates
- Lazy loading of images
- Avoided heavy work on main thread
- Smooth scrolling in lists and grids

---

## 🔐 Memory Management & Thread Safety

- Used `[weak self]` to avoid retain cycles
- UI updates restricted to main thread
- Safe async handling with `Task` and `MainActor`
- Proper lifecycle handling

---

## 🧩 Reusable Components

Custom UIKit components:

- `HDButton`
- `HDTextField`
- `HDTitleLabel`
- `HDSecondaryTitleLabel`
- `HDBodyLabel`
- `HDAvatarImageView`

Utility extensions:

- `UIView+Ext`
- `UIViewController+Ext`
- `UITableView+Ext`
- `Date+Ext`

---

## 💾 Persistence

- Implemented using `UserDefaults`
- Codable-based storage
- Favorites management with validation

---

## 🎨 UI/UX

- Follows **Apple Human Interface Guidelines**
- Supports:
  - 🌙 Dark Mode
  - 🔠 Dynamic Type (Accessibility)
  - 🗣️ VoiceOver
- Uses SF Symbols for consistent iconography
- Clean spacing and typography

---

## 🛠️ Advanced UIKit Usage

- UICollectionView with custom layout
- UITableView with reusable cells
- UISearchController integration
- UIContentUnavailableConfiguration (empty states)
- UIHostingConfiguration (SwiftUI inside UIKit cell)

---

## 🔄 Navigation

- UINavigationController-based navigation
- Modal presentation for user detail screen
- Delegate pattern for communication between screens

---

## 🚀 Tech Stack

- Swift (Latest Version)
- UIKit
- Async/Await
- URLSession
- NSCache
- UserDefaults
- SF Symbols

---

## 📦 Project Highlights

- Built completely from scratch
- No third-party libraries used
- Production-ready architecture
- Clean, scalable, and maintainable codebase

---

## 🏁 Conclusion

This project demonstrates strong knowledge of:

- UIKit & MVC architecture
- Networking & async programming
- Performance optimization
- Memory management
- Real-world iOS app development practices

---

## 📌 Future Improvements

- Retry mechanism for network calls
- Offline support
- Unit testing
- Advanced caching system

---

## 👨‍💻 Author

Harsh Darji — iOS Developer 🚀

If you have any questions or want to collaborate on iOS projects, feel free to reach out!

* **Developer:** Harsh
* **Role:** Senior iOS Engineer (Swift & UIKit Specialist)
* **Phone:** [+91 9662108047](tel:+919662108047)
* **Email:** [dev.iharsh1008@gmail.com](mailto:dev.iharsh1008@gmail.com)
* **GitHub:** [dev1008iharsh](https://github.com/dev1008iharsh)
* **Linkedin:** [dev1008iharsh]([https://github.com/dev1008iharsh](https://www.linkedin.com/in/dev1008iharsh/))

---
*Built with ❤️ and Senior-level best practices for the developer community.*

---
