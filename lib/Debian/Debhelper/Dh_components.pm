package Debian::Debhelper::Dh_components;

use warnings;
use strict;
use Carp;
use Readonly;
use DirHandle;
use Debian::Copyright;

Readonly my $BUILD_STAGES => [
    'copy',
    'patch',
    'config',
    'build',
    'test',
    'install'
];

Readonly my $RULES_LOCATIONS => [
    'debian/components/%',
    'debian/components',
    '/usr/share/pkg-components/build_stages',
];

our $VERSION = '0.3';

sub new {
    my $class = shift;
    my %args   = @_;
    $args{build_stages} ||= $BUILD_STAGES;
    $args{rules_locations} ||= $RULES_LOCATIONS;

    my $components_specified = exists $args{components};
    my %components;
    if ($components_specified) {
        %components = map {$_ => 1} @{$args{components}};
    }
    $args{components} = [];

    my $self = \%args;

    bless $self, $class;

    my $dir_handle = DirHandle->new($self->{dir});
    if ($dir_handle) {

        my $copyright_file = "$self->{dir}/copyright.in";
        if (-r $copyright_file) {
            $self->{copyright} = Debian::Copyright->new();
            $self->{copyright}->read($copyright_file);
        }

        while(my $file = $dir_handle->read) {
            next if $file =~ /^\./;
            next if not -d "$self->{dir}/$file";
            next if $components_specified and not exists $components{$file};
            push @{$self->{components}}, $file;

            my $copyright_frag = "$self->{dir}/$file/copyright";
            if ($self->{copyright} && -r $copyright_frag) {
                $self->{copyright}->read($copyright_frag);
            }         
        }
    }

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

sub script {
    my $self = shift;
    my $component = shift;
    my $build_stage = shift;

    return undef if ! grep {$component eq $_} $self->components;
    return undef if ! grep {$build_stage eq $_} $self->build_stages;

    foreach my $loc (@{$self->{rules_locations}}) {
        my $thisloc = $loc;
        $thisloc =~ s{%}{$component}g;
        my $script = "$thisloc/$build_stage";
        return $script if -x $script;
    }

    return undef;
}

sub build_copyright {
    my $self = shift;
    my $file = shift;
    if ($self->{copyright}) {
        $self->{copyright}->write($file);
    }
    return;
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

This is a constructor which takes a number of named arguments.

=over 4

=item C<dir>

This is the path to a components directory. Typically
this will just be C<debian/components>. This argument is mandatory.

=item C<package>

This is the package name and is mandatory.

=item C<build_stages>

If this argument, an array reference, is given it will override the normal
sequence of build stages.

=item  C<component>

If this parameter, an array reference, is set only those components listed will
be considered.

=item C<rules_locations>

If this parameter, an array reference, is given it will override the normal
location of build stage scripts.

=back

=head2 build_stages

This returns the build stages in the order in which they should occur:
copy, patch, config, build, test, install.

=head2 directory

This returns the directory name that was passed to the constructor.

=head2 package

This returns the package name that was passed to the constructor.

=head2 components

This returns an array listing the components found in that component directory.

=head2 script

This method takes two arguments, the component and the build stage, and returns
the script that needs to be run.

=head2 build_copyright

If this method finds a file C<copyright.in> in the components directory, it
merges in any component copyright files in the component directories and
writes the result to the specified location.

=head1 CONFIGURATION AND ENVIRONMENT

Debian::Debhelper::Dh_components requires no configuration files or environment variables.

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
