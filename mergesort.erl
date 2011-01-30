-module(mergesort).
-export([mergesort/1]).

% Splits the list into two

divide([]) -> {[],[]};
divide([Head]) -> {Head, []};
divide([Head | Tail]) -> lists:split(length([Head | Tail]) div 2, [Head | Tail]).

% Merging two lists

mergelists([], [], Acc) -> lists:reverse(Acc);
mergelists([Head | Tail], [], Acc) -> mergelists(Tail, [], [Head | Acc]);
mergelists([], [Head | Tail] , Acc) -> mergelists([], Tail, [Head | Acc]);
mergelists([XH | XT], [YH | YT], Acc) when XH < YH ->
    mergelists(XT, [YH | YT], [XH | Acc]);
mergelists([XH | XT], [YH | YT], Acc) when XH >= YH ->
    mergelists([XH | XT], YT, [YH | Acc]).

% Sorting the lists

mergesort([]) -> [];
mergesort([X]) -> [X];
mergesort([Head | Tail]) ->
    {Left, Right} = divide([Head | Tail]),
    mergelists(mergesort(Left), mergesort(Right), []).
