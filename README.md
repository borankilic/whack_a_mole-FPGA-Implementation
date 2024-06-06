# whack_a_mole-FPGA-Implementation
VHDL codes for the design of a simple Whack-a-Mole game implemented on the FPGA. 
This was the final project of the EE244 (Digital Systems Design Course) course of the Electrical & Electronical Engineering curricilum of Bogazici University.


## INTRODUCTION
The primary objective of this project is to design and implement a simplified version of the "Whack-a- Mole" game on a Field Programmable Gate Array (FPGA) platform, utilizing the Nexys3 board. This endeavor integrates multiple fundamental concepts of digital design, including VGA signal generation, pseudo-random number generation, and real-time interactive gameplay, making it an exemplary educational exercise in the realm of digital systems and hardware description languages (HDLs).

 
## PROBLEM STATEMENT
The design of this project, which appears to be a fairly simple game, was laborious, and it required multidimensional thinking on our part. The primary reason for this was because it requires many independent components that should work in great harmony and synchronization. In addition, we have utilized almost all of the input and output ports that are covered in the context of this course (EE 244 Digital System Design) which adds another layer of dependencies. The mole should appear within the 3 by 3 grid whose position and the time of visibility, however, should be assigned randomly. The randomness can be additionally controlled by the user by changing the positions of the switches. The player should have access to the buttons on the FPGA to move the cursor on the grid in order to catch the mole before it disappears. If they manage to do so, the score should increase gradually, and it should be visible to the player on the FPGA’s seven segment display, until the score reaches the value “10” which is the condition for the game to be over. The user can also restart the game by using the leftmost switch (T11) on the FPGA which is allocated to the reset signal of the design, which overall showcases the practical application of VHDL in developing interactive and visually engaging digital systems on FPGA platforms.

### USER MANUAL

- In order to implement the overall design, the user should have a Nexys3TM FPGA board, according to which the design is optimized. Upon loading the FPGA board with the bit file, one can opt for resetting the game in advance with the T5 switch on the FPGA which also allows reinitializing the game.
- Switches called V8 U8 N8 M8 V9 and T10 constitute the seed inputs whereby the randomization can be chosen before starting the game. The reset is achieved by the activation of T5 switch.
- Push buttons have the following functionalities:
  - BTNU: moving the cursor upwards
  - BTND: moving the cursor downwards
  - BTNL: moving the cursor to the left
  - BTNR: moving the cursor to the right
  - BTNS: clicking on the mole

- Follow the steps below to run this program:
  1. Obtain the bit-file either by synthesizing the VHDL files for the project or take the already synthesized one
  2. Transfer the bit-file to Nexys3 Board by Digilent Adept software
  3. Program the device
  4. Take a 2-sided HDMI VGA cable, connect one side to the output port of the Nexys3
  Board and the other to the input driver of a 800x640 monitor with 69 GHz refresh rate
  5. Follow the instructions above to control the player
  6. If you receive no input signal on the monitor, try resetting the design by sliding the T11
  switch up & down.
  7. If you still don’t get any signal check the compatibility of your monitor and your FPGA board.
