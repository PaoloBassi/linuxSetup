# Catppuccin Mocha — EZA_COLORS
# Add to ~/.zshrc: source ~/.config/eza_colors.zsh
#
# Mocha 256-color approximations:
#   111 = blue     #89b4fa
#   114 = green    #a6e3a1
#   115 = teal     #94e2d5
#   116 = sky      #89dceb
#   117 = sapphire #74c7ec
#   147 = lavender #b4befe
#   189 = text     #cdd6f4
#   210 = red      #f38ba8
#   211 = maroon   #eba0ac
#   216 = peach    #fab387
#   223 = yellow   #f9e2af
#   238 = surface1 #45475a
#   242 = overlay0 #6c7086

EZA_COLORS=''

# file types
EZA_COLORS+='fi=38;5;189:'          # regular file — text
EZA_COLORS+='di=38;5;111;1:'        # directory — blue bold
EZA_COLORS+='ln=38;5;117:'          # symlink — sky
EZA_COLORS+='or=38;5;210:'          # broken symlink — red
EZA_COLORS+='ex=38;5;114;1:'        # executable — green bold
EZA_COLORS+='pi=38;5;223:'          # pipe — yellow
EZA_COLORS+='so=38;5;147:'          # socket — lavender
EZA_COLORS+='bd=38;5;216:'          # block device — peach
EZA_COLORS+='cd=38;5;216:'          # char device — peach

# permissions — user
EZA_COLORS+='ur=38;5;114:'          # user read — green
EZA_COLORS+='uw=38;5;223:'          # user write — yellow
EZA_COLORS+='ux=38;5;210:'          # user exec — red
EZA_COLORS+='ue=38;5;210:'          # user exec (setuid) — red

# permissions — group
EZA_COLORS+='gr=38;5;114:'          # group read — green
EZA_COLORS+='gw=38;5;223:'          # group write — yellow
EZA_COLORS+='gx=38;5;210:'          # group exec — red

# permissions — other
EZA_COLORS+='tr=38;5;238:'          # other read — surface1
EZA_COLORS+='tw=38;5;238:'          # other write — surface1
EZA_COLORS+='tx=38;5;238:'          # other exec — surface1

# special permission bits
EZA_COLORS+='su=38;5;210;1:'        # setuid — red bold
EZA_COLORS+='sf=38;5;210;1:'        # setgid — red bold
EZA_COLORS+='xa=38;5;115:'          # extended attributes — teal

# size
EZA_COLORS+='sn=38;5;114:'          # size number — green
EZA_COLORS+='sb=38;5;242:'          # size unit — overlay0
EZA_COLORS+='df=38;5;111:'          # major device — blue
EZA_COLORS+='ds=38;5;116:'          # minor device — sky

# user/group
EZA_COLORS+='uu=38;5;147:'          # your user — lavender
EZA_COLORS+='un=38;5;242:'          # other user — overlay0
EZA_COLORS+='gu=38;5;111:'          # your group — blue
EZA_COLORS+='gn=38;5;242:'          # other group — overlay0

# date
EZA_COLORS+='da=38;5;116:'          # date — sky

# git
EZA_COLORS+='ga=38;5;114:'          # git added — green
EZA_COLORS+='gm=38;5;216:'          # git modified — peach
EZA_COLORS+='gd=38;5;210:'          # git deleted — red
EZA_COLORS+='gv=38;5;111:'          # git renamed — blue
EZA_COLORS+='gt=38;5;223:'          # git typechanged — yellow
EZA_COLORS+='gi=38;5;242:'          # git ignored — overlay0
EZA_COLORS+='gc=38;5;210:'          # git conflicted — red

# header
EZA_COLORS+='hd=38;5;147;1:'        # header — lavender bold

# punctuation / special
EZA_COLORS+='xx=38;5;238:'          # punctuation (dashes in perms) — surface1
EZA_COLORS+='lp=38;5;117:'          # symlink path — sky
EZA_COLORS+='cc=38;5;216:'          # control char — peach
EZA_COLORS+='bO=38;5;210:'          # broken overlay — red

export EZA_COLORS

# archives — maroon (via LS_COLORS for extension matching)
LS_COLORS+=':*.tar=38;5;211:*.tgz=38;5;211:*.gz=38;5;211:*.zip=38;5;211:'
LS_COLORS+='*.7z=38;5;211:*.rar=38;5;211:*.bz2=38;5;211:*.xz=38;5;211:'
LS_COLORS+='*.zst=38;5;211:*.deb=38;5;211:*.rpm=38;5;211:'
export LS_COLORS
