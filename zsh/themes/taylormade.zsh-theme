# A TaylorMade oh-my-zsh theme

bg_proc_exists="✠";
command_line_start="▶";


function output_character_repeat() {
	local i len character
	len=$1
	character=$2
	i=0
	while (( i++ < len )) { echo -n "${character}" }
}

function do_top_border() {
	local reset line top_left_corner top_right_corner machine_name user_name len date curtime
	local LS_SIZE MID_SIZE RS_SIZE LS_OUTPUT MID_OUTPUT RS_OUTPUT LS_REPEAT RS_REPEAT i COL_COUNT 
	local border_color username_color date_color time_color
	reset="%{${reset_color}%}"
	border_color="%{$fg[white]%}"
	username_color="%{$fg[red]%}"
	date_color="%{$fg[magenta]%}"
	time_color="%{$fg[magenta]%}"
	line="┉"
	top_left_corner="┏"
	top_right_corner="┓"
	MID_OUTPUT="%D"
	LS_OUTPUT="%n@%m"
	RS_OUTPUT="%*"
	# Take 2 off for the corners
	MID_SIZE=${#${(S%%)MID_OUTPUT//$~zero/}}
	LS_SIZE=${#${(S%%)LS_OUTPUT//$~zero/}}
	RS_SIZE=${#${(S%%)RS_OUTPUT//$~zero/}}
	LS_REPEAT=$(( (((COLUMNS - 2) / 2) - ${LS_SIZE} - (${MID_SIZE} / 2)) / 2 ))
	RS_REPEAT=$(( (((COLUMNS - 2) / 2) - ${RS_SIZE} - (${MID_SIZE} / 2)) / 2 ))

	echo -n "${border_color}${top_left_corner}"
	output_character_repeat ${LS_REPEAT} ${line}
	echo -n "${username_color}${LS_OUTPUT}${border_color}"
	output_character_repeat ${LS_REPEAT} ${line}
	echo -n "${date_color}${MID_OUTPUT}${border_color}"
	output_character_repeat ${RS_REPEAT} ${line}
	echo -n "${time_color}${RS_OUTPUT}${border_color}"
	output_character_repeat $(( ${RS_REPEAT} )) ${line}
	echo "${reset}"
}

function create_git_midline() {
	local git_dir git_branch git_staged_additions git_staged_mods git_staged_deletions git_unstaged_mods git_untracked
	local reset git_branch_colour git_staged_colour git_unstaged_colour leader_colour
	git_dir=$1
	git_branch=$2
	git_staged=$3
	git_unstaged=$4
	reset="%{$reset_color%}"
	git_staged_colour="%{$fg[green]%}"
	git_unstaged_colour="%{$fg[red]%}"
	leader_colour="%{$fg[white]%}"

	output="$fg[yellow]${git_dir}"
	[[ "master" == "${git_branch}" ]] && git_branch_colour="%{$bg[red]$fg[black]%}"
	[[ -z ${git_branch_colour} ]] && git_branch_colour="%{$bg[cyan]$fg[black]%}"
	output="${leader_colour}| ${git_branch_colour}[ ${git_branch} ]${reset} ${output}"
	git_staged_additions=`git status -s | grep "^A" | wc -l`
	git_staged_mods=`git status -s | grep "^M" | wc -l`
	git_staged_deletions=`git status -s | grep "^D" | wc -l` 
	git_unstaged_mods=`git status -s | grep "^ M" | wc -l`
	git_untracked=`git status -s | grep "??" | wc -l` 

	output="${output} ${leader_colour}Unstaged: M:${git_unstaged_colour}${git_unstaged_mods:-0}${leader_colour} ?:${git_unstaged_colour}${git_untracked:-0}"
	output="${output} ${leader_colour}Staged: A:${git_staged_colour}${git_staged_additions:-0}${leader_colour} M:${git_staged_colour}${git_staged_mods:-0}${leader_colour} D:${git_staged_colour}${git_staged_deletions:-0}"

	output="${output}${reset}"
	echo -n ${output}
}

function do_midline() {
	local reset bar space cur_dir output git_str git_base_dir
	local colour_cur_dir git_branch_colour 
	local git_dir git_branch git_staged git_unstaged
	local DIR_SIZE GIT_SIZE
	cur_dir="%~/"
	git_str=$1
	#DIR BRANCH STASHES UNSTAGED STAGED ACTION 

	reset="%{${reset_color}%}"
	[[ -w $PWD ]] && colour_cur_dir="%{$fg[green]%}" || colour_cur_dir="%{$fg[red]%}"
	space=" "

	git_dir=`echo ${git_str} | sed -e 's/^.*1@\(.*\)1@.*$/\1/g'`
	[[ -n ${git_dir} ]] && git_branch=`echo ${git_str} | sed -e 's/^.*2@\(.*\)2@.*$/\1/g'` && 	git_unstaged=`echo ${git_str} | sed -e 's/^.*4@\(.*\)4@.*$/\1/g'` && git_staged=`echo ${git_str} | sed -e 's/^.*5@\(.*\)5@.*$/\1/g'`
	[[ -n ${git_dir} ]] && output=`create_git_midline ${git_dir} ${git_branch} ${git_staged:--} ${git_unstaged:--}`
	[[ -z ${git_dir} ]] && output="%{$fg[white]%}| ${colour_cur_dir}%~"

	echo -n "${output}"
	echo "${reset}"
}

function do_bottom_border() {
	local reset line bottom_left_corner bottom_right_corner machine_name user_name len date curtime
	local LS_SIZE MID_SIZE RS_SIZE LS_OUTPUT MID_OUTPUT RS_OUTPUT LS_REPEAT RS_REPEAT i COL_COUNT 
	local border_color username_color date_color time_color
	local job_count
	reset="%{${reset_color}%}"
	border_color="%{$fg[white]%}"
	username_color="%{$fg[red]%}"
	date_color="%{$fg[magenta]%}"
	time_color="%{$fg[magenta]%}"
	line="┉"
	bottom_left_corner="┗"
	bottom_right_corner="┛"
	job_count=`jobs -l | wc -l | sed -e "s/[ \t]*\(.*\)/\1/g"`
	LS_OUTPUT="${job_count} background jobs"
	[[ $RETVAL -ne 0 ]] && MID_OUTPUT="Last Command Failed"
	# Take 2 off for the corners
	MID_SIZE=${#${(S%%)MID_OUTPUT//$~zero/}}
	LS_SIZE=${#${(S%%)LS_OUTPUT//$~zero/}}
	RS_SIZE=${#${(S%%)RS_OUTPUT//$~zero/}}
	LS_REPEAT=$(( (((COLUMNS - 2) / 2) - ${LS_SIZE} - (${MID_SIZE} / 2)) / 2 ))
	RS_REPEAT=$(( (((COLUMNS - 2) / 2) - ${RS_SIZE} - (${MID_SIZE} / 2)) / 2 ))

	echo -n "${border_color}${bottom_left_corner}"
	output_character_repeat ${LS_REPEAT} ${line}
	echo -n "${date_color}${LS_OUTPUT}${border_color}"
	output_character_repeat ${LS_REPEAT} ${line}
	echo -n "${username_color}${MID_OUTPUT}${border_color}"
	output_character_repeat ${RS_REPEAT} ${line}
	echo -n "${time_color}${RS_OUTPUT}${border_color}"
	output_character_repeat $(( ${RS_REPEAT} )) ${line}
	echo "${reset}"
}

function build_prompt() {
	RETVAL=$?
	autoload -Uz vcs_info
	setopt prompt_subst
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' get-revision true
	zstyle ':vcs_info:*' check-for-changes true
	zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash
	zstyle ':vcs_info:*' stagedstr '+'
	zstyle ':vcs_info:git:*' unstagedstr '⊙'
	zstyle ':vcs_info:git:*' formats "1@%r/%S1@ 2@%b2@ 3@%m3@ 4@%u4@ 5@%c5@ 6@%a6@"
	vcs_info
	
	local git_str

	git_str="${vcs_info_msg_0_}"
	git_str=${(S%%)git_str}

	do_top_border 
	do_midline ${git_str}
	do_bottom_border $RETVAL
	echo "%{$fg[white]%}$command_line_start%{${reset_color}%}";
}

PROMPT='%{%f%b%k%}$(build_prompt) '
