-ifdef(dbg).
-include_lib("eunit/include/eunit.hrl").
-else.
-define(debugFmt(X,Y),ok).
-endif.

-define(HeavyStateWindowLength, 1000).
