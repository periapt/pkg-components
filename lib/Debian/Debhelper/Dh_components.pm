package Debian::Debhelper::Dh_components;

use warnings;
use strict;
use Carp;
use Readonly;
use DirHandle;

Readonly my $BUILD_STAGES => [
    'copy',
    'patch',
    'config',
    'build',
    'test',
    'install'
];

our $VERSION = '0.1';

sub new {
    my $class = shift;
    my %args   = @_;
    $args{build_stages} ||= $BUILD_STAGES;

    my $components_specified = exists $args{components};
    my %components;
    if ($components_specified) {
        %components = map {$_ => 1} @{$args{components}};
    }
    $args{components} = [];

    my $self = \%args;

    my $dir_handle = DirHandle->new($self->{dir});
    if ($dir_handle) {
        while(my $file = $dir_handle->read) {
            next if $file =~ /^\./;
            next if not -d "$self->{dir}/$file";
            next if $components_specified and not exists $components{$file};
            push @{$self->{components}}, $file;
        }
    }
    bless $self, $class;
    return $self;
}

sub build_stages { 
    my $self = shift;
    return @{$self->{build_stages}};
}

sub directory {
    my $self = shift;
    return $self->{dir};
}

sub package {
    my $self = shift;
    return $self->{package};
}

sub components {
    my $self = shift;
    return @{$self->{components}};
}

# Module implementation here


1; # Magic true value required at end of module
__END__

=head1 NAME

Debian::Debhelper::Dh_components - Data for Debian components handling


=head1 VERSION

This document describes Debian::Debhelper::Dh_components version 0.1


=head1 SYNOPSIS

    use Debian::Debhelper::Dh_components;
    my $components = Debian::Debhelper::Dh_components->new;
  
=head1 DESCRIPTION

Back-end for C<dh_components> command. The module has three tasks:

=over 

=item merging of documents (not implemented);

=item merging of C<substvar> merging (not implemented);

=item cascading implementation of component build process (not implemented).

=back

=head1 INTERFACE 

=head2 new

This is a constructor which takes a number of named arguments. The first
mandatory argument, C<dir>, is the path to a components directory. Typically
this will just be C<debian/components>. The second, C<package>, is the
package name. If the C<build_stages> argument, an array reference, is given
this will override the normal sequence of build stages. If the C<component>
parameter, an array reference, is set only those components listed will
be considered.

=head2 build_stages

This returns the build stages in the order in which they should occur:
copy, patch, config, build, test, install.

=head2 directory

This returns the directory name that was passed to the constructor.

=head2 package

This returns the package name that was passed to the constructor.

=head2 components

This returns an array listing the components found in that component directory.

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Debian::Debhelper::Dh_components requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

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
