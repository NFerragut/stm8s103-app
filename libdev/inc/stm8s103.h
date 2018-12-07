/*******************************************************************************

    stm8s103.h
    
    Declarations for the STM8S103 microcontroller family.
    Header file is more portable than the Cosmic version <iostm8s103.h>.
    It avoids using the Cosmic C Language extension for absolute addressing.

*******************************************************************************/

#ifndef _STM8S103_H
#define _STM8S103_H


/******************************************************************************/
/* Include Header Files */

#include <stdint.h>


/******************************************************************************/
/* Public Macro Declarations */

#define getCC()                     ((char)_asm("push cc\n pop a"))
#define halt()                      {_asm("halt");}
#define nop()                       {_asm("nop");}
#define restoreInterrupts(ccBackup) {setCC(ccBackup);}
#define saveInterrupts(ccBackup)    {ccBackup = getCC();{_asm("sim");}}
#define setCC(var)                  {_asm("push a\n pop cc",(var));}
#define softwareInterrupt()         {_asm("trap");}
#define waitForEvent()              {_asm("wfe");}
#define waitForInterrupt()          {_asm("wfi");}


/******************************************************************************/
/* Peripheral Type Declarations */

/* General Purpose I/O Ports (GPIO) */
typedef struct GPIO_Struct {
    volatile uint8_t ODR;           /* Output Data Register */
    volatile uint8_t IDR;           /* Input Data Register */
    volatile uint8_t DDR;           /* Data Direction Register */
    volatile uint8_t CR1;           /* Configuration Register 1 */
    volatile uint8_t CR2;           /* Configuration Register 2 */
} GPIO_Type;

/* Flash Program Memory and Data EEPROM (FLASH) */
typedef struct FLASH_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
    volatile uint8_t NCR2;          /* Complementary Control Register 2 */
    volatile uint8_t FPR;           /* Protection Register */
    volatile uint8_t NFPR;          /* Complementary Protection Register */
    volatile uint8_t IAPSR;         /* Status Register */
             uint8_t reserved1;
             uint8_t reserved2;
    volatile uint8_t PUKR;          /* Program Memory Unprotection Key Register */
             uint8_t reserved3;
    volatile uint8_t DUKR;          /* Data EEPROM Unprotection Key Register */
} FLASH_Type;

/* External Interrupt Control (EXTI) */
typedef struct EXTI_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
} EXTI_Type;

/* Clock Control (CLK) */
typedef struct CLK_Struct {
    volatile uint8_t ICKR;          /* Internal Clock Control Register */
    volatile uint8_t ECKR;          /* External Clock Control Register */
             uint8_t reserved1;
    volatile uint8_t CMSR;          /* Clock Master Status Register */
    volatile uint8_t SWR;           /* Clock Master Switch Register */
    volatile uint8_t SWCR;          /* Switch Control Register */
    volatile uint8_t CKDIVR;        /* Clock Divider Register */
    volatile uint8_t PCKENR1;       /* Peripheral Clock Gating Register 1 */
    volatile uint8_t CSSR;          /* Clock Security System Register */
    volatile uint8_t CCOR;          /* Configurable Clock Output Register */
    volatile uint8_t PCKENR2;       /* Peripheral Clock Gating Register 2 */
             uint8_t reserved2;
    volatile uint8_t HSITRIMR;      /* HSI Clock Calibration Trimming Register */
    volatile uint8_t SWIMCCR;       /* SWIM Clock Control Register */
} CLK_Type;

/* Window Watchdog (WWDG) */
typedef struct WWDG_Struct {
    volatile uint8_t CR;            /* Control Register */
    volatile uint8_t WR;            /* Window Register */
} WWDG_Type;

/* Independent Watchdog (IWDG) */
typedef struct IWDG_Struct {
    volatile uint8_t KR;            /* Key Register */
    volatile uint8_t PR;            /* Prescalar Register */
    volatile uint8_t RLR;           /* Reload Register */
} IWDG_Type;

/* Auto-Wakeup (AWU) */
typedef struct AWU_Struct {
    volatile uint8_t CSR;           /* Control/Status Register */
    volatile uint8_t APR;           /* Asynchronous Prescalar Register */
    volatile uint8_t TBR;           /* Timebase Selection Register */
} AWU_Type;

/* Serial Perihperal Interface (SPI) */
typedef struct SPI_Struct {
    volatile uint8_t CR1;           /* SPI Control Register 1 */
    volatile uint8_t CR2;           /* SPI Control Register 2 */
    volatile uint8_t ICR;           /* SPI Interrupt Control Register */
    volatile uint8_t SR;            /* SPI Status Register */
    volatile uint8_t DR;            /* SPI Data Register */
    volatile uint8_t CRCPR;         /* SPI CRC Polynomial Register */
    volatile uint8_t RXCRCR;        /* SPI Rx CRC Register */
    volatile uint8_t TXCRCR;        /* SPI Tx CRC Register */
} SPI_Type;

/* Inter-Integrated Circuit (I2C) Interface */
typedef struct I2C_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
    volatile uint8_t FREQR;         /* Frequency Register */
    volatile uint8_t OARL;          /* Own Address Register LSB */
    volatile uint8_t OARH;          /* Own Address Register MSB */
             uint8_t reserved;
    volatile uint8_t DR;            /* Data Register */
    volatile uint8_t SR1;           /* Status Register 1 */
    volatile uint8_t SR2;           /* Status Register 2 */
    volatile uint8_t SR3;           /* Status Register 3 */
    volatile uint8_t ITR;           /* Interrupt Register */
    volatile uint8_t CCRL;          /* Clock Control Register Low */
    volatile uint8_t CCRH;          /* Clock Control Register High */
    volatile uint8_t TRISER;        /* Rise Time Register */
} I2C_Type;

/* Universal Asynchronous Receiver Transmitter (UART) */
typedef struct UART1_Struct {
    volatile uint8_t SR;            /* Status Register */
    volatile uint8_t DR;            /* Data Register */
    volatile uint8_t BRR1;          /* Baud Rate Register 1 */
    volatile uint8_t BRR2;          /* Baud Rate Register 2 */
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
    volatile uint8_t CR3;           /* Control Register 3 */
    volatile uint8_t CR4;           /* Control Register 4 */
    volatile uint8_t CR5;           /* Control Register 5 */
    volatile uint8_t GTR;           /* Guard Time Register */
    volatile uint8_t PSCR;          /* Prescalar Register */
} UART1_Type;

/* 16-Bit Advanced Control Timer (TIM1) */
typedef struct TIM1_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
    volatile uint8_t SMCR;          /* Slave Mode Control Register */
    volatile uint8_t ETR;           /* External Trigger Register */
    volatile uint8_t IER;           /* Interrupt Enable Register */
    volatile uint8_t SR1;           /* Status Register 1 */
    volatile uint8_t SR2;           /* Status Register 2 */
    volatile uint8_t EGR;           /* Event Generation Register */
    volatile uint8_t CCMR1;         /* Capture/Compare Mode Register 1 */
    volatile uint8_t CCMR2;         /* Capture/Compare Mode Register 2 */
    volatile uint8_t CCMR3;         /* Capture/Compare Mode Register 3 */
    volatile uint8_t CCMR4;         /* Capture/Compare Mode Register 4 */
    volatile uint8_t CCER1;         /* Capture/Compare Enable Register 1 */
    volatile uint8_t CCER2;         /* Capture/Compare Enable Register 2 */
    volatile uint8_t CNTRH;         /* Counter High */
    volatile uint8_t CNTRL;         /* Counter Low */
    volatile uint8_t PSCRH;         /* Prescalar High */
    volatile uint8_t PSCRL;         /* Prescalar Low */
    volatile uint8_t ARRH;          /* Auto-Reload Register High */
    volatile uint8_t ARRL;          /* Auto-Reload Register Low */
    volatile uint8_t RCR;           /* Repetition Counter Register */
    volatile uint8_t CCR1H;         /* Capture/Compare Regiater 1 High */
    volatile uint8_t CCR1L;         /* Capture/Compare Regiater 1 Low */
    volatile uint8_t CCR2H;         /* Capture/Compare Regiater 2 High */
    volatile uint8_t CCR2L;         /* Capture/Compare Regiater 2 Low */
    volatile uint8_t CCR3H;         /* Capture/Compare Regiater 3 High */
    volatile uint8_t CCR3L;         /* Capture/Compare Regiater 3 Low */
    volatile uint8_t CCR4H;         /* Capture/Compare Regiater 4 High */
    volatile uint8_t CCR4L;         /* Capture/Compare Regiater 4 Low */
    volatile uint8_t BKR;           /* Break Register */
    volatile uint8_t DTR;           /* Deadtime Register */
    volatile uint8_t OISR;          /* Output Idle State Register */
} TIM1_Type;

/* 16-Bit General Purpose Timer (TIM2) */
typedef struct TIM2_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
             uint8_t reserved1;
             uint8_t reserved2;
    volatile uint8_t IER;           /* Interrupt Enable Register */
    volatile uint8_t SR1;           /* Status Register 1 */
    volatile uint8_t SR2;           /* Status Register 2 */
    volatile uint8_t EGR;           /* Event Generation Register */
    volatile uint8_t CCMR1;         /* Capture/Compare Mode Register 1 */
    volatile uint8_t CCMR2;         /* Capture/Compare Mode Register 2 */
    volatile uint8_t CCMR3;         /* Capture/Compare Mode Register 3 */
    volatile uint8_t CCER1;         /* Capture/Compare Enable Register 1 */
    volatile uint8_t CCER2;         /* Capture/Compare Enable Register 2 */
    volatile uint8_t CNTRH;         /* Counter High */
    volatile uint8_t CNTRL;         /* Counter Low */
    volatile uint8_t PSCR;          /* Prescalar Register */
    volatile uint8_t ARRH;          /* Auto-Reload Register High */
    volatile uint8_t ARRL;          /* Auto-Reload Register Low */
    volatile uint8_t CCR1H;         /* Capture/Compare Regiater 1 High */
    volatile uint8_t CCR1L;         /* Capture/Compare Regiater 1 Low */
    volatile uint8_t CCR2H;         /* Capture/Compare Regiater 2 High */
    volatile uint8_t CCR2L;         /* Capture/Compare Regiater 2 Low */
    volatile uint8_t CCR3H;         /* Capture/Compare Regiater 3 High */
    volatile uint8_t CCR3L;         /* Capture/Compare Regiater 3 Low */
} TIM2_Type;

/* 16-Bit General Purpose Timer (TIM4) */
typedef struct TIM4_Struct {
    volatile uint8_t CR1;           /* Control Register 1 */
             uint8_t reserved1;
             uint8_t reserved2;
    volatile uint8_t IER;           /* Interrupt Enable Register */
    volatile uint8_t SR;            /* Status Register */
    volatile uint8_t EGR;           /* Event Generation Register */
    volatile uint8_t CNTR;          /* Counter Register */
    volatile uint8_t PSCR;          /* Prescalar Register */
    volatile uint8_t ARR;           /* Auto-Reload Register */
} TIM4_Type;

/* Analog/Digital Converter (ADC) */
typedef struct ADCDB_Struct {
    volatile uint8_t RH;            /* Data Buffer Register High */
    volatile uint8_t RL;            /* Data Buffer Register Low */
} ADCDB_Type;

typedef struct ADC_Struct {
    volatile uint8_t CSR;           /* Control/Status Register */
    volatile uint8_t CR1;           /* Configuration Register 1 */
    volatile uint8_t CR2;           /* Configuration Register 2 */
    volatile uint8_t CR3;           /* Configuration Register 3 */
    volatile uint8_t DRH;           /* Data Register High */
    volatile uint8_t DRL;           /* Data Register Low */
    volatile uint8_t TDRH;          /* Schmitt Trigger Disable Register High */
    volatile uint8_t TDRL;          /* Schmitt Trigger Disable Register Low */
    volatile uint8_t HTRH;          /* High Threshold Register High */
    volatile uint8_t HTRL;          /* High Threshold Register Low */
    volatile uint8_t LTRH;          /* Low Threshold Register High */
    volatile uint8_t LTRL;          /* Low Threshold Register Low */
    volatile uint8_t AWSRH;         /* Watchdog Status Register High */
    volatile uint8_t AWSRL;         /* Watchdog Status Register Low */
    volatile uint8_t AWCHR;         /* Watchdog Control Register High */
    volatile uint8_t AWCRL;         /* Watchdog Control Register Low */
} ADC_Type;

/* Interrupt Controller (ITC) */
typedef struct ITC_Struct {
    volatile uint8_t SPR1;          /* Software Priority Register 1 */
    volatile uint8_t SPR2;          /* Software Priority Register 2 */
    volatile uint8_t SPR3;          /* Software Priority Register 3 */
    volatile uint8_t SPR4;          /* Software Priority Register 4 */
    volatile uint8_t SPR5;          /* Software Priority Register 5 */
    volatile uint8_t SPR6;          /* Software Priority Register 6 */
    volatile uint8_t SPR7;          /* Software Priority Register 7 */
    volatile uint8_t SPR8;          /* Software Priority Register 8 */
} ITC_Type;

/* Debug Module (DM) */
typedef struct DM_Struct {
    volatile uint8_t BK1RE;         /* Breakpoint 1 Register Extended Byte */
    volatile uint8_t BK1RH;         /* Breakpoint 1 Register High Byte */
    volatile uint8_t BK1RL;         /* Breakpoint 1 Register Low Byte */
    volatile uint8_t BK2RE;         /* Breakpoint 2 Register Extended Byte */
    volatile uint8_t BK2RH;         /* Breakpoint 2 Register High Byte */
    volatile uint8_t BK2RL;         /* Breakpoint 2 Register Low Byte */
    volatile uint8_t CR1;           /* Control Register 1 */
    volatile uint8_t CR2;           /* Control Register 2 */
    volatile uint8_t CSR1;          /* Control/Status Register 1 */
    volatile uint8_t CSR2;          /* Control/Status Register 2 */
    volatile uint8_t ENFCTR;        /* Enable Function Register */
} DM_Type;


/******************************************************************************/
/* Register Map */

#define GPIOA           (*((GPIO_Type*)0x5000))
#define GPIOB           (*((GPIO_Type*)0x5005))
#define GPIOC           (*((GPIO_Type*)0x500A))
#define GPIOD           (*((GPIO_Type*)0x500F))
#define GPIOE           (*((GPIO_Type*)0x5014))
#define GPIOF           (*((GPIO_Type*)0x5019))
#define GPIO            (&GPIOA)
#define FLASH           (*((FLASH_Type*)0x505A))
#define EXTI            (*((EXTI_Type*)0x5062))
#define RST             (*((volatile uint8_t*)0x50B3))
#define CLK             (*((CLK_Type*)0x50C0))
#define WWDG            (*((WWDG_Type*)0x50D1))
#define IWDG            (*((IWDG_Type*)0x50E0))
#define AWU             (*((AWU_Type*)0x50F0))
#define SPI             (*((SPI_Type*)0x5200))
#define I2C             (*((I2C_Type*)0x5210))
#define UART1           (*((UART1_Type*)0x5230))
#define TIM1            (*((TIM1_Type*)0x5250))
#define TIM2            (*((TIM2_Type*)0x5300))
#define TIM4            (*((TIM4_Type*)0x5340))
#define ADC1DB          (*((ADCDB_Type*)0x53E0))
#define ADC1            (*((ADC_Type*)0x53E0))
#define CFG_GCR         (*((volatile uint8_t*)0x7F60))
#define ITC             (*((ITC_Type*)0x7F70))
#define ITC_SPR         (*((volatile uint8_t*)0x7F70))
#define SWIM            (*((volatile uint8_t*)0x7F80))
#define DM              (*((DM_Type*)0x7F90))


#endif      /* _STM8S103_H */
