// Copyright 2018 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

//func kdsaSign(uint64, *byte) uint64
TEXT ·kdsaSign(SB), NOSPLIT|NOFRAME, $0-32
	MOVD fc+0(FP), R0    // function code
	MOVD block+8(FP), R1 // address parameter block

loop:
	WORD $0xB93A0008    // compute digital signature authentication
	BVS  loop           // branch back if interrupted
	BEQ  success        // signature creation successful
	BGT  retry          // signing unsuccessful, but retry with new rand num
error:
        MOVD $1, R2         // fallthrough indicates fatal error
        MOVD R2, ret+16(FP) // return 1 - signing was unsuccessful
        MOVD R2, ret+24(FP) // return 1 - there was a fatal error
	RET

retry:
	MOVD $1, R2	
        MOVD R2, ret+16(FP) // return 1 - signing was unsuccessful
	MOVD $2, R2
        MOVD R2, ret+24(FP) // return 2 - retry with a new randome number
	RET

success:
	MOVD $0, R2
	MOVD R2, ret+16(FP) // return 0 - signing was successful
	MOVD R2, ret+24(FP) // return 0 - no error condition arose
	RET
