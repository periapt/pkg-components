package Debian::Parse::Uscan;

use warnings;
use strict;
use Carp;
use Readonly;

our $VERSION = '0.3';

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub parse { 
    my $self = shift;
    my $string = shift;
    my $results = {};

    # Get versions
    if ($string =~ m{
                ^              # beginning of line
                Newest\sversion\son\sremote\ssite\sis\s
               (\S+)            # remote version
               ,\slocal\sversion\sis\s
               (\S+)            # local version
               $                # end of line
    }xms) {
        $results->{remote_version} = $1;
        $results->{local_version} = $2;
    }

    # Downloaded file
    if ($string =~ m{
                ^              # beginning of line
                \-\-\s
                Successfully\sdownloaded\supdated\spackage\s
                (\S+)          # downloaded file
                $              # end of line
    }xms) {
        $results->{downloaded_file} = $1;
    }

    # Symlink
    if ($string =~ m{
                ^              # beginning of line
                \s+            # large initial space
                and\ssymlinked\s
                (\S+)          # symlink
                \sto\sit
                $              # end of line
    }xms) {
        $results->{symlink} = $1;
    }

    return $results;
}

# Module implementation here


1; # Magic true value required at end of module
__END__

=head1 NAME

Debian::Parse::Uscan - Utility method to parse verbose uscan output

=head1 VERSION

This document describes Debian::Parse::Uscan version 0.3

=head1 SYNOPSIS

    use Debian::Parse::Uscan;
    my $parser = Debian::Parse::Uscan->new;
    my $details = $parser->parse($uscan_output);
    print "Local version: $details->{local_version}\n";
    print "Downloaded: $details->{downloaded}\n";
  
=head1 DESCRIPTION

This is a simple utility class that encapsulates the regular expressions
needed to glean information from the verbose output of C<uscan>.

=head1 INTERFACE 

=head2 new

This is a constructor.

=head2 parse

The C<parse> method takes the output as a string as an argument and returns a
hash reference containing the extracted fields.

=head1 DEPENDENCIES

None.

=head1 BUGS AND LIMITATIONS

This module is only really intended for Debian and related systems.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-debian-debhelper-dh_components@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Nicholas Bamber  C<< <nicholas@periapt.co.uk> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Nicholas Bamber C<< <nicholas@periapt.co.uk> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
