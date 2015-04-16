#ifndef QEUSHULLYOPERATIONS_H
#define QEUSHULLYOPERATIONS_H

#define SCRIPT_OP_EXIT          0x00000002
#define SCRIPT_OP_MOV           0x00000003  // (or CALL? or load_script?) 5
#define SCRIPT_OP_RETURN        0x00000005  // 0
#define SCRIPT_OP_ADD           0x00000050
#define SCRIPT_OP_SUB           0x00000051
#define SCRIPT_OP_SET_VAR       0x00000055
#define SCRIPT_OP_BIT_AND       0x00000056
#define SCRIPT_OP_CMP_EQ        0x0000005a
#define SCRIPT_OP_CMP_LT        0x0000005c
#define SCRIPT_OP_CMP_GTEQ      0x0000005f
#define SCRIPT_OP_SHOW_TEXT     0x0000006e
#define SCRIPT_OP_END_TEXT      0x0000006f
#define SCRIPT_OP_CLEAR_TEXT    0x00000071
#define SCRIPT_OP_WAIT_INPUT    0x00000072
#define SCRIPT_OP_UNK1          0x00000074
#define SCRIPT_OP_UNK2          0x0000007f
#define SCRIPT_OP_JUMP          0x0000008c
#define SCRIPT_OP_CALL          0x0000008f
#define SCRIPT_OP_JUMP_COND     0x000000a0
#define SCRIPT_OP_DIV           0x000000B4  // ?
#define SCRIPT_OP_COPY_STR      0x00000192  // or furigana output?
#define SCRIPT_OP_UNK3          0x000001a6
#define SCRIPT_OP_UNK4          0x000001f4
#define SCRIPT_OP_UNK5          0x000001f5
#define SCRIPT_OP_UNK6          0x0000021b
//#define SCRIPT_OP_  0x0000
//#define SCRIPT_OP_  0x0000
//#define SCRIPT_OP_  0x0000
//#define SCRIPT_OP_  0x0000

#endif // QEUSHULLYOPERATIONS_H
