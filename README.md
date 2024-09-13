# MATH-EXPRESSions Solver

### Objective
This program is designed to help solve challenges in the game [MATH-EXPRESSions](https://store.steampowered.com/app/1953970/MATH_EXPRESSions/#:~:text=MATH%20EXPRESSions.%20WORDLE%20for%20math%20fans.%20The%20perfect), a Wordle-inspired puzzle for math enthusiasts.

### Author
**Gyeongcheol Cho**

### Last Updated
**September 12, 2024**

### Developed with
**MATLAB 2023b**

---
## How to Use the Program

1. **Run the Program:**
   - Open and run the file **OhJungHak.mat** in MATLAB.
2. **Enter the Current Rank:**
   - When prompted, input the current rank (e.g., `31`) and press **Enter**.
3. **Choose Equation Input Method:**
   - You will be asked if you want to input the initial equation manually. 
     - Type **'Y'** to input your own equation (e.g., `'2+9348=9350'`).
     - Type **'N'** to let the program generate equations based on further options.
3. **Set Duplication Limits:**
   - If you choose not to input your own equation, the program will ask how many times numbers can be duplicated in the equation. 
     - Enter a small whole number (e.g., `2`) and press **Enter**.
4. **Define the Number of Attempts:**
   - Next, specify how many equations the program should attempt to generate. 
     - For example, you might enter `10000` to ensure a comprehensive search. If no suitable equations are found, you may need to increase this value and try again.
5. **Enter Feedback from the Game:**
   - Once the equation is entered or generated, input the results of the equation from the game.
     - The color codes are as follows:
       - **r** = Red (completely incorrect)
       - **l** = Lime (correct number but wrong location)
       - **g** = Green (correct number and correct location)
     - For example, if the game returns results such as two reds, four greens, and two limes, you would input **'rrggggrllgg'** in the MATLAB command window.
6. **Repeat the Process:**
   - The program will ask if you'd like to try another equation. 
   - Repeat the process until the correct equation is found, ideally within six attempts.
---

## Update Note ##
**Version 1 (November 10, 2022)**
- Published the initial version
  
**Version 2 (March 11, 2023)**
- Updated the search algorithm for the optimal equation.
  
**Version 2.1 (September 12, 2024)**
- Revised prompts and error messages for improved clarity and user experience.

---

### Additional Notes

- The program allows for flexibility in solving equations by either manually entering equations or letting the program generate multiple equations based on your preferences.
- Keep in mind that larger values for attempts or duplicates might be needed if the program struggles to find a valid equation. Adjust these as necessary.

---
