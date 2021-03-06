#  ---------------------------------------------------------------------------
#
#  Sections:
#
#  1.   Environment Configuration
#		1a. Variables
#		1b. Editor
#		1c. Git Client
#		1d. Etc.
#
#  2.   Terminal Improvements
#		2a. General
#		2b. Overrides
#		2c. Git
#
#  3.	Workiva Dev
#		3a. Virtual Environments
#		3b. Requirements
#		3c. Datastore
#		3d. Builds
#		3e. Deploy
#		3f. Local Server
#		3g. Local Tests
#		3h. Git
#		3i. JIRA
#		3j. Combinations (of other aliases)
#
#	4. Alias for an Alias
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#		---------------------------
#		1a. VARIABLES
#		---------------------------

			export WORKON_HOME=$HOME/.virtualenvs
			source /usr/local/bin/virtualenvwrapper.sh
			export MAVEN_OPTS="-Xmx4096m -Xss1024m -XX:MaxPermSize=1024m"
			export ANT_OPTS="-Xms512m -Xmx2056m"
			export M2_HOME=/usr/local/Cellar/maven30/3.0.5/libexec

			export PS1="\[\033[36m\]\u\[\033[m\]:\[\033[33;1m\]\w\[\033[m\]\$ "
			export CLICOLOR=1
			export LSCOLORS=ExFxBxDxCxegedabagacad

			export DATASTORES_DIR='/Users/nathancoleman/workspaces/wf/datastores/'
			export SCRIPTS_DIR='/Users/nathancoleman/workspaces/wf/scripts/'

			export GOPATH=$HOME/go
			export GOBIN=$GOPATH/bin
			export PATH=$PATH:$GOBIN

			export PYTHONPATH="$PYTHONPATH:/usr/local/google_appengine"

#		---------------------------
#		1b. EDITOR
#		---------------------------

			alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

#		---------------------------
#		1c. GIT CLIENT
#		---------------------------

			alias tower="gittower ."

#		---------------------------
#		1d. ETC.
#		---------------------------

			alias edit-bash="atom ~/workspaces/wf/scripts/.bash_profile"
			alias edit-bash-local="atom ~/.bash_profile"
			alias edit-zsh="atom ~/.zshrc"

			alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"
			alias show-hidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
			alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
			alias poem='say "here is a poem for you all." && say "gary is a scary mother fucker" && say "super hairy mother fucker" && say "fucking larry mother fucker" && say "dont you know?"'


#   -------------------------------
#   2. TERMINAL IMPROVEMENTS
#   -------------------------------

#		---------------------------
#		2a. GENERAL
#		---------------------------

			alias c='clear'
			alias d='cd ~/Desktop'
			alias h='cd ~'
			alias ls='ls -1'
			alias r='cd /'
			alias w='cd ~/workspaces'
			alias ww='w && cd wf'
			alias wn='w && cd nathancoleman'

			alias 1up='cd ../'
			alias 2up='cd ../../'
			alias 3up='cd ../../../'

			alias whereami='PWD'

			mkcd () {
				mkdir $1
				cd $1
			}

#		---------------------------
#		2b. OVERRIDES
#		---------------------------

			alias ls="ls -GFh"
			alias mkdir="mkdir -p"


#		---------------------------
#		2c. GIT
#		---------------------------

#			Git Completion
			if [ -f $SCRIPTS_DIR'.git-completion.bash' ]; then
				. $SCRIPTS_DIR'.git-completion.bash'
			fi

			alias gst='git status'
			alias gcg='git config --global'
			alias gcl='git config'
			alias gca='git commit -a -m'
			alias gco='git checkout'
			alias which-branch='git rev-parse --abbrev-ref HEAD'
			alias which-repo='basename $(git rev-parse --show-toplevel)'
			alias git-info='echo $(which-repo) : $(which-branch)'


#   -------------------------------
#   3. WORKIVA DEV
#   -------------------------------

#		---------------------------
#		3a. VIRTUAL ENVIRONMENTS
#		---------------------------

			alias mkvirtualenv='mkvirtualenv -a $(PWD)'
			alias deac='deactivate'
			alias sky='workon sky'
			alias dc='workon dc'
			alias elements='workon elements'
			alias stack='workon stack'
			alias cleansky='workon cleansky'
			alias scripts='workon scripts'

			mksky () {
				clean_sky=$HOME"/workspaces/wf/cleansky"
				skies_dir=$HOME"/workspaces/wf/skies"
				dc_dir=$HOME"/workspaces/wf/datacollections/wf/apps/dc"
				name=$1
				new_dir=$skies_dir/$name

				printf '\n\nMaking directory: '$new_dir
				printf '\n================================================\n'
				mkdir -p $new_dir

				printf '\n\nSetting up git repo'
				printf '\n================================================\n'
				cd $clean_sky

				git stash -u save --keep-index
				git stash drop

				git pull Upstream master

				cp -r . $new_dir/

				cd $new_dir

				printf '\n\nCreating virtual environment: '$name
				printf '\n================================================\n'
				mkvirtualenv -a $(PWD) $name

				printf '\n\nInstalling dependencies'
				printf '\n================================================\n'
				pip install -Ur requirements_dev.txt

				printf '\n\nSymlinking to datacollections repo'
				printf '\n================================================\n'
				cdsitepackages
				cd wf/apps/
				mv dc dc_pip
				ln -s $dc_dir dc
				workon $name

				printf '\n\nInitiating full build'
				printf '\n================================================\n'
				full

				printf '\n\n COMPLETE\n'
				tower
			}

			rmsky () {
				skies_dir=$HOME"/workspaces/wf/skies"
				name=$1
				rm_dir=$skies_dir/$name

				cd $HOME &> /dev/null
				echo 'Removing directory: '$rm_dir
				rm -rf $rm_dir &> /dev/null

				echo 'Removing environment: '$name
				deac &> /dev/null
				rmvirtualenv $name &> /dev/null
			}


#		---------------------------
#		3b. REQUIREMENTS
#		---------------------------

			alias req='rm -rf /Users/nathancoleman/.virtualenvs/sky/build/* && pip install -r requirements.txt'
			alias req-dev='rm -rf /Users/nathancoleman/.virtualenvs/sky/build/* && pip install -r requirements_dev.txt'
			alias edit-req='atom requirements.txt'
			alias edit-req-dev='atom requirements_dev.txt'


#		---------------------------
#		3c. DATASTORE
#		---------------------------

			alias mk-datastore='mkdir -p datastore'
			alias reset-data="python tools/erase_reset_data.py --admin=nathan.coleman@workiva.com --password=test --enabled_settings='enable_data_collection,enable_attachments'  --global_password=test"
			alias replace-data="rm -rf /tmp/django_dev~big-sky.datastore && cp /tmp/django_dev~big-sky.datastore_copy /tmp/django_dev~big-sky.datastore && rm -rf /tmp/django_dev~big-sky.search_indexes && cp /tmp/django_dev~big-sky.search_indexes_copy /tmp/django_dev~big-sky.search_indexes"


#		---------------------------
#		3d. BUILDS
#		---------------------------

			alias full='tools/build/build_full.sh'
			alias lazy='tools/build/build_lazy.sh'
			alias lazy-gen='tools/build/build_lazy-with-gen.sh'


#		---------------------------
#		3e. DEPLOY
#		---------------------------

		alias deploy='tools/build/deploy.sh'
		alias deploy-release='tools/build/deploy_release.sh'


#		---------------------------
#		3f. LOCAL SERVER
#		---------------------------

			alias server='python manage.py runserver 0.0.0.0:8001 --log_level debug'


#		---------------------------
#		3g. LOCAL TESTS
#		---------------------------

			alias test='python manage.py test'


#		---------------------------
#		3h. GIT
#		---------------------------

			gh-compare () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				branch=$(which-branch)
				base=${branch%/*}/Compare
				open $github_url/$username/$repo/compare/$username:$base...$branch
			}

			gh-repo () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				open $github_url/$username/$repo
			}

			gh-branch () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				branch=$(which-branch)
				open $github_url/$username/$repo/tree/$branch
			}

			gh-template () {
				template_dir=$SCRIPTS_DIR'templates/'
				template=$template_dir'pull_request.txt'
				branch=$(which-branch)
				ticket=$branch
				lower_ticket=$(echo $ticket | tr '[:upper:]' '[:lower:]')
				sed -i "" 's/\*\*\*\*/'$ticket'/g' $template
				cat $template | pbcopy
				sed -i "" 's/'$ticket'/\*\*\*\*/g' $template
				sed -i "" 's/'$lower_ticket'/____/g' $template
			}

			mpr-template () {
				template_dir=$SCRIPTS_DIR'templates/'
				template=$template_dir'master_pull_request.txt'
				branch=$(which-branch)
				ticket=${branch%/*}
				lower_ticket=$(echo $ticket | tr '[:upper:]' '[:lower:]')
				sed -i "" 's/\*\*\*\*/'$ticket'/g' $template
				sed -i "" 's/____/'$lower_ticket'/g' $template
				cat $template | pbcopy
				sed -i "" 's/'$ticket'/\*\*\*\*/g' $template
				sed -i "" 's/'$lower_ticket'/____/g' $template
			}

#		---------------------------
#		3i. JIRA
#		---------------------------

			jira () {
				jira_url="https://jira.webfilings.com/browse"
				branch=$(which-branch)
				ticket=${branch%/*}
				open $jira_url/$ticket
			}

			jira-template () {
				template_dir=$SCRIPTS_DIR'templates/'
				template=$template_dir'jira_ticket.txt'
				cat $template | pbcopy
			}


#		---------------------------
#		3j. COMBINATIONS
#		---------------------------

			alias sky-tower='workon sky && gittower .'
			alias dc-tower='workon dc && gittower .'
			alias cleansky-tower='workon cleansky && gittower .'

			alias doitall='req && full && reset-data && server'
			alias full-server='full && server'
			alias lazy-server='lazy && server'
			alias req-full='req && full'
			alias req-full-server='req && full && server'
			alias req-lazy='req && lazy'
			alias req-lazy-server='req && lazy && server'


#	-------------------------------
#	4. ALIAS FOR AN ALIAS
#	-------------------------------

		alias f-s='full-server'
		alias gi='git-info'
		alias l-s='lazy-server'
		alias r-d='reset-data'
		alias s='server'
		alias wb='which-branch'
		alias wr='which-repo'
