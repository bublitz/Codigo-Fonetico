unit untMain;

interface

uses
  SysUtils;

function CodiFonPT_BR(nome: PChar): PChar; cdecl; export;

implementation

function CodiFonPT_BR(nome: PChar): PChar;
var
  i: integer;
  novo, aux: string;

begin
  try
    // Adicione SysUtils em uses
    aux := AnsiUpperCase(nome);

    // Tira acentos
    aux := StringReplace(aux, 'Á', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Â', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ã', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'À', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ä', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Å', 'A', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'É', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ê', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'È', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ë', 'E', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Í', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Î', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ì', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ï', 'I', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ó', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ô', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Õ', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ò', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ö', 'O', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ú', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Û', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ù', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ü', 'U', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ç', 'S', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ñ', 'N', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ý', 'Y', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Ÿ', 'Y', [rfReplaceAll, rfIgnoreCase]);
    aux := StringReplace(aux, 'Y', 'Y', [rfReplaceAll, rfIgnoreCase]);

    for i := 1 to Length(aux) do
      if Ord(aux[i]) > 127 then
        aux[i] := #32;

    // Retira E , DA, DE e DO do nome
    // José da Silva = José Silva
    // João Costa e Silva = João Costa Silva
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
      As alterações nas regras abaixo são sugestões do
      Vinícius de Lucena Bonoto,
      monografia
      Bacharel em Ciência da Computação
      FAGOC - Faculdade Governador Ozanam Coelho
      Ubá/MG - 2011
    }

    novo := '';
    for i := 1 to Length(aux) do
    begin
      case aux[i] of
        // 'A','E','I','O','U','Y','H' e espaços: ignora

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
           case aux[i+1] of
             'H': // SH = X
               novo := novo + 'X';

             'A','E','I','O','U':
               if CharInSet(aux[i-1], ['A','E','I','O','U']) then
                 novo := novo + 'Z' // S entre duas vogais = Z
               else
                 novo := novo + 'S';
           else
             if aux[i-1] = 'C' then
              novo := novo + 'KS'
             else
               if (i = Length(aux)) or (aux[i+1] = ' ') then
                 novo := novo + 'S';
           end;

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
    CodiFonPT_BR := PChar('');
  end;
end;

end.
