-module(qsort).
-export([qsort/1]).


% Splits the list into two

divide([]) -> {[],[]};
divide([Head]) -> {Head, []};
divide([Head | Tail]) -> lists:split(length([Head | Tail]) div 2, [Head | Tail]).

% Interleaving the lists

interleave([], []) -> [],
interleave(X, []) -> X,
interleave([], Y) -> Y,
interleave([LH | LT], [RH | RT]) ->
    if
	LH >= RH -> LeftList = [RH | interleave(LT, RT)], RightList = [LH | interleave()],
	LH < RH -> LeftList = [LH | LT], RightList = [RH | RT]
    end,
    RR = lists:reverse(RightList),
    

% Sorting

qsort([]) -> [],
qsort([X]) -> [X],
qsort([Head | Tail]) ->
    {Left, Right} = divide([Head | Tail]),
    %RightWithoutTail = lists:delete(length(Right), Right),
    ReverseRight = lists:reverse(Right),
    
