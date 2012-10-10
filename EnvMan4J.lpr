program EnvMan4J;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unitMain, lazcontrols, EnvVarSave, unithelp, unitSettings;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformHelp, formHelp);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.

