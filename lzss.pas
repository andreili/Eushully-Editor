unit lzss;

interface

uses
  Classes, SysUtils;

const
  N = 4096;
  F = 18;
  TRESHOLD = 2;

type
  LZSSSectorHeader = record
    original_length1: UInt32;
    original_length2: UInt32;
    length: UInt32;
  end;

  TLZSSPackData = record
    state: Integer;
    i, c, len, r, s: Integer;
    last_match_length, code_buf_ptr: Integer;
    mask: byte;
    code_buf: array [0 .. 16] of byte;
    match_position, match_length: Integer;
    lson: array [0 .. N] of Integer;
    rson: array [0 .. N + 256] of Integer;
    dad: array [0 .. N] of byte;
    text_byf: array [0 .. (N + F)] of byte;
  end;

  pLZSSUnpackData = ^TLZSSUnpackData;

  TLZSSUnpackData = record
    state: Integer;
    i, j, k, r, c: Integer;
    flags: Integer;
    text_byf: array [0 .. (N + F)] of byte;
  end;

  TLZSS = class
  private
    fDat: pLZSSUnpackData;
    fInIdx: UInt32;

    function CreateLZSSUnpackData(): pLZSSUnpackData;
    procedure FreeLZSSUnpackData(data: pLZSSUnpackData);
  public
    function read_sector(stream: TFileStream; var buf: pByte): UInt32;
    function unlzss(inp: Pointer; inSize: Integer; outp: Pointer;
      outSize: Integer): Integer;

    procedure Init();
    function LZSSRead(inp: pByte; inSize: Integer; outp: pByte;
      outSize: Integer): Integer;
    procedure DeInit();
  end;

implementation

function TLZSS.read_sector(stream: TFileStream; var buf: pByte): UInt32;
var
  hdr: LZSSSectorHeader;
  tmp: pByte;
begin
  stream.Read(hdr, sizeof(LZSSSectorHeader));
  GetMem(tmp, hdr.length);
  stream.Read(tmp[0], hdr.length);
  GetMem(buf, hdr.original_length1);
  unlzss(tmp, hdr.length, buf, hdr.original_length1);
  FreeMem(tmp);
  result := hdr.original_length1;
end;

function TLZSS.unlzss(inp: Pointer; inSize: Integer; outp: Pointer;
  outSize: Integer): Integer;
begin
  fDat := CreateLZSSUnpackData();
  result := LZSSRead(inp, inSize, outp, outSize);
  FreeLZSSUnpackData(fDat);
end;

procedure TLZSS.Init();
begin
  fDat := CreateLZSSUnpackData();
end;

procedure TLZSS.DeInit();
begin
  FreeLZSSUnpackData(fDat);
end;

function TLZSS.CreateLZSSUnpackData(): pLZSSUnpackData;
var
  c: Integer;
begin
  New(result);
  for c := 0 to (N - F - 1) do
    result^.text_byf[c] := 0;
  result^.state := 0;
  fInIdx := 0;
end;

procedure TLZSS.FreeLZSSUnpackData(data: pLZSSUnpackData);
begin
  FreeMem(data);
end;

function TLZSS.LZSSRead(inp: pByte; inSize: Integer; outp: pByte;
  outSize: Integer): Integer;
var
  outIdx, i, j, k, r, size: Integer;
  c: byte;
  flags: UInt16;
label pos1, pos2, getout;
begin
  outIdx := 0;
  i := fDat^.i;
  j := fDat^.j;
  k := fDat^.k;
  r := fDat^.r;
  c := fDat^.c;
  flags := fDat^.c;
  size := 0;

  if (fDat^.state = 2) then
    goto pos2
  else if (fDat^.state = 1) then
    goto pos1;

  r := N - F;
  flags := 0;

  while (true) do
  begin
    flags := flags shr 1;
    if ((flags and 256) = 0) then
    begin
      c := inp[fInIdx];
      inc(fInIdx);
      if (fInIdx > inSize) then
        break;
      flags := c or $FF00;
    end;

    if ((flags and 1) <> 0) then
    begin
      c := inp[fInIdx];
      inc(fInIdx);
      if (fInIdx > inSize) then
        break;
      fDat^.text_byf[r] := c;
      inc(r);
      r := r and (N - 1);
      outp[outIdx] := c;
      inc(outIdx);
      inc(size);
      if (size >= outSize) then
      begin
        fDat^.state := 1;
        goto getout;
      end;
    pos1 :
    end
    else
    begin
      i := inp[fInIdx] and $000000FF;
      inc(fInIdx);
      if (fInIdx > inSize) then
        break;
      j := inp[fInIdx];
      inc(fInIdx);
      if (fInIdx > inSize) then
        break;
      i := i or ((j and $F0) shl 4);
      j := (j and $0F) + TRESHOLD;
      for k := 0 to j do
      begin
        c := fDat^.text_byf[(i + k) and (N - 1)];
        fDat^.text_byf[r] := c;
        inc(r);
        outp[outIdx] := c;
        inc(outIdx);
        r := r and (N - 1);
        inc(size);
        if (size > outSize) then
        begin
          fDat^.state := 2;
          goto getout;
        end;
      pos2 :
      end;
    end;
  end;

  fDat^.state := 0;

getout :
  fDat^.i := i;
  fDat^.j := j;
  fDat^.k := k;
  fDat^.r := r;
  fDat^.c := c;
  fDat^.flags := flags;
  result := size;
end;

end.
