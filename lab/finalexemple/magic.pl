:- use_module(library(clpfd)).


% Complete the following program p(N) that writes a (kind of) magic
% square: an NxN matrix with ALL the numbers 1..N^2, such that the
% sum of every row and every column is equal.
% More precisely, this sum is (N + N^3) / 2.
% Note: don't worry if your program is (too) slow when N >= 6.

%% Example:  (this solution is not unique):
%%
%%    1   2  13  24  25
%%    3   8  18  17  19
%%   16  14  15   9  11
%%   22  20   7  10   6
%%   23  21  12   5   4

main:- p(7), nl, halt.

p(N):-
    NSquare is N*N,
    length(Vars, NSquare),
    
    %% 1. domini
    Vars ins 1..NSquare, %%HOLA ALEX, ESTO DECLARA EL DOMINIO DE LAS VARIABLES [1,N^2]
    all_distinct(Vars),  %%esto obliga a que si var1 tiene valor 1 , var2 esta en el dominio [2, N^2]  por si quieres hacer cuadrados magicos que tengan todos valores diferentes pero no ahce falta
    %%all distinct es la version super potente con grafos bipartitos de all-diferent. Hacen lo mismo pero uno propaga mas potente (Eso si, es mas costoso en tiempo all distinct)
    %% 2.Constraints (resitrcciones y mayoria de codigo)
    
    squareByRows(N,Vars,SquareByRows),
    transpose( SquareByRows, SquareByCols ),  % transpose already exists: no need to implement it
    Sum is (N + N*N*N) // 2,
    constraintsSum( Sum, SquareByRows),
    constraintsSum( Sum, SquareByCols), %%estas funciones son las que realmente añaden los constraints (mirarse la funcion suma en CLP importante, no es la suma cualquiera)
    
    %% 3 labeling es la fase de dar valor a todas las variables (se pueden esocger estrategias y minimizar / maximizar)
    label(Vars),
    %% 4 output (autoexplicativo)
    writeSquare(SquareByRows),nl,!.


squareByRows(_,[],[]):-!.
squareByRows(N,Vars,[Row|SquareByRows]):- append(Row,Vars1,Vars), length(Row,N), squareByRows(N,Vars1,SquareByRows),!.

writeSquare(Square):- member(Row,Square), nl, member(N,Row), write4(N), fail.
writeSquare(_).

constraintsSum(_,[]):-!. %%abre la documentacion para saber que hace sum. Le estoy obligando a  que todas las columnas sumen exactamente el valor Sum 
constraintsSum(Sum,[Row | SquareByRows]) :- sum(Row, #=, Sum), constraintsSum(Sum,SquareByRows).

write4(N):- N<10,   write('   '), write(N),!.
write4(N):- N<100,  write('  ' ), write(N),!.
write4(N):-         write(' '  ), write(N),!.
