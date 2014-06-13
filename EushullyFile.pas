unit EushullyFile;

interface

uses
  Classes, SysUtils, Windows, EushullyALF;

const
  BUF_SIZE = 16*1024;

type
  TEushullyFile = class
  private
    fFile: THandle;
    fALFFile: TALFFile;
    fALF: TEushullyALF;

    function getName(): string;
    function getSize(): UInt32;
    function getSizeHuman(): string;
  public
    constructor Create(alf: TEushullyALF; root: string; fileName: string);
    destructor Destroy(); override;

    procedure SaveToFile(FileName: string);

    procedure close();

    property Name: string read getName;
    property Size: UInt32 read getSize;
    property SizeHuman: string read getSizeHuman;

    function read(var buf; readSize: UInt32): UInt32;
    function seek(pos: UInt32): UInt32;
  end;

implementation

constructor TEushullyFile.Create(alf: TEushullyALF; root: string; fileName: string);
begin
  inherited Create();
  self.fALF:=alf;
  self.fALFFile:=alf.open(fileName);

  if FileExists(root + fileName) then
  begin
    // открываем локальный файл на диске
    fFile:=FileOpen(root + fileName, fmOpenRead or fmShareDenyWrite);
    fALFFile.offset:=0;
    fALFFile.length:=GetFileSize(fFile, nil);
    fALFFile.pos:=0;
  end
    else
  begin
    fFile:=FileOpen(fALFFile.archiveName, fmOpenRead);
    fALFFile.pos:=0;
  end;
end;

destructor TEushullyFile.Destroy();
begin
  close();
  inherited;
end;

procedure TEushullyFile.SaveToFile(FileName: string);
var
  buf: array[0..BUF_SIZE-1] of byte;
  readSize: UInt32;
  str: TFileStream;
begin
  seek(0);
  str:=TFileStream.Create(FileName, fmOpenWrite or fmCreate);
  repeat
    readSize:=read(buf, BUF_SIZE);
    str.Write(buf, readSize);
  until (readSize<BUF_SIZE);
  str.Free;
end;

procedure TEushullyFile.close();
begin
  FileClose(fFile);
  self.fALFFile.length:=UInt32(-1);
end;

function TEushullyFile.read(var buf; readSize: UInt32): UInt32;
begin
  if (fALFFile.pos + readSize > fALFFile.length) then
    readSize:=fALFFile.length - fALFFile.pos;
  FileSeek(fFile, fALFFile.offset, soFromBeginning);
  FileSeek(fFile, fALFFile.pos, soFromCurrent);
  result:=FileRead(fFile, buf, readSize);
  inc(fALFFile.pos, result);
end;

function TEushullyFile.seek(pos: UInt32): UInt32;
begin
  if (self.fALFFile.length < pos) then
    self.fALFFile.pos:=self.fALFFile.length
  else
    self.fALFFile.pos:=pos;
  result:=self.fALFFile.pos;
end;

function TEushullyFile.getName(): string;
begin
  result:=self.fALFFile.fileName;
end;

function TEushullyFile.getSize(): UInt32;
begin
  result:=self.fALFFile.length;
end;

function TEushullyFile.getSizeHuman(): string;
begin
  result:='';
end;

end.

