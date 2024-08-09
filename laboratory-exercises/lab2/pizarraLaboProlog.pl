
% Pizarra usada en las primeras dos clases de labo de Prolog, con ejemplos de Prolog

% 
% Una base de datos relacional es un conjunto de "relaciones". 
% Cada relación viene expresada mediante "tuplas".
%   por ejemplo, una relación "estudiante" puede tener las tuplas:
%    estudiante( juan,  21, barcelona, 'Carrer Aragó 453',    ... ). 
%    estudiante( pedro, 22, barcelona, 'Carrer Viladomat 4',  ... ). 
% 
% Si tenemos las relaciones de "padre" y de "hermano":
%  padre(juan,pedro).                  % el padre de juan es pedro
%  padre(maria,pedro).
%  ...                                 % n tuplas en la relación padre

%  hermano(pedro,vicente).             % el hermano de pedro es vicente
%  hermano(pedro,alberto).
%  ...                                 % m tuplas en la relación hermano
% 
% 
% ¿Cómo podríamos hacer la relación "tio"?  Con n x m tuplas?
%        malgastamos espacio (es información que en realidad ya tenemos!!)
%        problemas de consistencia....   restricciones de integridad
%
%  Solución: bases de datos deductivas
%
%  ponemos una regla:
%     forall S,T   tio(S,T) if exists P  such that padre(S,P) AND hermano(P,T)
%
%    diferentes maneras de expresar estas reglas ("cláusulas de Horn de LPO"):
%  
%          A S,T    tio(S,T)  <--    E P  (  padre(S,P)  &   hermano(P,T)  )
%          A S,T    tio(S,T)   v   - E P  (  padre(S,P)  &   hermano(P,T)  )     -E x p(x)   ===   A x  -p(x)
%          A S,T    tio(S,T)   v     A P -(  padre(S,P)  &   hermano(P,T)  )
%          A S,T    tio(S,T)   v     A P  ( -padre(S,P)  v  -hermano(P,T)  )
%          A S,T,P  tio(S,T)   v            -padre(S,P)  v  -hermano(P,T)
%
%                   tio(S,T)   v  -padre(S,P)  v  -hermano(P,T)        % en las cláusulas de LPO no escribimos los As
%  
%  en prolog:       tio(S,T):-     padre(S,P), hermano(P,T).   ("el tio de S es T si el padre de S es P y el hermano de P es T")
%
% programa Prolog === BD deductiva !!


%1 
padre(juan,pedro).      % el padre de juan es pedro
%2 
padre(maria,pedro).
%3 
hermano(pedro,vicente). % el hermano de pedro es vicente
%4 
hermano(pedro,alberto).
%5 
tio(S,T):- padre(S,P), hermano(P,T).          %el ámbito de las variables es la misma cláusula


%?- tio(juan,Z).
% La pila de backtracking:  cuando llama a hermano(pedro,T), usa la 3. y empila la 4.
% da la respuesta Z = vicente
% y si pido más respuestas (con el ;), entonces el backtracking usa lo empilado como alternativa, y usa la 4.


%?- tio(A,B)
% La pila de backtracking:  
%        cuando llama a padre(S,P), usa la 1. y empila la 2.
%        cuando llama a hermano(pedro,T), usa la 3. y empila la 4.
% da la respuesta:
%     A = juan
%     B = vicente
% en este momento la pila contiene  2,4
% y si pido más respuestas (con el ;), entonces el backtracking usa lo último empilado como alternativa, y usa la 4.
% da la respuesta:
%     A = juan
%     B = alberto
% en este momento la pila contiene  2
% y si pido más respuestas (con el ;), entonces el backtracking usa la 2
%        cuando llama a hermano(pedro,T), usa la 3. y empila la 4.
% da la respuesta:
%     A = maria
%     B = vicente
% en este momento la pila contiene  4
% y si pido más respuestas (con el ;), entonces el backtracking usa la 4
% da la respuesta:
%     A = maria
%     B = alberto
% en este momento la pila queda vacía y termina

%




% Lo que hay en una línea detrás del porcentaje % es un comentario.
% En este archivo pizarraLaboProlog.pl  hay muchos comentarios!

% En Prolog, lo que comienza por Mayúscula o por subrayado  _  son variables.
%
% Lo demás son términos;    juan,  hermano(X,juan),  f(X,a),   f(g(a),Z),   ...

% entramos (en linux) en el swi prolog con el comando swipl
% nos da mensaje de bienvenida y saca el prompt:
% ?-
%
% Ahora podemos decirle que lea este archivo, que se llama  pizarraLaboProlog.pl   :
% ?- [pizarraLaboProlog].
% después de esto, ya podemos hacer consultas:
% ?- padre(juan,X).      % esto es nuestro "objetivo"   (inglés: goal)
% ?- padre(Y,pedro).


% ¿Cómo hace el intérprete de Prolog para "ejecutar" un programa Prolog?
% Busca la primera cláusula en la base de datos cuya "cabeza" sea "unificable" con el objetivo:
%  "cabeza".
%  "cabeza" :- "cola".

%  "unificar" = dadas dos expresiones, dar valores a sus variables, para que sean iguales:

%  el simbolo  = significa "es unificable"

% | ?- f(X,a) = f(b,Y).
% | ?- f(f(X),a)  =  f(Y,Y).
% | ?- f(f(X),a) \=  f(Y,Y).
% | ?- f(f(X),a)  =  f(Y,Z).




%"listas"  [ a, b, f(a), g(f(a,X)), [c], X ]
% []                es la lista vacía
% [ a, b | L ]      la | separa los primeros elementos de la LISTA de los demás elementos

% ?- [a,b,c] = [X|L].

% nota: en realidad una lista [a,b,c] es una notación elegante para el término:   .( a, .(b, .(c,[]) ) )




% Prolog es programación DECLARATIVA. NO imperativa
% Esto hace que los programas sean versátiles: la misma definición nos sirve para muchos tipos de consultas.
% Por ejemplo, podemos declarar (definir) qué es pertenecer a una lista: pert(X,L) "X pertenece a la lista L"


% pert(X,L) = "X pertenece a la lista L"      (en realidad ya existe en swi Prolog, y se llama member)
pert(X, [X|_] ).
pert(X, [_|L] ):- pert(X,L).


%concat(L1,L2,L3) = "L3 es la concatenacion de L1 con L2"                     ya existe y se llama append
concat( [],     L,  L       ).
concat( [X|L1], L2, [X|L3] ):- concat( L1, L2, L3).

% aritmetica!!
% Var is Expresion   = "unifica el resultado de evaluar Expresion con Var"

%fact(N,F) = "F es el factorial de N"  F será  N * (N-1) * ... * 1
fact(0,1):- !.
fact(N,F):- N1 is N-1,  fact(N1,F1), F is N * F1.
% en fact(3,F):  para la 3a llamada recursiva con fact(0,...), usa la cláusula 1 y empila la 2!!

%long(L,N) = "la longitud de L es N"                     ya existe y se llama length
long([],0).
long([_|L],N):- long(L,N1), N is N1+1.


%permutacion(L,P) = "P es una permutacion de la lista L"     n!                     ya existe y se llama permutation

permutacion([],[]).
permutacion([X|L], P):- permutacion(L,P1),     
			concat( Pa,    Pb, P1),
			concat( Pa, [X|Pb], P).


%subcjto(L,S) = "S es un subconjunto de L"  2^n
% Si L es [e1 ... en-1 en]
%           0 ...  0    1  
%                       hay tantos subconjuntos como tiras de n bits
subcjto( [], [] ).
subcjto( [_|L],    S  ):-  subcjto(L,S).
subcjto( [X|L], [X|S] ):-  subcjto(L,S).


%cifras( L, N ) escribe las maneras de obtener N a partir de + - * /      de los elementos de la lista L
% ejemplo:
% ?- cifras( [4,9,8,7,100,4], 380 ).
%    4 * (100-7) + 8         <-------------
%    ((100-9) + 4 ) * 4
%    ...

cifras(L,N):-
    subcjto(L,S),         % S = [4,8,7,100]
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



% Ejemplo para explicar el operador de corte "!":

p(1).                           %1
p(2).                           %2

q(a).                           %3
q(b).                           %4

r(3,4,5).                       %5
r(X,Y,Z):- p(X), q(Y), !, s(Z). %6    el corte ! quita de la pila las alternativas para p(..) q(..) y r(..)
r(5,6,7).                       %7

s(3).                           %8
s(4).                           %9

h(X,Y,Z):- r(X,Y,Z).            %10
% A B C      A B C  

h(a,b,c).                       %11

%% Se comporta así:
%% ?- h(A,B,C), write( [A,B,C] ), nl, fail.
%% [3,4,5]
%% [1,a,3]
%% [1,a,4]
%% [a,b,c]
%% false.



% der( Expr, Var, Der )  == "la derivada de Expr con respecto Var es Der"
der( X, X, 1):- !.
der( C, _, 0):- atomic(C).     % atomic significa que es una expresion constante o un entero
der( A+B, X, U+V ):- der(A,X,U), der(B,X,V). 
der( A*B, X, A*V+B*U ):- der(A,X,U), der(B,X,V). 
% ...


% union( L1, L2, U ) == "U es la union de L1 con L1 (como conjuntos, sin repeticiones)"
union( [],     L,  L ).
union( [X|L1], L2, U     ):-     member(X,L2),   union( L1, L2, U ).
union( [X|L1], L2, [X|U] ):- not(member(X,L2)),  union( L1, L2, U ).


% "not" es "negacion por fallo finito"  "negation by finite failure"
% en realidad el "not" ya está definido en swiprolog, pero si lo tuviéramos que definir, "minot", sería así:
minot( X ):- call(X), !, fail.       %minot( X ):-  X, !, fail.   <--- esto daría error sintáctico; por eso existe el "call"
minot( _ ).




% Haced también los ejercicios de Prolog de los exámenes finales más antiguos (de antes de que existiera el examen de labo).
