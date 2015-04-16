#include "qeushullyscript.h"
#include "qeushullybin.h"
#include "qeushullyvariables.h"
#include "qeushullygame.h"

extern QEushullyGame eushully_game;

QEushullyScript::QEushullyScript(QObject *parent) :
    QObject(parent)
{
    this->m_debug = eushully_game.get_debug();
}

QString QEushullyScript::parse_param(quint32 type, quint32 value, bool isAddr)
{
    QString res = "";
    QString val = ((isAddr) ? "<a href=\"#" + QString::number(value, 16) + "\">" : "") +
            QString::number(value, 16) + ((isAddr) ? "</a>" : "");
    switch (type)
    {
    case SCRIPT_FIELD_VALUE:
        res = " VAL(" + val + ")";
        break;
    case SCRIPT_FIELD_TEXT:
        res = " TEXT(" + val + ")";
        break;
    case SCRIPT_FIELD_VAR_NUM:
        res = " VAR(" + val + ")";
        break;
    case SCRIPT_FIELD_VAR_TEXT:
        res = " VAR_TEXT(" + val + ")";
        break;
    default:
        res = " " + QString::number(type, 16) +"(" + val + ")";
        break;
    }
    return res;
}

quint32 QEushullyScript::parse_cmd(quint32 addr, bool execute)
{
    this->m_debug_msg = "";

    switch (this->m_script.at(addr))
    {
    case 0x00000001:
        return 0;

    case 0x00000002:
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] RETN (?);";
        if (execute)
        {
            //this->m_addr = eushully_game.stack_pop() + 1;
        }
        return 0;

    case 0x00000003:
        if (this->m_script.at(addr+1) == 0)
            return 2;
        else if (this->m_script.at(addr+1) == 0xc)
            return 2;
        else
            return 0;

    case SCRIPT_OP_RETURN:
        //opcode = "RETURN";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] RETURN;";
        if (execute)
        {
            this->m_addr = eushully_game.stack_pop() + 3;
        }
        return 0;

    case 0x00000008:
        return 2;

    case 0x00000009:
        return 5;

    case 0x0000000a:
        return 6;

    case 0x0000000c:
        return 6;

    case 0x0000001e:
        return 4;

    case 0x00000023:
        return 4;

    case 0x00000025:
        return 6;

    case 0x00000026:
        return 8;

    case 0x00000028:
        return 3;

    case 0x0000002b:
        return 6;

    case 0x0000002d:
        return 4;

    case 0x00000030:
        return 0;

    case 0x00000032:
        if (this->m_script.at(addr+1) == 9)
            return 6;
        else if (this->m_script.at(addr+1) == 0)
            return 20;
        else
            return 4;

    case 0x00000036:
        return 6;

    case 0x0000003c:
        return 4;

    case 0x0000004b:
        return 4;

    case SCRIPT_OP_ADD:
        //opcode = "ADD";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] ADD";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        if (execute)
        {
        }
        return 6;

    case SCRIPT_OP_SUB:
        //opcode = "SUB";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] SUB";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 6;

    case 0x00000052:
        return 6;

    case 0x00000053:
        return 6;

    case 0x00000054:
        return 6;

    case SCRIPT_OP_SET_VAR:
        //opcode = "SET_VAR";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] SET_VAR";
        for (int j=0 ; j<2 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        if (execute)
        {
            eushully_game.getVars()->set_value(this->m_script.at(addr + 2),
                                               this->m_script.at(addr + 3),
                                               this->m_script.at(addr + 4));
        }
        return 4;

    case SCRIPT_OP_BIT_AND:
        //opcode = "BIT_AND";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] BIT_AND";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 6;

    case 0x00000057:
        return 6;

    case 0x00000058:
        return 6;

    case 0x00000059:
        return 6;

    case SCRIPT_OP_CMP_EQ:
        //opcode = "CMP_EQ";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] CMP_EQ";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 6;

    case 0x0000005b:
        return 0;

    case SCRIPT_OP_CMP_LT:
        //opcode = "CMP_LT";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] CMP_LT";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 6;

    case 0x0000005d:
        return 6;

    case 0x0000005e:
        return 6;

    case SCRIPT_OP_CMP_GTEQ:
        //opcode = "CMP_GTEQ";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] CMP_GTEQ";
        for (int j=0 ; j<3 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 6;

    case 0x00000060:
        return 4;

    case 0x00000061:
        return 6;

    case 0x00000063:
        return 4;

    case 0x00000064:
        return 4;

    case 0x00000067:
        return 0;

    case 0x0000006c:
        return 4;

    case SCRIPT_OP_SHOW_TEXT:
        //opcode = "SHOW_TEXT";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] SHOW_TEXT";
        for (int j=0 ; j<2 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 4;

    case SCRIPT_OP_END_TEXT:
        //opcode = "END_TEXT";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] END_TEXT" +
                this->parse_param(this->m_script.at(addr + 1),
                                  this->m_script.at(addr + 2));
        return 2;

    case 0x00000070:
        return 10;

    case SCRIPT_OP_CLEAR_TEXT:
        //opcode = "CLEAR_TEXT";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] CLEAR_TEXT" +
                this->parse_param(this->m_script.at(addr + 1),
                                  this->m_script.at(addr + 2));
        return 2;

    case SCRIPT_OP_WAIT_INPUT:
        //opcode = "WAIT_INPUT";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] WAIT_INPUT" +
                this->parse_param(this->m_script.at(addr + 1),
                                  this->m_script.at(addr + 2));
        return 2;

    case 0x00000073:
        return 20;

    case 0x00000074:
        return 2;

    case 0x00000075:
        return 2;

    case 0x00000076:
        return 5;

    case 0x00000077:
        return 2;

    case 0x00000078:
        return 2;

    case 0x00000079:
        return 6;

    case 0x0000007a:
        return 6;

    case 0x0000007b:
        return 4;

    case 0x0000007c:
        return 0;

    case 0x0000007f:
        return 1;

    case 0x00000082:
        return 10;

    case 0x00000083:
        return 6;

    case 0x00000085:
        return 0;

    case 0x00000086:
        return 2;

    case 0x00000087:
        return 0;

    case 0x00000088:
        return 2;

    case 0x0000008c:
        return 2;

    case SCRIPT_OP_CALL:
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] CALL" +
                this->parse_param(this->m_script.at(addr + 1),
                                  this->m_script.at(addr + 2), true);
        if (execute)
        {
            eushully_game.stack_push(this->m_addr);
            this->m_addr = this->m_script.at(addr + 2);
            return -1;
        }
        return 2;

    case 0x00000090:
        return 14;

    case 0x00000093:
        return 0;

    case 0x00000094:
        return 0;

    case 0x00000096:
        return 6;

    case 0x00000097:
        return 10;

    case SCRIPT_OP_JUMP_COND:
        //opcode = "JUMP_COND";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] JUMP_COND";
        for (int j=0 ; j<2 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        this->m_debug_msg += this->parse_param(this->m_script.at(addr + 5),
                                               this->m_script.at(addr + 6), true);
        return 6;

    case 0x000000a1:
        return 0;

    case 0x000000a2:
        return 4;

    case 0x000000a3:
        return 4;

    case 0x000000ae:
        return 0;

    case 0x000000b4:
        return 4;

    case 0x000000b5:
        return 2;

    case 0x000000b6:
        return 2;

    case 0x000000b7:
        return 2;

    case 0x000000b8:
        return 0;

    case 0x000000b9:
        return 2;

    case 0x000000ba:
        return 2;

    case 0x000000bf:
        return 2;

    case 0x000000c0:
        return 2;

    case 0x000000c1:
        return 0;

    case 0x000000c2:
        return 4;

    case 0x000000c3:
        return 2;

    case 0x000000c4:
        return 2;

    case 0x000000c5:
        return 4;

    case 0x000000c6:
        return 4;

    case 0x000000c7:
        return 4;

    case 0x000000c8:
        if (this->m_script.at(addr+1) == 0)
            return 2;
        else
            return 0;

    case 0x000000cc:
        return 4;

    case 0x000000cd:
        return 0;

    case 0x000000d3:
        return 0;

    case 0x000000d4:
        return 8;

    case 0x000000d5:
        return 2;

    case 0x000000d9:
        return 0;

    case 0x000000fa:
        return 0;

    case 0x000000fb:
        return 4;

    case 0x000000fe:
        return 2;

    case 0x000000ff:
        return 2;

    case 0x00000101:
        return 0;

    case 0x00000105:
        return 4;

    case 0x00000107:
        return 4;

    case 0x00000108:
        return 2;

    case 0x00000109:
        return 4;

    case 0x0000010a:
        return 4;

    case 0x0000010b:
        return 28;

    case 0x0000010c:
        return 4;

    case 0x0000010d:
        return 2;

    case 0x0000010e:
        return 4;

    case 0x0000012c:
        if (this->m_script.at(addr+1) == 0)
            return 4;
        else
            return 10;

    case 0x0000012e:
        return 16;

    case 0x0000012f:
        return 8;

    case 0x00000130:
        return 2;

    case 0x00000131:
        return 2;

    case 0x00000132:
        return 2;

    case 0x00000133:
        return 2;

    case 0x00000134:
        return 6;

    case 0x00000135:
        return 4;

    case 0x00000136:
        return 4;

    case 0x0000013f:
        return 6;

    case 0x00000140:
        return 8;

    case 0x00000141:
        return 2;

    case 0x00000142:
        return 8;

    case 0x00000144:
        return 4;

    case 0x00000147:
        return 12;

    case 0x00000149:
        return 2;

    case 0x00000190:
        return 6;

    case 0x00000191:
        return 4;

    case SCRIPT_OP_COPY_STR:
        //opcode = "COPY_STR";
        this->m_debug_msg = "[0x" + QString::number(addr, 16) + "] COPY_STR";
        for (int j=0 ; j<2 ; j++)
            this->m_debug_msg += this->parse_param(this->m_script.at(addr + 1 + j*2),
                                                   this->m_script.at(addr + 2 + j*2));
        return 4;

    case 0x00000193:
        return 6;

    case 0x00000194:
        return 6;

    case 0x00000195:
        return 6;

    case 0x00000196:
        return 6;

    case 0x00000197:
        return 8;

    case 0x00000198:
        return 6;

    case 0x00000199:
        return 0;

    case 0x0000019a:
        return 5;

    case 0x0000019b:
        return 0;

    case 0x0000019c:
        return 0;

    case 0x0000019d:
        return 4;

    case 0x0000019e:
        return 4;

    case 0x000001a0:
        return 18;

    case 0x000001a1:
        return 5;

    case 0x000001a2:
        return 2;

    case 0x000001a3:
        return 2;

    case 0x000001a4:
        return 4;

    case 0x000001a5:
        return 2;

    case 0x000001a6:
        return 4;

    case 0x000001a7:
        return 2;

    case 0x000001a8:
        return 0;

    case 0x000001a9:
        return 2;

    case 0x000001aa:
        return 2;

    case 0x000001ab:
        return 4;

    case 0x000001ac:
        return 6;

    case 0x000001ad:
        return 0;

    case 0x000001ae:
        return 6;

    case 0x000001af:
        return 6;

    case 0x000001b0:
        return 6;

    case 0x000001b1:
        return 2;

    case 0x000001b2:
        return 2;

    case 0x000001b3:
        return 6;

    case 0x000001b4:
        return 2;

    case 0x000001b5:
        return 2;

    case 0x000001b6:
        return 2;

    case 0x000001b7:
        return 2;

    case 0x000001b8:
        return 4;

    case 0x000001b9:
        return 4;

    case 0x000001ba:
        return 4;

    case 0x000001bb:
        return 2;

    case 0x000001bc:
        return 0;

    case 0x000001bf:
        return 0;

    case 0x000001c1:
        return 6;

    case 0x000001c2:
        return 4;

    case 0x000001c4:
        return 2;

    case 0x000001c7:
        return 5;

    case 0x000001c8:
        return 4;

    case 0x000001ca:
        return 2;

    case 0x000001cb:
        return 12;

    case 0x000001cd:
        return 4;

    case 0x000001ce:
        return 2;

    case 0x000001cf:
        return 2;

    case 0x000001d0:
        return 6;

    case 0x000001d1:
        return 10;

    case 0x000001d2:
        return 9;

    case 0x000001d3:
        return 10;

    case 0x000001d5:
        return 0;

    case 0x000001f4:
        return 0;

    case 0x000001f5:
        return 0;

    case 0x000001f6:
        return 0;

    case 0x000001f7:
        return 4;

    case 0x000001f8:
        return 8;

    case 0x000001f9:
        return 6;

    case 0x000001fa:
        return 2;

    case 0x000001fb:
        return 16;

    case 0x000001fd:
        return 8;

    case 0x000001fe:
        return 10;

    case 0x000001ff:
        return 8;

    case 0x00000202:
        return 10;

    case 0x00000203:
        return 8;

    case 0x00000204:
        return 8;

    case 0x00000205:
        return 12;

    case 0x00000208:
        return 6;

    case 0x0000020b:
        return 14;

    case 0x0000020c:
        return 0;

    case 0x0000020d:
        return 2;

    case 0x0000020e:
        return 0;

    case 0x0000020f:
        return 6;

    case 0x00000212:
        return 4;

    case 0x00000213:
        return 6;

    case 0x00000214:
        return 4;

    case 0x00000215:
        return 4;

    case 0x00000216:
        return 4;

    case 0x00000217:
        return 8;

    case 0x00000218:
        return 8;

    case 0x00000219:
        return 8;

    case 0x0000021a:
        return 8;

    case 0x0000021b:
        return 2;

    case 0x0000021c:
        return 0;

    case 0x0000021d:
        return 4;

    case 0x0000021e:
        return 12;

    case 0x0000021f:
        return 14;

    case 0x00000220:
        return 12;

    case 0x00000222:
        return 4;

    case 0x00000223:
        return 16;

    case 0x00000224:
        return 0;

    case 0x00000228:
        return 10;

    case 0x00000229:
        return 10;

    case 0x0000022c:
        return 6;

    case 0x0000022f:
        return 10;

    case 0x00000230:
        return 2;

    case 0x00000231:
        return 8;

    case 0x00000232:
        return 8;

    case 0x00000233:
        return 4;

    case 0x00000234:
        return 10;

    case 0x00000235:
        return 10;

    case 0x00000236:
        return 8;

    case 0x00000238:
        return 2;

    case 0x00000239:
        return 12;

    case 0x0000023b:
        return 14;

    case 0x0000023c:
        return 0;

    case 0x0000023d:
        return 0;

    case 0x0000023f:
        return 4;

    case 0x00000242:
        return 4;

    case 0x00000243:
        return 0;

    case 0x00000244:
        return 0;

    case 0x0000024d:
        return 24;

    case 0x0000024e:
        return 2;

    case 0x0000024f:
        return 20;

    case 0x00000250:
        return 20;

    case 0x00000251:
        return 17;

    case 0x00000252:
        return 2;

    case 0x00000256:
        return 10;

    case 0x00000258:
        if (this->m_script.at(addr+1) == 9)
            return 6;
        else
            return 4;

    case 0x00000259:
        return 0;

    case 0x0000025c:
        return 16;

    case 0x0000025d:
        return 6;

    case 0x0000025e:
        return 10;

    case 0x0000025f:
        return 8;

    case 0x00000260:
        return 8;

    case 0x00000261:
        return 2;

    case 0x00000273:
        return 0;

    case 0x00000275:
        return 0;

    case 0x0000027f:
        return 4;

    case 0x0000028c:
        return 3;

    case 0x000002bc:
        return 6;

    case 0x000002bd:
        return 2;

    case 0x000002bf:
        return 6;

    case 0x000002c5:
        return 4;

    case 0x000002c7:
        return 8;

    case 0x000002ce:
        return 2;

    case 0x000002cf:
        return 2;

    case 0x000002d0:
        return 6;

    case 0x000002d1:
        return 6;

    case 0x000002d2:
        return 6;

    case 0x000002d3:
        return 6;

    case 0x000002d5:
        return 4;

    case 0x000002d7:
        return 6;

    case 0x000002d8:
        return 6;

    case 0x000002da:
        return 16;

    case 0x000002db:
        return 2;

    case 0x000002dd:
        return 4;

    case 0x000002de:
        return 4;

    case 0x000002df:
        return 6;

    case 0x000002e0:
        return 6;

    case 0x000002e1:
        return 6;

    case 0x000002e2:
        return 6;

    case 0x000002e3:
        return 6;

    case 0x000002e4:
        return 6;

    case 0x000002e5:
        return 2;

    case 0x000002e6:
        return 6;

    case 0x000002e7:
        return 4;

    case 0x000002e8:
        return 2;

    case 0x000002e9:
        return 2;

    case 0x000002ea:
        return 2;

    case 0x000002eb:
        return 24;

    case 0x000002ec:
        return 4;

    case 0x000002ee:
        return 4;

    case 0x000002ef:
        return 22;

    case 0x000002f0:
        return 18;

    case 0x000002f1:
        return 14;

    case 0x000002f2:
        return 12;

    case 0x000002fb:
        return 6;

    case 0x00000320:
        if (this->m_script.at(addr+1) == 0)
            return 20;
        else if (this->m_script.at(addr+1) == 9)
            return 20;
        else
            return 4;

    case 0x00000322:
        return 8;

    case 0x00000323:
        return 10;

    case 0x00000324:
        return 0;

    case 0x00000325:
        return 6;

    case 0x00000328:
        return 6;

    case 0x00000329:
        return 9;

    case 0x0000032b:
        return 4;

    case 0x0000032c:
        return 12;

    case 0x0000032d:
        return 4;

    case 0x0000032e:
        return 22;

    case 0x0000032f:
        return 29;

    case 0x00000332:
        return 5;

    case 0x00000334:
        return 2;

    case 0x00000335:
        return 8;

    case 0x00000337:
        return 8;

    case 0x0000033b:
        return 8;

    case 0x0000033e:
        return 10;

    case 0x0000033f:
        return 6;

    case 0x000003e8:
        return 4;

    case 0x000004b0:
        return 4;

    case 0x00000579:
        return 1;

    case 0x000005dc:
        return 4;

    case 0x00000708:
        if (this->m_script.at(addr+1) == 0)
            return 6;
        else
            return 4;

    case 0x00000756:
        return 1;

    case 0x000007b6:
        return 1;

    case 0x000007d0:
        return 4;

    case 0x000009cd:
        return 8;

    case 0x000009d1:
        return 8;

    case 0x00000acd:
        return 0;

    case 0x00000b42:
        return 0;

    case 0x00000c5a:
        return 0;

    case 0x00000f59:
        return 0;

    }
    return -2;
}

void QEushullyScript::parse(QList<quint32> &raw)
{
    this->m_addr = 0;
    this->m_parse_result.clear();
    int i = 0;
    this->m_script = raw.mid(0);
    while (i < raw.count())
    {
        QString str = "<a name=\"" + QString::number(i, 16) + "\" />";

        qint32 args_count = this->parse_cmd(i);
        if (args_count == -2)
        {
            this->m_parse_result.append(str + "Unknown CMD: 0x" +
                                        QString::number(raw.at(i), 16));
        }
        else
        {
            if (this->m_debug_msg.length() == 0)
            {
                str += "[0x" + QString::number(i, 16) + "] " +
                        "0x" + QString::number(raw.at(i), 16) + " ";
                if (i + args_count < raw.count())
                    for (int j=0 ; j<args_count ; j++)
                        str += "0x" + QString::number(raw.at(i + j + 1), 16) + " ";
                this->m_parse_result.append(str);
            }
            else
            {
                this->m_parse_result.append(str + this->m_debug_msg);
            }
            i += args_count;
        }

        i++;

    }
    this->m_addr = 0;
}

QString QEushullyScript::getParseResult()
{
    return this->m_parse_result.join("<br/>");
}

quint32 QEushullyScript::run()
{
    //this->parse_cmd(this->m_addr, true);
    return this->m_addr;
}

quint32 QEushullyScript::step()
{
    this->m_addr += this->parse_cmd(this->m_addr, true) + 1;
    return this->m_addr;
}

quint32 QEushullyScript::step_into()
{
    return this->m_addr;
}
