# Atomic Path 

Atomic Path is a sleek, croos-platform habit-tracking applicatoin built to help users build consistency. 
It features a clean, responsive UI and utilises native device audio for satisfying user upon completing daily tasks.
Currently deployed and optimised for iOS and macOS

## Features 
**Daily Tracking**: easily check off daily habits and monitor completion counts 
**Persistent Storage**: Saves habit history locally so users never lose their progress. 
**Audio Feedback**: Integrates native multimedia to play a satisfying pencil-scratch sound effect upon task completion. 
**Responsive UI**: Built with QML for a fluid, modern mobile experience 

## Tech Stack 
Language: C++ 
UI Framework: Qt 6.8 / QML 
Build System: CMake 
Deployment: Xcode (iOS/macOS target) 

## Getting Started 

### Prerequisites 
To build and run this project, you will need: 
* Qt Creator (with Qt 6.8+ and the Multimedia module installed)
* CMake
* Xcode (for Apple device deployment)

### Installation & Build Instructions 
1. Clone the repository:
2. Open the CMakeLists.txt file in Qt Creator.
3. Configure the project with your local macOS/iOS kit.
4. Click the Build (Hammer) icon to generate the Xcode blueprints
5. Open the generated project in Xcode
6. Select your target device (Simulator or physical iPhone) and hit Run(play) 
