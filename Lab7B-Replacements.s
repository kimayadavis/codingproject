        .syntax     unified
        .cpu        cortex-m4
        .text

        .set        BitBanding,1        // Comment out if not using bit-banding

// void PutBit(void *bits, uint32_t index, uint32_t bit) ;

        .global     PutBit
        .thumb_func
        .align

PutBit:

       .ifdef  BitBanding
        SUB     R0,R0,0x20000000 
        LSL     R0,R0,5             //GET BIT BAND REGION OFFSET
        ADD     R0,R0,R1,LSL 2 
        ADD     R0,R0,0x22000000
        STRB    R2,[R0]
        BX      LR
        .else
//nonbitbanding version 
        //get byte index
        PUSH    {R4-R8}
        LSR     R5,R1,3
        ADD     R3,R0,R5            //add offset to bit array addy
        AND     R4, R1,(1<<3)-1     //GET THE BIT INDEX 
        LSL     R7,R2,R4            //BIT IN THE RIGHT PLACE
        LDR     r8,=1               //setting up register for or
        LSL     R8,R8,R4            //SHIFT A 1 BY THE SAME AMOUNT
        LDRB    R6,[R3]            //load target byte 
        BIC     R6,R6,R8            //clear target byte
        ORR     R6,R6,R7              //set target byter
        STRB    R6,[R3]             //stire updated byte into address
        POP     {R4-R8}
        BX      LR
        .endif
  



// uint32_t GetBit(void *bits, uint32_t index) ;

        .global     GetBit
        .thumb_func
        .align

GetBit:
       .ifdef  BitBanding
        SUB     R0,R0,0x20000000
        LSL     R0,R0,5               //GET BITBAND REGION OFFSET
        ADD     R0,R0,R1,LSL 2
        ADD     R0,R0,0x22000000
        LDR     R2,[R0]
        MOV     R0,R2                 //store and move to return
        BX      LR
        .else
        PUSH    {R4-R8}
        LSR     R5,R1,3
        ADD     R3,R0,R5            
        AND     R4, R1,(1<<3)-1     //GET THE BIT INDEX 
        LDRB    R6,[R3]             // HAVE THE byte
        LSR     R6,R6,R4            //HAVE IT VERY RIGHT      
        AND     R0,R6,1             //and it n storee
        POP     {R4-R8}
        BX      LR
        .endif


     .end
