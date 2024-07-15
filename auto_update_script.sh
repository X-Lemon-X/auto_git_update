#!/bin/bash

## This script is used to update a git repository on a machine
## fill the following variables with the appropriate values
git_url='git@github.com:X-Lemon-X/SDRAC_V2.git' # The url of the git repository or the ssh url
directory_of_repo_on_the_machine='/home/lemonx/it/SDRAC_V2' # The directory of the repository on the machine
update_branch='main' # The branch to update
log_file='autoupdate.log' # The name of the log file where the update logs will be stored





# Get the directory of the script
script_dir=$(dirname "$(realpath "$0")")
log_file=$(echo "$script_dir/$log_file")


cd $script_dir
./run_before_update.sh $log_file

echo "$(date)-> Run update" >> $log_file

if [ ! -d "$directory_of_repo_on_the_machine" ]; then
  cd $directory_of_repo_on_the_machine/..
  git clone $git_url $directory_of_repo_on_the_machine
fi

cd $directory_of_repo_on_the_machine
git fetch origin
# Check if the local branch is up to date with its upstream branch
local_commit=$(git rev-parse @)
remote_commit=$(git rev-parse @{u})

if [ "$local_commit" = "$remote_commit" ]; then
  echo  "$(date)-> Repository is up to date." >> $log_file
  exit 0
fi

# Check if the directory exists
if [ -d "$directory_of_repo_on_the_machine" ]; then
  cd $directory_of_repo_on_the_machine
  git pull origin $update_branch >> $log_file
else
  git clone $git_url $directory_of_repo_on_the_machine >> $log_file
  cd $directory_of_repo_on_the_machine
fi

cd $script_dir
./run_after_update.sh $log_file
