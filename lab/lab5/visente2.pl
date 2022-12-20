
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
%%
misioneros = [0,0,0]
canibales  = [0,0,0]

%%count(L,X,Reps) para una lista L i un elemento X cuenta las repeticiones
count([],_,0).
count([L|L1],X,Reps):- L \= X, count(L1,X,Reps).
count([X|L1], X, Reps) :- count(L1,X,Reps1), Reps is Reps1+1.

main :- EstadoInicial = ..., EstadoFinal = ...,
between(1, 1000, CosteMax), % Buscamos soluci´on de coste 0; si no, de 1, etc.
camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
reverse(Camino, Camino1), write(Camino1), write(’ con coste ’), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :- CosteMax > 0,
unPaso( CostePaso, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
\+ member( EstadoSiguiente, CaminoHastaAhora ),
CosteMax1 is CosteMax-CostePaso, 
camino(CosteMax1, EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

unPaso(....):- ...