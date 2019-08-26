use strict;
use warnings;
use Irssi;

our $VERSION = '0.1';
our %IRSSI = (
    authors     => 'Tuomas Kulve',
    contact     => 'tuomas@kulve.fi',
    name        => 'discord_bot_rename.pl',
    description => 'Replace the bot\'s name with the sender from Discord side',
    license     => 'Apache License 2.0',
    url         => 'http://no-url',
);

# HOWTO:
#
#   /load discord_bot_rename.pl
#
#
# Based on discord_unhilight.pl   by Christoffer Holmberg, which is:
# Based on slack_strip_auto_cc.pl by Ævar Arnfjörð Bjarmason.

sub msg_strip_nick_from_discord_bridge {
    my ($server, $data, $nick, $host) = @_;
    my ($target, $message) = split /:/, $data, 2;

    # The message must be from the Discord bridge bot (DBot1 in my case)
    return unless $nick =~ /^DBot[0-9]$/;

    # Get the sender's nick from the message, i.e. " <nickname>"
    $message =~ /^[ ]*<([^>]+)>/;
    my $discord_nick = "$1";

    # Remove the sender's nick from the message
    $message =~ s/^[ ]*<\Q$discord_nick\E> //;

    # Suffix the sender's nick with "_d" to note that it's from Discord
    $discord_nick = $discord_nick."_d";

    my $new_data = "$target:$message";
    Irssi::signal_continue($server, $new_data, $discord_nick, $host);
}

Irssi::signal_add('event privmsg', 'msg_strip_nick_from_discord_bridge');
