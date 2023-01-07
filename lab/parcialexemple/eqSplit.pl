%% Write a Prolog predicate eqSplit(L,S1,S2) that, given a list of
%% integers L, splits it into two disjoint subsets S1 and S2 such that
%% the sum of the numbers in S1 is equal to the sum of S2. It should
%% behave as follows:
%%
%% ?- eqSplit([1,5,2,3,4,7],S1,S2), write(S1), write('    '), write(S2), nl, fail.
%%
%% [1,5,2,3]    [4,7]
%% [1,3,7]    [5,2,4]
%% [5,2,4]    [1,3,7]
%% [4,7]    [1,5,2,3]


eqSplit([],[],[]).
eqSplit(L,S1,S2):- subcj(L,S1), subcj(L,S2), disjoint(S1,S2),length(S1,L1),length(S2,L2), length(L,L3), L3 =:= L1+L2, sum(S1,S), sum(S2,S).

sum([],0).
sum([X|L],S) :- sum(L,S1), S is S1+X.

%%%%% subcj(L,S) %%%% S es como L pero chiquito
subcj([],[]).
subcj([_|L], S) :- subcj(L,S).
subcj([X|L],[X|S]) :- subcj(L,S).

disjoint([],[]).
disjoint([],L).
disjoint([X|Y],L) :- not( member(X,L)) , disjoint(Y,L).
