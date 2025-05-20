unit untCodFon;

interface

uses
  SysUtils;

function CodiFonPT_BR(nome: PChar): PChar; cdecl; export;

implementation

function RemoverAcentos(const AStr: string): string;
const
  AcentosOrigin = '¡¬√¿ƒ≈… »ÀÕŒÃœ”‘’“÷⁄€Ÿ‹«—›ü';
  AcentosSubsti = 'AAAAAAEEEEIIIIOOOOOOUUUCNYY';
var
  i: Integer;
begin
  Result := AStr;
  for i := 1 to Length(AcentosOrigin) do
    Result := StringReplace(Result, AcentosOrigin[i], AcentosSubsti[i], [rfReplaceAll, rfIgnoreCase]);
end;

function RemoverConjuncoes(const AStr: string): string;
const
  Conjuncoes: array of String = ['DA', 'DAS', 'DE', 'DI', 'DO', 'DOS', 'E'];
var
  i: Integer;
  Palavras: TArray<string>;
begin
  Result := AStr;
  Palavras := Result.Split([' ']);
  for i := 0 to Length(Palavras) - 1 do
    if Palavras[i] <> '' then
      if Palavras[i].ToUpper = 'DA' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'DAS' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'DE' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'DI' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'DO' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'DOS' then
        Palavras[i] := ''
      else if Palavras[i].ToUpper = 'E' then
        Palavras[i] := '';

  Result := string.Join(' ', Palavras);
end;

function CodiFonPT_BR(nome: PChar): PChar;
var
  i: integer;
  novo, aux: string;

begin
  try
    // Adicione SysUtils em uses
    aux := AnsiUpperCase(nome);
    aux := RemoverAcentos(aux);
    aux := RemoverConjuncoes(aux);
    aux := RemoverDuplicatas(aux);

    {
      As alteraÁıes nas regras abaixo s„o sugestıes do
      VinÌcius de Lucena Bonoto, na sua monografia de conclus„o do curso de
      Bacharel em CiÍncia da ComputaÁ„o na
      FAGOC - Faculdade Governador Ozanam Coelho
      Ub·/MG - 2011
    }

    novo := '';
    i := 1;
    while i <= Length(aux) do
    begin
      case aux[i] of
        'B','D','F','J','K','L','M','R','T','V':
          novo := novo + aux[i];
        'C':
          if (i < Length(aux)) and (aux[i+1] = 'H') then
          begin
            novo := novo + 'X';
            Inc(i);
          end
          else if (i < Length(aux)) and (aux[i+1] in ['A','O','U','R','L']) then
            novo := novo + 'K'
          else if (i < Length(aux)) and (aux[i+1] in ['E','I']) then
            novo := novo + 'S';
        'G':
          if (i < Length(aux)) and (aux[i+1] in ['E','I']) then
            novo := novo + 'J'
          else
            novo := novo + 'G';
        'N':
          if (i = Length(aux)) or (aux[i+1] = ' ') then
            novo := novo + 'M'
          else
            novo := novo + 'N';
        'P':
          if (i < Length(aux)) and (aux[i+1] = 'H') then
          begin
            novo := novo + 'F';
            Inc(i);
          end
          else
            novo := novo + 'P';
        'Q':
          if (i < Length(aux)) and (aux[i+1] = 'U') then
          begin
            novo := novo + 'K';
            Inc(i);
          end
          else
            novo := novo + 'Q';
        'S':
          if (i < Length(aux)) and (aux[i+1] = 'H') then
          begin
            novo := novo + 'X';
            Inc(i);
          end
          else if (i > 1) and (i < Length(aux)) and (aux[i-1] in ['A','E','I','O','U']) and (aux[i+1] in ['A','E','I','O','U']) then
            novo := novo + 'Z'
          else
            novo := novo + 'S';
        'W':
          novo := novo + 'V';
        'X':
          novo := novo + 'X';
        'Z':
          if (i = Length(aux)) or (aux[i+1] = ' ') then
            novo := novo + 'S'
          else
            novo := novo + 'Z';
      end;
      Inc(i);
    end;

    Result := PChar(novo);
  except
    Result := PChar('');
  end;
end;

end.
