Orbit 🌌
Orbit is a high-performance, physics-driven task management application built with Flutter and the Flame Engine. Instead of a boring list, your tasks are dynamic "bubbles" that interact with gravity, collisions, and user gestures.

✨ Features
Physics-Based UI: Powered by Forge2D (Box2D port for Flame). Tasks have mass, density, and restitution.

Intuitive Gestures:

Drag & Sling: Grab a task and whirl it around using a MouseJoint.

Flick to Delete: Sling a task out of the screen bounds to delete it from the database.

Double Tap: Open a native Flutter modal to view task details.

Priority Visualization: Bubbles are color-coded and sized based on priority (P1, P2, P3).

Local Persistence: Uses Isar Database for lightning-fast, NoSQL local storage.

Hybrid Architecture: Seamlessly bridges the Flame Game Loop with Flutter's Reactive UI.

🚀 Tech Stack
Framework: Flutter

Game Engine: Flame

Physics: Forge2D

Database: Isar

🛠️ Installation
Clone the repository:

Bash
git clone https://github.com/your-username/orbit.git
Install dependencies:

Bash
flutter pub get
Run code generation (for Isar):

Bash
dart run build_runner build
Launch the app:

Bash
flutter run
🕹️ How to Play (Work)
Add a Task: Click the Floating Action Button (FAB) to create a new task bubble.

Organize: Drag bubbles to move them around. The physics engine handles collisions automatically.

View Details: Double-tap a bubble to see its full title and creation date.

Complete/Delete: "Sling" the bubble off the screen to remove it from your orbit forever.

🤝 Contributing
This project was built to explore the boundaries of non-traditional UI. Contributions, issues, and feature requests are welcome!
