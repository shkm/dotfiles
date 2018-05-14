au User CmSetup call cm#register_source({'name' : 'monster',
\ 'priority': 9,
\ 'scoping': 1,
\ 'scopes': ['ruby'],
\ 'abbreviation': 'rb',
\ 'cm_refresh_patterns':['[^. \t].\w', '[a-zA-Z_]\w*::'],
\ 'cm_refresh': {'omnifunc': 'monster#omnifunc'},
\ })
