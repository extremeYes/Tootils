
PrintHelp() {
	case "$1" in
		foo)
			# if command -v rsync &>/dev/null; then
			# 	echo yes
			# else
			# 	echo no
			# fi
			# cat receives the text block below as its standard input.
			# The '-' in '<<-' is the key to allowing indentation.
			cat <<-CESTFINI
				Usage: tt foo [options]

				It allows you to do this thing and this other thing.

				NOTE:
					Tootils works like bar when biz. This note is even
					indented further, and it will be preserved correctly.

			CESTFINI
			;;

		bar)
			cat <<-CESTFINI
				Usage: tt bar [filename]

				The 'bar' command is for frobbing the widgets. Ensure that
				the input file is correctly formatted.

			CESTFINI
			;;

		"")
			cat <<-CESTFINI
				Tootils Help

				Usage: tt [command]

				Available commands:
					foo     - Does the foo things.
					bar     - Frobs the widgets.
					backup  - Backs up all configured folders.

				Run 'tt help [command]' for more details.
			CESTFINI
			;;
		*)
			erro "unknown command bro"
			;;
	esac
}
