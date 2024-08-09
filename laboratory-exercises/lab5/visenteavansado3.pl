camino( 0, _, _, E,E, C,C ). % Caso base: cuando el estado actual es el estado final.
camino( CosteMax, N, P, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ) :-
    CosteMax > 0,
    CosteMax < P,
    unPaso( CostePaso, N, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
    \+ member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino(CosteMax1, N,P ,EstadoSiguiente, EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

%%UN ESTAT ESTA DEFINIT PER EL CANTO DRET I ESQUERRE DEL PONT I UN K: EL PORTADOR DE LA LLANTERNA
manuel:- EstadoInicial = [[1,2,5,8],[],1], EstadoFinal = [[],[1,2,5,8],_], between(1, 1000, CosteMax), % Buscamos solucion de coste 0; si no, de 1, etc.
    camino( CosteMax, N, P, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
    reverse(Camino, Camino1), write(Camino1), write('con coste'), write(CosteMax), nl, halt.  


unPaso(ACTUAL,SEGUENT):-

%%la llanterna si esta a la dreta es 0 i si esta a la esquerra val 1
whichSideIsTheFuckingLantern(_,[],0).
whichSideIsTheFuckingLantern([],_,1).
whichSideIsTheFuckingLantern(A,B,K).
fastest(L,K):- min_list(L,K).

