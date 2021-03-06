module application.xsh;

import user.syscall;
import user.malloc;
import user.basicio;
import user.keycodes;

import libos.keyboard;
import libos.console;

char[] prompt = "$> ";
bool intfic = false;

int main() {

  // init the keyboard libOS
  Keyboard.init();
  Console.init();

  //Console.clear();
  Console.setColors(Color.White, Color.Black);

  // print the initial text
  Console.printString("xsh: XOmB shell\n\n");

  // malloc test
  int* pointer = cast(int*)malloc(10*int.sizeof);
  pointer[0] = 1337;
  print(pointer[0], "\n");
  free(pointer);
  pointer[2] = 1337;
  print(pointer[2], "\n");

  // print the prompt
  print(prompt);

  // for grabing the key
  short keyCode;
  char key;

  char[1] echoStr;

  char[512] lineBuffer;
  int lineBufferPos = 0;

  void* buff;

  while(true) {
    keyCode = Keyboard.grabKey();

    if(keyCode != Key.Null)
    {
      key = Keyboard.translateCode(keyCode);

      if (key != '\0')
      {
        // echo the character (should allow this to be turned off by forked apps)
        echoStr[0] = key;
        print(echoStr);

        if (key == '\n')
        {
          // interpret line
          if (lineBufferPos > 0)
          {
            switch (lineBuffer[0..lineBufferPos])
            {
              case "free":
                free(buff);
                break;
              case "malloc":
                buff = malloc(100);
                break;
              case "yield":
                yield();
                break;
              case "intfic":
                if(!intfic) {
                  makeEnvironment(1); // 1 is intfic
                  intfic = true;
                } else {
                  print("You've already scheduled it!\n");
                }
                break;
              default:
              print("Error: Unknown Command\n");
              break;
            }
          }

          lineBufferPos = 0;

          // echo next line
          print(prompt);
        }
        else
        {
          // add to the line buffer
          // note, if we go over the max, the line will be misinterpreted
          lineBuffer[lineBufferPos++] = key;
          if (lineBufferPos == lineBuffer.length) { lineBufferPos--; }
        }
      }
    }
  }

  exit(0);

  //d is awesome
  return 0;
}


