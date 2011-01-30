-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

% Sreating the new db
new() -> [].

% Destroying db
destroy(_Db) -> ok.

% Inserting new element at the and of the list
insert(Value, []) -> [Value];
insert(Value, List) -> [Value | List].

% Interface for inserting
write(Key, Element, Db) -> insert({Key, Element}, Db).

% Deleting the element with key 'Key' from the db
deleteitem([], _, X) -> X;
deleteitem([{Key, _Element} | Tail], Key, NewDb) -> deleteitem(Tail, Key, NewDb);
deleteitem([Head | Tail], Key, NewDb) -> deleteitem(Tail, Key, [Head | NewDb]).

% Interface to delete
delete(Key, Db) -> deleteitem(Db, Key, []).

% Reading the element from Db
readthrough([], _Key) -> {error, instance};
readthrough([{Key, Element} | _Tail], Key) -> {ok, Element};
readthrough([_Head | Tail], Key) -> readthrough(Tail, Key).

% interface to reading
read(Key, Db) -> readthrough(Db, Key).

% Matching the elements
matching([], _, Answer) -> Answer;
matching([{Key, Element} | Tail], Element, Answer) -> matching(Tail, Element, [Key | Answer]);
matching([_Head | Tail], Element, Answer) -> matching(Tail, Element, Answer).

% interface to matching
match(Element, Db) -> matching(Db, Element, []).
