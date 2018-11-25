/*******************************************************************************

    unitTest.c

    Functions for unit tests.
    Jumper wires are required for these tests:
        A1 ( 0)  <--->  ( 1) A2
        A3 ( 2)  <--->  (13) D4
        B4 ( 4)  <--->  ( 5) C3
        C4 ( 6)  <--->  ( 7) C5
        C6 ( 8)  <--->  ( 9) C7
        D2 (11)  <--->  (12) D3
        D5 (14)  <--->  (15) D6

*******************************************************************************/


/******************************************************************************/
/* Include Header Files */

#include "arduino.h"
#include <limits.h>
#include <stdint.h>
#include "stm8s103.h"
#include <string.h>
#include "unitTest.h"


/******************************************************************************/
/* Private Declarations */

// -- Private Constant Declarations --

#define BUFFER_LENGTH (sizeof(buffer)-1)
#define MAX_ATOD_LOW 0x010
#define MAX_MICRO_ERROR 200L
#define MAX_MILLI_ERROR 1
#define MAX_PULSE_TIMEOUT 2048
#define MAX_RATIO_ERROR 1000
#define MAX_TONE_ERROR 12
#define MIN_ATOD_HIGH 0x3e0
#define NUM_OF_BAUD_RATES (sizeof(baudRates)/sizeof(baudRates[0]))
#define NUM_OF_MICRO_DELAYS (sizeof(microDelays)/sizeof(microDelays[0]))
#define NUM_OF_MILLI_DELAYS (sizeof(milliDelays)/sizeof(milliDelays[0]))
#define NUM_OF_NOTES (sizeof(frequencies)/sizeof(frequencies[0]))
#define NUM_OF_PAIRS (sizeof(pairs)/sizeof(pairs[0]))
#define TEST_LONG (0xAAAAAAAA)
#define TEST_WORD (0x1248)


// -- Private Flash-Based Constant Definitions --

static const uint32_t baudRates[] = { 300, 1200, 9600, 57600, 115200 };
static const char buffer[] = "Hello, World!";
static const float frequencies[] = {
                            NOTE_B0,    NOTE_C1,    NOTE_CS1,   NOTE_D1,
    NOTE_DS1,   NOTE_E1,    NOTE_F1,    NOTE_FS1,   NOTE_G1,    NOTE_GS1,
    NOTE_A1,    NOTE_AS1,   NOTE_B1,    NOTE_C2,    NOTE_CS2,   NOTE_D2,
    NOTE_DS2,   NOTE_E2,    NOTE_F2,    NOTE_FS2,   NOTE_G2,    NOTE_GS2,
    NOTE_A2,    NOTE_AS2,   NOTE_B2,    NOTE_C3,    NOTE_CS3,   NOTE_D3,
    NOTE_DS3,   NOTE_E3,    NOTE_F3,    NOTE_FS3,   NOTE_G3,    NOTE_GS3,
    NOTE_A3,    NOTE_AS3,   NOTE_B3,    NOTE_C4,    NOTE_CS4,   NOTE_D4,
    NOTE_DS4,   NOTE_E4,    NOTE_F4,    NOTE_FS4,   NOTE_G4,    NOTE_GS4,
    NOTE_A4,    NOTE_AS4,   NOTE_B4,    NOTE_C5,    NOTE_CS5,   NOTE_D5,
    NOTE_DS5,   NOTE_E5,    NOTE_F5,    NOTE_FS5,   NOTE_G5,    NOTE_GS5,
    NOTE_A5,    NOTE_AS5,   NOTE_B5,    NOTE_C6,    NOTE_CS6,   NOTE_D6,
    NOTE_DS6,   NOTE_E6,    NOTE_F6,    NOTE_FS6,   NOTE_G6,    NOTE_GS6,
    NOTE_A6,    NOTE_AS6,   NOTE_B6,    NOTE_C7,    NOTE_CS7,   NOTE_D7,
    NOTE_DS7,   NOTE_E7,    NOTE_F7,    NOTE_FS7,   NOTE_G7,    NOTE_GS7,
    NOTE_A7,    NOTE_AS7,   NOTE_B7,    NOTE_C8,    NOTE_CS8,   NOTE_D8,
    NOTE_DS8,   NOTE_E8,    NOTE_F8,    NOTE_FS8,   NOTE_G8,    NOTE_GS8,
    NOTE_A8,    NOTE_AS8,   NOTE_B8
};
static const uint16_t microDelays[] = { 0, 1000, 16383, 65535 };
static const uint32_t milliDelays[] = { 0, 1000, 10000, 90000 };
static const pinType pairs[][2] = {
    { 0, 1 },
    { 2, 13 },
    { 4, 5 },
    { 6, 7 },
    { 8, 9 },
    { 11, 12 },
    { 14, 15 }
};


// -- Private Function Prototypes --

static void checkAnalogPin(uint8_t analogPin, pinType pin);
static void checkDigitalPin(pinType aPin, modeType aMode, pinType bPin, modeType bMode);
static void checkDigitalPins(pinType a, pinType b);
static void checkMicroDelay(uint16_t delay);
static void checkMilliDelay(uint32_t delay);
static void checkPwmOut(pinType pwm, pinType feedback);
static void checkSerialConfig(uint32_t speed, serialConfigType cfg);
static void checkSerialRead(void);
static void checkShiftIn(pinType dataPin, pinType clockPin, bitOrderType order, uint8_t idle);
static void checkShiftOut(pinType dataPin, pinType clockPin, bitOrderType order, uint8_t idle);
static void checkTone(pinType out, pinType in);
static void spiRxReady(pinType clock, uint8_t idle);
static void spiTxReady(pinType clock, uint8_t idle);
static void testAdvancedIo(void);
static void testAnalogIo(void);
static void testBitsAndBytes(void);
static void testDigitalIo(void);
static void testSerialCommunication(void);
static void testTime(void);


/******************************************************************************/
/* Public Function Definitions */

// The setup() function is called when a sketch starts. Use it to initialize
// variables, pin modes, start using libraries, etc. The setup() function will
// only run once, after each powerup or reset of the development board.
void assert(uint8_t test) {
    if (test == 0) {
        FAIL();
    }
}

// Run all the unit tests
// If any test fails, then the LED will be lit
// Unit tests expect jumpers on Arduino pin pairs (refer to the pairs[] array)
// Return 1 if all tests pass; otherwise 0
uint8_t runUnitTests(void) {
    PASS();
    // testBitsAndBytes();
    // testTime();
    // testDigitalIo();
    // testAnalogIo();
    // testAdvancedIo();
    testSerialCommunication();
    return (uint8_t)DID_PASS();
}


/******************************************************************************/
/* Private Function Definitions */

static void checkAnalogPin(uint8_t analogPin, pinType pin) {
    pinMode(pin, OUTPUT);

    // Read analog value of low pin
    digitalWrite(pin, LOW);
    uint16_t value = analogRead(analogPin);
    ASSERT(value <= MAX_ATOD_LOW);

    // Read analog value of high pin
    digitalWrite(pin, HIGH);
    uint16_t value = analogRead(analogPin);
    ASSERT(value >= MIN_ATOD_HIGH);

    // Restore pin as input
    pinMode(pin, INPUT);
}

static void checkDigitalPin(pinType aPin, modeType aMode, pinType bPin, modeType bMode) {
    pinMode(bPin, bMode);
    pinMode(aPin, aMode);
    digitalWrite(aPin, HIGH);
    ASSERT(digitalRead(bPin) == HIGH);
    digitalWrite(aPin, LOW);
    ASSERT(digitalRead(bPin) == LOW);
}

static void checkDigitalPins(pinType a, pinType b) {
    if ((a != 3) && (a != 4)) {
        checkDigitalPin(a, OUTPUT, b, INPUT);
        checkDigitalPin(a, OUTPUT_FAST, b, INPUT);
    }
    checkDigitalPin(a, OUTPUT, b, INPUT_PULLUP);
    checkDigitalPin(a, OUTPUT_FAST, b, INPUT_PULLUP);
    checkDigitalPin(a, OUTPUT_OPENDRAIN, b, INPUT_PULLUP);

    checkDigitalPin(b, OUTPUT, a, INPUT);
    checkDigitalPin(b, OUTPUT_FAST, a, INPUT);
    if ((a != 3) && (a != 4)) {
        checkDigitalPin(b, OUTPUT, a, INPUT_PULLUP);
        checkDigitalPin(b, OUTPUT_FAST, a, INPUT_PULLUP);
        checkDigitalPin(b, OUTPUT_OPENDRAIN, a, INPUT_PULLUP);
    }

    pinMode(a, INPUT);
    pinMode(b, INPUT);
}

static void checkMicroDelay(uint16_t usDelay) {
    uint32_t start = micros();
    delayMicroseconds(usDelay);
    uint32_t stop = micros();
    uint32_t calcDelay = stop - start;
    ASSERT(calcDelay <= usDelay + MAX_MICRO_ERROR);
    ASSERT(usDelay <= calcDelay + MAX_MICRO_ERROR);
}

static void checkMilliDelay(uint32_t msDelay) {
    uint32_t start = millis();
    delay(msDelay);
    uint32_t stop = millis();
    uint32_t calcDelay = stop - start;
    ASSERT(calcDelay <= msDelay + MAX_MILLI_ERROR);
    ASSERT(msDelay <= calcDelay + MAX_MILLI_ERROR);
}

static void checkPwmOut(pinType pwm, pinType feedback) {
    // Test PWM with 0% duty
    uint8_t dutyCycle = 0;
    int32_t width;
    analogWrite(pwm, dutyCycle);
    width = pulseIn(feedback, HIGH, MAX_PULSE_TIMEOUT);
    ASSERT(width == 0);
    width = pulseIn(feedback, LOW, MAX_PULSE_TIMEOUT);
    ASSERT(width == 0);
    ASSERT(digitalRead(feedback) == LOW);

    // Test PWM with all (increasing) duty cycles not including 0% or 100%
    int32_t hiWidth = 0;
    int32_t loWidth = MAX_PULSE_TIMEOUT;
    for (dutyCycle = 1; dutyCycle < 255; dutyCycle++) {
        analogWrite(pwm, dutyCycle);
        width = pulseIn(feedback, HIGH, MAX_PULSE_TIMEOUT);
        ASSERT(hiWidth <= width + 4);
        hiWidth = width;
        width = pulseIn(feedback, HIGH, -MAX_PULSE_TIMEOUT);
        ASSERT(width == 0);
        width = pulseIn(feedback, LOW, MAX_PULSE_TIMEOUT);
        ASSERT(loWidth + 4 >= width);
        loWidth = width;
    }
    // PWM frequency should be approximately 1kHz
    ASSERT((0 <= loWidth) && (loWidth < 10));
    ASSERT((900 < hiWidth) && (hiWidth < 1024));

    // Test PWM with all (decreasing) duty cycles not including 0% or 100%
    hiWidth = MAX_PULSE_TIMEOUT;
    loWidth = 0;
    for (dutyCycle = 254; dutyCycle > 0; dutyCycle--) {
        analogWrite(pwm, dutyCycle);
        width = pulseIn(feedback, HIGH, MAX_PULSE_TIMEOUT);
        ASSERT(hiWidth + 4 >= width);
        hiWidth = width;
        width = pulseIn(feedback, LOW, -MAX_PULSE_TIMEOUT);
        ASSERT(width == 0);
        width = pulseIn(feedback, LOW, MAX_PULSE_TIMEOUT);
        ASSERT(loWidth <= width + 4);
        loWidth = width;
    }

    // Test PWM with 100% duty
    dutyCycle = 255;
    analogWrite(pwm, dutyCycle);
    width = pulseIn(feedback, HIGH, MAX_PULSE_TIMEOUT);
    ASSERT(width == 0);
    width = pulseIn(feedback, LOW, MAX_PULSE_TIMEOUT);
    ASSERT(width == 0);
    ASSERT(digitalRead(feedback) == HIGH);

    // Restore pin mode
    pinMode(pwm, INPUT);
}

static void checkSerialConfig(uint32_t speed, serialConfigType cfg) {
    serialBegin(speed, cfg);
    ASSERT(serialWrite((uint8_t)('A' + cfg)) == 1);
    while(serialAvailable() == 0)
        ;
    int16_t feedback = serialRead();
    if (feedback == 255) {
        // Ignore idle character sometimes sent by UART peripheral
        while(serialAvailable() == 0)
            ;
        feedback = serialRead();
    }
    ASSERT(feedback == 'A' + cfg);
    ASSERT((UART1.SR & 0x0f) == 0);
    serialEnd();
}

static void checkSerialRead(void) {
    char buf[BUFFER_LENGTH];
    serialFlush();
    ASSERT(serialAvailable() == BUFFER_LENGTH);
    uint8_t pos = (uint8_t)(strchr(buffer, 'W') - buffer);
    ASSERT(serialReadBytesUntil('W', buf, BUFFER_LENGTH) == pos);
    ASSERT(memcmp(buf, buffer, pos) == 0);
    ASSERT(serialReadBytes(buf, BUFFER_LENGTH) == BUFFER_LENGTH - pos);
    ASSERT(memcmp(buf, &buffer[pos], BUFFER_LENGTH - pos) == 0);
}

static void checkShiftIn(pinType dataPin, pinType clockPin, bitOrderType order, uint8_t idle) {
    // Setup SPI
    digitalWrite(clockPin, idle);
    SPI.CR1 = (uint8_t)((order ? 0 : 0x80) | (idle ? 0x02 : 0));
    SPI.CR2 = 0x02;
    SPI.CR1 |= 0x40;
    spiTxReady(clockPin, idle);

    // Test shiftIn() function
    uint16_t value;
    for (value = 0; value < 256; value++) {
        SPI.DR = (uint8_t)value;
        uint8_t feedback = shiftIn(dataPin, clockPin, order);
        ASSERT(feedback == value);
    }

    // Disable SPI
    SPI.CR1 = 0;
}

static void checkShiftOut(pinType dataPin, pinType clockPin, bitOrderType order, uint8_t idle) {
    // Setup SPI
    digitalWrite(clockPin, idle);
    SPI.CR1 = (uint8_t)((order ? 0 : 0x80) | (idle ? 0x02 : 0));
    SPI.CR2 = 0x06;
    SPI.CR1 |= 0x40;
    spiRxReady(clockPin, idle);

    // Test shiftOut() function
    uint16_t value;
    for (value = 0; value < 256; value++) {
        shiftOut(dataPin, clockPin, order, (uint8_t)value);
        uint8_t feedback = SPI.DR;
        ASSERT(feedback == value);
    }

    // Disable SPI
    SPI.CR1 = 0;
}

static void checkTone(pinType out, pinType in) {
    pinMode(out, OUTPUT);
    uint8_t note;
    uint32_t measured;
    for (note = 0; note < NUM_OF_NOTES; note++) {
        float frequency = frequencies[note];
        tone(out, frequency, 0);
        uint32_t expected = (uint32_t)(500000.0 / frequency);
        measured = pulseIn(in, HIGH, 100000);
        ASSERT((expected <= measured + MAX_TONE_ERROR) && (measured <= expected + MAX_TONE_ERROR));
        measured = pulseIn(in, LOW, 100000);
        ASSERT((expected <= measured + MAX_TONE_ERROR) && (measured <= expected + MAX_TONE_ERROR));
    }
    noTone(out);
    measured = pulseIn(in, HIGH, 100000);
    ASSERT(measured == 0);
    pinMode(out, INPUT);
}

static void spiRxReady(pinType clock, uint8_t idle) {
    uint8_t active = (uint8_t)!idle;
    SPI.DR;
    if ((SPI.SR & 0x81) != 0) {
        while ((SPI.SR & 0x81) != 0x01) {
            digitalWrite(clock, active);
            digitalWrite(clock, idle);
        }
        SPI.DR;
    }
}

static void spiTxReady(pinType clock, uint8_t idle) {
    uint8_t active = (uint8_t)!idle;
    while ((SPI.SR & 0x82) != 0x02) {
        digitalWrite(clock, active);
        digitalWrite(clock, idle);
    }
}

// Test Advanced I/O category
//  - noTone()
//  - shiftIn()
//  - shiftOut()
//  - tone()
// Note 1: pulseIn() is tested as part of testAnalogIo()
// Note 2: pulseIn() is accurate with short and long times so...
//         pulseInLong() is not necessary
static void testAdvancedIo(void) {
    // Use SPI in slave mode to write shifted bytes
    //      pin 6 is used as the shiftIn() output clock pin
    //      pin 8 is used as the shiftIn() input data pin
    //      SPI is configured as an output only slave
    //      pin 9 is the SPI slave output data pin (MISO)
    //      pin 7 is the SPI slave input clock pin
    pinMode(6, OUTPUT);
    checkShiftIn(8, 6, MSBFIRST, LOW);
    checkShiftIn(8, 6, LSBFIRST, LOW);
    checkShiftIn(8, 6, MSBFIRST, HIGH);
    checkShiftIn(8, 6, LSBFIRST, HIGH);
    pinMode(6, INPUT);

    // Use SPI in slave mode to read shifted bytes
    //      pin 6 is used as the shiftOut() output clock pin
    //      pin 9 is used as the shiftOut() output data pin
    //      SPI is configured as an input only slave
    //      pin 8 is the SPI slave input data pin (MOSI)
    //      pin 7 is the SPI slave input clock pin
    pinMode(6, OUTPUT);
    pinMode(9, OUTPUT);
    checkShiftOut(9, 6, MSBFIRST, LOW);
    checkShiftOut(9, 6, LSBFIRST, LOW);
    checkShiftOut(9, 6, MSBFIRST, HIGH);
    checkShiftOut(9, 6, LSBFIRST, HIGH);
    pinMode(9, INPUT);
    pinMode(6, INPUT);

    uint8_t index;
    for (index = 0; index < NUM_OF_PAIRS; index++) {
        uint8_t a = pairs[index][0];
        uint8_t b = pairs[index][1];
        if ((a != 3) && (a != 4))
            checkTone(a, b);
        if ((b != 3) && (b != 4))
            checkTone(b, a);
    }
}

// Test Analog I/O category
// Also test pulseIn() function
//  - analogRead()
//  - analogWrite()
//  - pulseIn()
static void testAnalogIo(void) {
    checkAnalogPin(0, 7);
    checkAnalogPin(1, 12);
    checkAnalogPin(2, 11);
    checkAnalogPin(3, 15);
    checkAnalogPin(4, 14);

    checkPwmOut(2, 13);
    checkPwmOut(5, 4);
    checkPwmOut(6, 7);
    checkPwmOut(12, 11);
    checkPwmOut(13, 2);
}

// Test Bits and Bytes category
//  - bit()
//  - bitClear()
//  - bitRead()
//  - bitSet()
//  - bitWrite()
//  - highByte()    (macro)
//  - lowByte()     (macro)
static void testBitsAndBytes(void) {
    uint8_t i;
    uint8_t valueByte;
    uint16_t valueWord;
    uint32_t valueLong;

    // Test bit() function
    for (i = 0; i < 64; i++) {
        valueLong = bit((uint8_t)i);
        ASSERT(valueLong == (1UL << i));
    }

    // Test bitClear() function
    for (i = 0; i < 32; i++) {
        valueLong = ULONG_MAX;
        bitClear(&valueLong, i);
        ASSERT(valueLong == ~bit(i));
    }

    // Test bitRead() function
    valueLong = TEST_LONG;
    for (i = 0; i < 32; i++) {
        valueByte = bitRead(valueLong, i);
        ASSERT(valueByte == ((TEST_LONG >> i) & 1));
    }
    valueLong >>= 1;
    for (i = 0; i < 32; i++) {
        valueByte = bitRead(valueLong, i);
        ASSERT(valueByte == (((TEST_LONG >> 1) >> i) & 1));
    }

    // Test bitSet() function
    for (i = 0; i < 32; i++) {
        valueLong = 0;
        bitSet(&valueLong, i);
        ASSERT(valueLong == bit(i));
    }

    // Test bitWrite() function
    for (i = 0; i < 32; i++) {
        valueLong = TEST_LONG;
        bitWrite(&valueLong, i, 1);
        ASSERT(valueLong == (TEST_LONG | bit(i)));
    }
    for (i = 0; i < 32; i++) {
        valueLong = TEST_LONG;
        bitWrite(&valueLong, i, 0);
        ASSERT(valueLong == (TEST_LONG & ~bit(i)));
    }

    // Test highByte() and lowByte() functions
    valueWord = TEST_WORD;
    for (i = 0; i < 32; i++) {
        valueWord = valueWord * 199 + 0xABCD;
        ASSERT(highByte(valueWord) == (valueWord / 256));
        ASSERT( lowByte(valueWord) == (valueWord & 255));
    }
}

// Test Digital I/O category
//  - digitalRead()
//  - digitalWrite()
//  - pinMode()
static void testDigitalIo(void) {
    uint8_t index;
    for (index = 0; index < NUM_OF_PAIRS; index++) {
        uint8_t a = pairs[index][0];
        uint8_t b = pairs[index][1];
        if ((b != 3) && (b != 4))
            checkDigitalPins(a, b);
        if ((a != 3) && (a != 4))
            checkDigitalPins(b, a);
    }
}

// Test Communications
//  - serialBegin()
//  - serialWrite()
//  - serialRead()
//  - serialEnd()
//  - serialAvailable()
//  - serialFlush()
//  - serialReadBytes()
//  - serialReadBytesUntil()
//  - serialWriteBuffer()
//  - serialWriteString()
static void testSerialCommunication(void) {
    int16_t result;

    // test writing and reading serial data one byte at a time
    serialBegin(115200, SERIAL_8N1);
    uint16_t val;
    for (val = 0; val < 256; val++) {
        ASSERT(serialWrite((uint8_t)val) == 1);
        delayMicroseconds((val == 0) ? 200 : 110);
        result = serialPeek();
        ASSERT(result == val);
        result = serialRead();
        ASSERT(result == val);
    }
    serialEnd();

    // test that serialAvailable() works as expected
    ASSERT(serialAvailable() == 0);
    serialBegin(115200, SERIAL_8N1);
    uint8_t count;
    for (count = 0; count < 10; count++) {
        ASSERT(serialAvailable() == count);
        serialWrite((uint8_t)((count & 1) ? 0x55 : 0xAA));
        ASSERT(serialAvailable() == count);
        while(serialAvailable() == count);
    }
    ASSERT(serialAvailable() == count);
    serialEnd();
    ASSERT(serialAvailable() == 0);

    // test serial functions that work with character buffers
    serialBegin(115200, SERIAL_8N1);
    serialWriteBuffer(buffer, BUFFER_LENGTH);
    checkSerialRead();
    serialWriteString(buffer);
    checkSerialRead();
    serialEnd();

    // test supported serial port configurations
    uint8_t baud;
    serialConfigType cfg;
    for (baud = 0; baud < NUM_OF_BAUD_RATES; baud++) {
        for (cfg = 0; cfg < 4; cfg++) {
            checkSerialConfig(baudRates[baud], cfg);
        }
    }

    // test serial find functions
    char target1[] = "Hello";
    serialBegin(115200, SERIAL_8N1);
    serialWriteBuffer(buffer, BUFFER_LENGTH);
    result = serialFind(target1);
    ASSERT(result == 1);
    result = serialPeek();
    ASSERT(result == -1);
    result = serialFind(target1);
    ASSERT(result == 0);
    result = serialAvailable();
    ASSERT(result == 0);
    serialWriteBuffer(buffer, BUFFER_LENGTH);
    result = serialFindUntil(target1, "o");
    ASSERT(result == 1);
    result = serialPeek();
    ASSERT(result == -1);
    result = serialFindUntil("World", "rl");
    ASSERT(result == 0);
    result = serialPeek();
    ASSERT(result == -1);
    delayMicroseconds(300);
    result = serialAvailable();
    ASSERT(result > 0);
    serialEnd();
}

// Test Time category
//  - delay()
//  - delayMicroseconds()
//  - micros()
//  - millis()
static void testTime(void) {
    // Verify ratio of micros() to millis()
    uint32_t us = micros();
    uint32_t ms = millis();
    uint32_t loop;
    for (loop = 0; loop < 1000000; loop++)
        ;
    us = micros() - us;
    ms = millis() - ms;
    uint32_t usCalc = 1000 * ms;
    ASSERT(usCalc <= us + MAX_RATIO_ERROR);
    ASSERT(us <= usCalc + MAX_RATIO_ERROR);

    // Test delayMicroseconds() using micros() as a reference
    uint8_t index;
    for (index = 0; index < NUM_OF_MICRO_DELAYS; index++) {
        checkMicroDelay(microDelays[index]);
    }

    // Test delay() using millis() as a reference
    uint8_t index;
    for (index = 0; index < NUM_OF_MILLI_DELAYS; index++) {
        checkMilliDelay(milliDelays[index]);
    }

    // Test that delay(0) never gets stuck even if TIM4 overflows to zero
    uint8_t index;
    for (index = 0; index < 100; index++) {
        uint32_t ms = millis();
        delay(0);
        ms = millis() - ms;
        ASSERT(ms <= MAX_MILLI_ERROR);
    }
}


/******************************************************************************/
