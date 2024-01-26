unit untMain;

interface

uses
  SysUtils;

function CodiFonPT_BR(nome: PChar): PChar; cdecl; export;

implementation

function CodiFonPT_BR(nome: PChar): PChar;
var
  i, p: integer;
  novo, aux: string;

begin
  try
    // Adicione SysUtils em uses
    aux := AnsiUpperCase(nome);
    novo := '';

    // Tira acentos
    for i := 1 to Length(aux) do
    begin
      case aux[i] of
        'Á', 'Â', 'Ã', 'À', 'Ä', 'Å': aux[i] := 'A';
        'É', 'Ê', 'È', 'Ë': aux[i] := 'E';
        'Í', 'Î', 'Ì', 'Ï': aux[i] := 'I';
        'Ó', 'Ô', 'Õ', 'Ò', 'Ö': aux[i] := 'O';
        'Ú', 'Û', 'Ù', 'Ü': aux[i] := 'U';
        'Ç': aux[i] := 'C';
        'Ñ': aux[i] := 'N';
        'Ý', 'Ÿ', 'Y': aux[i] := 'I';
      else
        if Ord(aux[i]) > 127 then
          aux[i] := #32;
      end;
    end;

    // Retira E , DA, DE e DO do nome
    // José da Silva = José Silva
    // João Costa e Silva = João Costa Silva
    p := Pos(' DA ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 3);
      p := Pos(' DA ', aux);
    end;
    p := Pos(' DAS ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 4);
      p := Pos(' DAS ', aux);
    end;
    p := Pos(' DE ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 3);
      p := Pos(' DE ', aux);
    end;
    p := Pos(' DI ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 3);
      p := Pos(' DI ', aux);
    end;
    p := Pos(' DO ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 3);
      p := Pos(' DO ', aux);
    end;
    p := Pos(' DOS ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 4);
      p := Pos(' DOS ', aux);
    end;
    p := Pos(' E ', aux);
    while p > 0 do
    begin
      Delete(aux, p, 2);
      p := Pos(' E ', aux);
    end;

    // Retira letras duplicadas
    // Elizabette = Elizabete
    for i := 1 to Length(aux)-1 do
      if aux[i] = aux[i+1] then
        Delete(aux, i, 1);

    for i := 1 to Length(aux) do
    begin
      case aux[i] of
        // 'A','E','I','O','U','Y','H' e espaços: ignora

        'B','D','F','J','K','L','M','N','R','T','V','X':
          novo := novo + aux[i];

        'C':  // CH = X
          if aux[i+1] = 'H' then
            novo := novo + 'X'
          else // Carol = Karol
          if aux[i+1] in ['A','O','U'] then
            novo := novo + 'K'
          else // Celina = Selina
          if aux[i+1] in ['E','I'] then
            novo := novo + 'S';

        'G': // Jeferson = Geferson
          if aux[i+1] = 'E' then
            novo := novo + 'J'
          else
            novo := novo + 'G';

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
               if aux[i-1] in ['A','E','I','O','U'] then
                 novo := novo + 'Z' // S entre duas vogais = Z
               else
                 novo := novo + 'S';
           else
             if (i = Length(aux)) or (aux[i+1] = ' ') then
               novo := novo + 'S';
           end;

        'W': // Walter = Valter
           novo := novo + 'V';

        'Z': // no final do nome tem som de S -> Luiz = Luis
           if (i = Length(aux)) or (aux[i+1] = ' ') then
             novo := novo + 'S'
           else
             novo := novo + 'Z';
      end;
    end;
    //novo := novo + ' ';
    CodiFonPT_BR := PChar(novo);
  except
    CodiFonPT_BR := PChar('');
  end;
end;

end.
