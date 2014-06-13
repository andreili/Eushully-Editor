program eushully;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  EushullyGame in 'EushullyGame.pas',
  lzss in 'lzss.pas',
  EushullyALF in 'EushullyALF.pas',
  EushullyScript in 'EushullyScript.pas',
  eushullybin in 'eushullybin.pas',
  EushullyFile in 'EushullyFile.pas',
  EushullyFS in 'EushullyFS.pas',
  EushullyAGF in 'EushullyAGF.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
