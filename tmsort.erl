-module(tmsort).
-export([mergesort/1, divide/1]).

% Splits the list into two

divide([]) -> {[],[]};
divide([Head]) -> {Head, []};
divide([Head | Tail]) -> lists:split(length([Head | Tail]) div 2, [Head | Tail]).

% Merging two lists

mergelists([], []) -> [];
mergelists(X, []) -> X;
mergelists([], Y) -> Y;
mergelists([XH | XT], [YH | YT]) ->
    if
	XH < YH -> NewHead = XH, NewXList = XT, NewYList = [YH | YT];
	XH >= YH -> NewHead = YH, NewXList = [XH | XT], NewYList = YT
    end,
    [NewHead | mergelists(NewXList, NewYList)].

% Sorting the lists

mergesort([]) -> [];
mergesort([X]) -> [X];
mergesort([Head | Tail]) ->
    {Left, Right} = divide([Head | Tail]),
    NewLeft = mergesort(Left),
    NewRight = mergesort(Right),
    mergelists(NewLeft, NewRight).

