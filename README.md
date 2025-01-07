# MATLAB Portfolio

Welcome to my MATLAB Portfolio! Here, you will find a collection of MATLAB projects that showcase different aspects of signal processing, visualization, and algorithm development.

## Projects

### 1. Filters
- **Description:** This project demonstrates how to decompose a filter into two components:
  - A **minimum-phase filter**
  - An **all-pass filter**
- **Details:** The decomposition helps in understanding the phase and magnitude characteristics of the filter.
- **Usage:** The scripts in this project guide you through the process of breaking down filters and analyzing their components.

### 2. Manual Phone Sounds
- **Description:** This project uses the `atdt` function to simulate the sounds of phone key presses.
- **Details:**
  - Each key generates a unique sound.
  - The generated signals are displayed, providing insight into their composition.
- **Usage:** Run the scripts to hear the sounds and observe the corresponding signals.

### 3. Phone Sounds Visualizer
- **Description:** Visualize phone sounds and their corresponding signals using a custom MATLAB app.
- **App Name:** `ATDT_Keypad`
- **Usage:**
  1. Install the app in MATLAB.
  2. Open and use it to explore the phone sound signals interactively.

### 4. Robot Project
- **Description:** Develop a robot algorithm to compete in a game created by the professor.
- **Rules:**
  - Robots can access any information on the board.
  - Control robot speed and movement (higher speed consumes more fuel).
  - The game ends when:
    - Robots collide (robot with the most fuel wins).
    - Time runs out (robot with the most fuel wins).
  - Collect barrels to gain fuel and avoid mines that reduce fuel.
- **Implementation:**
  - The robot algorithm is implemented in `robostrategy_myrobot.m`.
  - Run the game using `rungame.m`.

### 5. Signal Smoothing
- **Description:** Smooth out a noisy signal using this script.
- **Details:**
  - The script applies smoothing techniques to reduce noise and enhance signal clarity.
- **Usage:** Input your noisy signal into the script and observe the smoothed output.

## Getting Started
1. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the projects in MATLAB.
3. Run the scripts and use the app.

## Requirements
- MATLAB (R2023a or later recommended)

---
Enjoy exploring these projects! Feel free to reach out if you have any questions or suggestions.
