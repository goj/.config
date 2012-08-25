import rlcompleter, readline
readline.parse_and_bind('tab: complete')
readline.parse_and_bind('set show-all-if-ambiguous On')
def source(obj):
    """source of the obj."""
    import pydoc, inspect
    try:
        pydoc.pipepager(inspect.getsource(obj), 'less')
    except IOError:
        pass
