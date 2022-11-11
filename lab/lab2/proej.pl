%prod(L,P) -> P es el producto de todos los elementos de L
prod([], 1). 
prod([X|L], P) :- prod(L, P1), P is P1*X.

%pescalar(L1, L2, P) -> P es el producto escalar de L1*L2
pescalar([],[],0).
pescalar([X|L], [Y|L2], P) :- pescalar(L, L2, P1), P is P1 + X*Y.

%reunion(L1, L2, R) -> R es la unión (sin repeticiones) de L1 y L2
union([], L, L).
union([X|L1], L2, R) :- member(X, L2), union(L1, L2, R).
union([X|L1], L2, [X|R]) :- \+member(X,L2), union(L1,L2,R).

%intersect(L1, L2, R) -> R es la intersección como conjunto (sin repeticiones) de L1 y L2
intersect([], _, []).
intersect(_, [], []).
intersect([X|L1], L2, [X|R]) :- member(X,L2), intersect(L1, L2, R).
intersect([X|L1], L2, R) :- \+member(X,L2), intersect(L1, L2, R).

%mylast(L, La) == La es el último elemento de L
mylast(L, La) :- append([], [La], L).
mylast([X|L], La) :- mylast(L, La).

%myreverse(L, LR) --> LR es el reverso de la lista LR
myreverse([], []).
myreverse([X|L], LR) :- myreverse(L, L1), append(L1, [X], LR).

%fib(N,F) --> n es el N-ésimo número de Fibonacci
fib(0, 0) :- !.
fib(1,1) :- !.
fib(N, F) :- N1 is N - 1, N2 is N - 2, fib(N1, F1), fib(N2, F2), F is F1 + F2.

%valid(P) --> dado valido
valid(6).
valid(5).
valid(4).
valid(3).
valid(2).
valid(1).

%dados(P,N,L) --> la lista L expresa una manera de sumar P puntos lanzando N dados
dados(P, 1, [P]) :- valid(P).
dados(P, N, [P1|L1]) :- N > 0, N1 is N - 1, valid(P1), P2 is P - P1, dados(P2, N1, L1).


suma([], 0).
suma([X|L], S) :-suma(L, S1), S is S1 + X.

%suma_demas(L) --> Hay un elemento que es la suma de los demas
suma_demas([X|X]).
suma_demas([X|L]) :- suma(L, S), X =:= S ; suma_demas_rec(L, [X]).

suma_demas_rec([X], L2) :- suma(L2, S), X =:= S.
suma_demas_rec([X|L1], L2) :- suma(L2, S), X =:= S ; suma_demas_rec(L1, [X|L2]).

%suma_ants(L) --> hay un elemento que es la suma de los anteriores.
suma_ants([X|X]).
suma_ants([X|L]) :- suma_ants_rec([X], L).

suma_ants_rec(L1, [X]) :- suma(L1, S), X =:= S.
suma_ants_rec(L1, [X|L2]) :- suma(L1, S), X =:= S ; suma_ants_rec([X|L1], L2).

%card(L) --> para cada elemento dice el numero de apariciones
card(L) :- reccard(L, L2), write(L2).

%reccard(L1, L2) --> L2 es la lista cardinal de L1
reccard([], []).
reccard([X|L1], [N|L2]) :- count(X, [X|L1], N), delete(L1, X, L3), reccard(L3, L2).

%count(X, L, N) --> N es el numero de apariciones de X en L
count(X, [], [X,0]).
count(X, [X|L], [X,N]) :- count(X, L, [X,N2]), N is N2 + 1, !.
count(X, [_|L], [X,N]) :- count(X, L, [X,N]). 

%esta_ordenada(L) --> L esta ordenada de menor a mayor
esta_ordenada([]).
esta_ordenada([X|[]]) :- !.
esta_ordenada([X,Y|L1]) :- X < Y, esta_ordenada([Y|L1]). 

%ord(L1,L2) --> L2 es la lista de enteros de L1 ordenada de menor a mayor.
ord(L1, L2) :- permutation(L1, L2), esta_ordenada(L2), !.

%diccionario(A,N) --> escribe todas las palabras de N simbolos del diccionario A.
diccionario(A, N) :- combination(A, N, C), printPar(C), write(' '), fail.

printPar([]).
printPar([X|C]) :- write(X), printPar(C).

%combination(A, N, C) --> C es una combinacion de N elementos de la lista a
combination(_, 0, []):- !.
combination(A, N, [X|C]) :- member(X, A), N1 is N - 1, combination(A, N1, C).

%palindromos(L) --> escribe todas las permutaciones de L que sean palindromos
aaaa([]) :- write('[]').
palindromos(L) :- espalindrom(L, L1), write(L1), nl, fail.

%espalindrom(L1, L2) --> L2 es un palindrom amb els elements de L2
espalindrom([], []).
espalindrom(L1, L2) :- permutation(L1, L2), reverse(L1, L2).

%sendmoney --> ejercicio 14
sendMoney:-  Letters = [S, E, N, D, M, O, R, Y, _, _],
                                Numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                                permutation(Letters, Numbers),
                                S1 is 1000 * S + 100 * E + 10 * N + D +
                                         1000 * M + 100 * O + 10 * R + E,
                                S1 is 10000 * M + 1000 * O + 100 * N + 10 * E + Y,
                                escriutResult(Letters), fail.
                                
escriutResult([S, E, N, D, M, O, R, Y, _, _]):-
                    nl,
                    write('S = '), write(S), nl,
                    write('E = '), write(E), nl,
                    write('N = '), write(N), nl,
                    write('D = '), write(D), nl,
                    write('M = '), write(M), nl,
                    write('O = '), write(O), nl,                                                 
                    write('R = '), write(R), nl,
                    write('Y = '), write(Y), nl.


%der( Expr, Var, Der )  == "la derivada de Expr con respecto Var es Der"
der(X, X, 1):- !.
der(C, _, 0):- atomic(C).     % atomic significa que es una expresion constante o un entero
der( A+B, X, U+V ):- der(A,X,U), der(B,X,V). 
der( A*B, X, A*V+B*U ):- der(A,X,U), der(B,X,V). 

%simplifica(F1, F2) --> F2 es F1 simplificada.
simplifica(X, X) :- \+ atomic(X).
simplifica(C, C) :- atomic(C).
simplifica(C + EXP,EXP3) :- atomic(C), simplifica(EXP, EXP2), simplifica(C + EXP2, EXP3), \+ atomic(X). 
simplifica(C - EXP, EXP3) :- atomic(C), simplifica(EXP, EXP2), simplifica(C + EXP2, EXP3), \+ atomic(X).
simplifica(C*EXP, C*EXP) :- atomic(C), simplifica(EXP, EXP2), simplifica(C + EXP2, EXP3), \+ atomic(X).
simplifica(C1 + C2, C3) :- atomic(C1), atomic(C2), C3 is C1 + C2.
simplifica(C1 - C2, C3) :- atomic(C1), atomic(C2), C3 is C1 - C2.
simplifica(C1 * C2, C3) :- atomic(C1), atomic(C2), C3 is C1 * C2.
simplifica(C1 + C2, C3) :- atomic(C1), atomic(C2), C3 is C1 + C2.
simplifica(C1 - C2, C3) :- atomic(C1), atomic(C2), C3 is C1 - C2.
simplifica(C1 * C2, C3) :- atomic(C1), atomic(C2), C3 is C1 * C2.
simplifica(C1 + C2 + EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(C3 + EXP, EXP2).
simplifica(C1 - C2 + EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(C3 + EXP, EXP2).
simplifica(C1 * C2 + EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 * C2, atomic(C3), simplifica(C3 + EXP, EXP2).
simplifica(C1 + C2 - EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(C3 - EXP, EXP2).
simplifica(C1 - C2 - EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(C3 - EXP, EXP2).
simplifica(C1 * C2 - EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 * C2, atomic(C3), simplifica(C3 - EXP, EXP2).
simplifica(C1 + EXP + C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(C3 + EXP, EXP2).
simplifica(C1 - EXP + C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(C3 - EXP, EXP2).
simplifica(C1 + EXP - C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(C3 + EXP, EXP2).
simplifica(C1 - EXP - C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(C3 - EXP, EXP2).
simplifica(EXP + C1 + C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(EXP + C3, EXP2).
simplifica(EXP + C1 - C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(EXP + C3, EXP2).
simplifica(EXP - C1 + C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, atomic(C3), simplifica(EXP - C3, EXP2).
simplifica(EXP - C1 - C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 - C2, atomic(C3), simplifica(EXP - C3, EXP2).
simplifica(EXP + C1 * C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 * C2, atomic(C3), simplifica(EXP + C3, EXP2).
simplifica(EXP - C1 * C2, EXP2) :- atomic(C1), atomic(C2), C3 is C1 * C2, atomic(C3), simplifica(EXP - C3, EXP2).
simplifica(C1*X + C2*X, C3*X) :- atomic(C1), atomic(C2), C3 is C1 + C2.
simplifica(C1*X + C2*X + EXP, EXP2) :- atomic(C1), atomic(C2), C3 is C1 + C2, simplifica(C3*X + EXP, EXP2).



%domino(16)
p([],[]).
p(L,[X|P]) :- select(X,L,R), p(R,P).

dom(L) :- p(L,P), llistagir(P, P2), ok(P2), write(P2), nl.
dom(_) :- write('no hay cadena'), nl.

ok([]).
ok([f(X,Y)]).
ok([f(X,Y), f(Y,Z)|P]) :- ok([f(Y,Z)|P]).

gir(f(X,Y), f(Y,X)).

llistagir([],[]).
llistagir([X|L1], [Y|L2]) :- gir(X, Y), llistagir(L1, L2).
llistagir([X|L1], [X|L2]) :- llistagir(L1, L2).



%SATSOLVER
%p:- readclauses(F), sat([],F).
%p:- write(’UNSAT’),nl.
%sat(I,[]):- write(’IT IS SATISFIABLE. Model: ’), write(I),nl,!.
%sat(I,F) :- 

%decision lit(F,Lit), % Select unit clause if any; otherwise, an arbitrary one.
%simplif(Lit,F,F1), % Simplifies F. Warning: may fail and cause backtracking
%sat( ... , ... ).


%SMOKERS (0 == healtySmoker, 1 == cancerSmoker, 2 == healtyNonsmoker, 3 == cancerNonSomker)
smokers :- personList([A1,B1,C1,D1], 4), suma([A1,B1,C1,D1], 10), 
            D1 < B1,
            personList([A2,B2,C2,D2], 4), suma([A2,B2,C2,D2], 10), 
            D2 < B2, 
            D3 is D1 + D2,
            B3 is B1 + B2,
            D3 > B3,
            write([A1,B1,C1,D1]), write(' '), write([A2,B2,C2,D2]), nl, fail. 
    
            

personList([], 0, 0) :- !.
personList([X|L], N, S) :- N1 is N - 1, between(0,2,X), personList(L, N1).

%numA(X, L, N) --> N es el numero de apariciones de X en L
numA(X, [], 0).
numA(X, [X|L], N) :- numA(X, L, N2), N is N2 + 1, !.
numA(X, [_|L], N) :- numA(X, L, N). 

%maq(L,C,M) --> te da una combinacion con el menor numero de monedas que sumen C
maq(L,C,M) :- maqrec(L,C,M,1).

%maqrec(L,C,M,S)
maqrec(L,C,M,S) :- length(L, N), randomList(M, N, S), monedas(L,C,M).
maqrec(L,C,M,S) :- S1 is S + 1, length(L, N), maqrec(L,C,M,S1), !.

%randomList(L,N,S) --> L es una lista de tamaño N con suma S
randomList([], 0, 0) :- !.
randomList([S], 1, S) :- !.
randomList([X|L], N, S) :- N1 is N - 1, S > 0, between(0,S,X), S1 is S - X, randomList(L,N1, S1).

%monedas(L,C,M) --> M es una combinacion de L que da C
monedas(L, C, M) :- length(M, N), length(L, N), pescalar(L, M, C).

%flatten(L, F) --> F es la lista aplanada de L
myflatten([], []) :- !.
myflatten([L|Ls], F) :-
    myflatten(L, F1),
    myflatten(Ls, F2),
    append(F1, F2, F), !.
myflatten(L, [L]).

%log(B,N,L) --> L es la parte entera del logaritmo en base B de L
log(B, 1, 0) :- !.
log(B, N, L) :- between(1,N,L), L1 is L + 1, N1 is B**L, N2 is B**L1, N1 =< N, N2 > N, !.

%li(N,M,L,S) --> respuesta al ejercicio 22
li(N, M, L, S) :- numlist(S1, N), subcjto(S1, S), length(S, M), compatible(L, S).

%compatible(L, S).
compatible([], _) :- !.
compatible([[X,Y]|L], S) :- compatible(L, S), \+member(X, S).
compatible([[X,Y]|L], S) :- compatible(L, S), \+member(Y, S).

%numlist(L, N).
numlist([], 0) :- !.
numlist([N|L], N) :- N1 is N - 1, numlist(L, N1). 

%subcjto(L,S) = "S es un subconjunto de L"
subcjto( [], [] ).
subcjto( [_|L],    S  ):-  subcjto(L,S).
subcjto( [X|L], [X|S] ):-  subcjto(L,S).
