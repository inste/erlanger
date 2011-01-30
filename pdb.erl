-module(pdb).
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
-export([loop/1]).

-record(item, {key, value}).

% External interface

% :INTERFACE: Destroying DB
stop() -> pdb ! destroy.

% :INTERFACE: Inserting a tuple
write(Key, Element) -> pdb ! {insert, #item{key = Key, value = Element}}.

% :INTERFACE: Removing
delete(Key) -> pdb ! {delete, Key}.

% :INTERFACE: Reading
read(Key) ->
    pdb ! {read, Key, self()},
    Pid = whereis(pdb),
    receive
	{read_answer, Pid, Key, Answer} -> Answer;
	_Other -> {error, no_found}
    end.

% :INTERFACE: Matching
match(Element) ->
    pdb ! {match, Element, self()},
    Pid = whereis(pdb),
    receive
	{match_answer, Pid, Element, Answer} -> Answer;
	_Other -> {error, not_found}
    end.

% Internal realization

% Inserting new element at the and of the list
insert(Value, []) -> [Value];
insert(Value, List) -> [Value | List].

% Deleting the element with key 'Key' from the db
deleteitem([], _, X) -> X;
deleteitem([#item{key = Key} | Tail], Key, NewDb) -> deleteitem(Tail, Key, NewDb);
deleteitem([Head | Tail], Key, NewDb) -> deleteitem(Tail, Key, [Head | NewDb]).

% Reading the element from Db
readthrough([], _Key) -> {error, instance};
readthrough([#item{key = Key, value = Element} | _Tail], Key) -> {ok, Element};
readthrough([_Head | Tail], Key) -> readthrough(Tail, Key).

% Matching the elements
matching([], _, Answer) -> Answer;
matching([#item{key = Key, value = Element} | Tail], Element, Answer) -> matching(Tail, Element, [Key | Answer]);
matching([_Head | Tail], Element, Answer) -> matching(Tail, Element, Answer).


% Creating the new db
start() ->
    register(pdb, spawn(pdb, loop, [[]])).

% The main loop
loop(Data) ->
    receive
	{insert, Value} ->
	    loop(insert(Value, Data));
	{delete, Key} ->
	    loop(deleteitem(Data, Key, []));
	{read, Key, Reciever} ->
	    Reciever ! {read_answer, self(), Key, readthrough(Data, Key)},
	    loop(Data);
	{match, Element, Reciever} ->
	    Reciever ! {match_answer, self(), Element, matching(Data, Element, [])},
	    loop(Data);
	destroy -> ok
    end.
