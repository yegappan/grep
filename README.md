grep
====

Plugin to integrate various grep like search tools with Vim.

The grep plugin integrates grep like utilities (grep, fgrep, egrep, agrep,
findstr, silver searcher (ag), ripgrep, ack and git grep) with Vim and allows
you to search for a pattern in one or more files and jump to them.

To use this plugin, you will need the grep like utilities in your system.  If a
particular utility is not present, then you cannot use the corresponding
features, but you can still use the rest of the features supported by the
plugin.

To use the this plugin with grep, you will need the grep, fgrep and egrep
utilities. To recursively search for files using grep, you will need the find
and xargs utilities. These tools are present in most of the Unix and MacOS
installations.  For MS-Windows systems, you can download the GNU grep and find
utilities from the following sites:

    http://gnuwin32.sourceforge.net/packages/grep.htm
    http://gnuwin32.sourceforge.net/packages/findutils.htm

On MS-Windows, you can use the findstr utility to search for patterns.
This is available by default on all MS-Windows systems.

If you want to use the agrep command with this plugin, then you can download
the agrep utility from:

    https://www.tgries.de/agrep/

If you want to use the Silver Searcher (ag) with this plugin, then you can
download the Silver Searcher from:

    https://github.com/ggreer/the_silver_searcher

If you want to use the ack utility with this plugin, then you can
download the ack utility from:

    https://beyondgrep.com/

If you want to use ripgrep (rg) with this plugin, then you can download the
ripgrep utility from:

    https://github.com/BurntSushi/ripgrep

The silver searcher, ripgrep and ack utilities can search for a pattern
recursively across directories without using any other additional utilities
like find and xargs.
