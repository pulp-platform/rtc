/* ----------------------------------------------------------------------------
   -- RTC Peripheral Access Layer
   ---------------------------------------------------------------------------- */

/** RTC - Register Layout Typedef */
typedef struct {
  __IO  uint32_t DATE;                      /**< RTC Date register, offset: 0x00 */
  __IO  uint32_t CLOCK;                     /**< RTC Clock register, offset: 0x04 */
  __IO  uint32_t ALARM_DATE;                /**< RTC_Alarm date register, offset: 0x08 */
  __IO  uint32_t ALARM_CLOCK;               /**< RTC_Alarm clock register, offset: 0x0C */
  __IO  uint32_t TIMER;                     /**< RTC_Timer register, offset: 0x10 */
  __IO  uint32_t CALIBRE;                   /**< RTC_Clabire register, offset: 0x14 */
  __IO  uint32_t EVENT_FLAG;                /**< RTC_Event_Flag register, offset: 0x18 */
} RTC_Type;
/* Should date be separated ? */

/* ----------------------------------------------------------------------------
   -- RTC Register Masks
   ---------------------------------------------------------------------------- */

/*!
 * @addtogroup RTC_Register_Masks RTC Register Masks
 * @{
 */
/*! @name DATE - Date register */
#define RTC_DATE_DATA_MASK            (0xFFFFFFFF)
#define RTC_DATE_DATA_SHIFT           (0U)
#define RTC_DATE_DATA(x)              (((uint32_t)(((uint32_t)(x)) /* << RTC_DATE_DATA_SHIFT */)) & RTC_DATE_DATA_MASK)

/*! @name CLOCK - Clock calendar register */
#define RTC_CLOCK_DATA_MASK           (0x3FFFFF)
#define RTC_CLOCK_DATA_SHIFT          (0U)
#define RTC_CLOCK_DATA(x)             (((uint32_t)(((uint32_t)(x)) /* << RTC_CLOCK_DATA_SHIFT */)) & RTC_CLOCK_DATA_MASK)

/*
 *  10 bits MSB of 16 bits 32768 Hz RTC second counter, {INIT_SEC_CNT, 5'h0}.
 *  If set 0x200, means start from 0x4000 / 0x8000 = 0.5s
 */
#define RTC_CLOCK_INIT_SEC_CNT_MASK   (0xFFC00000)
#define RTC_CLOCK_INIT_SEC_CNT_SHIFT  (0U)
#define RTC_CLOCK_INIT_SEC_CNT(x)     (((uint32_t)(((uint32_t)(x)) << RTC_CLOCK_INIT_SEC_CNT_SHIFT)) & RTC_CLOCK_INIT_SEC_CNT_MASK)

/*! @name TIMER - Timer count down register */
#define RTC_TIMER_CMP_MASK            (0x1FFFF)
#define RTC_TIMER_CMP_SHIFT           (0U)
#define RTC_TIMER_CMP(x)              (((uint32_t)(((uint32_t)(x)) /* << RTC_TIMER_CMP_SHIFT */)) & RTC_TIMER_CMP_MASK)
#define RTC_TIMER_RETRIG_MASK         (0x40000000)
#define RTC_TIMER_RETRIG_SHIFT        (30U)
#define RTC_TIMER_RETRIG(x)           (((uint32_t)(((uint32_t)(x)) << RTC_TIMER_RETRIG_SHIFT)) & RTC_TIMER_RETRIG_MASK)
#define RTC_TIMER_EN_MASK             (0x80000000)
#define RTC_TIMER_EN_SHIFT            (31U)
#define RTC_TIMER_EN(x)               (((uint32_t)(((uint32_t)(x)) << RTC_TIMER_EN_SHIFT)) & RTC_TIMER_EN_MASK)

/*! @name ALARM_DATE - Date register */
#define RTC_ALARM_DATE_DATA_MASK      (0xFFFFFFFF)
#define RTC_ALARM_DATE_DATA_SHIFT     (0U)
#define RTC_ALARM_DATE_DATA(x)        (((uint32_t)(((uint32_t)(x)) /* << RTC_ALARM_DATE_DATA_SHIFT */)) & RTC_ALARM_DATE_DATA_MASK)

/*! @name ALARM_CLOCK - Timer count down register */
#define RTC_ALARM_CLOCK_DATA_MASK     (0x3FFFFF)
#define RTC_ALARM_CLOCK_DATA_SHIFT    (0U)
#define RTC_ALARM_CLOCK_DATA(x)       (((uint32_t)(((uint32_t)(x)) /* << RTC_ALARM_CLOCK_DATA_SHIFT */)) & RTC_ALARM_CLOCK_DATA_MASK)
/* MASK[5:0] for Y:M:D:h:m:s, (1 - always match; 0 - see real calendar) */
#define RTC_ALARM_CLOCK_MATCH_MASK_MASK     (0x3F000000)
#define RTC_ALARM_CLOCK_MATCH_MASK_SHIFT    (24U)
#define RTC_ALARM_CLOCK_MATCH_MASK(x)       (((uint32_t)(((uint32_t)(x)) << RTC_ALARM_CLOCK_MATCH_MASK_SHIFT)) & RTC_ALARM_CLOCK_MATCH_MASK_MASK)

#define RTC_ALARM_CLOCK_EN_MASK       (0x80000000)
#define RTC_ALARM_CLOCK_EN_SHIFT      (31U)
#define RTC_ALARM_CLOCK_EN(x)         (((uint32_t)(((uint32_t)(x)) << RTC_ALARM_CLOCK_EN_SHIFT)) & RTC_ALARM_CLOCK_EN_MASK)

/*! @name EVENT_FLAG - Timer and alarm event flag register */
#define RTC_EVENT_FLAG_ALARM_MASK     (0x1)
#define RTC_EVENT_FLAG_ALARM_SHIFT    (0U)
#define RTC_EVENT_FLAG_ALARM(x)       (((uint32_t)(((uint32_t)(x)) /* << RTC_EVENT_FLAG_ALARM_SHIFT */)) & RTC_EVENT_FLAG_ALARM_MASK)
#define RTC_EVENT_FLAG_TIMER_MASK     (0x2)
#define RTC_EVENT_FLAG_TIMER_SHIFT    (1U)
#define RTC_EVENT_FLAG_TIMER(x)       (((uint32_t)(((uint32_t)(x)) << RTC_EVENT_FLAG_TIMER_SHIFT)) & RTC_EVENT_FLAG_TIMER_MASK)

/*!
 * @}
 */ /* end of group RTC_Register_Masks */

/* RTC - Peripheral instance base addresses */
/** Peripheral RTC base address */
#define RTC_BASE                               (SOC_CTRL_BASE + 0x01D0u)
/** Peripheral RTC base pointer */
#define RTC                                    ((RTC_Type *)RTC_BASE)
/** Array initializer of RTC base addresses */
#define RTC_BASE_ADDRS                         { RTC_BASE }
/** Array initializer of RTC base pointers */
#define RTC_BASE_PTRS                          { RTC }







// For PULP-OS
#define APB_SOC_RTC_OFFSET                 0x1D0

#ifndef __ARCHI_RTC_H__
#define __ARCHI_RTC_H__

#define RTC_RTC_EVENT                      ARCHI_SOC_EVENT_RTC_IRQ

//  Address of RTC registers
#define RTC_DATE_OFFSET                    0x00
#define RTC_CLOCK_OFFSET                   0x04
#define RTC_ALARM_DATE_OFFSET              0x08
#define RTC_ALARM_CLOCK_OFFSET             0x0C
#define RTC_TIMER_OFFSET                   0x10
#define RTC_CALIBRE_OFFSET                 0x14
#define RTC_EVENT_FLAG_OFFSET              0x18

#define RTC_Irq_Alarm_Flag                 0x00
#define RTC_Irq_Timer_Flag                 0x01

#endif
