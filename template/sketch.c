/*******************************************************************************

    sketch.c
    
    Implements an Arduino-like sketch.

*******************************************************************************/


/******************************************************************************/
/* Include Header Files */

#include "arduino.h"
#include <stdint.h>


/******************************************************************************/
/* Private Declarations */

#define TEST_LED 3


/******************************************************************************/
/* Public Function Definitions */

// The setup() function is called when a sketch starts. Use it to initialize
// variables, pin modes, start using libraries, etc. The setup() function will
// only run once, after each powerup or reset of the development board.
void setup(void) {
    pinMode(TEST_LED, OUTPUT_OPENDRAIN);
}

// The loop() function does precisely what its name suggests, and loops
// consecutively, allowing your program to change and respond. Use it to
// actively control the development board.
void loop(void) {
    uint8_t value = digitalRead(TEST_LED);
    digitalWrite(TEST_LED, (uint8_t)!value);
    delay(125);
}

// SerialEvent occurs when new data is received by the UART peripheral.
// This routine will only be called between calls to loop(); therefore, using
// delay() in the loop() function will delay reaction to the received data.
// Multiple bytes of data may be available.
void serialEvent(void) {
}


/******************************************************************************/
