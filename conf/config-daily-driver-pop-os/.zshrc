# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/maxence/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="alanpeabody"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### ALIAS ###
# GIT #
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

# DOCKER #
alias dmysql="docker run --name mysql -e MYSQL_ROOT_PASSWORD=secret -p 3307:3306 -d mysql:5.7"
alias dpma="docker run --name myadmin -d --link mysql:db -p 8080:80 phpmyadmin/phpmyadmin"

### CONFIG VARIABLES ###
LOAD_FUNCTIONS=true

### FUNCTIONS ###
if $LOAD_FUNCTIONS ; then
    ## ALIAS ##
    alias git-sp="speedPush"
    alias git-sp-n="speedPushN"
    alias drm="dockerRmAll"
    alias drmv="dockerRmAllVolumes"
    alias dc-bu="dockerComposeBuildAndUpDetached"
    alias dc-e="dockerComposeExec"

    ########################
    # GIT SPEED PUSH       #
    ########################
    speedPush() {
        git add .
        git commit --amend --no-edit
        git push -f
    }

    ########################
    # GIT SPEED PUSH -n    #
    ########################
    speedPushN() {
        git add .
        git commit --amend --no-edit -n
        git push -f --no-verify
    }

    ########################
    # RM DOCKER CONTAINER  #
    ########################
    dockerRmAll() {
        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
    }

    ########################
    # RM DOCKER VOLUMES    #
    ########################
    dockerRmAllVolumes() {
        docker volume rm $(docker volume ls -q)
    }

    ########################
    # DC BUILD AND UP -D   #
    ########################
    dockerComposeBuildAndUpDetached() {
        docker-compose build
        docker-compose up -d
    }

    ########################
    # DC EXEC              #
    # $1 = container       #
    # $2 = command         #
    ########################
    dockerComposeExec () {
        if [ $1 ] && [ $2 ]
        then
            docker-compose exec $1 $2
        else
            echo "Error : bad arguments"
        fi
    }

    ########################
    # MKDIR + CD           #
    # $1 = new folder name #
    ########################
    mkcd () {
        if [ $1 ]
        then
            mkdir $1
            cd $1
        else
            echo "Error : no argument"
        fi
    }

    ######################
    # BACK IN THE FILES  #
    # $1 = how much back #
    ######################
    b() {
        if [ $1 ]
        then
            i=$1
        else
            i=1
        fi

        count=2
        command='cd ..'
        while [ $count -le $i ]
        do
            command+="/.."
            (( count++ ))
        done

        eval $command
    }
fi
