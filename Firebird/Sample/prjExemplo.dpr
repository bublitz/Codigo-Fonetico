program prjExemplo;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {Form1},
  untCodFon in '..\untCodFon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
