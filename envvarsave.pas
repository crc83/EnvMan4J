unit EnvVarSave;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function SetGlobalEnvironment(const Name, Value: string;
  const User: Boolean = True): Boolean;

implementation
uses
registry,windows;

{*********************************************}
{ Set Global Environment Function             }
{ Coder : Kingron,2002.8.6                    }
{ Bug Report : Kingron@163.net                }
{ Test OK For Windows 2000 Advance Server     }
{ Parameter:                                  }
{ Name : environment variable name            }
{ Value: environment variable Value           }
{ Ex: SetGlobalEnvironment('MyVar','OK')      }
{*********************************************}
resourcestring
  REG_MACHINE_LOCATION = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';
  REG_USER_LOCATION = 'Environment';


function SetGlobalEnvironment(const Name, Value: string;
  const User: Boolean = True): Boolean;
begin
  with TRegistry.Create do
    try
      if User then { User Environment Variable }
        Result := OpenKey(REG_USER_LOCATION, True)
      else { System Environment Variable }
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        Result  := OpenKey(REG_MACHINE_LOCATION, True);
      end;
      if Result then
      begin
        WriteString(Name, Value); { Write Registry for Global Environment }
        { Update Current Process Environment Variable }
        SetEnvironmentVariable(PChar(Name), PChar(Value));
        { Send Message To All Top Window for Refresh }
        SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(PChar('Environment')));
      end;
    finally
      Free;
    end;
end; { SetGlobalEnvironment }

end.

