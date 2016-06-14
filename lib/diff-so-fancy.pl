use utf8;
use open qw(:std :utf8); # http://stackoverflow.com/a/519359
binmode STDOUT,':utf8';

my $horizontal_color = "";
	# Pre-process the line before we do any other markup #
	# End pre-processing #
	####################################################################
	# Look for git index and replace it horizontal line (header later) #
	####################################################################
	if ($line =~ /^${ansi_color_regex}index /) {
		# Print the line color and then the actual line
		$horizontal_color = $1;
		print horizontal_rule($horizontal_color);
	} elsif ($line =~ /^${ansi_color_regex}diff --(git|cc) (.*?)(\s|\e|$)/) {

		# Print out the bottom horizontal line of the header
		print horizontal_rule($horizontal_color);
	######################################
	# Look for binary file changes
	######################################
	} elsif ($line =~ /Binary files \w\/(.+?) and \w\/(.+?) differ/) {
		print "${horizontal_color}modified: $2 (binary)\n";
		print horizontal_rule($horizontal_color);
# Mark the first char of an empty line
# String to boolean
sub get_less_charset {
	my @less_char_vars = ("LESSCHARSET", "LESSCHARDEF", "LC_ALL", "LC_CTYPE", "LANG");
	foreach (@less_char_vars) {
		return $ENV{$_} if defined $ENV{$_};
	}
}

sub should_print_unicode {
	if (-t STDOUT) {
		# Always print unicode chars if we're not piping stuff, e.g. to less(1)
		return 1;
	}
	# Otherwise, assume we're piping to less(1)
	return get_less_charset() =~ /utf-?8/i;
}

# Remove all ANSI codes from a string
# Remove all trailing and leading spaces

# Print a line of em-dash or line-drawing chars the full width of the screen
sub horizontal_rule {
	my $color = $_[0] || "";
	my $width = `tput cols`;
	my $uname = `uname -s`;

	if ($uname =~ /MINGW32|MSYS/) {
		$width--;
	}

	# em-dash http://www.fileformat.info/info/unicode/char/2014/index.htm
	#my $dash = "\x{2014}";
	# BOX DRAWINGS LIGHT HORIZONTAL http://www.fileformat.info/info/unicode/char/2500/index.htm
	my $dash;
	if (should_print_unicode()) {
		$dash = "\x{2500}";
	} else {
		$dash = "-";
	}

	# Draw the line
	my $ret = $color . ($dash x $width) . "\n";

	return $ret;
}