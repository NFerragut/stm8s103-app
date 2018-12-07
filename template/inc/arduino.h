/*******************************************************************************

    arduino.h

    Declarations for Arduino-style interfaces.

*******************************************************************************/

#ifndef _STM8BOARD_H
#define _STM8BOARD_H


/******************************************************************************/
/* Include Header Files */

#include <ctype.h>
#include <math.h>
#include <stdint.h>
#include <stdlib.h>


/******************************************************************************/
/* Public Declarations */

// -- Public Constant Declarations --

#define PINS_COUNT      16
#define HIGH            1
#define LOW             0


// -- Public Constants for Musical Note Frequencies --

#define NOTE_B0         30.87
#define NOTE_C1         32.70
#define NOTE_CS1        34.65
#define NOTE_D1         36.71
#define NOTE_DS1        38.89
#define NOTE_E1         41.20
#define NOTE_F1         43.65
#define NOTE_FS1        46.25
#define NOTE_G1         49.00
#define NOTE_GS1        51.91
#define NOTE_A1         55.00
#define NOTE_AS1        58.27
#define NOTE_B1         61.74
#define NOTE_C2         65.41
#define NOTE_CS2        69.30
#define NOTE_D2         73.42
#define NOTE_DS2        77.78
#define NOTE_E2         82.41
#define NOTE_F2         87.31
#define NOTE_FS2        92.50
#define NOTE_G2         98.00
#define NOTE_GS2        103.83
#define NOTE_A2         110.00
#define NOTE_AS2        116.54
#define NOTE_B2         123.47
#define NOTE_C3         130.81
#define NOTE_CS3        138.59
#define NOTE_D3         146.83
#define NOTE_DS3        155.56
#define NOTE_E3         164.81
#define NOTE_F3         174.61
#define NOTE_FS3        185.00
#define NOTE_G3         196.00
#define NOTE_GS3        207.65
#define NOTE_A3         220.00
#define NOTE_AS3        233.08
#define NOTE_B3         246.94
#define NOTE_C4         261.63
#define NOTE_CS4        277.18
#define NOTE_D4         293.66
#define NOTE_DS4        311.13
#define NOTE_E4         329.63
#define NOTE_F4         349.23
#define NOTE_FS4        369.99
#define NOTE_G4         392.00
#define NOTE_GS4        415.30
#define NOTE_A4         440.00
#define NOTE_AS4        466.16
#define NOTE_B4         493.88
#define NOTE_C5         523.25
#define NOTE_CS5        554.37
#define NOTE_D5         587.33
#define NOTE_DS5        622.25
#define NOTE_E5         659.25
#define NOTE_F5         698.46
#define NOTE_FS5        739.99
#define NOTE_G5         783.99
#define NOTE_GS5        830.61
#define NOTE_A5         880.00
#define NOTE_AS5        932.33
#define NOTE_B5         987.77
#define NOTE_C6         1046.50
#define NOTE_CS6        1108.73
#define NOTE_D6         1174.66
#define NOTE_DS6        1244.51
#define NOTE_E6         1318.51
#define NOTE_F6         1396.91
#define NOTE_FS6        1479.98
#define NOTE_G6         1567.98
#define NOTE_GS6        1661.22
#define NOTE_A6         1760.00
#define NOTE_AS6        1864.66
#define NOTE_B6         1975.53
#define NOTE_C7         2093.00
#define NOTE_CS7        2217.46
#define NOTE_D7         2349.32
#define NOTE_DS7        2489.02
#define NOTE_E7         2637.02
#define NOTE_F7         2793.83
#define NOTE_FS7        2959.96
#define NOTE_G7         3135.96
#define NOTE_GS7        3322.44
#define NOTE_A7         3520.00
#define NOTE_AS7        3729.31
#define NOTE_B7         3951.07
#define NOTE_C8         4186.01
#define NOTE_CS8        4434.92
#define NOTE_D8         4698.63
#define NOTE_DS8        4978.03
#define NOTE_E8         5274.04
#define NOTE_F8         5587.65
#define NOTE_FS8        5919.91
#define NOTE_G8         6271.93
#define NOTE_GS8        6644.88
#define NOTE_A8         7040.00
#define NOTE_AS8        7458.62
#define NOTE_B8         7902.13


// -- Public Type Declarations --

typedef enum bitOrderEnum {
    LSBFIRST            = 0,        // Least Significant Bit (LSB) is sent first
    MSBFIRST            = 1,        // Most Significant Bit (MSB) is sent first
} bitOrderType;

typedef enum modeEnum {
    INPUT               = 0,
    INPUT_PULLUP        = 1,
    OUTPUT              = 4,
    OUTPUT_OPENDRAIN    = 5,
    OUTPUT_FAST         = 6,
} modeType;

typedef uint8_t pinType;

typedef enum serialConfigEnum {
    SERIAL_8N1          = 0,                    // Default value
    SERIAL_8N2          = 1,
    SERIAL_8E1          = 2,
    SERIAL_8O1          = 3,
} serialConfigType;


// -- Public Macro Declarations --

// Bits and Bytes
#define highByte(w)                 ((uint8_t)((w) >> 8))
#define lowByte(w)                  ((uint8_t)((w) & 0xFF))

// Characters functions
#define isAlpha(c)                  isalpha(c)
#define isAlphaNumeric(c)           isalnum(c)
#define isAscii(c)                  (((c) & ~0x7F) == 0)
#define isControl(c)                iscntrl(c)
#define isDigit(c)                  isdigit(c)
#define isGraph(c)                  isgraph(c)
#define isHexadecimalDigit(c)       isxdigit(c)
#define isLowerCase(c)              islower(c)
#define isPrintable(c)              isprint(c)
#define isPunct(c)                  ispunct(c)
#define isSpace(c)                  ((c) == ' ')
#define isUpperCase(c)              isupper(c)
#define isWhitespace(c)             isspace(c)

// Interrupts
#define interrupts()                {_asm("rim");}
#define noInterrupts()              {_asm("sim");}

// Math
#define constrain(x,a,b)            ((a)<=(x)?((x)<=(b)?(x):(b)):(a))
#define map(x,a1,a2,b1,b2)          (((x)-(a1))*((b2)-(b1))/((a2)-(a1))+(b1))
#define max(a,b)                    ((a)>(b)?(a):(b))
#define min(a,b)                    ((a)<(b)?(a):(b))
#define sq(x)                       ((x)*(x))

// Random Numbers
#define random(v)                   (rand() % v)
#define randomSeed(s)               srand(s)


/******************************************************************************/
/* Public Function Prototypes */

// Read the value from the specified analog pin
// param analogPin = the analog pin to measure (0-4)
// Returns the analog measurement (0-1023)
uint16_t analogRead(uint8_t analogPin);

// Start a PWM output with the specified duty cycle
// param pin = the digital pin to drive the PWM output (2, 5, 6, 12, or 13)
// param dutyCycle = the PWM duty cycle (0-255)
void analogWrite(pinType pin, uint8_t dutyCycle);

// Get a mask for the specified bit
// param bitNumber = the number of the bit to set (0-31)
// returns a 32-bit value with a single bit set
uint32_t bit(uint8_t bitNumber);

// Write a 0 to a bit of a value
// param value = pointer to a 32-bit value
// param bitNumber = the number of the bit to clear (0-31)
void bitClear(uint32_t* value, uint8_t bitNumber);

// Read a bit of value
// param value = the 32-bit value to read
// param bitNumber = the number of the bit to read (0-31)
// Returns the value of the bit that was read (0 or 1)
uint8_t bitRead(uint32_t value, uint8_t bitNumber);

// Write a 1 to a bit of a value
// param value = pointer to a 32-bit value
// param bitNumber = the number of the bit to set (0-31)
void bitSet(uint32_t* value, uint8_t bitNumber);

// Write a bit of value
// param value = pointer to a 32-bit value
// param bitNumber = the number of the bit to write (0-31)
// param bitValue = the new bit value (0 or 1)
void bitWrite(uint32_t* value, uint8_t bitNumber, uint8_t bitValue);

// Delay for the specified number of milliseconds
// param milliseconds = the number of milliseconds to delay
void delay(uint32_t milliseconds);

// Delay for the specified number of microseconds
// param microseconds = the number of microseconds to delay
void delayMicroseconds(uint16_t microseconds);

// Read a digital pin
// param pin = the pin to read
// Returns the value of the pin (HIGH or LOW)
uint8_t digitalRead(pinType pin);

// Write a digital pin HIGH or LOW
// param pin = the pin to write
// param value = the value to write to the pin (HIGH or LOW)
void digitalWrite(pinType pin, uint8_t value);

// Get the number of microseconds since reset.
// Returns the number of microseconds since reset.
uint32_t micros(void);

// Get the number of milliseconds since reset.
// Returns the number of milliseconds since reset.
uint32_t millis(void);

// Stop generation of a tone on the specified pin
// param pin = the pin with the tone generation
void noTone(pinType pin);

// Configure a digital pin
// param pin = the pin to configure
// param mode = the pin mode
//              - INPUT pin can read HIGH or LOW
//              - INPUT_PULLUP pin has an internal pullup resistance
//              - OUTPUT pin can drive HIGH or LOW
//              - OUTPUT_OPENDRAIN pin can drive LOW, but not HIGH
//              - OUTPUT_FAST pin can drive HIGH or LOW
void pinMode(pinType pin, modeType mode);

// Read a pulse on a pin
// Most accurate with short pulse durations
// param pin = the pin used to read the pulse
// param value = the polarity of the pulse
//          LOW to read a low pulse, HIGH to read a high pulse
// param timeout = the maximum microseconds to wait for the completion of the pulse
// Returns the width of the pulse from edge to edge
int32_t pulseIn(pinType pin, uint8_t value, int32_t timeout);

// Read a pulse on a pin
// Most accurate with long pulse durations
// param pin = the pin used to read the pulse
// param value = the polarity of the pulse
//          LOW to read a low pulse, HIGH to read a high pulse
// param timeout = the maximum microseconds to wait for the completion of the pulse
// Returns the width of the pulse from edge to edge
int32_t pulseInLong(pinType pin, uint8_t value, int32_t timeout);

// Get the number of bytes available for reading from the serial port
// Returns the number of bytes available to read
int16_t serialAvailable(void);

// Open the serial port to communicate over pins 14 and 15
// param speed = speed in bits per second (baud)
// param config = sets data, parity, and stop bits. Refer to serialConfigType
void serialBegin(uint32_t speed, serialConfigType config);

// Close the serial port so pins 14 and 15 can be used as general purpose I/O
void serialEnd(void);

// Read data from the serial buffer until a target string is found
// param target = the string to search for
// Return true if the target string is found, return false if a timeout occurs
uint8_t serialFind(char* target);

// Read data from the serial buffer until a target string or terminator string
// is found.
// param target = the string to search for
// param terminal = the terminal string in the search
// Return true if the target string is found, return false if the terminal
//        string is found or if a timeout occurs
uint8_t serialFindUntil(char* target, char* terminal);

// Wait for the transmission of outgoing serial data to complete
void serialFlush(void);

// Look at incoming serial data without removing it from the queue
// Returns the first byte of incoming serial data (or -1 if no data is available)
int16_t serialPeek(void);

// Read incoming serial data
// Returns the first byte of incoming serial data (or -1 if no data is available)
int16_t serialRead(void);

// Read characters from the serial port into a buffer
// The function terminates if it times out (see serialSetTimeout())
// param buffer = pointer to an array for received serial port bytes
// param length = the maximum number of bytes to write to the buffer
//                Function terminates if length bytes have been saved
// Returns the number of bytes that were saved in the buffer
int16_t serialReadBytes(char* buffer, uint16_t length);

// Read characters from the serial port into a buffer until the terminator
// character is received
// The function terminates if it times out (see serialSetTimeout())
// param terminator = the character to search for
// param buffer = pointer to an array for received serial port bytes
//                The terminator character is not saved in the buffer
// param length = the maximum number of bytes to write to the buffer
//                Function terminates if length bytes have been saved
// Returns the number of bytes that were saved in the buffer
int16_t serialReadBytesUntil(char terminator, char* buffer, uint16_t length);

// Set the timeout used for serial communications.
// Used by serialReadBytes(), serialReadBytesUntil()
void serialSetTimeout(int32_t milliseconds);

// Writes a single byte of data to the serial port
// Returns the number of bytes written
int16_t serialWrite(uint8_t val);

// Writes an array of bytes to the serial port
// Returns the number of bytes written (so far)
int16_t serialWriteBuffer(uint8_t* buf, uint16_t len);

// Writes a zero-terminated string to the serial port
// The terminating zero is not written
// Returns the number of bytes written (so far)
int16_t serialWriteString(uint8_t* str);

// Shift a byte in from an external device one bit at a time
// param dataPin = the pin that reads the bit values
// param clockPin = the pin that generates a clock pulse for each bit
// param bitOrder = specifies the order of bits (LSBFIRST or MSBFIRST)
// Returns the value that was read from the external device
uint8_t shiftIn(pinType dataPin, pinType clockPin, bitOrderType bitOrder);

// Shift a byte out to an external device one bit at a time
// param dataPin = the pin that writes the bit values
// param clockPin = the pin that generates a clock pulse for each bit
// param bitOrder = specifies the order of bits (LSBFIRST or MSBFIRST)
// param value = the value that should be shifted out one bit at a time
void shiftOut(pinType dataPin, pinType clockPin, bitOrderType bitOrder, uint8_t value);

// Start generating a tone on the specified pin
// The tone is 50% duty square wave at the specified frequency (Hz)
// The tone will automatically stop after the specified duration (ms)
// If the duration is 0, the tone will play indefinitely
// param pin = the pin to drive the generated tone
// param frequency = the requested tone frequency (30-20000 Hz)
// param duration = milliseconds that the tone should play
void tone(pinType pin, float frequency, uint32_t duration);


/******************************************************************************/

#endif      /* _STM8BOARD_H */
