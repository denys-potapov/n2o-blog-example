-include_lib("nitro/include/nitro.hrl").

-record(pagination, {?ELEMENT_BASE(element_pagination), active, count, url}).