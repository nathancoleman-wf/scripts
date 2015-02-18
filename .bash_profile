#  ---------------------------------------------------------------------------
#
#  Sections:
#  1.   Environment Configuration
#		1a. Variables
#		1b. Editor
#		1c. Git Client
#		1d. Etc.
#  2.   Terminal Improvements
#		2a. General
#		2b. Git
#  3.	Workiva Dev
#		3a. Virtual Environments
#		3b. Requirements
#		3c. Datastore
#		3d. Builds
#		3e. Local Server
#		3f. Local Tests
#		3g. Git
#		3h. Combinations (of other aliases)
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
			export ANT_OPTS="-Xms512m -Xmx1024m"
			export MAVEN_OPTS="-Xmx4096m -Xss1024m -XX:MaxPermSize=128m"
			export M2_HOME=/usr/local/Cellar/maven30/3.0.5/libexec
			# export PATH=/usr/local/bin:$PATH

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
			
			alias edit-bash="subl ~/workspaces/wf/scripts/.bash_profile"
			alias edit-bash-local="subl ~/.bash_profile"
			alias edit-zsh="subl ~/.zshrc"

			alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

			alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"
			alias show-hidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
			alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'


#   -------------------------------
#   2. TERMINAL IMPROVEMENTS
#   -------------------------------

#		---------------------------
#		2a. GENERAL
#		---------------------------

			alias c="clear"
			alias d="cd ~/Desktop"
			alias h="cd ~"
			alias r="cd /"

			alias 1up="cd ../"
			alias 2up="cd ../../"
			alias 3up="cd ../../../"


#		---------------------------
#		2b. GIT
#		---------------------------

			alias gst="git status"
			alias gcg="git config --global"
			alias gcl="git config"
			alias gco="git checkout"
			alias which-branch="git rev-parse --abbrev-ref HEAD"
			alias which-repo='basename $(git rev-parse --show-toplevel)'


#   -------------------------------
#   3. WORKIVA DEV
#   -------------------------------

#		---------------------------
#		3a. VIRTUAL ENVIRONMENTS
#		---------------------------

			alias deac="deactivate"
			alias sky="workon sky && cd ~/workspaces/wf/bigsky"
			alias dc="workon dc && cd ~/workspaces/wf/datacollections"
			alias stack="workon stack && cd ~/workspaces/wf/python-runtime-stack"
			alias cleansky="workon cleansky"

			mksky () {
				clean_sky=$HOME"/workspaces/wf/cleansky"
				skies_dir=$HOME"/workspaces/wf/skies"
				name=$1
				new_dir=$skies_dir/$name

				printf '\n\nMaking directory: '$new_dir
				printf '\n================================================'
				mkdir -p $new_dir

				printf '\n\nSetting up git repo'
				printf '\n================================================'
				cd $clean_sky

				git stash -u save --keep-index
				git stash drop

				git pull Upstream master

				cp -r . $new_dir/

				cd $new_dir
				
				printf '\n\nCreating virtual environment: '$name
				printf '\n================================================'
				mkvirtualenv -a $(PWD) $name

				printf '\n\nInstalling dependencies'
				printf '\n================================================'
				pip install -Ur requirements_dev.txt
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

			alias req="pip install -Ur requirements.txt"
			alias req-dev="pip install -Ur requirements_dev.txt"
			alias edit-req="subl requirements.txt"
			alias edit-req-dev="subl requirements_dev.txt"


#		---------------------------
#		3c. DATASTORE
#		---------------------------

			alias mk-datastore="mkdir -p datastore"
			alias reset-data="mk-datastore && python tools/erase_reset_data.py --admin=nathan.coleman@workiva.com --password=test --enabled_settings='enable_data_collection,enable_attachments' --disabled_prefs='enable_home,show_tour' --global_password=test"
			alias r-d="reset-data"


#		---------------------------
#		3d. BUILDS
#		---------------------------

			alias full="tools/build/build_full.sh"
			alias lazy="tools/build/build_lazy.sh"
			alias lazy-gen="tools/build/build_lazy-with-gen.sh"


#		---------------------------
#		3e. LOCAL SERVER
#		---------------------------

			alias server="python manage.py runserver 0.0.0.0:8001"
			alias s="server"


#		---------------------------
#		3f. LOCAL TESTS
#		---------------------------

			alias test="python manage.py test"


#		---------------------------
#		3g. GIT
#		---------------------------
			
			gh-compare () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				branch=$(which-branch)
				base=${branch%/*}/Compare
				chrome $github_url/$username/$repo/compare/$username:$base...$branch
			}

			gh-repo () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				chrome $github_url/$username/$repo
			}

			gh-branch () {
				github_url="https://www.github.com"
				username="nathancoleman-wf"
				repo=$(which-repo)
				branch=$(which-branch)
				chrome $github_url/$username/$repo/tree/$branch
			}

			jira () {
				jira_url="https://jira.webfilings.com/browse"
				branch=$(which-branch)
				ticket=${branch%/*}
				chrome $jira_url/$ticket
			}


#		---------------------------
#		3h. COMBINATIONS
#		---------------------------

			alias sky-tower="workon sky && gittower ."
			alias dc-tower="workon dc && gittower ."
			alias cleansky-tower="workon cleansky && gittower ."

			alias doitall="req && full && reset-data && server"
			alias full-server="full && server"
			alias f-s="full-server"
			alias lazy-server="lazy && server"
			alias l-s="lazy-server"

			alias req-full="req && full"
			alias req-full-server="req && full && server"
			alias req-lazy="req && lazy"
			alias req-lazy-server="req && lazy && server"

