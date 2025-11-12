
# NOTE: this fork of reasymotion ONLY adds simple info popups to its reasymotion actions for visual confirmation
#       expansion to long form command names and tab spacing are applied solely for readability

declare-option -hidden str _scrolloff
declare-option -hidden range-specs reasymotionselections

declare-option -hidden str reasymotion_command
set-option global reasymotion_command "rkak_easymotion"

declare-option -hidden str reasymotion_last_selection 

declare-option str reasymotion_keys
set-option global reasymotion_keys "abcdefghijklmnopqrstuvwxyz"

set-face global REasymotionBackground rgb:aaaaaa
set-face global REasymotionForeground white,red+F

define-command reasymotion-select-screen -params 1 %{
	set-option window _scrolloff %opt{scrolloff}
	set-option window scrolloff 0,0

	execute-keys "gbGt%arg{1}<a-:>"

	reasymotion-selection

	hook window -once NormalKey .* %{
		set-option window scrolloff %opt{_scrolloff}
	}
	hook window -once NormalIdle .* %{
		set-option window scrolloff %opt{_scrolloff}
	}
}

define-command reasymotion-select-screen-expand -params 1 %{
	set-option window _scrolloff %opt{scrolloff}
	set-option window scrolloff 0,0
	set-option window reasymotion_last_selection %val{selections_desc}

	execute-keys "gbGt%arg{1}<a-:>"

	reasymotion-selection-expand %opt{reasymotion_last_selection}

	hook window -once NormalKey .* %{
		set-option window scrolloff %opt{_scrolloff}
	}
	hook window -once NormalIdle .* %{
		set-option window scrolloff %opt{_scrolloff}
	}
}

# gbGt to select whole screen
define-command reasymotion-selection %{
	add-highlighter buffer/reasymotionselections replace-ranges reasymotionselections
	add-highlighter buffer/reasymotionbackground fill REasymotionBackground

	evaluate-commands %sh{
		# need enviroment variables
		# (can't remove because otherwise kak doesn't export them so the program can't access them)
		# $kak_selections_desc $kak_opt_reasymotion_keys
		$kak_opt_reasymotion_command start
		# rkak_easymotion start
	}
}

define-command reasymotion-selection-expand -params 1 %{
	add-highlighter buffer/reasymotionselections replace-ranges reasymotionselections
	add-highlighter buffer/reasymotionbackground fill REasymotionBackground

	evaluate-commands %sh{
		# need enviroment variables
		# (can't remove because otherwise kak doesn't export them so the program can't access them)
		# $kak_selections_desc $kak_opt_reasymotion_keys

		export EXTEND_SELECTION=$1

		# rkak_easymotion start
		$kak_opt_reasymotion_command start
		}
}

define-command reasymotion-line %{
	reasymotion-select-screen <a-s>x
}

define-command reasymotion-line-expand %{
	reasymotion-select-screen-expand <a-s>x
}

define-command reasymotion-word %{
	reasymotion-select-screen s\w+<ret>
}

define-command reasymotion-word-expand %{
	reasymotion-select-screen-expand s\w+<ret>
}

define-command reasymotion-on-letter-to-word %{
	info -title 'Jump to Word' -- '  Press letter  '
	on-key %{
		reasymotion-select-screen "s\b%val{key}\w*<ret>"
	}
}

define-command reasymotion-on-letter-to-word-expand %{
	info -title 'Expand to word' -- '  Press letter  '
	on-key %{
		reasymotion-select-screen-expand "s\b%val{key}\w*<ret>"
	}
}

define-command reasymotion-on-letter-to-letter %{
	info -title 'Jump to letter' -- '  Press letter  '
	on-key %{
		reasymotion-select-screen "s%val{key}<ret>"
	}
}

define-command reasymotion-on-letter-to-letter-expand %{
	info -title 'Expand to letter' -- '   Press letter   '
	on-key %{
		reasymotion-select-screen-expand "s%val{key}<ret>"
	}
}
