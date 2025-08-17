
Help() {
	case "$1" in
		foo)
			# if command -v rsync &>/dev/null; then
			# 	echo yes
			# else
			# 	echo no
			# fi
			# cat receives the text block below as its standard input.
			# The '-' in '<<-' is the key to allowing indentation.
			cat <<-EOF
				Usage: tt foo [options]

				It allows you to do this thing and this other thing.

				NOTE:
					Tootils works like bar when biz. This note is even
					indented further, and it will be preserved correctly.

			EOF
			;;

		bar)
			cat <<-EOF
				Usage: tt bar [filename]

				The 'bar' command is for frobbing the widgets. Ensure that
				the input file is correctly formatted.

			EOF
			;;

		"")
			cat <<-EOF
				Tootils Help

				Usage: tt [command]

				Available commands:
					foo     - Does the foo things.
					bar     - Frobs the widgets.
					backup  - Backs up all configured folders.

				Run 'tt help [command]' for more details.
			EOF
			;;
		*)
			erro "unknown command bro"
			;;
	esac
}
