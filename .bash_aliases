# . ~/.bash_aliases
#
# @author - manj@cs.stanford.edu
#

# Directory listing
case `uname` in
Darwin)
    alias ls='ls -G'
    ;;
Linux)
    alias ls='ls --color'
    ;;
*)
    ;;
esac
alias l='ls -1'
alias ll='ls -la'
alias lh='ls -lah'

# Human readable figures
alias df='df -h'
alias du='du -h'

# Interactive operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# grep colors - http://www.termsys.demon.co.uk/vtansi.htm#colors
export GREP_OPTIONS='--color=auto'
# color codes
#  '1;33' - Yellow
#  '1;31' - Red
export GREP_COLOR='1;31'
alias grepn='grep -n'
alias gcat='grep -n ".*\"'

# Editors
alias vi='vim'
alias vim='vim -o'
alias catn='cat -n'

# Quiet please!
alias gdb='gdb -q'
alias bc='bc -q'
alias strace='strace -q'

# hexdump
#
#  Escape single (double) quotes by enclosing them in
#  double (single) quotes
#  hexdump -v
#  hexdump -v -e ' 1/1 "%02x " '
#  hexdump -v -e ' "%07.7_ax  " 4/4 "%08x " "\n" '
#  hexdump -v -e ' "%07.7_ax  " 8/4 "%08x " "\n" '
#  hexdump -v -e ' "%07.7_ax  " 16/1 "%_p" " " 16/1 "%_p" "  " 16/1 "%_p" " " 16/1 "%_p" "\n" '
#  hexdump -v -e ' "%07.7_ax  " 4/4 "%08x " "  |" ' -e '16/1 "%_p"  "|" "\n" '
#
#  hexdump -e ' [iterations]/[byte_count] "[format string]" ' <file-name>
#  -- This means apply [format string] to groups of [byte_count] bytes, [iterations] times.
#
#  hexdump -e ' 4/4 "%08x  " ' -e '"\n"'  <file-name>
#  -- This means apply format string = "%08x  " to 4 groups of 4 byte each
#     times and then apply the format s tring "\n". This leads this output:
#     4f020000  0001000b  5a080000  20310d11
#     086f1652  00000200  000d0300  000b0b05
#     00020000  75080000  74735f73  00657461
#     43020000  00000041  78696611  755f6465
#     65675f70  74656d6f  00007972  72740400
#     ...
#
#   -n length  Interpret only length bytes of input.
#   -s offset  Skip offset bytes from the beginning of the input. Appending the
#              character b, k, or m to offset causes it to be interpreted as a
#              multiple of 512, 1024, or 1048576, respectively.
#   -v         Cause hexdump to display all input data.  Without the -v option,
#              any number of groups of output lines, which would be identical to
#              the immediately preceding group of output lines (except for the
#              input offsets), are replaced with a line comprised of a single
#              asterisk.
alias hd='hexdump'                             # 1-byte hex; display duplicate data by *
alias hdb='hexdump -v'                         # 1-byte hex; display all input data
alias hdr='hexdump -v -e '"'"' 1/1 "%02x "'"'" # 1-byte hex without crlf
alias hdc='hexdump -v -C'                      # 2-byte hex + ASCII
alias hdd='hexdump -v -d'                      # 2-byte decimal
alias hdhs='hexdump -v -e '"'"' "%07.7_ax  " 4/4 "%08x " "\n" '"'"                                            # 4-byte hex
alias hdhl='hexdump -v -e '"'"' "%07.7_ax  " 8/4 "%08x " "\n" '"'"                                            # 8-byte hex
alias hdhc='hexdump -v -e '"'"' "%07.7_ax  " 4/4 "%08x " "  |" '"' -e '16/1 "'"%_p"  "|" "\n" '"'"            # 4-byte hex + ASCII
alias hdp='hexdump -v -e '"'"' "%07.7_ax  " 16/1 "%_p" " " 16/1 "%_p" "  " 16/1 "%_p" " " 16/1 "%_p" "\n"'"'" # 64-byte ASCII

# Misc
alias sbash='source ~/.bashrc'
alias vm='ssh manj@ubuntu'
