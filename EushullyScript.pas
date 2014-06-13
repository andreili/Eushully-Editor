unit EushullyScript;

{$define SHOW_ONLY_STRS}
//{$define SHOW_HTML}

interface

uses
  Classes, SysUtils;

const
  SCRIPT_OP_EXIT       = $00000002;
  SCRIPT_OP_MOV        = $00000003;  // (or CALL? or load_script?) 5
  SCRIPT_OP_RETURN     = $00000005;  // 0
  SCRIPT_OP_ADD        = $00000050;
  SCRIPT_OP_SUB        = $00000051;
  SCRIPT_OP_SET_VAR    = $00000055;
  SCRIPT_OP_BIT_AND    = $00000056;
  SCRIPT_OP_CMP_EQ     = $0000005a;
  SCRIPT_OP_CMP_LT     = $0000005c;
  SCRIPT_OP_CMP_GTEQ   = $0000005f;
  SCRIPT_OP_SHOW_TEXT  = $0000006e;
  SCRIPT_OP_END_TEXT   = $0000006f;
  SCRIPT_OP_CLEAR_TEXT = $00000071;
  SCRIPT_OP_WAIT_INPUT = $00000072;
  SCRIPT_OP_UNK1       = $00000074;
  SCRIPT_OP_UNK2       = $0000007f;
  SCRIPT_OP_JUMP       = $0000008c;
  SCRIPT_OP_CALL       = $0000008f;
  SCRIPT_OP_JUMP_COND  = $000000a0;
  SCRIPT_OP_DIV        = $000000B4;  // ?
  SCRIPT_OP_COPY_STR   = $00000192;  // or furigana output?
  SCRIPT_OP_UNK3       = $000001a6;
  SCRIPT_OP_UNK4       = $000001f4;
  SCRIPT_OP_UNK5       = $000001f5;
  SCRIPT_OP_UNK6       = $0000021b;
//  SCRIPT_OP_  = $0000
//  SCRIPT_OP_  = $0000
//  SCRIPT_OP_  = $0000
//  SCRIPT_OP_  = $0000

  SCRIPT_FIELD_VALUE     = $00000000;
  SCRIPT_FIELD_TEXT      = $00000002;
  SCRIPT_FIELD_VAR_NUM   = $00000003;
  SCRIPT_FIELD_VAR_TEXT  = $00000005;
  SCRIPT_FIELD_UNK       = $00000009;

type
  TEushullyScript = class
    private
      f_parseResult: TStringList;
      f_addr: UInt32;
      //f_debug: boolean;
      f_debugMsg: string;
      f_script: array of UInt32;

      function parseParam(typ, val: UInt32; isAddr: boolean = false): string;
      function parseCmd(addr: UInt32; execute: boolean = false): Integer;
      function getCMD(Addr: UInt32): UInt32;
    public
      destructor Destroy(); override;

      procedure parse(raw: PInteger; size: UInt32);

      property Parsed: TStringList read f_parseResult;
      property CMD[Addr: UInt32]: UInt32 read getCMD;
  end;

implementation

destructor TEushullyScript.Destroy();
begin
  SetLength(f_script, 0);
  f_parseResult.Free;
end;

function TEushullyScript.parseParam(typ, val: UInt32; isAddr: boolean = false): string;
var
  _val: string;
begin
  result:='';
  if (isAddr) then
    _val:={$ifdef SHOW_HTML}'<a href="#' + {$endif}IntToHex(val, 4){$ifdef SHOW_HTML} + '">'{$endif}
  else
    _val:='';
  _val:=_val + IntToHex(val, 4);
  {$ifdef SHOW_HTML}
  if (isAddr) then
    _val:=_val + '</a>';
  {$endif}
  case (typ) of
    SCRIPT_FIELD_VALUE: result:=' VAL(' + _val + ')';
    SCRIPT_FIELD_TEXT: result:=' TEXT(' + _val + ')';
    SCRIPT_FIELD_VAR_NUM: result:=' VAR(' + _val + ')';
    SCRIPT_FIELD_VAR_TEXT: result:=' VAR_TEXT(' + _val + ')';
    else result:=' ' + IntToHex(typ, 4) + '(' + _val + ')';
  end;
end;

function TEushullyScript.parseCmd(addr: UInt32; execute: boolean = false): Integer;
var
  j: UInt32;
begin
  self.f_debugMsg:='';
  case (self.f_script[addr]) of
    $00000001: result:=0;
    SCRIPT_OP_EXIT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] EXIT (?)';
        if (execute) then
        begin
          //self.f_addr = game.stack_pop() + 1;
        end;
        result:=0;
      end;
    SCRIPT_OP_MOV:
      begin
        case (self.f_script[addr+1]) of
          $00: result:=2;
          $0c: result:=2;
          else result:=0;
        end;
      end;
    SCRIPT_OP_RETURN:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] RETURN';
        if (execute) then
        begin
          //self.f_addr = game.stack_pop() + 1;
        end;
        result:=0;
      end;
    $00000008: result:=2;
    $00000009: result:=5;
    $0000000a: result:=6;
    $0000000c: result:=6;
    $0000001e: result:=4;
    $00000023: result:=4;
    $00000025: result:=6;
    $00000026: result:=8;
    $00000028: result:=3;
    $0000002b: result:=6;
    $0000002d: result:=4;
    $00000030: result:=0;
    $00000032:
      begin
        case (self.f_script[addr+1]) of
          $09: result:=6;
          $00: result:=20;
          else result:=4;
        end;
      end;
    $00000036: result:=6;
    $0000003c: result:=4;
    $0000004b: result:=4;
    SCRIPT_OP_ADD:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] ADD';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        if (execute) then
        begin
        end;
        result:=6;
      end;
    SCRIPT_OP_SUB:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] SUB';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        if (execute) then
        begin
        end;
        result:=6;
      end;
    $00000052: result:=6;
    $00000053: result:=6;
    $00000054: result:=6;
    SCRIPT_OP_SET_VAR:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] SET_VAR';
        for j:=0 to 1 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        if (execute) then
        begin
          {eushully_game.getVars()->set_value(this->m_script.at(addr + 2),
                                              this->m_script.at(addr + 3),
                                              this->m_script.at(addr + 4));}
        end;
        result:=4;
      end;
    SCRIPT_OP_BIT_AND:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] BIT_AND';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        result:=6;
      end;
    $00000057: result:=6;
    $00000058: result:=6;
    $00000059: result:=6;
    SCRIPT_OP_CMP_EQ:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] CMP_EQ';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        result:=6;
      end;
    $0000005b: result:=0;
    SCRIPT_OP_CMP_LT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] CMP_LT';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        result:=6;
      end;
    $0000005d: result:=6;
    $0000005e: result:=6;
    SCRIPT_OP_CMP_GTEQ:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] CMP_GTEQ';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        result:=6;
      end;
    $00000060: result:=4;
    $00000061: result:=6;
    $00000063: result:=4;
    $00000064: result:=4;
    $00000067: result:=0;
    $0000006c: result:=4;
    SCRIPT_OP_SHOW_TEXT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] SHOW_TEXT';
        for j:=0 to 1 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        result:=4;
      end;
    SCRIPT_OP_END_TEXT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] END_TEXT' +
         self.parseParam(self.f_script[addr+1], self.f_script[addr+2]);
        result:=2;
      end;
    $00000070: result:=10;
    SCRIPT_OP_CLEAR_TEXT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] CLEAR_TEXT' +
         self.parseParam(self.f_script[addr+1], self.f_script[addr+2]);
        result:=2;
      end;
    SCRIPT_OP_WAIT_INPUT:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] WAIT_INPUT' +
         self.parseParam(self.f_script[addr+1], self.f_script[addr+2]);
        result:=2;
      end;
    $00000073: result:=20;
    $00000074: result:=2;
    $00000075: result:=2;
    $00000076: result:=5;
    $00000077: result:=2;
    $00000078: result:=2;
    $00000079: result:=6;
    $0000007a: result:=6;
    $0000007b: result:=4;
    $0000007c: result:=0;
    $0000007f: result:=1;
    $00000082: result:=10;
    $00000083: result:=6;
    $00000085: result:=0;
    $00000086: result:=2;
    $00000087: result:=0;
    $00000088: result:=2;
    $0000008c: result:=2;
    SCRIPT_OP_CALL:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] CALL' +
         self.parseParam(self.f_script[addr+1], self.f_script[addr+2]);
        if (execute) then
        begin
          {eushully_game.stack_push(this->m_addr);
           this->m_addr = this->m_script.at(addr + 2);
           return -1;}
        end;
        result:=2;
      end;
    $00000090: result:=14;
    $00000093: result:=0;
    $00000094: result:=0;
    $00000096: result:=6;
    $00000097: result:=10;
    SCRIPT_OP_JUMP_COND:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] JUMP_COND';
        for j:=0 to 2 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+5], self.f_script[addr+6], true);
        result:=6;
      end;
    $000000a1: result:=0;
    $000000a2: result:=4;
    $000000a3: result:=4;
    $000000ae: result:=0;
    $000000b4: result:=4;
    $000000b5: result:=2;
    $000000b6: result:=2;
    $000000b7: result:=2;
    $000000b8: result:=0;
    $000000b9: result:=2;
    $000000ba: result:=2;
    $000000bf: result:=2;
    $000000c0: result:=2;
    $000000c1: result:=0;
    $000000c2: result:=4;
    $000000c3: result:=2;
    $000000c4: result:=2;
    $000000c5: result:=4;
    $000000c6: result:=4;
    $000000c7: result:=4;
    $000000c8:
      begin
        case (self.f_script[addr+1]) of
          $00: result:=2;
          else result:=0;
        end;
      end;
    $000000cc: result:=4;
    $000000cd: result:=0;
    $000000d3: result:=0;
    $000000d4: result:=8;
    $000000d5: result:=2;
    $000000d9: result:=0;
    $000000fa: result:=0;
    $000000fb: result:=4;
    $000000fe: result:=2;
    $000000ff: result:=2;
    $00000101: result:=0;
    $00000105: result:=4;
    $00000107: result:=4;
    $00000108: result:=2;
    $00000109: result:=4;
    $0000010a: result:=4;
    $0000010b: result:=28;
    $0000010c: result:=4;
    $0000010d: result:=2;
    $0000010e: result:=4;
    $0000012c:
      begin
        case (self.f_script[addr+1]) of
          $00: result:=4;
          else result:=10;
        end;
      end;
    $0000012e: result:=16;
    $0000012f: result:=8;
    $00000130: result:=2;
    $00000131: result:=2;
    $00000132: result:=2;
    $00000133: result:=2;
    $00000134: result:=6;
    $00000135: result:=4;
    $00000136: result:=4;
    $0000013f: result:=6;
    $00000140: result:=8;
    $00000141: result:=2;
    $00000142: result:=8;
    $00000144: result:=4;
    $00000147: result:=12;
    $00000149: result:=2;
    $00000190: result:=6;
    $00000191: result:=4;
    SCRIPT_OP_COPY_STR:
      begin
        self.f_debugMsg:='[0x' + IntToHex(addr, 4) + '] COPY_STR';
        for j:=0 to 1 do
          self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+1+j*2], self.f_script[addr+2+j*2]);
        self.f_debugMsg:= self.f_debugMsg + self.parseParam(self.f_script[addr+5], self.f_script[addr+6], true);
        result:=4;
      end;
    $00000193: result:=6;
    $00000194: result:=6;
    $00000195: result:=6;
    $00000196: result:=6;
    $00000197: result:=8;
    $00000198: result:=6;
    $00000199: result:=0;
    $0000019a: result:=5;
    $0000019b: result:=0;
    $0000019c: result:=0;
    $0000019d: result:=4;
    $0000019e: result:=4;
    $000001a0: result:=18;
    $000001a1: result:=5;
    $000001a2: result:=2;
    $000001a3: result:=2;
    $000001a4: result:=4;
    $000001a5: result:=2;
    $000001a6: result:=4;
    $000001a7: result:=2;
    $000001a8: result:=0;
    $000001a9: result:=2;
    $000001aa: result:=2;
    $000001ab: result:=4;
    $000001ac: result:=6;
    $000001ad: result:=0;
    $000001ae: result:=6;
    $000001af: result:=6;
    $000001b0: result:=6;
    $000001b1: result:=2;
    $000001b2: result:=2;
    $000001b3: result:=6;
    $000001b4: result:=2;
    $000001b5: result:=2;
    $000001b6: result:=2;
    $000001b7: result:=2;
    $000001b8: result:=4;
    $000001b9: result:=4;
    $000001ba: result:=4;
    $000001bb: result:=2;
    $000001bc: result:=0;
    $000001bf: result:=0;
    $000001c1: result:=6;
    $000001c2: result:=4;
    $000001c4: result:=2;
    $000001c7: result:=5;
    $000001c8: result:=4;
    $000001ca: result:=2;
    $000001cb: result:=12;
    $000001cd: result:=4;
    $000001ce: result:=2;
    $000001cf: result:=2;
    $000001d0: result:=6;
    $000001d1: result:=10;
    $000001d2: result:=9;
    $000001d3: result:=10;
    $000001d5: result:=0;
    $000001f4: result:=0;
    $000001f5: result:=0;
    $000001f6: result:=0;
    $000001f7: result:=4;
    $000001f8: result:=8;
    $000001f9: result:=6;
    $000001fa: result:=2;
    $000001fb: result:=16;
    $000001fd: result:=8;
    $000001fe: result:=10;
    $000001ff: result:=8;
    $00000202: result:=10;
    $00000203: result:=8;
    $00000204: result:=8;
    $00000205: result:=12;
    $00000208: result:=6;
    $0000020b: result:=14;
    $0000020c: result:=0;
    $0000020d: result:=2;
    $0000020e: result:=0;
    $0000020f: result:=6;
    $00000212: result:=4;
    $00000213: result:=6;
    $00000214: result:=4;
    $00000215: result:=4;
    $00000216: result:=4;
    $00000217: result:=8;
    $00000218: result:=8;
    $00000219: result:=8;
    $0000021a: result:=8;
    $0000021b: result:=2;
    $0000021c: result:=0;
    $0000021d: result:=4;
    $0000021e: result:=12;
    $0000021f: result:=14;
    $00000220: result:=12;
    $00000222: result:=4;
    $00000223: result:=16;
    $00000224: result:=0;
    $00000228: result:=10;
    $00000229: result:=10;
    $0000022c: result:=6;
    $0000022f: result:=10;
    $00000230: result:=2;
    $00000231: result:=8;
    $00000232: result:=8;
    $00000233: result:=4;
    $00000234: result:=10;
    $00000235: result:=10;
    $00000236: result:=8;
    $00000238: result:=2;
    $00000239: result:=12;
    $0000023b: result:=14;
    $0000023c: result:=0;
    $0000023d: result:=0;
    $0000023f: result:=4;
    $00000242: result:=4;
    $00000243: result:=0;
    $00000244: result:=0;
    $0000024d: result:=24;
    $0000024e: result:=2;
    $0000024f: result:=20;
    $00000250: result:=20;
    $00000251: result:=17;
    $00000252: result:=2;
    $00000256: result:=10;
    $00000258:
      begin
        case (self.f_script[addr+1]) of
          $09: result:=6;
          else result:=4;
        end;
      end;
    $00000259: result:=0;
    $0000025c: result:=16;
    $0000025d: result:=6;
    $0000025e: result:=10;
    $0000025f: result:=8;
    $00000260: result:=8;
    $00000261: result:=2;
    $00000273: result:=0;
    $00000275: result:=0;
    $0000027f: result:=4;
    $0000028c: result:=3;
    $000002bc: result:=6;
    $000002bd: result:=2;
    $000002bf: result:=6;
    $000002c5: result:=4;
    $000002c7: result:=8;
    $000002ce: result:=2;
    $000002cf: result:=2;
    $000002d0: result:=6;
    $000002d1: result:=6;
    $000002d2: result:=6;
    $000002d3: result:=6;
    $000002d5: result:=4;
    $000002d7: result:=6;
    $000002d8: result:=6;
    $000002da: result:=16;
    $000002db: result:=2;
    $000002dd: result:=4;
    $000002de: result:=4;
    $000002df: result:=6;
    $000002e0: result:=6;
    $000002e1: result:=6;
    $000002e2: result:=6;
    $000002e3: result:=6;
    $000002e4: result:=6;
    $000002e5: result:=2;
    $000002e6: result:=6;
    $000002e7: result:=4;
    $000002e8: result:=2;
    $000002e9: result:=2;
    $000002ea: result:=2;
    $000002eb: result:=24;
    $000002ec: result:=4;
    $000002ee: result:=4;
    $000002ef: result:=22;
    $000002f0: result:=18;
    $000002f1: result:=14;
    $000002f2: result:=12;
    $000002fb: result:=6;
    $00000320:
      begin
        case (self.f_script[addr+1]) of
          $00: result:=20;
          $09: result:=20;
          else result:=4;
        end;
      end;
    $00000322: result:=8;
    $00000323: result:=10;
    $00000324: result:=0;
    $00000325: result:=6;
    $00000328: result:=6;
    $00000329: result:=9;
    $0000032b: result:=4;
    $0000032c: result:=12;
    $0000032d: result:=4;
    $0000032e: result:=22;
    $0000032f: result:=29;
    $00000332: result:=5;
    $00000334: result:=2;
    $00000335: result:=8;
    $00000337: result:=8;
    $0000033b: result:=8;
    $0000033e: result:=10;
    $0000033f: result:=6;
    $000003e8: result:=4;
    $000004b0: result:=4;
    $00000579: result:=1;
    $000005dc: result:=4;
    $00000708:
      begin
        case (self.f_script[addr+1]) of
          $00: result:=6;
          else result:=4;
        end;
      end;
    $00000756: result:=1;
    $000007b6: result:=1;
    $000007d0: result:=4;
    $000009cd: result:=8;
    $000009d1: result:=8;
    $00000acd: result:=0;
    $00000b42: result:=0;
    $00000c5a: result:=0;
    $00000f59: result:=0;
    else result:=-2;
  end;
end;

procedure TEushullyScript.parse(raw: PInteger; size: UInt32);
var
  i, j: UInt32;
  str: string;
  args_count: Integer;
begin
  self.f_addr:=0;
  self.f_parseResult:=TStringList.Create();
  self.f_parseResult.Clear;
  SetLength(self.f_script, size);
  Move(raw^, self.f_script[0], 4*size);
  i:=0;
  while (i<size) do
  begin
    {$ifdef SHOW_HTML}
    str:='<a name="' + IntToHex(i, 4) + '" />';
    {$else}
    str:='';
    {$endif}
    args_count:=parseCmd(i);
    if (args_count = -2) then
    begin
      self.f_parseResult.Add('Unknown CMD: 0x' + IntToHex(self.f_script[i], 4));
    end
      else
    begin
      if (Length(self.f_debugMsg) = 0) then
      begin
        str:=str + '[0x' + IntToHex(i, 4) + '] 0x' + IntToHex(self.f_script[i], 4) + ' ';
        if (i + args_count < size) then
          for j:=0 to args_count-1 do
            str:=str + '0x' + IntToHex(self.f_script[i+j+1], 4) + ' ';
        {$ifndef SHOW_ONLY_STRS}
        self.f_parseResult.AddObject(str, TObject(Pointer(i)));
        {$endif}
      end
        else
      {$ifdef SHOW_ONLY_STRS}
      if ((f_script[i]=SCRIPT_OP_SHOW_TEXT)) then
      {$endif}
        self.f_parseResult.AddObject(str + self.f_debugMsg, TObject(Pointer(i)));
      inc(i, args_count);
    end;
    inc(i);
  end;
  self.f_addr:=0;
end;

function TEushullyScript.getCMD(Addr: UInt32): UInt32;
begin
  result:=f_script[Addr];
end;

end.

