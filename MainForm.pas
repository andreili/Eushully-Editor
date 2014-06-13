unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ComCtrls, StdCtrls, EushullyGame, Grids, ValEdit,
  EushullyALF, EushullyFile, Eushullybin, GR32_Image, GR32, GR32_Resamplers,
  EushullyAGF;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    tv_files: TTreeView;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    m_log: TMemo;
    N1: TMenuItem;
    mm_open: TMenuItem;
    OpenDialog1: TOpenDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    vleParams: TValueListEditor;
    ImgView321: TImgView32;
    PopupMenu1: TPopupMenu;
    oo_extract: TMenuItem;
    procedure mm_openClick(Sender: TObject);
    procedure tv_filesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure oo_extractClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fGame: TEushullyGame;
    fImage: TBitmap32;

    procedure load(path: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  fImage := TBitmap32.Create;
  ImgView321.Bitmap := fImage;
  fGame := nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if (fGame <> nil) then
    fGame.Free;
end;

procedure TForm1.load(path: string);
begin
  if (fGame <> nil) then
    fGame.Free;
  fGame := TEushullyGame.Create();
  fGame.load(path);
  Form1.Caption := 'AGEEditor: "' + fGame.Title + '"';
  fGame.FS.MakeTree(tv_files, tv_files.Items.AddChild(nil, fGame.Title));
  tv_files.Items.Item[0].data := fGame;
  tv_files.SortType := stText
end;

procedure TForm1.mm_openClick(Sender: TObject);
begin
  if (OpenDialog1.Execute()) then
  begin
    load(ExtractFilePath(OpenDialog1.FileName));
  end;
end;

procedure TForm1.oo_extractClick(Sender: TObject);
var
  i: integer;
  f: TEushullyFile;
begin
  if (tv_files.Selected = nil) then
    Exit;
  for i := 0 to tv_files.Items.Count - 1 do
    if (tv_files.Items[i].Selected) and
      (UInt32(tv_files.Items[i].data) < $100000) then
    begin
      f := fGame.FS.open(tv_files.Items[i].Text);
      f.SaveToFile('.\' + tv_files.Items[i].Text);
      f.Free;
    end;
end;

procedure TForm1.tv_filesClick(Sender: TObject);
var
  data: TObject;
  i: integer;
  alf: TEushullyALF;
  f: TEushullyFile;
  bmp: TEushullyAGF;
  str: TMemoryStream;
begin
  if (tv_files.Selected = nil) then
    Exit;
  data := TObject(tv_files.Selected.data);

  vleParams.Strings.Clear;
  if (UInt32(tv_files.Selected.data) < $100000) then
  begin
    // выбран файл
    f := fGame.FS.open(tv_files.Selected.Text);
    vleParams.Values['Размер'] := IntToStr(f.Size);
    if (TEushullyBIN.isFormat(f)) then
      vleParams.Values['Тип'] := 'Eushully Script File'
    else if (TEushullyAGF.isFormat(f)) then
    begin
      bmp:=TEushullyAGF.Create;
      bmp.load(f);
      str:=bmp.toMemory();
      str.Seek(0, soFromBeginning);
      fImage.LoadFromStream(str);
      ImgView321.Bitmap:=fImage;
      str.Free;
      bmp.Free;
    end
    else
      vleParams.Values['Тип'] := '-';
    f.Free;
    // ImgView321.
    // fImage.lo
  end
  else if (data.ClassName = 'TEushullyALF') then
  begin
    // выбран архив
    alf := TEushullyALF(data);
    vleParams.Values['Тип'] := '-';
    vleParams.Values['Заголовок'] := alf.Title;
    vleParams.Values['Файлов'] := IntToStr(alf.FilesCount);
  end
  else if (data.ClassName = 'TEushullyGame') then
  begin
    // выбрана игра
    alf := fGame.FS.MainArchive;
    for i := 0 to alf.SettingsCount - 1 do
    begin
      vleParams.Values[alf.SettingName[i]] := alf.Settings[i];
    end;
  end;
  // vleParams.AutoSizeColumns();
end;

end.
