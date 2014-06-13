unit EushullyGame;

interface

uses
  EushullyFS;

type
  TEushullyGame = class
  private
    f_loaded: boolean;
    f_path: string;
    //f_debug: boolean;
    f_fs: TEushullyFS;
    //m_variables: TEushullyVariables;
//    f_stack: tlis
    function getFS(): TEushullyFS;
    function getTitle(): string;
  public
    destructor Destroy(); override;
    function load(path: string): boolean;
    procedure unload();

    property FS: TEushullyFS read getFS;
    property Title: string read getTitle;
  end;

implementation

destructor TEushullyGame.Destroy();
begin
  unload();
end;

function TEushullyGame.load(path: string): boolean;
begin
  self.f_fs:=TEushullyFS.Create();
  self.f_path:=path;
  self.f_loaded:=self.f_fs.load(path);
  result:=self.f_loaded;
end;

procedure TEushullyGame.unload();
begin
  if (f_fs <> nil) then
  begin
    f_fs.Free;
    f_fs:=nil;
  end;
end;

function TEushullyGame.getFS(): TEushullyFS;
begin
  result:=f_fs;
end;

function TEushullyGame.getTitle(): string;
begin
  result:=self.f_fs.MainArchive.Title;
end;

end.

