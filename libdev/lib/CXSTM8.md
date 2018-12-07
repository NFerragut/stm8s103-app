# STM8 Machine Library

The STM8 Machine Library is part of the Cosmic compiler and tools. The following table is a more compact version of the Cosmic documentation. For more details refer to the Cosmic documentation.

## Overview

| Function | Description | Inputs | Result |
| :--: | :-- | :-- | :-- |
| c_bitfw | Update masked bits of word with value | Y = word address<br/>c_x.w = mask<br/>A:XL = value | (Y).w = ((((Y).w XOR A:XL)<br/>AND c_x.w) XOR (Y).w) |
| c_bitfwl | Update masked bits of 2nd word with value | Y = word address<br/>c_x.w = mask<br/>A:XL = value | Y[1].w = (((Y[1].w XOR<br/>A:XL) AND c_x.w) XOR Y[1].w) |
| c_cmulx | Multiply | X = word<br/>A = byte | c_lreg = X * A |
| c_cmuly | Multiply | Y = word<br/>A = byte | c_lreg = Y * A |
| c_ctof | Convert byte to float | A = byte | c_lreg.f = (float)A |
| c_eewbf | Eeprom char bit field update | c_x.w = *eeprom* address<br/>A = mask<br/>XL = value | (c_x.w) &= ~A<br/> (c_x.w) \|= A & XL<br/>wait for *eeprom* write |
| c_eewrc | Write a char in *eeprom* | X = *eeprom* address<br/>A = value | if (X) == A return<br/>(X) = A<br/>wait for *eeprom* write |
| c_eewrl | Write a long int in *eeprom* | X = *eeprom* address<br/>c_lreg = value | for (byte 1..4)<br/>call c_eewrc |
| c_eewrw | Write a short int in *eeprom* | X = *eeprom* address<br/>sp1.w = value | for (byte 1..2)<br/>call c_eewrc |
| c_eewstr | Move a structure in *eeprom* | Y = source address<br/>X = *eeprom* address<br/>A = size | for (1..A)<br/>call c_eewrc |
| c_eewstrl | Move a structure in *eeprom* | Y = source address<br/>c_x = *eeprom* address<br/>X = size | for (1..X)<br/>call c_eewrc |
| c_fadd | Add float to float | c_lreg = float1<br/>X = float2 address | c_lreg.f = c_lreg.f * (X).f |
| c_fcmp | Compare floats | c_lreg = float1<br/>X = float2 address | compare(c_lreg.f, (X).f)<br/>result in CC |
| c_fdiv | Divide float by float | c_lreg = float1<br/>X = float2 address | c_lreg.f = c_lreg.f / (X).f |
| c_fgadd | Add float to float in memory | X = float1 address<br/>c_lreg = float2 | (X).f = (X).f + c_lreg.f |
| c_fgmul | Multiply float by float in memory | X = float1 address<br/>c_lreg = float2 | (X).f = (X).f * c_lreg.f |
| c_fgsub | Subtract float from float in memory | X = float1 address<br/>c_lreg = float2 | (X).f = (X).f - c_lreg.f |
| c_fmul | Multiply float by float | c_lreg = float1<br/>X = float2 address | c_lreg.f = c_lreg.f * (X).f |
| c_fneg | Negate a float | c_lreg = float | c_lreg.f = -c_lreg.f |
| c_fsub | Subtract float from float | c_lreg = float1<br/>X = float2 address | c_lreg.f = c_lreg.f = (X).f |
| c_ftoi | Convert float to integer | c_lreg = float | X = (int)c_lreg.f |
| c_ftol | Convert float into long integer | c_lreg = float | c_lreg = (long)c_lreg.f |
| c_fzmp | Compare a float in memory to zero | X = float address | compare((X).f,0)<br/>result in CC |
| c_getlx | Get a long word from memory | X = long address | c_lreg = (X) |
| c_getly | Get a long word from memory | Y = long address | c_lreg = (Y) |
| c_getwfx | Get a word from far memory | c_x:X = long address | A:XL = (c_x:X) |
| c_getwfy | Get a word from far memory | c_y:Y = long address | A:XL = (c_y:Y) |
| c_getxfx | Get a word from far memory | c_x:X = long address | X = (c_x:X) |
| c_getxfy | Get a word from far memory | c_y:Y = long address | X = (c_y:Y) |
| c_getyfx | Get a word from far memory | c_x:X = long address | Y = (c_x:X) |
| c_getyfy | Get a word from far memory | c_y:Y = long address | Y = (c_y:Y) |
| c_idiv | Quotient of integer division | Y = divisor<br/>X = dividend | if (X != 0)<br/>X = Y / X |
| c_imul | Integer multiplication | X = integer1<br/>Y = integer2 | X = X * Y |
| c_itof | Convert integer into float | X = integer | c_lreg.f = X |
| c_itol | Convert integer into long | A:XL = long address | c_lreg = (A:XL) |
| c_itolx | Convert integer into long | X = integer | c_lreg.l = X |
| c_itoly | Convert integer into long | Y = integer | c_lreg.l = Y |
| c_jctab | Perform C switch statement on char | A = switch value<br/>address table<sup>1</sup> after call | jump to code<br/>no return |
| c_jltab | Perform C switch statement on long | c_lreg = switch value<br/>X = address table address<sup>2</sup> | jump to code<br/>no return |
| c_jstab | Perform C switch statement on integer | X = switch value<br/>address table<sup>1</sup> after call | jump to code<br/>no return |
| c_ladc | Long integer addition | c_lreg = long<br/>A = unsigned value | c_lreg = c_lreg + A.b |
| c_ladd | Long integer addition | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg + (X).l |
| c_land | Bitwise AND for long integers | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg AND (X).l |
| c_lcmp | Long unsigned integer compare | c_lreg = long1<br/>X = long2 address | compare(c_lreg, (X).l)<br/>result in CC |
| c_ldiv | Quotient of long integer division | c_lreg = long1<br/>X = long2 address | if ((X).l != 0)<br/>c_lreg = c_lreg / (X).l |
| c_lgadc | Long addition | X = long address<br/>A = unsigned value | (X).l = (X).l + A.b |
| c_lgadd | Long addition | X = long1 address<br/>c_lreg = long2 | (X).l = (X).l + c_lreg |
| c_lgand | Long bitwise AND | X = long1 address<br/>c_lreg = long1 | (X).l = (X).l AND c_lreg |
| c_lglsh | Long shift left | X = long address<br/>A = bit count | (X).l = (X).l << A |
| c_lgmul | Long multiplication in memory | X = long1 address<br/>c_lreg = long2 | (X).l = (X).l * c_lreg |
| c_lgneg | Negate a long integer in memory | X = long address | (X).l = -(X).l |
| c_lgor | Long bitwise OR | X = long1 address<br/>c_lreg = long2 | (X).l = (X).l OR c_lreg |
| c_lgrsh | Signed long shift right | X = long address<br/>A = bit count | (X).l = (X).l >> A |
| c_lgsbc | Long subtraction | X = long1 address<br/>A = unsigned value | (X).l = (X).l - A.b |
| c_lgsub | Long subtraction | X = long1 address<br/>c_lreg = long2 | (X).l = (X).l - c_lreg |
| c_lgursh | Unsigned long shift right | X = unsigned long address<br/>A = bit count | (X).l = (X).l >> A |
| c_lgxor | Long bitwise exclusive OR | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg OR (X).l |
| c_llsh | Long integer shift left | c_lreg = long<br/>A = bit count | c_lreg = c_lreg << A |
| c_lmod | Remainder of long integer division | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg % (X).l |
| c_lmul | Multiply long integer by long integer | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg * (X).l |
| c_lneg | Negate a long integer | c_lreg = long | c_lreg = -c_lreg |
| c_lor | Bitwise OR with long integers | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg OR (X).l |
| c_lrsh | Long integer right shift | c_lreg = long<br/>A = signed bit count | c_lreg = c_lreg >> A |
| c_lrzmp | Long test against zero | c_lreg = long | compare(c_lreg, 0)<br/>result in CC |
| c_lsbc | Long integer subtraction | c_lreg = long<br/>A = unsigned byte | c_lreg = c_lreg - A |
| c_lsub | Long integer subtraction | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg - (X).l |
| c_lsmp | Long signed integer compare with overflow | c_lreg = long1<br/>X = long2 address | compare(c_lreg, (X).l)<br/>result in CC |
| c_ltof | Convert long integer into float | c_lreg = long | c_lreg = (float)c_lreg.l |
| c_ltor | Load memory into long register | c_lreg = long1<br/>X = long2 address | c_lreg = (X).l |
| c_ludv | Quotient of unsigned long integer division | c_lreg = unsigned long1<br/>X = unsigned long2 address | if ((X).l != 0)<br/>c_lreg = c_lreg / (X).l |
| c_lumd | Remainder of unsigned long integer division | c_lreg = unsigned long1<br/>X = unsigned long2 address | if ((X).l != 0)<br/>c_lreg = c_lreg % (X).l |
| c_lursh | Unsigned long integer shift right | c_lreg = unsigned long<br/>A = bit count | c_lreg = c_lreg >> A |
| c_lxor | Bitwise exclusive OR with long integers | c_lreg = long1<br/>X = long2 address | c_lreg = c_lreg XOR (X).l |
| c_lzmp | Compare a long integer to zero | X = long address | compare((X).l, 0)<br/>result in CC |
| c_pgadc | Far pointer addition | X = far pointer address<br/>A = unsigned byte | (X).3 = (X).3 + A |
| c_pgadd | Far pointer addition | X = far pointer address<br/>c_lreg = long | (X).3 = (X).3 + c_lreg |
| c_putlx | Put a long integer in memory | X = long address<br/>c_lreg = long | (X).l = c_lreg |
| c_putly | Put a long integer in memory | Y = long address<br/>c_lreg = long | (Y).l = c_lreg |
| c_putwf | Put a word in far memory | c_y:Y = word far address<br/>A:XL = word | (c_y:Y).w = A:XL |
| c_pxtox | Get a far pointer from far memory | c_x:X = far pointer address | c_x:X = (c_x:X).3 |
| c_pxtoy | Get a far pointer from far memory | c_x:X = far pointer address | c_y:Y = (c_x:X).3 |
| c_pytox | Get a far pointer from far memory | c_y:Y = far pointer address | c_x:X = (c_y:Y).3 |
| c_pytoy | Get a far pointer from far memory | c_y:Y = far pointer address | c_y:Y = (c_y:Y).3 |
| c_rtofl | Store long register in far memory | c_x:X = long far address<br/>c_lreg = long | (c_x:X).l = c_lreg |
| c_rtol | Store long register in memory | X = long address<br/>c_lreg = long | (X).l = c_lreg |
| c_sdivx | Quotient of signed char division | X = signed dividend<br/>A = signed divisor | if (A != 0)<br/>X = X / A |
| c_sdivy | Quotient of signed char division | Y = signed dividend<br/>A = signed divisor | if (A != 0)<br/>Y = Y / A |
| c_smodx | Remainder of signed char division | X = signed dividend<br/>A = signed divisor | if (A != 0)<br/>X = X % A |
| c_smody | Remainder of signed char division | Y = signed dividend<br/>A = signed divisor | if (A != 0)<br/>Y = Y % A |
| c_smul | Multiply long integer by unsigned byte | c_lreg = long<br/>A = unsigned byte | c_lreg = c_lreg * A |
| c_uitof | Convert unsigned integer into float | X = unsigned word | c_lreg.f = X.w |
| c_uitol | Convert unsigned integer into long | A:XL = unsigned word | c_lreg = A:XL |
| c_uitolx | Convert unsigned integer into long | X = unsigned word | c_lreg = X |
| c_uitoly | Convert unsigned integer into long | Y = unsigned word | c_lreg = Y |
| c_ultof | Convert unsigned long integer into float | c_lreg = unsigned long | c_lreg.f = c_lreg |
| c_umul | Multiply unsigned integers with long result | X = unsigned integer1<br/>Y = unsigned integer2 | c_lreg = X * Y |
| c_vmul | Multiply signed integers with long result | X = signed integer1<br/>Y = signed integer2 | c_lreg = X * Y |
| c_xtopy | Store a far pointer into far memory | c_y:Y = far pointer address<br/>c_x:X = far pointer | (c_y:Y) = c_x:X |
| c_xymvf | Copy a structure in far memory | c_y:Y = array1 far address<br/>c_x:X = array2 far address<br/>A = array size | for (1..A)<br/>c_x:X[i] = c_y:Y[i] |
| c_xymvfl | Copy a large structure in far memory | c_y:Y = array1 far address<br/>c_x = array2 address<br/>X = array size | for (1..X)<br/>c_x[i] = c_y:Y[i] |
| c_xymvx<br/>(c_xymov) | Copy a structure into another | Y = array1 address<br/>X = array2 address<br/>A = array size | for (1..A)<br/>X[i] = Y[i] |
| c_xymvxl | Copy a large structure into another | Y = array1 address<br/>c_x = array2 address<br/>X = array size | for (1..X)<br/>c_x[i] = Y[i] |
| c_ytopx | Store a far pointer into far memory | c_y:Y = far pointer<br/>c_x:X = far pointer address | (c_x:X).3 = c_y:Y |
| c_yxmvf | Copy a structure in far memory | c_x:X = array1 far address<br/>c_y:Y = array2 far address<br/>A = array size | for (1..A)<br/>c_y:Y[i] = c_x:X[i] |
| c_yxmvfl | Copy a large structure in far memory | c_x = array1 far address<br/>c_y:Y = array2 address<br/>X = array size | for (1..X)<br/>c_y:Y[i] = c_x[i] |
| c_yxmvx<br/>(c_yxmov) | Copy a structure into another | X = array1 address<br/>Y = array2 address<br/>A = array size | for (1..A)<br/>Y[i] = X[i] | 
| c_yxmvxl | Copy a large structure into another | c_x = array1 address<br/>Y = array2 address<br/>X = array size | for (1..X)<br/>Y[i] = c_x[i] |

<sup>1</sup> The address table is a list of 2-byte signed offsets.  
<sup>2</sup> The address table contains the following: 1) a size count, 2) pairs of 4-byte values and 2-byte addresses, and 3) a 2-byte default address.  
