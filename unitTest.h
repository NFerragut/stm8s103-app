/*******************************************************************************

    unitTest.h

    Functions for unit tests.

*******************************************************************************/

#ifndef _UNITTEST_H
#define _UNITTEST_H


/******************************************************************************/
/* Include Header Files */

#include <stdint.h>
#include "stm8s103.h"


/******************************************************************************/
/* Public Macro Declarations */

#define ASSERT(x)       assert((uint8_t)(x))
#define FAIL()          {GPIOB.ODR &= 0xDF; GPIOB.DDR |= 0x20;}
#define PASS()          {GPIOB.ODR |= 0x20; GPIOB.DDR |= 0x20;}
#define IS_UT_ACTIVE()  (GPIOB.DDR & 0x20)
#define DID_PASS()      ((GPIOB.ODR & 0x20) != 0)
#define DID_FAIL()      ((GPIOB.ODR & 0x20) == 0)


/******************************************************************************/
/* Public Function Prototypes */

void assert(uint8_t test);
uint8_t runUnitTests(void);


/******************************************************************************/

#endif      /* _UNITTEST_H */
