unit EushullyALF;

interface

uses
  Classes, SysUtils, lzss, Windows;

const
  ALF_SIGNATURE_APPEND = 'S4AC';
  ALF_SIGNATURE_DATA = 'S4IC';
  ALF_FILE_ENTRY_NAME_LEN = 64;
  ALF_ARCHIVE_NAME_LEN = 256;

  CP_SHIFT_JIS = 932;

type
  EALFType = (ALF_DATA, ALF_APPEND, ALF_UNK);

  TALFHeader = record
    sign: array [0 .. 3] of AnsiChar;
    version: array [0 .. 3] of AnsiChar;
    title: array [0 .. 231] of AnsiChar;
    // title: array[0..115] of WideChar;
  end;

  TALFDataHeader = record
    d1: UInt32;
    d2: UInt32;
    d3: UInt32;
    d4: UInt32; // always 0x00000001
    d5: UInt32; // always 0x00000001
    d6: UInt32; // always 0x00000001
    d7: UInt32; // always 0x00000280
    d8: UInt32; // always 0x000001e0
    d9: UInt32; // always 0x00000010
    d10: UInt32;
    d11: UInt32;
    d12: UInt32;
    d13: UInt32; // always 0x00000002
    d14: UInt32; // always 0x00000002
    d15: UInt32; // always 0x00000002
  end;

  TALFAppendHeader = record
    d1: UInt32;
    d2: UInt32;
    d3: UInt32;
    d4: UInt32;
    d5: UInt32;
    d6: UInt32;
    append_no: UInt32;
  end;

  TALFArchives = record
    count: UInt32;
    archives: array of array of AnsiChar;
  end;

  TALFFileEntry = record
    file_name: array [0 .. (ALF_FILE_ENTRY_NAME_LEN - 1)] of AnsiChar;
    acrhive_index: UInt32;
    file_index: UInt32;
    offset: UInt32;
    length: UInt32;
  end;

  TALFData1Header = record
    d1: UInt32;
    d2: UInt32;
    data_count: UInt32;
  end;

  TALFSettingsHeader = record
    data_size: UInt32;
    d1: UInt32;
  end;

  TALFFile = record
    archiveName: string;
    fileName: string;
    offset: UInt32;
    length: UInt32;
    pos: UInt32;
  end;

  TEushullyALF = class
  private
    f_fileName: string;
    f_root: string;
    f_header: TALFHeader;
    f_data_header: TALFDataHeader;
    f_append_header: TALFAppendHeader;
    f_archives: TALFArchives;
    f_filesCount: UInt32;
    f_files: array of TALFFileEntry;
    f_data1_header: TALFData1Header;
    f_data1: array of UInt32;
    f_settings_header: TALFSettingsHeader;
    f_settings: TStringList;

    function getFilesCount(): UInt32;
    function getFileName(Idx: UInt32): string;
    function getFileSize(Idx: UInt32): UInt32;
    function getSettingsCount(): UInt32;
    function getSettingName(Idx: UInt32): string;
    function getSettingsByIdx(Idx: UInt32): string;
    function getSettingsByName(Name: string): string;
    function getTitle(): string;
    function getType(): EALFType;
  public
    destructor Destroy(); override;
    class function isFormat(Name: string): boolean;

    function LoadFromFile(Name: string): boolean;
    function LoadFromStream(stream: TFileStream): boolean;

    property FilesCount: UInt32 read getFilesCount;
    property fileName[Idx: UInt32]: string read getFileName;
    property FileSize[Idx: UInt32]: UInt32 read getFileSize;
    function isExist(Name: string): boolean;
    function open(Name: string): TALFFile;

    property SettingsCount: UInt32 read getSettingsCount;
    property SettingName[Idx: UInt32]: String read getSettingName;
    property Settings[Idx: UInt32]: String read getSettingsByIdx;
    // property Settings[Name: string]: String read getSettingsByName;

    property ArchiveType: EALFType read getType;
    property title: string read getTitle;
    property Name: string read f_fileName;
  end;

implementation

destructor TEushullyALF.Destroy();
begin
  SetLength(self.f_archives.archives, 0, 0);
  SetLength(self.f_files, 0);
  SetLength(self.f_data1, 0);
  self.f_settings.Free;
end;

class function TEushullyALF.isFormat(Name: string): boolean;
var
  f: TFileStream;
  sign: array [0 .. 3] of AnsiChar;
begin
  f := TFileStream.Create(Name, fmOpenRead);
  f.Read(sign, 4);
  f.Free;
  result := ((sign = ALF_SIGNATURE_DATA) or (sign = ALF_SIGNATURE_APPEND));
end;

function TEushullyALF.LoadFromFile(Name: string): boolean;
var
  f: TFileStream;
begin
  self.f_fileName := Name;
  f := TFileStream.Create(Name, fmOpenRead);
  result := self.LoadFromStream(f);
  f.Free;
end;

function ReadZString(stream: TSTream): string;
Var
  c: AnsiChar;
begin
  result := '';
  while (stream.Position < stream.Size) do
  begin
    stream.Read(c, 1);
    if (c = #0) then
      break;
    result := result + c;
  end;
end;

function TEushullyALF.LoadFromStream(stream: TFileStream): boolean;
var
  i: Integer;
  headerSize: UInt32;
  header: pByte;
  HeaderStream: TMemoryStream;
  lzss: TLZSS;
  s: string;
begin
  result := false;
  if (stream.fileName <> '') then
    self.f_fileName := stream.fileName;
  self.f_root := ExtractFilePath(self.f_fileName);

  // reading header & check signature
  stream.Read(self.f_header, sizeof(TALFHeader));
  if (self.f_header.sign = ALF_SIGNATURE_DATA) then
    stream.Read(self.f_data_header, sizeof(TALFDataHeader))
  else
    stream.Read(self.f_append_header, sizeof(TALFAppendHeader));

  if (self.getType() = ALF_UNK) then
    Exit;

  lzss := TLZSS.Create();
  headerSize := lzss.read_sector(stream, header);
  HeaderStream := TMemoryStream.Create();
  HeaderStream.Write(header^, headerSize);
  HeaderStream.Seek(0, soBeginning);

  // reading archives list
  HeaderStream.Read(self.f_archives.count, 4);
  SetLength(self.f_archives.archives, self.f_archives.count,
    ALF_ARCHIVE_NAME_LEN);
  for i := 0 to self.f_archives.count - 1 do
    HeaderStream.read(self.f_archives.archives[i][0], ALF_ARCHIVE_NAME_LEN);

  // reading files entry list
  HeaderStream.Read(self.f_filesCount, 4);
  SetLength(self.f_files, self.f_filesCount);
  HeaderStream.Read(self.f_files[0], sizeof(TALFFileEntry) * self.f_filesCount);

  if (HeaderStream.Position < HeaderStream.Size) then
  begin
    // reading DATA-1
    HeaderStream.Read(self.f_data1_header, sizeof(TALFData1Header));
    SetLength(self.f_data1, self.f_data1_header.data_count);
    HeaderStream.Read(self.f_data1[0], self.f_data1_header.data_count * 4);

    // reading base settings
    self.f_settings := TStringList.Create();
    self.f_settings.NameValueSeparator := '=';
    HeaderStream.Read(self.f_settings_header, sizeof(TALFSettingsHeader));
    for i := 0 to self.f_settings_header.d1 - 1 do
    begin
      s := ReadZString(HeaderStream);
      self.f_settings.Values[s + '_' + IntToStr(i)] := ReadZString
        (HeaderStream);
    end;
  end;

  HeaderStream.Free;
  FreeMem(header);
  result := true;
end;

function TEushullyALF.getType(): EALFType;
begin
  if (self.f_header.sign = ALF_SIGNATURE_DATA) then
    result := ALF_DATA
  else if (self.f_header.sign = ALF_SIGNATURE_APPEND) then
    result := ALF_APPEND
  else
    result := ALF_UNK;
end;

function TEushullyALF.getFilesCount(): UInt32;
begin
  result := self.f_filesCount;
end;

function TEushullyALF.getFileName(Idx: UInt32): string;
begin
  if (Idx >= self.f_filesCount) then
    result := ''
  else
    result := self.f_files[Idx].file_name;
end;

function TEushullyALF.getFileSize(Idx: UInt32): UInt32;
begin
  if (Idx >= self.f_filesCount) then
    result := UInt32(-1)
  else
    result := self.f_files[Idx].length;
end;

function TEushullyALF.getSettingsCount(): UInt32;
begin
  result := self.f_settings_header.d1;
end;

function TEushullyALF.getSettingName(Idx: UInt32): string;
begin
  result := self.f_settings.Names[Idx];
end;

function TEushullyALF.getSettingsByIdx(Idx: UInt32): string;
{var
  len: Integer;
  str: pAnsiChar;}
begin
  {str:=pAnsiChar(self.f_settings.ValueFromIndex[Idx]);
  len := MultiByteToWideChar(CP_SHIFT_JIS, 0, str, -1, nil, 0);
  SetLength(result, len);
  MultiByteToWideChar(CP_SHIFT_JIS, 0, str, -1, pWideChar(result), len); }
  result:=self.f_settings.ValueFromIndex[Idx];
end;

function TEushullyALF.getSettingsByName(Name: string): string;
begin
  result := self.f_settings.Values[Name];
end;

function TEushullyALF.isExist(Name: string): boolean;
var
  i: Integer;
begin
  Name := UpperCase(Name);
  for i := 0 to self.f_filesCount - 1 do
    if (self.f_files[i].file_name=Name) then
    begin
      result := true;
      Exit;
    end;
  result := false;
end;

function TEushullyALF.open(Name: string): TALFFile;
var
  i: Integer;
  entry: TALFFileEntry;
begin
  result.length := UInt32(-1);
  Name := UpperCase(Name);
  for i := 0 to self.f_filesCount - 1 do
    if (self.f_files[i].file_name=Name) then
    begin
      entry := self.f_files[i];
      result.length := entry.length;
      result.offset := entry.offset;
      result.fileName := entry.file_name;
      result.archiveName := self.f_root +  pAnsiChar(self.f_archives.archives[entry.acrhive_index]);
      Exit;
    end;
end;

function TEushullyALF.getTitle(): string;
var
  len: Integer;
begin
  if (self.f_header.title[0] > #$7f) then
  begin
    len := MultiByteToWideChar(CP_SHIFT_JIS, 0, self.f_header.title, -1, nil, 0);
    SetLength(result, len-1);
    MultiByteToWideChar(CP_SHIFT_JIS, 0, self.f_header.title, -1, pWideChar(result), len);
  end
  else
    result := self.f_header.title;
end;

end.
