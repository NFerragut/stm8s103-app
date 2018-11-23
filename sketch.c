/*******************************************************************************

    sketch.c
    
    Implements an Arduino-like sketch.

*******************************************************************************/


/******************************************************************************/
/* Include Header Files */

#include "arduino.h"
#include "unitTest.h"


/******************************************************************************/
/* Private Declarations */

// -- Private Variable Definitions --

static uint8_t passed;


/******************************************************************************/
/* Public Function Definitions */

// The setup() function is called when a sketch starts. Use it to initialize
// variables, pin modes, start using libraries, etc. The setup() function will
// only run once, after each powerup or reset of the development board.
void setup(void) {
    passed = runUnitTests();
}

// The loop() function does precisely what its name suggests, and loops
// consecutively, allowing your program to change and respond. Use it to
// actively control the development board.
void loop(void) {
    if (passed) {
        // Blink board led
        uint8_t value = digitalRead(3);
        digitalWrite(3, (uint8_t)!value);
        delay(200);
    }
}

// SerialEvent occurs when new data is received by the UART1 peripheral.
// This routine will only be called between calls to loop(); therefore, using
// delay() in the loop() function will delay reaction to the received data.
// Multiple bytes of data may be available.
void serialEvent(void) {
}


/******************************************************************************/
