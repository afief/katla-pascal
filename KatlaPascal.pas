program KatlaInPascal;

uses crt, sysutils, KatlaWords;

type word = array[1..5] of string;

const green: string = '🟩';
const yellow: string = '🟨';
const white: string = '⬜';

var userInput: string;
var guessCount: integer = 1;
var answer: string;
var answered: boolean = false;

var userInputs: array[1..6] of string;
var userResults: array[1..6] of word;

procedure printHeader();
begin
  writeln('Petunjuk');
  writeln('- Tebak sebuah kata valid 5 huruf dalam KBBI');
  writeln('- Anda memiliki enak kesempatan' + LineEnding);
  writeln('Ketik `keluar` untuk keluar dari permainan');
  writeln('--------------------------------------' + LineEnding)
end;

procedure printResult();
var i, j: integer;
begin
  for i := 1 to 6 do
  begin
    if userResults[i, 1] <> '' then
    begin
      for j := 1 to 5 do write(userInputs[i][j] + '  ');
      writeln();
      for j := 1 to 5 do write(userResults[i, j] + ' ');
      writeln();
    end
  end;
  writeln();
end;

function isYellow(input: string; position: integer): boolean;
var i:integer;
var countOfYellow: integer = 0; countOfUnmatched: integer = 0;
begin
  for i := 1 to Length(answer) do
    if (answer[i] = input[position]) and (answer[i] <> input[i]) then countOfUnmatched := countOfUnmatched + 1;
  for i:= 1 to position do
    if (input[i] = input[position]) and (answer[i] <> input[i]) then countOfYellow := countOfYellow + 1;
  isYellow := countOfUnmatched >= countOfYellow;
end;

function positionStatus(input: string; position: integer): string;
begin
  if answer[position] = input[position] then positionStatus := green
  else if isYellow(input, position) then positionStatus := yellow
  else positionStatus := white
end;

function getResult(input: string): word;
var i: integer;
begin
  for i := 1 to 5 do getResult[i] := positionStatus(input, i);
end;

function isValidWord(input: string): boolean;
var i: integer;
var kata: string;
begin
  for kata in KatlaWords.words do if input = kata then Exit(true);
  isValidWord := false;
end;

begin
  randomize;
  answer := KatlaWords.words[random(Length(KatlaWords.words)) + 1];
  ClrScr;
  printHeader();
  repeat
    write('Masukkan Jawaban: ');
    ReadLn(userInput);
    if userInput = 'keluar' then Halt(1);
    ClrScr;
    printHeader();

    if Length(userInput) > 5 then begin
      printResult();
      writeln('Lebih dari 5 karakter' + LineEnding);
    end else if Length(userInput) < 5 then begin
      printResult();
      writeln('Kurang dari 5 karakter' + LineEnding);
    end else if not isValidWord(userInput) then begin
      printResult();
      writeln('Tidak ada di dalam KBBI' + LineEnding);
    end else begin
      userResults[guessCount] := getResult(userInput);
      userInputs[guessCount] := userInput;
      printResult();
      guessCount := guessCount + 1;

      if userInput = answer then answered := true;
    end;
  until (guessCount > 6) or answered;

  if answered then writeln('Selamat! Kamu berhasil menebaknya.')
  else writeln('Kamu berlum berhasil menebaknya. Jawabannya adalah ' + answer);
end.