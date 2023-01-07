% Branch-and-bound solution for a Traveling-Salesman-like problem: find the
% shortest route in order to visit all 22 (or the first N) cities starting from
% city 1 (it does not matter in what city the trip ends).
% First try it as it is, and understand how it works.
% Then try to improve it, in order to solve it for more cities than just 12, by:
%   -using the alternative clause 2
%   -replacing in clause 3 the native swiprolog predicate "select" by your own better myselect
% Can you solve the problem for all 22 cities?

numCities(12).

main:- statistics(walltime,_),
	numCities(N),  %try higher numbers here...
	retractall(bestRouteSoFar(_,_)),  assertz(bestRouteSoFar(100000,[])),  % "infinite" distance
	retractall(minDist(_,_)), assertsMinDist, retractall(nearestCities(_, _)), assertsNearestCities, 
	findall(I,between(2,N,I),Cities), tsp( Cities, 0, [1] ).
main:- bestRouteSoFar(Km,ReverseRoute), reverse( ReverseRoute, Route ), nl,
	write('Optimal route: '), write(Route), write('. '), write(Km), write(' km.'), nl, nl,
	statistics(walltime,[MS|_]), S is MS/1000, write(S), write(' seconds.'), nl, halt.

%LBound is the nearest city of City.
lowerBoundOfRemainingCities([], 0).
lowerBoundOfRemainingCities([City|Rest], LBound):-
	lowerBoundOfRemainingCities(Rest, LBoundRest), 
	minDist(City, MinDist), 
	LBound is LBoundRest + MinDist.

myselect(CurrentCity, NextCity, Cities, RemainingCities):- %con CurrentCity podemos calcular la ciudad más cercana no visitada.
	length(Cities, NCities),
	numCities(TotalCities),
	Nivel is TotalCities-NCities,
	Nivel =< 2,
	nearestCities(CurrentCity, List),
	member(NextCity, List),
	member(NextCity, Cities),
	select(NextCity, Cities, RemainingCities).

myselect(_, NextCity, Cities, RemainingCities):-
	select(NextCity, Cities, RemainingCities).

% tsp( Cities, AccumulatedKm, RouteSoFar )
%1
tsp( [], AccumulatedKm, RouteSoFar ):- storeRouteIfBetter(AccumulatedKm,RouteSoFar), fail.

%2
% tsp(  _, AccumulatedKm, _          ):- bestRouteSoFar(Km,_), AccumulatedKm >= Km, !, fail.

%alternative:

tsp( Cities, AccumulatedKm, _ ):-
	bestRouteSoFar(Km,_),
    lowerBoundOfRemainingCities( Cities, LBound ),   %implement this (efficiently)!
    AccumulatedKm+LBound >= Km, !, fail.

%3
tsp( Cities, AccumulatedKm, [ CurrentCity | RouteSoFar ] ):-
	myselect( CurrentCity, City, Cities, RemainingCities ),
    distance( CurrentCity, City, Km ),  AccumulatedKm1 is AccumulatedKm+Km,
    tsp( RemainingCities, AccumulatedKm1, [ City, CurrentCity | RouteSoFar ] ).

storeRouteIfBetter( Km, Route ):-  bestRouteSoFar( BestKm, _ ), Km < BestKm,
    write('Improved solution. New best distance is '), write(Km), write(' km.'),
    statistics(walltime,[MS|_]), S is MS/1000, write(' ('), write(S), write(' s)'), nl,
    retractall(bestRouteSoFar(_,_)), assertz(bestRouteSoFar(Km,Route)),  %this asserts or retracts info from the database.
    !.

matriz([[   0,144,114,105, 31,109,135,132, 85, 79,158, 20, 73,162,127,190,156, 58, 87, 71,154, 55],
	[ 144,  0,144,181,147, 76,195, 73, 64,114,220,135, 71, 18, 39, 60, 37,101, 62,146,205,153],
	[ 114,144,  0, 49, 86,169, 51, 78,130, 42, 76, 94,114,154,105,151,125,137, 94, 46, 61, 66],
	[ 105,181, 49,  0, 73,189, 31,124,152, 67, 52, 88,135,195,146,197,169,147,123, 40, 51, 49],
	[  31,147, 86, 73,  0,128,104,119, 97, 57,126, 17, 82,164,122,184,151, 80, 85, 40,123, 24],
	[ 109, 76,169,189,128,  0,212,126, 38,128,238,112, 54, 92, 95,137,110, 51, 77,148,227,146],
	[ 135,195, 51, 31,104,212,  0,129,174, 85, 26,118,157,206,157,201,176,173,141, 67, 19, 79],
	[ 132, 73, 78,124,119,126,129,  0, 92, 65,153,115, 84, 80, 35, 73, 47,118, 55, 98,136,113],
	[  85, 64,130,152, 97, 38,174, 92,  0, 90,200, 82, 17, 82, 66,120, 89, 36, 39,112,189,111],
	[  79,114, 42, 67, 57,128, 85, 65, 90,  0,111, 59, 73,128, 80,137,106, 95, 57, 33, 99, 48],
	[ 158,220, 76, 52,126,238, 26,153,200,111,  0,141,183,231,182,224,201,198,167, 91, 19,102],
	[  20,135, 94, 88, 17,112,118,115, 82, 59,141,  0, 67,153,114,177,142, 63, 75, 52,137, 39],
	[  73, 71,114,135, 82, 54,157, 84, 17, 73,183, 67,  0, 90, 64,123, 89, 35, 28, 95,172, 95],
	[ 162, 18,154,195,164, 92,206, 80, 82,128,231,153, 90,  0, 49, 47, 35,119, 79,161,214,169],
	[ 127, 39,105,146,122, 95,157, 35, 66, 80,182,114, 64, 49,  0, 62, 28, 99, 40,113,166,124],
	[ 190, 60,151,197,184,137,201, 73,120,137,224,177,123, 47, 62,  0, 34,156,102,170,206,183],
	[ 156, 37,125,169,151,110,176, 47, 89,106,201,142, 89, 35, 28, 34,  0,123, 68,139,183,151],
	[  58,101,137,147, 80, 51,173,118, 36, 95,198, 63, 35,119, 99,156,123,  0, 63,106,190,100],
	[  87, 62, 94,123, 85, 77,141, 55, 39, 57,167, 75, 28, 79, 40,102, 68, 63,  0, 85,154, 91],
	[  71,146, 46, 40, 40,148, 67, 98,112, 33, 91, 52, 95,161,113,170,139,106, 85,  0, 85, 20],
	[ 154,205, 61, 51,123,227, 19,136,189, 99, 19,137,172,214,166,206,183,190,154, 85,  0, 98],
	[  55,153, 66, 49, 24,146, 79,113,111, 48,102, 39, 95,169,124,183,151,100, 91, 20, 98,  0]]).

assertsMinDist:-
	matriz(M), nth1(N, M, Row), select(0, Row, RowWithout0), min_list(RowWithout0, Min), assertz(minDist(N, Min)), fail.
assertsMinDist.

assertsNearestCities:-
	assertz(nearestCities(1, [12, 5, 22, 18, 20, 13, 10, 9, 19, 4, 6, 3, 15, 8, 7, 2, 21, 17, 11, 14, 16])),
	assertz(nearestCities(2, [14, 17, 15, 16, 19, 9, 13, 8, 6, 18, 10, 12, 1, 3, 20, 5, 22, 4, 7, 21, 11])),
	assertz(nearestCities(3, [10, 20, 4, 7, 21, 22, 11, 8, 5, 12, 19, 15, 13, 1, 17, 9, 18, 2, 16, 14, 6])),
	assertz(nearestCities(4, [7, 20, 22, 3, 21, 11, 10, 5, 12, 1, 19, 8, 13, 15, 18, 9, 17, 2, 6, 14, 16])),
	assertz(nearestCities(5, [12, 22, 1, 20, 10, 4, 18, 13, 19, 3, 9, 7, 8, 15, 21, 11, 6, 2, 17, 14, 16])),
	assertz(nearestCities(6, [9, 18, 13, 2, 19, 14, 15, 1, 17, 12, 8, 10, 5, 16, 22, 20, 3, 4, 7, 21, 11])),
	assertz(nearestCities(7, [21, 11, 4, 3, 20, 22, 10, 5, 12, 8, 1, 19, 13, 15, 18, 9, 17, 2, 16, 14, 6])),
	assertz(nearestCities(8, [15, 17, 19, 10, 2, 16, 3, 14, 13, 9, 20, 22, 12, 18, 5, 4, 6, 7, 1, 21, 11])),
	assertz(nearestCities(9, [13, 18, 6, 19, 2, 15, 12, 14, 1, 17, 10, 8, 5, 22, 20, 16, 3, 4, 7, 21, 11])),
	assertz(nearestCities(10, [20, 3, 22, 5, 19, 12, 8, 4, 13, 1, 15, 7, 9, 18, 21, 17, 11, 2, 14, 6, 16])),
	assertz(nearestCities(11, [21, 7, 4, 3, 20, 22, 10, 5, 12, 8, 1, 19, 15, 13, 18, 9, 17, 2, 16, 14, 6])),
	assertz(nearestCities(12, [5, 1, 22, 20, 10, 18, 13, 19, 9, 4, 3, 6, 15, 8, 7, 2, 21, 11, 17, 14, 16])),
	assertz(nearestCities(13, [9, 19, 18, 6, 15, 12, 2, 10, 1, 5, 8, 17, 14, 20, 22, 3, 16, 4, 7, 21, 11])),
	assertz(nearestCities(14, [2, 17, 16, 15, 19, 8, 9, 13, 6, 18, 10, 12, 3, 20, 1, 5, 22, 4, 7, 21, 11])),
	assertz(nearestCities(15, [17, 8, 2, 19, 14, 16, 13, 9, 10, 6, 18, 3, 20, 12, 5, 22, 1, 4, 7, 21, 11])),
	assertz(nearestCities(16, [17, 14, 2, 15, 8, 19, 9, 13, 6, 10, 3, 18, 20, 12, 22, 5, 1, 4, 7, 21, 11])),
	assertz(nearestCities(17, [15, 16, 14, 2, 8, 19, 9, 13, 10, 6, 18, 3, 20, 12, 5, 22, 1, 4, 7, 21, 11])),
	assertz(nearestCities(18, [13, 9, 6, 1, 19, 12, 5, 10, 15, 22, 2, 20, 8, 14, 17, 3, 4, 16, 7, 21, 11])),
	assertz(nearestCities(19, [13, 9, 15, 8, 10, 2, 18, 17, 12, 6, 14, 5, 20, 1, 22, 3, 16, 4, 7, 21, 11])),
	assertz(nearestCities(20, [22, 10, 4, 5, 3, 12, 7, 1, 19, 21, 11, 13, 8, 18, 9, 15, 17, 2, 6, 14, 16])),
	assertz(nearestCities(21, [7, 11, 4, 3, 20, 22, 10, 5, 8, 12, 1, 19, 15, 13, 17, 9, 18, 2, 16, 14, 6])),
	assertz(nearestCities(22, [20, 5, 12, 10, 4, 1, 3, 7, 19, 13, 21, 18, 11, 9, 8, 15, 6, 17, 2, 14, 16])).
assertsNearestCities.


%  Number of points N is   22
distance(A,B,Km):-
	matriz(M),
    nth1(A,M,Row), nth1(B,Row,Km),!.

