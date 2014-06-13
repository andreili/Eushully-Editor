unit EushullyFS;

interface

uses
  Classes, SysUtils, EushullyALF, EushullyFile, ComCtrls;

type
  TEushullyFS = class
  private
    f_root: string;
    f_archives_count: UInt32;
    f_archives: array of TEushullyALF;

    function getLoaded(): boolean;
    function getRoot(): string;
    function getArchive(FileName: string): TEushullyALF;
    function getMainArchive(): TEushullyALF;

    procedure onFile(FileIterator: TSearchRec);
  public
    destructor Destroy(); override;
    function load(path: string): boolean;
    procedure unload();

    property Loaded: boolean read getLoaded;
    property Root: string read getRoot;
    property Archive[FileName: string]: TEushullyALF read getArchive;
    property MainArchive: TEushullyALF read getMainArchive;

    procedure MakeTree(Tree: TTreeView; parent: TTreeNode);
    function getArchiveByFile(FileName: string): TEushullyALF;

    function open(FileName: string): TEushullyFile;
  end;

implementation

destructor TEushullyFS.Destroy();
begin
  unload();
end;

procedure TEushullyFS.onFile(FileIterator: TSearchRec);
begin
  if (TEushullyALF.isFormat(FileIterator.Name)) then
  begin
    SetLength(self.f_archives, f_archives_count + 1);
    self.f_archives[f_archives_count] := TEushullyALF.Create();
    if (not self.f_archives[f_archives_count].LoadFromFile(FileIterator.Name))
      then
      self.f_archives[f_archives_count] := nil;
    inc(f_archives_count);
  end;
end;

function TEushullyFS.load(path: string): boolean;
var
  rec: TSearchRec;
begin
  self.f_root := path;

  if FindFirst(IncludeTrailingPathDelimiter(path) + '*.*',
    faAnyFile - faDirectory, rec) = 0 then
  begin
    repeat
      onFile(rec);
    until FindNext(rec) <> 0;
    FindClose(rec);
  end;

  result := (f_archives_count > 0);
end;

procedure TEushullyFS.unload();
var
  i: integer;
begin
  for i := 0 to self.f_archives_count - 1 do
    self.f_archives[i].Free;
  SetLength(self.f_archives, 0);
  self.f_archives_count := 0;
end;

function TEushullyFS.getLoaded(): boolean;
begin
  result := (f_archives_count > 0);
end;

function TEushullyFS.getRoot(): string;
begin
  result := self.f_root;
end;

function TEushullyFS.getArchive(FileName: string): TEushullyALF;
var
  i: integer;
begin
  for i := 0 to self.f_archives_count - 1 do
    if (self.f_archives[i].isExist(FileName)) then
    begin
      result := self.f_archives[i];
      Exit;
    end;
  result := nil;
end;

function TEushullyFS.getMainArchive(): TEushullyALF;
var
  i: integer;
begin
  for i := 0 to self.f_archives_count - 1 do
    if (self.f_archives[i].ArchiveType = ALF_DATA) then
    begin
      result := self.f_archives[i];
      Exit;
    end;
  result := nil;
end;

procedure TEushullyFS.MakeTree(Tree: TTreeView; parent: TTreeNode);
var
  i, j: integer;
  alf: TEushullyALF;
  alf_node: TTreeNode;
begin
  for i := 0 to self.f_archives_count - 1 do
  begin
    alf := f_archives[i];
    alf_node := Tree.Items.AddChild(parent, ExtractFileName(alf.Name));
    alf_node.Data := alf;
    for j := 0 to alf.FilesCount - 1 do
    begin
      if (alf.FileName[j] <> '@') then
        Tree.Items.AddChild(alf_node, alf.FileName[j]).Data := Pointer(j);
    end;
  end;
  Tree.Selected := parent;
end;

function TEushullyFS.getArchiveByFile(FileName: string): TEushullyALF;
var
  i: integer;
begin
  for i := 0 to self.f_archives_count - 1 do
    if (self.f_archives[i].isExist(FileName)) then
    begin
      result := f_archives[i];
      Exit;
    end;
  result := nil;
end;

function TEushullyFS.open(FileName: string): TEushullyFile;
begin
  result := TEushullyFile.Create(self.Archive[FileName], self.Root, FileName);
end;

end.
