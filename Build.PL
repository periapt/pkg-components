use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Debian::Debhelper::Dh_components',
    license             => 'perl',
    dist_author         => 'Nicholas Bamber <nicholas@periapt.co.uk>',
    dist_version_from   => 'lib/Debian/Debhelper/Dh_components.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'version'    => 0,
    },
    create_makefile_pl => 'traditional',
    add_to_cleanup      => [ 'Debian-Debhelper-Dh_components-*' ],
);

$builder->create_build_script();
