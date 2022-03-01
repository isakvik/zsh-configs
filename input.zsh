# forward/backward word stops at /
WORDCHARS="${WORDCHARS/\//}"
# don't freeze term on ctrl+s
stty -ixon <$TTY >$TTY

# rebind ctrl+c to ctrl+d
# needs to be done before zsh init - CHECK .BASHRC

# other key customizations with zle: (ref https://stackoverflow.com/a/68987551 )

export KEY_CTRL_U=$'' 
export KEY_CTRL_R=$''
export KEY_CTRL_L=$''
export KEY_CTRL_D=$''
export KEY_CTRL_A=$''
export KEY_CTRL_E=$''
export KEY_CTRL_B=$''
export KEY_CTRL_Z=$''
export KEY_CTRL_X=$''
export KEY_CTRL_C=$''
export KEY_CTRL_V=$''
export KEY_LEFT=$'OD'
export KEY_RIGHT=$'OC'
export KEY_SHIFT_UP=$'[1;2A'
export KEY_CTRL_LEFT=$'[1;5D'
export KEY_CTRL_RIGHT=$'[1;5C'
export KEY_SHIFT_DOWN=$'[1;2B'
export KEY_SHIFT_RIGHT=$'[1;2C'
export KEY_SHIFT_LEFT=$'[1;2D'
export KEY_ALT_LEFT=$'[1;3D'
export KEY_ALT_RIGHT=$'[1;3C'
export KEY_SHIFT_ALT_LEFT=$'[1;4D'
export KEY_SHIFT_ALT_RIGHT=$'[1;4C'
export KEY_SHIFT_CTRL_A=$'A'
export KEY_SHIFT_CTRL_E=$'E'
export KEY_SHIFT_CTRL_LEFT=$'[1;6D'
export KEY_SHIFT_CTRL_RIGHT=$'[1;6C'
export KEY_CTRL_DELETE=$'[3;5~'
export KEY_CTRL_BACKSPACE=$''
export KEY_SHIFT_HOME=$'[1;2H'
export KEY_SHIFT_END=$'[1;2F'
export KEY_DELETE=$'[3~'
export KEY_BACKSPACE=$''

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# copy selected terminal text to clipboard
zle -N widget::copy-selection
function widget::copy-selection {
    if ((REGION_ACTIVE)); then
        zle copy-region-as-kill
        printf "%s" $CUTBUFFER | pbcopy
    fi
}

# cut selected terminal text to clipboard
zle -N widget::cut-selection
function widget::cut-selection() {
    if ((REGION_ACTIVE)) then
        zle kill-region
        printf "%s" $CUTBUFFER | pbcopy
    fi
}

# paste clipboard contents
zle -N widget::paste
function widget::paste() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="$(pbpaste)${RBUFFER}"
    CURSOR=$(( CURSOR + $(echo -n "$(pbpaste)" | wc -m | bc) ))
}

# select entire prompt
zle -N widget::select-all
function widget::select-all() {
    local buflen=$(echo -n "$BUFFER" | wc -m | bc)
    CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
    zle set-mark-command
    while [[ $CURSOR > 0 ]]; do
        zle beginning-of-line
    done
}

# scrolls the screen up, in effect clearing it
zle -N widget::scroll-and-clear-screen
function widget::scroll-and-clear-screen() {
    printf "\n%.0s" {1..$LINES}
    zle clear-screen
}

function widget::util-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-unselect() {
    REGION_ACTIVE=0
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

function widget::util-insertchar() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="${1}${RBUFFER}"
    zle forward-char
}


function widget::key-æ() {
    echo æ
}

function widget::key-ø() {
    echo ø
}

function widget::key-å() {
    echo å
}

#                       |  key sequence                   | command
# --------------------- | ------------------------------- | -------------

bindkey                   $KEY_CTRL_RIGHT                   forward-word
bindkey                   $KEY_CTRL_LEFT                    backward-word
bindkey                   $KEY_CTRL_DELETE                  kill-word
bindkey                   $KEY_CTRL_BACKSPACE               backward-kill-word
bindkey                   $KEY_CTRL_Z			    undo
bindkey                   $KEY_CTRL_R			    redo
bindkey                   $KEY_CTRL_U                       history-incremental-search-backward
bindkey                   $KEY_CTRL_C                       widget::copy-selection
bindkey                   $KEY_CTRL_X                       widget::cut-selection
bindkey                   $KEY_CTRL_V                       widget::paste
bindkey                   $KEY_CTRL_A                       widget::select-all
bindkey                   $KEY_CTRL_L                       widget::scroll-and-clear-screen

for keyname        kcap   seq                   mode        widget (

    left           kcub1  $KEY_LEFT             unselect    backward-char
    right          kcuf1  $KEY_RIGHT            unselect    forward-char
    ctrl-left          x  $KEY_CTRL_LEFT        unselect    backward-word
    ctrl-right         x  $KEY_CTRL_RIGHT       unselect    forward-word

    shift-up       kri    $KEY_SHIFT_UP         select      up-line-or-history
    shift-down     kind   $KEY_SHIFT_DOWN       select      down-line-or-history
    shift-right    kRIT   $KEY_SHIFT_RIGHT      select      forward-char
    shift-left     kLFT   $KEY_SHIFT_LEFT       select      backward-char

    alt-right         x   $KEY_ALT_RIGHT        unselect    forward-word
    alt-left          x   $KEY_ALT_LEFT         unselect    backward-word
    shift-alt-right   x   $KEY_SHIFT_ALT_RIGHT  select      forward-line
    shift-alt-left    x   $KEY_SHIFT_ALT_LEFT   select      backward-line

    ctrl-e            x   $KEY_CTRL_E           unselect    end-of-line
    shift-ctrl-e      x   $KEY_SHIFT_CTRL_E     select      end-of-line
    shift-ctrl-a      x   $KEY_SHIFT_CTRL_A     select      beginning-of-line
    shift-ctrl-right  x   $KEY_SHIFT_CTRL_RIGHT select      forward-word
    shift-ctrl-left   x   $KEY_SHIFT_CTRL_LEFT  select      backward-word

    shift-home        x   $KEY_SHIFT_HOME       select      beginning-of-line
    shift-end         x   $KEY_SHIFT_END        select      end-of-line

    del               x   $KEY_DELETE           delselect   delete-char
    bksp              x   $KEY_BACKSPACE        delselect   backward-delete-char
    ctrl-bksp         x   $KEY_CTRL_BACKSPACE   delselect   backward-delete-word

    a                 x       'a'               insertchar  'a'
    b                 x       'b'               insertchar  'b'
    c                 x       'c'               insertchar  'c'
    d                 x       'd'               insertchar  'd'
    e                 x       'e'               insertchar  'e'
    f                 x       'f'               insertchar  'f'
    g                 x       'g'               insertchar  'g'
    h                 x       'h'               insertchar  'h'
    i                 x       'i'               insertchar  'i'
    j                 x       'j'               insertchar  'j'
    k                 x       'k'               insertchar  'k'
    l                 x       'l'               insertchar  'l'
    m                 x       'm'               insertchar  'm'
    n                 x       'n'               insertchar  'n'
    o                 x       'o'               insertchar  'o'
    p                 x       'p'               insertchar  'p'
    q                 x       'q'               insertchar  'q'
    r                 x       'r'               insertchar  'r'
    s                 x       's'               insertchar  's'
    t                 x       't'               insertchar  't'
    u                 x       'u'               insertchar  'u'
    v                 x       'v'               insertchar  'v'
    w                 x       'w'               insertchar  'w'
    x                 x       'x'               insertchar  'x'
    y                 x       'y'               insertchar  'y'
    z                 x       'z'               insertchar  'z'
    æ                 x       'æ'               insertchar  'æ'
    ø                 x       'ø'               insertchar  'ø'
    å                 x       'å'               insertchar  'å'
    A                 x       'A'               insertchar  'A'
    B                 x       'B'               insertchar  'B'
    C                 x       'C'               insertchar  'C'
    D                 x       'D'               insertchar  'D'
    E                 x       'E'               insertchar  'E'
    F                 x       'F'               insertchar  'F'
    G                 x       'G'               insertchar  'G'
    H                 x       'H'               insertchar  'H'
    I                 x       'I'               insertchar  'I'
    J                 x       'J'               insertchar  'J'
    K                 x       'K'               insertchar  'K'
    L                 x       'L'               insertchar  'L'
    M                 x       'M'               insertchar  'M'
    N                 x       'N'               insertchar  'N'
    O                 x       'O'               insertchar  'O'
    P                 x       'P'               insertchar  'P'
    Q                 x       'Q'               insertchar  'Q'
    R                 x       'R'               insertchar  'R'
    S                 x       'S'               insertchar  'S'
    T                 x       'T'               insertchar  'T'
    U                 x       'U'               insertchar  'U'
    V                 x       'V'               insertchar  'V'
    W                 x       'W'               insertchar  'W'
    X                 x       'X'               insertchar  'X'
    Y                 x       'Y'               insertchar  'Y'
    Z                 x       'Z'               insertchar  'Z'
    0                 x       '0'               insertchar  '0'
    1                 x       '1'               insertchar  '1'
    2                 x       '2'               insertchar  '2'
    3                 x       '3'               insertchar  '3'
    4                 x       '4'               insertchar  '4'
    5                 x       '5'               insertchar  '5'
    6                 x       '6'               insertchar  '6'
    7                 x       '7'               insertchar  '7'
    8                 x       '8'               insertchar  '8'
    9                 x       '9'               insertchar  '9'

    exclamation-mark      x  '!'                insertchar  '!'
    hash-sign             x  '\#'               insertchar  '\#'
    dollar-sign           x  '$'                insertchar  '$'
    percent-sign          x  '%'                insertchar  '%'
    ampersand-sign        x  '\&'               insertchar  '\&'
    star                  x  '\*'               insertchar  '\*'
    plus                  x  '+'                insertchar  '+'
    comma                 x  ','                insertchar  ','
    dot                   x  '.'                insertchar  '.'
    forwardslash          x  '\\'               insertchar  '\\'
    backslash             x  '/'                insertchar  '/'
    colon                 x  ':'                insertchar  ':'
    semi-colon            x  '\;'               insertchar  '\;'
    left-angle-bracket    x  '\<'               insertchar  '\<'
    right-angle-bracket   x  '\>'               insertchar  '\>'
    equal-sign            x  '='                insertchar  '='
    question-mark         x  '\?'               insertchar  '\?'
    left-square-bracket   x  '['                insertchar  '['
    right-square-bracket  x  ']'                insertchar  ']'
    hat-sign              x  '^'                insertchar  '^'
    underscore            x  '_'                insertchar  '_'
    left-brace            x  '{'                insertchar  '{'
    right-brace           x  '\}'               insertchar  '\}'
    left-parenthesis      x  '\('               insertchar  '\('
    right-parenthesis     x  '\)'               insertchar  '\)'
    pipe                  x  '\|'               insertchar  '\|'
    tilde                 x  '\~'               insertchar  '\~'
    at-sign               x  '@'                insertchar  '@'
    dash                  x  '\-'               insertchar  '\-'
    double-quote          x  '\"'               insertchar  '\"'
    single-quote          x  "\'"               insertchar  "\'"
    backtick              x  '\`'               insertchar  '\`'
    whitespace            x  '\ '               insertchar  '\ '
) {
    eval "function widget::key-$keyname() {
        widget::util-$mode $widget \$@
    }"
    zle -N widget::key-$keyname
    bindkey $seq widget::key-$keyname
}

# suggested by "e.nikolov", fixes autosuggest completion being 
# overriden by keybindings: to have [zsh] autosuggest [plugin
# feature] complete visible suggestions, you can assign an array
# of shell functions to the `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` 
# variable. when these functions are triggered, they will also 
# complete any visible suggestion. Example:
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
    widget::key-right
    widget::key-shift-right
    widget::key-cmd-right
    widget::key-shift-cmd-right
)

