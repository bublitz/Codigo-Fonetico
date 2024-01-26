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

    // Tira acentos
    aux := StringReplace(aux, '¡', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '¬', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '√', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '¿', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'ƒ', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '≈', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '…', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' ', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '»', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'À', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Õ', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Œ', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ã', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'œ', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '”', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '‘', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '’', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '“', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '÷', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '⁄', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '€', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ÿ', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '‹', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '«', 'S', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '—', 'N', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, '›', 'Y', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'ü', 'Y', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Y', 'Y', [rfReplaceAll, rfIgnoreCase]);

    for i := 1 to Length(aux) do
      if Ord(aux[i]) > 127 then
        aux[i] := #32;

    // Retira E , DA, DE e DO do nome
    // JosÈ da Silva = JosÈ Silva
    // Jo„o Costa e Silva = Jo„o Costa Silva
    aux := StringReplace(aux, ' DA ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' DAS ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' DE ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' DI ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' DO ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' DOS ', '', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, ' E ', '', [rfReplaceAll, rfIgnoreCase]);

    // Retira letras duplicadas
    // Elizabette = Elizabete
    for i := 1 to Length(aux)-1 do
      if aux[i] = aux[i+1] then
        Delete(aux, i, 1);

    {
      As alteraÁıes nas regras abaixo s„o sugestıes do
      VinÌcius de Lucena Bonoto, na sua monografia de conclus„o do curso de
      Bacharel em CiÍncia da ComputaÁ„o na
      FAGOC - Faculdade Governador Ozanam Coelho
      Ub·/MG - 2011
    }

    novo := '';
    for i := 1 to Length(aux) do
    begin
      case aux[i] of
        // 'A','E','I','O','U','Y','H' e espaÁos: ignora

        'B','D','F','J','K','L','M','R','T','V':
          novo := novo + aux[i];

        'C':  // CH = X
          if aux[i+1] = 'H' then
            novo := novo + 'X'
          else // Carol = Karol
          if CharInSet(aux[i+1], ['A','O','U']) then
            novo := novo + 'K'
          else
          if aux[i-1] = 'X' then
            novo := novo + 'S'
          else // Celina = Selina
          if CharInSet(aux[i+1], ['E','I']) then
            novo := novo + 'S'
          else
          if CharInSet(aux[i+1], ['R','L']) then
            novo := novo + 'K';

        'G': // Jeferson = Geferson
          if CharInSet(aux[i+1], ['E','I']) then
            novo := novo + 'J'
          else
            novo := novo + 'G';

        'N': // Nilton e Niltom
          if (i = Length(aux)) or (aux[i+1] = ' ') then
            novo := novo + 'M'
          else
            novo := novo + 'N';

        'P': // Phelipe = Felipe
           if aux[i+1] = 'H' then
             novo := novo + 'F'
           else
             novo := novo + 'P';

        'Q': // Keila = Queila
           if aux[i+1] = 'U' then
             novo := novo + 'K'
           else
             novo := novo + 'Q';

        'S':
          if i<Length(aux) then
            case aux[i+1] of
             'H': // SH = X
               novo := novo + 'X';

             'A','E','I','O','U':
               if CharInSet(aux[i-1], ['A','E','I','O','U']) then
                 novo := novo + 'Z' // S entre duas vogais = Z
               else
                 novo := novo + 'S';
            end
          else
           if aux[i-1] = 'C' then
            novo := novo + 'KS'
           else
             if (i = Length(aux)) or (aux[i+1] = ' ') then
               novo := novo + 'S';

        'U':
           if CharInSet(aux[i - 1], ['A','E','I','O','U']) then
             novo := novo + 'L';

        'W': // Walter = Valter
           novo := novo + 'V';

        'X': // Walter = Valter
          if (i = Length(aux)) or (aux[i+1] = ' ') then
             novo := novo + 'KS'
           else
             novo := novo + 'X';

        'Z': // no final do nome tem som de S -> Luiz = Luis
           if (i = Length(aux)) or (aux[i+1] = ' ') then
             novo := novo + 'S'
           else
             if (i = Length(aux)) or (aux[i+1] = ' ') then
               novo := novo + 'S' ;
      end;
    end;

    CodiFonPT_BR := PChar(novo);
  except
    CodiFonPT_BR := PChar(novo);
  end;
end;

end.
