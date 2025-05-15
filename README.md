# Zuma Game 🎯

A tile-matching puzzle game developed in Assembly language, featuring cannon-based shooting, level-based progression, stack-driven logic, and high-score tracking through file handling. Players aim to form chain reactions by aligning colored balls before they reach the danger zone.

---

## 🎮 Gameplay Overview

Zuma Game is a color-matching puzzle game where players shoot colored balls toward a moving chain. The goal is to align three or more balls of the same color to trigger chain reactions and earn points.

- The cannon holds two balls at a time and allows switching between them.
- Balls travel along a predefined path toward a danger zone.
- Chain reactions and gap creation earn bonus points.

---

## 🧩 Game Structure

### 📌 Levels & Design

#### **Stage 1**
- **Level 1: Color Cascade**
  - Gentle introduction with slow speed and wide turns
  - Basic color matching with 2–3 colors
- **Level 2: Rolling Waves**
  - Faster speed, narrower paths, introduces slow-down power-up
- **Level 3: Arc of Fusion**
  - Sharp turns, more colors, includes Backwards Ball power-up

#### **Stage 2**
- **Level 1: Maze of Momentum**
  - Complex maze path with tunnels and memory-based targeting
  - Gap-creation mechanics and Accuracy Ball power-up
- **Level 2: Spiral Surge**
  - Spiral layout with looping motion and Explosion Ball power-up
  - Focus on rhythm and chain planning

---

## 🧠 Core Features

- **Strategic Cannon Mechanics**
  - Dual-ball holding system
  - Switch & shoot functionality
- **Chain Reaction Scoring**
  - Points awarded for combo sequences and gap creation
- **Stack Usage**
  - Push/pop operations for game flow and color management
- **Exception Handling**
  - Input validation to prevent crashes or invalid gameplay states
- **Power-Ups**
  - Slow-Down Ball, Backwards Ball, Accuracy Ball, Explosion Ball
- **Sound Integration**
  - Effects for shooting, matching, and game events

---

## 🗂 Screens Implemented

- Welcome Screen (player name input)
- Main Menu
- Game Play Screen
- Pause Screen
- Instructions Screen
- High Score & Player Display Screen

---

## 💾 File Handling

- Player names and high scores are saved using low-level file I/O
- Scores are stored in **sorted order**
- System calls used:
  - `CreateFileA`
  - `ReadFile`
  - `WriteFile`
  - `CloseHandle`

---

## ⚙️ Assembly Code Structure

### Key Procedures
- `MainMenu PROC`
- `Level1`, `Level2`, `Level3 PROC`
- `DrawPlayer`, `RandomPlayerPosition`, `DrawBall PROC`

### File I/O Prototypes
```asm
CreateFileA PROTO a1: PTR BYTE, a2: DWORD, a3: DWORD, a4: DWORD, a5: DWORD, a6: DWORD, a7: DWORD
ReadFile    PROTO a1: DWORD, a2: PTR BYTE, a3: DWORD, a4: PTR DWORD, a5: DWORD
WriteFile   PROTO a1: DWORD, a2: PTR BYTE, a3: DWORD, a4: PTR DWORD, a5: DWORD
CloseHandle PROTO a1: DWORD
---
```
## 📈 Scoring System

- Points awarded for:
  - Matching 3 or more balls of the same color
  - Creating and triggering chain reactions
  - Creating and successfully closing gaps in the chain
- High scores are recorded and stored using file handling
- Scores are maintained in sorted order per player

---

## 🧪 Requirements & Rules

- Stack operations (`push`/`pop`) are mandatory for procedure logic
- Input validation and exception handling for incorrect formats is required
- Level 3 must feature faster-moving enemies/balls to increase difficulty
- This is an individual project and must be demonstrated live

---

## 🧠 Learning Highlights

- Implementation of a 2D game using Assembly language
- Usage of low-level system calls for file read/write operations
- Real-time gameplay logic using stack-based flow control
- Design and management of progressive game levels with increasing difficulty
- Integration of visual and audio feedback in Assembly-based gameplay

---

## 🛠️ Build & Run Instructions

### 🧱 Build the Game

1. Assemble the source code:
 ```bash
 ml /c /coff ZumaGame.asm
 ```
2. Link the object file:
```bash
link /subsystem:console ZumaGame.obj
```

### ▶️ Run the Game
3. Run the executable:

```bash
ZumaGame.exe
```
#### If you're using DOSBox:

Mount the folder where your files are:
```bash
mount c c:\Your\ZumaGame\Directory
c:
ZumaGame.exe
```
