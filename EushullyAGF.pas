unit EushullyAGF;

interface

uses
  Classes, SysUtils, Windows, EushullyFile, EushullyFS, lzss;

const
  AGF_SIGN = 'ACGF';
  ACIF_SIGN = 'ACIF';
  AGF_TYPE_24BIT = 1;
  AGF_TYPE_32BIT = 2;

type
  TAGFHeader = record
    sign: array [0 .. 3] of AnsiChar;
    type_: UInt32;
    unknown: UInt32;
  end;

  TAGFImageHeader = record
    header: BITMAPFILEHEADER;
    dummy: word;
    info: BITMAPINFOHEADER;
    pal: array [0 .. 255] of RGBQUAD;
  end;

  TACIFHeader = record
    sign: array [0 .. 3] of AnsiChar;
    type_: UInt32;
    unknown: UInt32;
    original_length: UInt32;
    width: UInt32;
    height: UInt32;
  end;

  TEushullyAGF = class
  private
    fHeader: TAGFHeader;
    fImageHeader: TAGFImageHeader;
    fRGBA: array of RGBQUAD;

    function readBuf(from: TEushullyFile; var buf: pByte): UInt32;
  public
    destructor Destroy(); override;

    function load(from: TEushullyFile): boolean;
    function toMemory(): TMemoryStream;

    class function isFormat(tstFile: TEushullyFile): boolean;
  end;

implementation

destructor TEushullyAGF.Destroy();
begin
  SetLength(fRGBA, 0);
  inherited Destroy();
end;

function TEushullyAGF.readBuf(from: TEushullyFile; var buf: pByte): UInt32;
var
  hdr: LZSSSectorHeader;
  tmp: pByte;
  lzss: TLZSS;
begin
  from.read(hdr, sizeof(LZSSSectorHeader));
  GetMem(buf, hdr.original_length1);
  if (hdr.original_length1 = hdr.length) then
  begin
    from.read(buf, hdr.original_length1);
    result := hdr.original_length1;
    Exit;
  end;

  GetMem(tmp, hdr.original_length1);
  lzss := TLZSS.Create;
  from.read(tmp^, hdr.length);
  result := lzss.unlzss(tmp, hdr.length, buf, hdr.original_length1);
  FreeMem(tmp);
  lzss.Free;
end;

type
  pRGBQUAD = ^RGBQUAD;

function TEushullyAGF.load(from: TEushullyFile): boolean;
var
  inBuf, rgbBuf, alpha, alpha_line, start_point: pByte;
  lzss: TLZSS;
  hdr: LZSSSectorHeader;
  readed, pal_size, alpha_size, rgb_stride, x, y: UInt32;
  acif: TACIFHeader;
  str: TFileStream;
begin
  result := false;
  from.seek(0);
  from.read(fHeader, sizeof(TAGFHeader));
  if (fHeader.sign <> AGF_SIGN) then
    Exit;
  if (fHeader.type_ <> AGF_TYPE_24BIT) and (fHeader.type_ <> AGF_TYPE_32BIT)
    then
    Exit;

  from.read(hdr, sizeof(LZSSSectorHeader));
  if (hdr.original_length1 = hdr.length) then
  begin
    readed := 0;
    inc(readed, from.read(fImageHeader.header, sizeof(BITMAPFILEHEADER)));
    inc(readed, from.read(fImageHeader.dummy, 2));
    inc(readed, from.read(fImageHeader.info, sizeof(BITMAPINFOHEADER)));
    pal_size := (hdr.original_length1 - readed) div sizeof(RGBQUAD);
    if (pal_size > 0) then
    begin
      // SetLength(pal, pal_size);
      from.read(fImageHeader.pal[0], pal_size * sizeof(RGBQUAD));
    end;
  end
  else
  begin
    GetMem(inBuf, hdr.length);
    from.read(inBuf^, hdr.length);
    lzss := TLZSS.Create;
    lzss.Init;
    lzss.LZSSRead(inBuf, hdr.length, @fImageHeader, sizeof(TAGFImageHeader));
    FreeMem(inBuf);
    lzss.Free;
  end;
  readBuf(from, rgbBuf);

  if (fHeader.type_ = AGF_TYPE_32BIT) then
  begin
    from.read(acif, sizeof(TACIFHeader));
    readBuf(from, alpha);
    // lzss.unlzss(alpha_buff,

    // rgba_len:=bmp_info.biWidth*bmp_info.biHeight*4;
    SetLength(fRGBA, fImageHeader.info.biWidth * fImageHeader.info.biHeight);
    rgb_stride := (fImageHeader.info.biWidth * fImageHeader.info.biBitCount div 8 +
        3) and not 3;

    for y := 0 to fImageHeader.info.biHeight - 1 do
    begin
      alpha_line:=@alpha[(fImageHeader.info.biHeight-y-1)*fImageHeader.info.biWidth];
      for x := 0 to fImageHeader.info.biWidth - 1 do
      begin
        start_point:=@fRGBA[y * fImageHeader.info.biHeight + x];
        if (fImageHeader.info.biBitCount = 8) then
        begin
          start_point[0]:=fImageHeader.pal[rgbBuf[y*rgb_stride+x]].rgbBlue;
          start_point[1]:=fImageHeader.pal[rgbBuf[y*rgb_stride+x]].rgbGreen;
          start_point[2]:=fImageHeader.pal[rgbBuf[y*rgb_stride+x]].rgbRed;
          {fRGBA[y * fImageHeader.info.biHeight + x] := fImageHeader.pal
            [rgbBuf[x + y * rgb_stride]];}
        end
        else
        begin
          {fRGBA[y * fImageHeader.info.biHeight + x] := fImageHeader.pal
            [rgbBuf[x + y * rgb_stride]]; }
        end;
        //fRGBA[y * fImageHeader.info.biHeight + x].rgbReserved:=alpha_line[x];
      end;
    end;
    FreeMem(alpha);
  end;

  FreeMem(rgbBuf);
end;

function TEushullyAGF.toMemory(): TMemoryStream;
begin
  if (fHeader.type_ = AGF_TYPE_32BIT) then
  begin
    fImageHeader.header.bfType := $4D42;
    fImageHeader.header.bfSize := sizeof(BITMAPFILEHEADER) + sizeof
      (BITMAPINFOHEADER) + fImageHeader.info.biWidth *
      fImageHeader.info.biHeight * 4;
    fImageHeader.header.bfOffBits := sizeof(BITMAPFILEHEADER) + sizeof
      (BITMAPINFOHEADER);

    fImageHeader.info.biSize := sizeof(BITMAPINFOHEADER);
    fImageHeader.info.biPlanes := 1;
    fImageHeader.info.biBitCount := 4 * 8;

    result := TMemoryStream.Create;
    result.Write(fImageHeader.header, sizeof(BITMAPFILEHEADER));
    result.Write(fImageHeader.info, sizeof(BITMAPINFOHEADER));
    result.Write(fRGBA[0], fImageHeader.info.biWidth * fImageHeader.info.biHeight * 4);
  end
    else
  begin
    fImageHeader.header.bfType := $4D42;
    fImageHeader.header.bfSize := sizeof(BITMAPFILEHEADER) + sizeof
      (BITMAPINFOHEADER) + fImageHeader.info.biWidth *
      fImageHeader.info.biHeight * 4;
    fImageHeader.header.bfOffBits := sizeof(BITMAPFILEHEADER) + sizeof
      (BITMAPINFOHEADER);

    fImageHeader.info.biSize := sizeof(BITMAPINFOHEADER);
    fImageHeader.info.biPlanes := 1;
    fImageHeader.info.biBitCount := fImageHeader.info.biBitCount div 8;

    result := TMemoryStream.Create;
    result.Write(fImageHeader.header, sizeof(BITMAPFILEHEADER));
    result.Write(fImageHeader.info, sizeof(BITMAPINFOHEADER));
    result.Write(fImageHeader.pal[0], 255);
    result.Write(fRGBA[0], fImageHeader.info.biWidth * fImageHeader.info.biHeight * 4);
  end;
end;

class function TEushullyAGF.isFormat(tstFile: TEushullyFile): boolean;
var
  header: TAGFHeader;
begin
  tstFile.seek(0);
  tstFile.read(header, sizeof(TAGFHeader));
  result := (header.sign = AGF_SIGN);
end;

end.
