
%subcjto(N,L,S):- N es el numero de elements que te el subconj S, L es el conjunt principal
subcjto(0, _, []):- !.
subcjto(N,[_|L], S ):- length(L,Num), Num >= N, subcjto(N,L,S).
subcjto(N, [X|L], [X|S] ):-  M is N-1, subcjto(M,L,S).

%cifras( L, N ) escribe las maneras de obtener N a partir de + - * /      de los elementos de la lista L
% ejemplo:
% ?- cifras( [4,9,8,7,100,4], 380 ).
%    4 * (100-7) + 8         <-------------
%    ((100-9) + 4 ) * 4
%    ...

cifras(L,N):-
    length(L,LEN),
    between(1,LEN, Num),
    subcjto(Num,L,S),         % S = [4,8,7,100]
    permutation(S,P),     % P = [4,100,7,8]
    expresion(P,E),       % E = 4 * (100-7) + 8 
    N is E,
    write(E), nl, fail.


% E = ( 4  *  (100-7) )    +    8
%            +
%          /   \
%         *     8
%        / \
%       4   -
%          / \
%        100  7


expresion([X],X).
expresion( L, E1 +  E2 ):- append( L1, L2, L), 
			  L1 \= [], L2 \= [],
			  expresion( L1, E1 ),
			  expresion( L2, E2 ).
expresion( L, E1 -  E2 ):- append( L1, L2, L), 
			  L1 \= [], L2 \= [],
			  expresion( L1, E1 ),
			  expresion( L2, E2 ).
expresion( L, E1 *  E2 ):- append( L1, L2, L), 
			  L1 \= [], L2 \= [],
			  expresion( L1, E1 ),
			  expresion( L2, E2 ).
expresion( L, E1 // E2 ):- append( L1, L2, L), 
			  L1 \= [], L2 \= [],
			  expresion( L1, E1 ),
			  expresion( L2, E2 ),
                          K is E2, K\=0.              % evitamos que se produzcan divisiones por cero 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camino( 0, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :-
    CosteMax > 0,
    unPaso( CostePaso, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
    \+ member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino(CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

main :-
    EstadoInicial = [3,3,0,0,true], EstadoFinal = [0,0,3,3,false],
    between(1, 1000, CosteMax), % Buscamos solucion de coste 0; si no, de 1, etc.
    camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
    reverse(Camino, Camino1), write(Camino1), write("con coste"), write(CosteMax), nl, halt.

isCorrect([ML, CL, MR, CR, _]):-
    ML >= 0, MR >= 0, CL >=0, CR >=0,
    ML =< 3, MR =< 3, CL =< 3, CR =< 3,
    dontFuckingEatMySchlong(ML,CL),
    dontFuckingEatMySchlong(MR,CR),!.


dontFuckingEatMySchlong(0,_).
dontFuckingEatMySchlong(M,C):- M>=C.


unPaso(1, EA, ES):-
    unPasoIMM(EA,ES),
    isCorrect(ES).


unPasoIMM([ML,CL,MR,CR,true], [MLN,CLN,MRN,CRN,false]):-
    MLN is ML - 1,
    CLN is CL - 1,
    MRN is MR + 1,
    CRN is CR + 1.


unPasoIMM([ML,CL,MR,CR,true], [ML,CLN,MR,CRN,false]):-
    member(N,[1,2]),
    CLN is CL - N,
    CRN is CR + N.


unPasoIMM([ML,CL,MR,CR,true], [MLN,CL,MRN,CR,false]):-
    member(N,[1,2]),
    MLN is ML - N,
    MRN is MR + N.


unPasoIMM([ML,CL,MR,CR,false], [MLN,CL,MRN,CR,true]):-
    member(N,[1,2]),
    MRN is MR - N,
    MLN is ML + N.

unPasoIMM([ML,CL,MR,CR,false], [ML,CLN,MR,CRN,true]):-
    member(N,[1,2]),
    CRN is CR - N,
    CLN is CL + N.

unPasoIMM([ML,CL,MR,CR,false], [MLN,CLN,MRN,CRN,true]):-
    MRN is MR - 1,
    CRN is CR - 1,
    MLN is ML + 1,
    CLN is CL + 1.
