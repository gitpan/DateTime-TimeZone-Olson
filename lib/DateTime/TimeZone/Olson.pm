=head1 NAME

DateTime::TimeZone::Olson - timezones from the Olson database

=head1 SYNOPSIS

	use DateTime::TimeZone::Olson qw(olson_version);

	$version = olson_version;

	use DateTime::TimeZone::Olson qw(
		olson_canonical_names olson_link_names olson_all_names
		olson_links
		olson_country_selection
	);

	$names = olson_canonical_names;
	$names = olson_link_names;
	$names = olson_all_names;
	$links = olson_links;
	$countries = olson_country_selection;

	use DateTime::TimeZone::Olson qw(olson_tz);

	$tz = olson_tz("America/New_York");

=head1 DESCRIPTION

This module encapsulates the Olson timezone database, providing
L<DateTime>-compatible timezone objects and ancillary data.  On each
program run this module provides access to a particular version of the
timezone database, determined by which version of L<Time::OlsonTZ::Data>
is installed.

=cut

package DateTime::TimeZone::Olson;

{ use 5.006; }
use warnings;
use strict;

use DateTime::TimeZone::Tzfile 0.005 ();
use Time::OlsonTZ::Data 0.201012 qw(
	olson_version
	olson_canonical_names olson_link_names olson_all_names
	olson_links
	olson_country_selection
	olson_tzfile
);

our $VERSION = "0.001";

use parent "Exporter";
our @EXPORT_OK = qw(
	olson_version
	olson_canonical_names olson_link_names olson_all_names
	olson_links
	olson_country_selection
	olson_tz
);

=head1 FUNCTIONS

=head2 Basic information

=over

=item olson_version

Returns the version number of the database to which this module is
providing access.  Version numbers for the Olson database currently
consist of a year number and a lowercase letter, such as "C<2010k>";
they are not guaranteed to retain this format in the future.

=back

=head2 Zone metadata

=over

=item olson_canonical_names

Returns the set of timezone names that this version of the database
defines as canonical.  These are the timezone names that are directly
associated with a set of observance data.  The return value is a reference
to a hash, in which the keys are the canonical timezone names and the
values are all C<undef>.

=item olson_link_names

Returns the set of timezone names that this version of the database
defines as links.  These are the timezone names that are aliases for
other names.  The return value is a reference to a hash, in which the
keys are the link timezone names and the values are all C<undef>.

=item olson_all_names

Returns the set of timezone names that this version of the
database defines.  These are the L</olson_canonical_names> and the
L</olson_link_names>.  The return value is a reference to a hash, in
which the keys are the timezone names and the values are all C<undef>.

=item olson_links

Returns details of the timezone name links in this version of the
database.  Each link defines one timezone name as an alias for some
other timezone name.  The return value is a reference to a hash, in
which the keys are the aliases and each value is the canonical name of
the timezone to which that alias refers.  All such canonical names can
be found in the L</olson_canonical_names> hash.

=item olson_country_selection

Returns information about how timezones relate to countries, intended
to aid humans in selecting a geographical timezone.  For details of the
data format see L<Time::OlsonTZ::Data/olson_country_selection>.

=back

=head2 Zone data

=over

=item olson_tz(NAME)

Returns a reference to an object that encapsulates the timezone
named I<NAME> in the Olson database and which implements the
L<DateTime::TimeZone> interface.  C<die>s if the name does not exist
in this version of the database.  Currently the object is of class
L<DateTime::TimeZone::Tzfile>, but this is not guaranteed.

=cut

my %cache_tz;
sub olson_tz($) {
	my($tzname) = @_;
	return $cache_tz{$tzname} ||= DateTime::TimeZone::Tzfile->new(
		filename => olson_tzfile($tzname),
		name => $tzname,
		category => ($tzname =~ m#\A([^/]+)/# ? $1 : undef),
		is_olson => 1,
	);
}

=back

=head1 BUGS

Parts of the Olson timezone database are liable to be inaccurate.
See L<Time::OlsonTZ::Data/BUGS> for discussion.  Frequent updates of
the installation of L<Time::OlsonTZ::Data> is recommended, to keep it
accurate for current dates.

=head1 SEE ALSO

L<DateTime::TimeZone>,
L<DateTime::TimeZone::Tzfile>,
L<Time::OlsonTZ::Data>

=head1 AUTHOR

Andrew Main (Zefram) <zefram@fysh.org>

=head1 COPYRIGHT

Copyright (C) 2010, 2011 Andrew Main (Zefram) <zefram@fysh.org>

=head1 LICENSE

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
