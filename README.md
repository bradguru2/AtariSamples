# AtariSamples
## We will build some exciting samples for Atari 2600
* We will be using Visual Studio Code as the editor
  * Visual Studio Code is cross-platform: Windows, Mac OSX, and Linux (and others)
  * The samples here are being developed on XUbuntu
* We will be using the Atari Dev Studio plugin for Visual Studio Code to compile and run the programs
  * Batari Basic compiler is used to compile the code into assembly
  * DASM is used to compile the code into machine language
  * Stella is an Atari emulator used to run the resulting program

## Experience with Batari Basic
* Is a little simpler than Assembly Language
* Unlike most basic syntax, Batari Basic is compiled only
  * Preprocesses on first pass
  * Compiles into Assembly Language on second pass
  * Compiles into Bin file for Atari on third pass using DASM
* Steep learning curve but not as steep as Assembly Language
* Since Atari memory is very limited, 4K per bank (up to 8 banks), most operations are byte operations
* Most variables are 8-bit
* Performance of Batari Basic is great running at 60hz.
* The thing to watch out for is how much code is running during a 1/60th cycle
* Great Batar Basic reference available: https://www.randomterrain.com/atari-2600-memories.html#batari_basic
