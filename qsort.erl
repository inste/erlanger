-module(qsort).
-export([qsort/1]).


qsort([]) ->
     [];
qsort([H | T]) ->
    qsort([ S || S <- T, S < H]) ++ [H] ++ qsort([ B || B <- T, B >= H]).
