# Balatro Win Recorder 
Welcome to the Balatro Win Recorder! As of the time of making this, Balatro has sadly not introduced run/seed history. It has been said to be in development, so this is a simple CLI-based bandage over the problem until it can be fixed at the game level.

As I was playing perhaps one of the greatest games ever I wanted a quick, uniform way to jot down available seed and run information. Out of that desire, this.

To start recording your own Balatro wins, Fork or Clone the repository, or simply download the script to your computer.

## Use
Running the script will create the following file and folder in the script's location.
- balatro.md
  - Used to store a quick reference winning seeds table
- winning-details/
  - Used to store individual run details as `.md` files
### Run
` PS > ./record-win.ps1` 
### Options 
flag | name | effect
-|-|-
-i | interactive | Enables GUI input for certain questions
-s | silent | Does not dipslay output text

## Limitations
### Game Process
This doesn't hook into the running game process whatsoever. This script only prompts you to record the data available to you at the end of a winning run. You will need to enter 'Endless Mode' to retrieve the necessary information after obtaining the seed.
### Error Handling
There is LITTLE TO NONE error handling. If something goes wrong, please accept [this apology](/img/wof.jpg). (worst case, you'll probably just have to write all the info down again)

## Notes
#### True Project Impetus
I had a great run with DNA, Blueprint, and Hologram, wasn't paying attention, and played a single-card hand on Needle, probably ante 5 or 6. I frustratedly clicked through the buttons to begin a new run (without copying the seed) before I realized I wanted to maybe try that run again. This project still doesn't even cover that case (wanting to record a losing seed, accidental loss or not), but it has given the ability to record other great decks.
