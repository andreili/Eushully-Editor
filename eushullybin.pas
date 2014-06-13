unit EushullyBIN;

interface

uses
  Classes, SysUtils, EushullyFile;

const
  BIN_SIGN = 'SYS';

type
  TBINHeader = record
    sign: array[0..2] of AnsiChar;    // always "SYS"
    version: array[0..3] of AnsiChar;
    space: char;
    type_,
    d1,
    d2,
    d3,
    d4,
    d5,
    offsets_size,                 // always 0x1C (include here value)
    size_71,
    offset_71,
    size_03,
    offset_03,
    size_8f,
    offset_8f: UInt32;
  end;

  TEushullyBIN = class
  private
    fName: string;
    fHeader: TBINHeader;
    fScriptRAW: array of UInt32;
    fOffsets: array[0..2] of array of UInt32;

    function getName(): string;
    function getScriptRAW(): PInteger;
    function getScriptSize(): UInt32;
  public
    destructor Destroy(); override;

    function load(from: TEushullyFile): boolean;
    procedure close();

    property Name: string read getName;
    class function isFormat(tstFile: TEushullyFile): boolean;

    property ScriptRAW: PInteger read getScriptRAW;
    property ScriptSize: UInt32 read getScriptSize;
  end;

implementation

destructor TEushullyBIN.Destroy();
begin
  close();
  inherited;
end;

function TEushullyBIN.getName(): string;
begin
  result:=fName;
end;

function TEushullyBIN.getScriptRAW(): PInteger;
begin
  result:=@fScriptRAW[0];
end;

function TEushullyBIN.getScriptSize(): UInt32;
begin
  result:=Length(fScriptRAW);
end;

function TEushullyBIN.load(from: TEushullyFile): boolean;
begin
  from.seek(0);
  from.read(fHeader, sizeof(TBINHeader));
  if (fHeader.sign <> BIN_SIGN) then
  begin
    result:=false;
    Exit;
  end;
  fName:=from.Name;

  SetLength(fScriptRAW, fHeader.offset_71);
  from.read(fScriptRAW[0], fHeader.offset_71*4);

  if (fHeader.size_71>0) then
  begin
    from.seek(fHeader.offset_71);
    SetLength(fOffsets[0], fHeader.size_71);
    from.read(fOffsets[0][0], fHeader.size_71*4);
  end;
  if (fHeader.size_03>0) then
  begin
    from.seek(fHeader.offset_03);
    SetLength(fOffsets[1], fHeader.size_03);
    from.read(fOffsets[1][0], fHeader.size_03*4);
  end;
  if (fHeader.size_8f>0) then
  begin
    from.seek(fHeader.offset_8f);
    SetLength(fOffsets[2], fHeader.size_8f);
    from.read(fOffsets[2][0], fHeader.size_8f*4);
  end;

  result:=true;
end;

procedure TEushullyBIN.close();
begin
  SetLength(fScriptRAW, 0);
  SetLength(fOffsets[0], 0);
  SetLength(fOffsets[1], 0);
  SetLength(fOffsets[2], 0);
end;

class function TEushullyBIN.isFormat(tstFile: TEushullyFile): boolean;
var
   header: TBINHeader;
begin
  tstFile.seek(0);
  tstFile.read(header, sizeof(TBINHeader));
  result:=(header.sign = BIN_SIGN);
end;

end.

